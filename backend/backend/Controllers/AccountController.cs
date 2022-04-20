using Google.Apis.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Repository.Entities;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Worker;
using Worker.Models;

namespace backend.Controllers
{
    [ApiController]
    [Route("moodapp/api/[controller]/[action]")]
    [Authorize]
    public class AccountController : ControllerBase
    {
        private SignInManager<UserEntity> _signInManager;
        private UserManager<UserEntity> _userManager;
        private RoleManager<IdentityRole> _roleManager;
        private readonly AppSettings _appSettings;
        private readonly AccountWorker _accountWorker;
        public AccountController(SignInManager<UserEntity> signInManager, UserManager<UserEntity> userManager, RoleManager<IdentityRole> roleManager, AccountWorker accountWorker, IOptions<AppSettings> appSettings)
        {
            _accountWorker = accountWorker;
            _signInManager = signInManager;
            _roleManager = roleManager;
            _userManager = userManager;
            _appSettings = appSettings.Value;
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> CheckLogin([FromBody] UserModel loginModel)
        {
            UserEntity user = await _userManager.FindByEmailAsync(loginModel.Email);
            if (user == null)
                return BadRequest("User does not exist");

            Microsoft.AspNetCore.Identity.SignInResult result = await _signInManager.PasswordSignInAsync(user, loginModel.Password, false, false);

            if(result.Succeeded)
            {
                JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(_appSettings.Authorization.Secret);
                SecurityTokenDescriptor tokenDescriptor = new SecurityTokenDescriptor 
                {
                    Subject = new ClaimsIdentity(new Claim[]
                        {
                    new Claim(ClaimTypes.Name, user.Id.ToString()),
                    new Claim(ClaimTypes.Role, "BasicUser")
                        }),
                    Expires = DateTime.UtcNow.AddDays(1),
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                };
                return Ok(tokenHandler.WriteToken(tokenHandler.CreateToken(tokenDescriptor)));
            };          

            return BadRequest("Incorrect username or password");
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> SignUp([FromBody] UserModel signupModel)
        {
            var x = await _roleManager.FindByNameAsync("BasicUser");
            if (x == null)
                await _roleManager.CreateAsync(new IdentityRole("BasicUser"));

            var user = new UserEntity { UserName = String.Concat(signupModel.FirstName, signupModel.LastName), Email = signupModel.Email };
            var result = await _userManager.CreateAsync(user, signupModel.Password);
            await _userManager.AddToRoleAsync(user, "BasicUser");

            if (result.Succeeded)
            {
                var id = _userManager.FindByEmailAsync(signupModel.Email).Result.Id;
                _accountWorker.AddUserContext(id);
                return Ok(result);
            }
            return BadRequest("Incorrect credentials");
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> ExternalSignUp([FromBody] ExternalSignUpModel signUpModel)
        {
            var payload = await VerifyGoogleToken(signUpModel);
            if (payload == null)
                return BadRequest("Invalid External Authentication.");

            var info = new UserLoginInfo(signUpModel.Provider, payload.Subject, signUpModel.Provider);
            var user = await _userManager.FindByLoginAsync(info.LoginProvider, info.ProviderKey);
            if (user == null)
            {
                user = await _userManager.FindByEmailAsync(payload.Email);
                if (user == null)
                {
                    user = new UserEntity { Email = payload.Email, UserName = payload.Email };
                    await _userManager.CreateAsync(user);
                    //prepare and send an email for the email confirmation
                    await _userManager.AddToRoleAsync(user, "Viewer");
                    await _userManager.AddLoginAsync(user, info);
                }
                else
                {
                    await _userManager.AddLoginAsync(user, info);
                }
            }
            if (user == null)
                return BadRequest("Invalid External Authentication.");

            //check for the Locked out account
            JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_appSettings.Authorization.Secret);
            SecurityTokenDescriptor tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                    {
                    new Claim(ClaimTypes.Name, user.Id.ToString()),
                    new Claim(ClaimTypes.Role, "SuperAdmin")
                    }),
                Expires = DateTime.UtcNow.AddDays(1),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            return Ok(tokenHandler.WriteToken(tokenHandler.CreateToken(tokenDescriptor)));
        }

        public async Task<GoogleJsonWebSignature.Payload> VerifyGoogleToken(ExternalSignUpModel externalAuth)
        {
            try
            {
                /*var settings = new GoogleJsonWebSignature.ValidationSettings()
                {
                    Audience = new List<string>() { _appSettings.Authentication.Google.ClientId }
                };*/
                return await GoogleJsonWebSignature.ValidateAsync(externalAuth.IdToken, new GoogleJsonWebSignature.ValidationSettings());
            }
            catch (Exception ex)
            {
                //log an exception
                return null;
            }
        }
    }
}
