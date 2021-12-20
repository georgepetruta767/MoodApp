using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Repository;
using Repository.EF;
using Repository.Entities;
using System.Threading.Tasks;

namespace backend
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddDbContext<MoodAppContext>(options => options.UseNpgsql(Configuration["postgresql:connectionString"])
                    .UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking)
                    .EnableSensitiveDataLogging(true), ServiceLifetime.Transient);

            services.AddIdentity<UserEntity, IdentityRole>()
                .AddEntityFrameworkStores<MoodAppContext>();

            services.AddControllers();
            services.AddTransient<Class1>();
            services.AddCors();

            var serviceProvider = services.BuildServiceProvider();
            var userManager = serviceProvider.GetService<UserManager<UserEntity>>();
            var roleManager = serviceProvider.GetService<RoleManager<IdentityRole>>();

            SeedRolesAsync(userManager, roleManager).Wait();
            SeedSuperAdminAsync(userManager, roleManager).Wait();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseCors(x => x
                .AllowAnyMethod()
                .AllowAnyHeader()
                .SetIsOriginAllowed(origin => true)
                .AllowCredentials());

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }

        public static async Task SeedRolesAsync(UserManager<UserEntity> userManager, RoleManager<IdentityRole> roleManager)
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
        }
    }
}
