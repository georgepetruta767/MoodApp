using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using System;

namespace backend
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
           Host.CreateDefaultBuilder(args)
               .ConfigureWebHostDefaults(webBuilder =>
               {
                   webBuilder.UseStartup<Startup>();
                   webBuilder.ConfigureAppConfiguration(ConfigSettings());
               });

        private static Action<WebHostBuilderContext, IConfigurationBuilder> ConfigSettings()
        {
            return (hostContext, configBuilder) =>
            {
                configBuilder.SetBasePath(hostContext.HostingEnvironment.ContentRootPath);
                configBuilder.AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
                configBuilder.AddJsonFile("connectionsettings.json", optional: true, reloadOnChange: true);
                configBuilder.AddEnvironmentVariables();
            };
        }
    }
}
