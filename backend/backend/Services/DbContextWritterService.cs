using Microsoft.EntityFrameworkCore.Design;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Scaffolding;
using Microsoft.EntityFrameworkCore.Scaffolding.Internal;
using System;
using System.Diagnostics.CodeAnalysis;

namespace backend.DbContextServices
{
#pragma warning disable EF1001 // Internal EF Core API usage.
    public class DbContextWritterService : CSharpDbContextGenerator
#pragma warning restore EF1001 // Internal EF Core API usage.
    {
        protected const String OldNamespace = "using Microsoft.EntityFrameworkCore;";
        protected const String IdentityNameSpace = "using Microsoft.AspNetCore.Identity.EntityFrameworkCore;";
        protected const String OldOnModelCreating = @" protected override void OnModelCreating(ModelBuilder modelBuilder)
        {";
        protected const String RepoNameSpace = "using Repository.Entities;";
        protected const String OldClass = "public partial class MoodAppContext : DbContext";
        protected const String NewClass = "public partial class MoodAppContext : IdentityDbContext<UserEntity>";
        protected const string Warning = @"            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseNpgsql(""Host=127.0.0.1;Database=moodapp;Username=postgres;Password=postgres"");
            }";
        protected const String NewOnModelCreating = @"        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Ignore<AspNetUserLogin>();
            modelBuilder.Ignore<AspNetUserRole>();
            modelBuilder.Ignore<AspNetUserClaim>();
            modelBuilder.Ignore<AspNetUserToken>();
            modelBuilder.Ignore<AspNetUser>();";
        protected const String OldAstNetRoleDbSet = @"public virtual DbSet<AspNetRole> AspNetRoles { get; set; }
        ";
        protected const String OldAstNetRoleClaimDbSet = @"public virtual DbSet<AspNetRoleClaim> AspNetRoleClaims { get; set; }
        ";
        protected const String OldAstNetUserDbSet = @"public virtual DbSet<AspNetUser> AspNetUsers { get; set; }
        ";
        protected const String OldAstNetUserClaimDbSet = @"public virtual DbSet<AspNetUserClaim> AspNetUserClaims { get; set; }
        ";
        protected const String OldAstNetUserLoginDbSet = @"public virtual DbSet<AspNetUserLogin> AspNetUserLogins { get; set; }
        ";
        protected const String OldAstNetUserRoleDbSet = @"public virtual DbSet<AspNetUserRole> AspNetUserRoles { get; set; }
        ";
        protected const String OldAstNetUserTokenDbSet = @"public virtual DbSet<AspNetUserToken> AspNetUserTokens { get; set; }
        ";
        protected const String OldAstNetRoleEntity = @" modelBuilder.Entity<AspNetRole>(entity =>
            {
                entity.HasIndex(e => e.NormalizedName, ""RoleNameIndex"")
                    .IsUnique();

                entity.Property(e => e.Name).HasMaxLength(256);

                entity.Property(e => e.NormalizedName).HasMaxLength(256);
            });
";
        protected const String OldAstNetRoleClaimEntity = @" modelBuilder.Entity<AspNetRoleClaim>(entity =>
            {
                entity.HasIndex(e => e.RoleId, ""IX_AspNetRoleClaims_RoleId"");

                entity.Property(e => e.RoleId).IsRequired();

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.AspNetRoleClaims)
                    .HasForeignKey(d => d.RoleId);
            });
";
        protected const String OldAstNetUserEntity = @" modelBuilder.Entity<AspNetUser>(entity =>
            {
                entity.HasIndex(e => e.NormalizedEmail, ""EmailIndex"");

                entity.HasIndex(e => e.NormalizedUserName, ""UserNameIndex"")
                    .IsUnique();

                entity.Property(e => e.Email).HasMaxLength(256);

                entity.Property(e => e.LockoutEnd).HasColumnType(""timestamp with time zone"");

                entity.Property(e => e.NormalizedEmail).HasMaxLength(256);

                entity.Property(e => e.NormalizedUserName).HasMaxLength(256);

                entity.Property(e => e.UserName).HasMaxLength(256);
            });
";
        protected const String OldAstNetUserClaimEntity = @" modelBuilder.Entity<AspNetUserClaim>(entity =>
            {
                entity.HasIndex(e => e.UserId, ""IX_AspNetUserClaims_UserId"");

                entity.Property(e => e.UserId).IsRequired();

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserClaims)
                    .HasForeignKey(d => d.UserId);
            });
";
        protected const String OldAstNetUserLoginEntity = @"  modelBuilder.Entity<AspNetUserLogin>(entity =>
            {
                entity.HasKey(e => new { e.LoginProvider, e.ProviderKey });

                entity.HasIndex(e => e.UserId, ""IX_AspNetUserLogins_UserId"");

                entity.Property(e => e.UserId).IsRequired();

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserLogins)
                    .HasForeignKey(d => d.UserId);
            });
";
        protected const String OldAstNetUserRoleEntity = @" modelBuilder.Entity<AspNetUserRole>(entity =>
            {
                entity.HasKey(e => new { e.UserId, e.RoleId });

                entity.HasIndex(e => e.RoleId, ""IX_AspNetUserRoles_RoleId"");

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.AspNetUserRoles)
                    .HasForeignKey(d => d.RoleId);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserRoles)
                    .HasForeignKey(d => d.UserId);
            });
";
        protected const String OldAstNetUserTokenEntity = @" modelBuilder.Entity<AspNetUserToken>(entity =>
            {
                entity.HasKey(e => new { e.UserId, e.LoginProvider, e.Name });

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserTokens)
                    .HasForeignKey(d => d.UserId);
            });
";
        public DbContextWritterService([NotNull] IProviderConfigurationCodeGenerator providerConfigurationCodeGenerator, [NotNull] IAnnotationCodeGenerator annotationCodeGenerator, [NotNull] ICSharpHelper cSharpHelper) : base(providerConfigurationCodeGenerator, annotationCodeGenerator, cSharpHelper)
        {
        }
        public override string WriteCode(IModel model, string contextName, string connectionString, string contextNamespace, string modelNamespace, bool useDataAnnotations, bool suppressConnectionStringWarning, bool suppressOnConfiguring)
        {
            string code = base.WriteCode(model, contextName, connectionString, contextNamespace, modelNamespace, useDataAnnotations, suppressConnectionStringWarning, suppressOnConfiguring)
                .Replace(OldNamespace, OldNamespace + System.Environment.NewLine + IdentityNameSpace + System.Environment.NewLine + RepoNameSpace)
               .Replace(OldClass, NewClass)
               .Replace(Warning, "")
            .Replace(OldOnModelCreating, NewOnModelCreating)
            .Replace(OldAstNetRoleDbSet, "")
            .Replace(OldAstNetRoleClaimDbSet, "")
            .Replace(OldAstNetUserDbSet, "")
            .Replace(OldAstNetUserClaimDbSet, "")
            .Replace(OldAstNetUserLoginDbSet, "")
            .Replace(OldAstNetUserRoleDbSet, "")
            .Replace(OldAstNetUserTokenDbSet, "")
             .Replace(OldAstNetRoleEntity, "")
             .Replace(OldAstNetRoleClaimEntity, "")
            .Replace(OldAstNetUserEntity, "")
            .Replace(OldAstNetUserClaimEntity, "")
            .Replace(OldAstNetUserLoginEntity, "")
            .Replace(OldAstNetUserRoleEntity, "")
            .Replace(OldAstNetUserTokenEntity, "");
            return code;
        }
    }
}
