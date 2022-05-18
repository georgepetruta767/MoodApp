using Microsoft.EntityFrameworkCore;
using Repository.EF;
using Repository.Entities;

namespace Repository
{
    public interface IMoodAppDbContext 
    {
        DbSet<UserEntity> Users { get; set; }
        DbSet<Context> Contexts { get; set; }
        DbSet<Event> Events { get; set; }
        DbSet<EventPersonRelation> EventPersonRelations { get; set; }
        int SaveChanges();
    }
}
