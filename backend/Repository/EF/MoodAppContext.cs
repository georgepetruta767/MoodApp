using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Repository.Entities;
using Microsoft.EntityFrameworkCore.Metadata;

#nullable disable

namespace Repository.EF
{
    public partial class MoodAppContext : IdentityDbContext<UserEntity>
    {
        public MoodAppContext()
        {
        }

        public MoodAppContext(DbContextOptions<MoodAppContext> options)
            : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {

        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.HasPostgresExtension("uuid-ossp");

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
