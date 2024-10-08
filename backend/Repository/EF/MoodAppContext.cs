﻿using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Repository.Entities;

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

        public virtual DbSet<Context> Contexts { get; set; }
        public virtual DbSet<Event> Events { get; set; }
        public virtual DbSet<EventPersonRelation> EventPersonRelations { get; set; }
        public virtual DbSet<Location> Locations { get; set; }
        public virtual DbSet<Person> People { get; set; }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {

        }

               protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Ignore<AspNetUserLogin>();
            modelBuilder.Ignore<AspNetUserRole>();
            modelBuilder.Ignore<AspNetUserClaim>();
            modelBuilder.Ignore<AspNetUserToken>();
            modelBuilder.Ignore<AspNetUser>();
            modelBuilder.HasPostgresExtension("uuid-ossp");

           
           
           
           
          
           
           
            modelBuilder.Entity<Context>(entity =>
            {
                entity.ToTable("context");

                entity.Property(e => e.Id)
                    .ValueGeneratedNever()
                    .HasColumnName("id");

                entity.Property(e => e.Aspnetuserid)
                    .IsRequired()
                    .HasColumnName("aspnetuserid");

                entity.HasOne(d => d.Aspnetuser)
                    .WithMany(p => p.Contexts)
                    .HasForeignKey(d => d.Aspnetuserid)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_aspnetusers_aspnetuser_id");
            });

            modelBuilder.Entity<Event>(entity =>
            {
                entity.ToTable("events");

                entity.Property(e => e.Id)
                    .ValueGeneratedNever()
                    .HasColumnName("id");

                entity.Property(e => e.AmountSpent).HasColumnName("amount_spent");

                entity.Property(e => e.ContextId).HasColumnName("context_id");

                entity.Property(e => e.EndingTime)
                    .HasColumnType("timestamp with time zone")
                    .HasColumnName("ending_time");

                entity.Property(e => e.Grade).HasColumnName("grade");

                entity.Property(e => e.LocationId).HasColumnName("location_id");

                entity.Property(e => e.Season).HasColumnName("season");

                entity.Property(e => e.StartingTime)
                    .HasColumnType("timestamp with time zone")
                    .HasColumnName("starting_time");

                entity.Property(e => e.Status).HasColumnName("status");

                entity.Property(e => e.Title)
                    .HasMaxLength(500)
                    .HasColumnName("title");

                entity.Property(e => e.Type).HasColumnName("type");

                entity.HasOne(d => d.Context)
                    .WithMany(p => p.Events)
                    .HasForeignKey(d => d.ContextId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_context_context_id");

                entity.HasOne(d => d.Location)
                    .WithMany(p => p.Events)
                    .HasForeignKey(d => d.LocationId)
                    .HasConstraintName("fk_locations_location_id");
            });

            modelBuilder.Entity<EventPersonRelation>(entity =>
            {
                entity.ToTable("event_person_relation");

                entity.Property(e => e.Id)
                    .ValueGeneratedNever()
                    .HasColumnName("id");

                entity.Property(e => e.EventId).HasColumnName("event_id");

                entity.Property(e => e.PersonId).HasColumnName("person_id");

                entity.HasOne(d => d.Event)
                    .WithMany(p => p.EventPersonRelations)
                    .HasForeignKey(d => d.EventId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_events_event_id");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.EventPersonRelations)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_people_person_id");
            });

            modelBuilder.Entity<Location>(entity =>
            {
                entity.ToTable("locations");

                entity.Property(e => e.Id)
                    .ValueGeneratedNever()
                    .HasColumnName("id");

                entity.Property(e => e.City)
                    .IsRequired()
                    .HasMaxLength(500)
                    .HasColumnName("city");

                entity.Property(e => e.Country)
                    .IsRequired()
                    .HasMaxLength(500)
                    .HasColumnName("country");

                entity.Property(e => e.Latitude).HasColumnName("latitude");

                entity.Property(e => e.Longitude).HasColumnName("longitude");
            });

            modelBuilder.Entity<Person>(entity =>
            {
                entity.ToTable("people");

                entity.Property(e => e.Id)
                    .ValueGeneratedNever()
                    .HasColumnName("id");

                entity.Property(e => e.Age).HasColumnName("age");

                entity.Property(e => e.ContextId).HasColumnName("context_id");

                entity.Property(e => e.Firstname)
                    .HasMaxLength(300)
                    .HasColumnName("firstname");

                entity.Property(e => e.Gender).HasColumnName("gender");

                entity.Property(e => e.Lastname)
                    .HasMaxLength(300)
                    .HasColumnName("lastname");

                entity.Property(e => e.SocialStatus).HasColumnName("social_status");

                entity.HasOne(d => d.Context)
                    .WithMany(p => p.People)
                    .HasForeignKey(d => d.ContextId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("fk_context_context_id");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
