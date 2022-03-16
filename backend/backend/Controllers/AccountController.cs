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
        private readonly AppSettings _appSettings;
        private AccountWorker _accountWorker;

        public AccountController(SignInManager<UserEntity> signInManager, UserManager<UserEntity> userManager, IOptions<AppSettings> appSettings)
        {
            _signInManager = signInManager;
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
                SecurityTokenDescriptor tokenDescriptor = new SecurityTokenDescriptor {
                    Subject = new ClaimsIdentity(new Claim[]
                        {
                    new Claim(ClaimTypes.Name, user.Id.ToString()),
                    new Claim(ClaimTypes.Role, "SuperAdmin")
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
            var result = await _userManager.CreateAsync(new UserEntity { UserName = signupModel.UserName, Email = signupModel.Email }, signupModel.Password);
            if(result.Succeeded)
            {
                _accountWorker.AddUserContext(_userManager.FindByEmailAsync(signupModel.Email).Id.ToString());
                return Ok(result);
            }
            return BadRequest("Incorrect credentials");
        }
    }
}
