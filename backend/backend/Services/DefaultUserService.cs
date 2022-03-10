using Microsoft.AspNetCore.Identity;
using Repository.Entities;
using System.Threading.Tasks;

namespace backend.Services
{
    public static class DefaultUserService
    {
        /*public static async Task SeedRolesAsync(UserManager<UserEntity> userManager, RoleManager<IdentityRole> roleManager)
        {
            var x = await roleManager.FindByNameAsync("SuperAdmin");
            if (x == null)
                await roleManager.CreateAsync(new IdentityRole("SuperAdmin"));
        }

        public static async Task SeedSuperAdminAsync(UserManager<UserEntity> userManager, RoleManager<IdentityRole> roleManager)
        {
            var defaultUser = new UserEntity
            {
                UserName = "superadmin",
                Email = "superadmin@gmail.com",
                EmailConfirmed = true,
                PhoneNumberConfirmed = true,
                TwoFactorEnabled = false,
                LockoutEnabled = false,
                AccessFailedCount = 5
            };
            var user = await userManager.FindByEmailAsync(defaultUser.Email);
            if (user == null)
            {
                await userManager.CreateAsync(defaultUser, "Pass123.");
                await userManager.AddToRoleAsync(defaultUser, "SuperAdmin");
            }
        }*/
    }
}