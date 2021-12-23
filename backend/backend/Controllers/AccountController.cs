using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Repository.Entities;
using System.IdentityModel.Tokens.Jwt;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [ApiController]
    [Route("moodapp/api/[controller]/[action]")]
    public class AccountController : ControllerBase
    {
        private SignInManager<UserEntity> _signInManager;
        private UserManager<UserEntity> _userManager;

        public AccountController(SignInManager<UserEntity> signInManager, UserManager<UserEntity> userManager)
        {
            _signInManager = signInManager;
            _userManager = userManager;
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> CheckLogin([FromBody] UserModel userModel)
        {
            UserEntity user = await _userManager.FindByEmailAsync(userModel.Email);
            if (user == null)
                return BadRequest("User does not exist");

            Microsoft.AspNetCore.Identity.SignInResult result = await _signInManager.PasswordSignInAsync(user, userModel.Password, false, false);

            if(result.Succeeded)
            {
                JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
                SecurityTokenDescriptor tokenDescriptor = new SecurityTokenDescriptor { };
                return Ok(tokenHandler.WriteToken(tokenHandler.CreateToken(tokenDescriptor)));
            }

            return BadRequest("Incorrect username or password");
        }
    }
}
