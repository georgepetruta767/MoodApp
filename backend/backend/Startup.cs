using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Repository.EF;
using Repository.Entities;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
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
            services.AddCors();

            services.AddControllers();

            services.AddDbContext<MoodAppContext>(options => options.UseNpgsql(Configuration["postgresql:connectionString"],o=>o.MigrationsAssembly("Repository"))
                    .UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking)
                    .EnableSensitiveDataLogging(true), ServiceLifetime.Transient);

            SetupDependencyInjection(services);

            SetupAutoMapper(services);

            //services.Configure<AppSettings>(Configuration.GetSection("AppSettings"));

            var serviceProvider = services.BuildServiceProvider();
            var userManager = serviceProvider.GetService<UserManager<UserEntity>>();
            var roleManager = serviceProvider.GetService<RoleManager<IdentityRole>>();

            SeedSuperAdminAsync(userManager, roleManager).Wait();
        }

        private static void SetupAutoMapper(IServiceCollection services)
        {
            var assemblyNames = new List<AssemblyName>()
            {
                new AssemblyName("backend"),
                new AssemblyName("Worker"),
                new AssemblyName("Repository")
            };

            List<Assembly> assemblies = new List<Assembly>();
            foreach (var assembly in assemblyNames)
            {
                assemblies.Add(Assembly.Load(assembly));
            }
            services.AddAutoMapper(assemblies);
        }

        public byte[] ConfigureOptions()
        {
            var settingsapp = Configuration.GetSection("AppSettings");
            var key = Encoding.ASCII.GetBytes(settingsapp["Authorization:Secret"]);
            return key;
        }

        public void SetupAuthorization(IServiceCollection services, byte[] key)
        {
            services.AddAuthentication(x =>
            {
                x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
           .AddJwtBearer(x =>
           {
               x.RequireHttpsMetadata = false;
               x.SaveToken = true;
               x.TokenValidationParameters = new TokenValidationParameters
               {
                   ValidateIssuerSigningKey = true,
                   IssuerSigningKey = new SymmetricSecurityKey(key),
                   ValidateIssuer = false,
                   ValidateAudience = false
               };
           });
        }

        public void SetupDependencyInjection(IServiceCollection services)
        {
            services.AddTransient<Repository.PeopleRepository>();
            services.AddTransient<Worker.PeopleWorker>();

            services.AddTransient<Repository.EventsRepository>();
            services.AddTransient<Worker.EventsWorker>();

            services.AddIdentity<UserEntity, IdentityRole>().AddEntityFrameworkStores<MoodAppContext>();
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
