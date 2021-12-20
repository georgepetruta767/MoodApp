
using backend.DbContextServices;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.EntityFrameworkCore.Scaffolding.Internal;
using Microsoft.Extensions.DependencyInjection;

namespace backend
{
    public class EFStartup : IDesignTimeServices
    {
        public void ConfigureDesignTimeServices(IServiceCollection serviceCollection)
        {
#pragma warning disable EF1001 // Internal EF Core API usage.
            serviceCollection.AddSingleton<ICSharpDbContextGenerator, DbContextWritterService>();
#pragma warning restore EF1001 // Internal EF Core API usage.
        }
    }
}
