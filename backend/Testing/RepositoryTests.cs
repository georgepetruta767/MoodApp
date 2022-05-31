using Microsoft.EntityFrameworkCore;
using Moq;
using Repository;
using Repository.EF;
using Repository.Entities;
using System;
using System.Collections.Generic;
using Xunit;

namespace RepositoryTests
{
    public class EventsRepositoryTests
    {
        private string _mockUserId = Guid.NewGuid().ToString();
        private readonly Mock<MoodAppContext> _mockDbContext;
        private readonly EventsRepository _repository;

        public EventsRepositoryTests()
        {
            /*_mockDbContext = new Mock<MoodAppContext>();

            var contexts = new List<Context>{
                new Context
                {
                    Id = Guid.NewGuid(),
                    Aspnetuserid = _mockUserId
                }
            }.AsQueryable();

            var mockContextsSet = new Mock<DbSet<Context>>();

            mockContextsSet.As<IQueryable<Context>>().Setup(m => m.Provider).Returns(contexts.Provider);
            mockContextsSet.As<IQueryable<Context>>().Setup(m => m.Expression).Returns(contexts.Expression);
            mockContextsSet.As<IQueryable<Context>>().Setup(m => m.ElementType).Returns(contexts.ElementType);
            mockContextsSet.As<IQueryable<Context>>().Setup(m => m.GetEnumerator()).Returns(contexts.GetEnumerator());


            _mockDbContext.Setup(x => x.Contexts).Returns(mockContextsSet.Object);

            var events = new List<Event> { }.AsQueryable();

            var mockEventsSet = new Mock<DbSet<Event>>();

            mockEventsSet.As<IQueryable<Event>>().Setup(m => m.Provider).Returns(events.Provider);
            mockEventsSet.As<IQueryable<Event>>().Setup(m => m.Expression).Returns(events.Expression);
            mockEventsSet.As<IQueryable<Event>>().Setup(m => m.ElementType).Returns(events.ElementType);
            mockEventsSet.As<IQueryable<Event>>().Setup(m => m.GetEnumerator()).Returns(events.GetEnumerator());

            _mockDbContext.Setup(x => x.Events).Returns(mockEventsSet.Object);

            var people = new List<Person> { }.AsQueryable();

            var mockPeopleSet = new Mock<DbSet<Person>>();

            mockPeopleSet.As<IQueryable<Person>>().Setup(m => m.Provider).Returns(people.Provider);
            mockPeopleSet.As<IQueryable<Person>>().Setup(m => m.Expression).Returns(people.Expression);
            mockPeopleSet.As<IQueryable<Person>>().Setup(m => m.ElementType).Returns(people.ElementType);
            mockPeopleSet.As<IQueryable<Person>>().Setup(m => m.GetEnumerator()).Returns(people.GetEnumerator());

            _mockDbContext.Setup(x => x.People).Returns(mockPeopleSet.Object);

            var relations = new List<EventPersonRelation> { }.AsQueryable();

            var mockRelationsSet = new Mock<DbSet<EventPersonRelation>>();

            mockRelationsSet.As<IQueryable<EventPersonRelation>>().Setup(m => m.Provider).Returns(relations.Provider);
            mockRelationsSet.As<IQueryable<EventPersonRelation>>().Setup(m => m.Expression).Returns(relations.Expression);
            mockRelationsSet.As<IQueryable<EventPersonRelation>>().Setup(m => m.ElementType).Returns(relations.ElementType);
            mockRelationsSet.As<IQueryable<EventPersonRelation>>().Setup(m => m.GetEnumerator()).Returns(relations.GetEnumerator());

            _mockDbContext.Setup(x => x.EventPersonRelations).Returns(mockRelationsSet.Object);

            _repository = new EventsRepository(_mockDbContext.Object);*/
        }

        [Fact]
        public void TestAddEvent()
        {
            /*_repository.AddEvent(new Repository.Entities.EventEntity
            {
                Id = Guid.NewGuid(),
                Title = "Data records",
                Status = 0,
                People = new List<PersonEntity> { },
                Type = 0,
                Season = (Global.Season)1
            }, _mockUserId);

            var y = _repository.GetEvents(_mockUserId);
            Assert.Equal(1, _repository.GetEvents(_mockUserId).Count);*/

            var options = new DbContextOptionsBuilder<MoodAppContext>()
            .UseInMemoryDatabase(databaseName: "MovieListDatabase")
            .Options;

            // Insert seed data into the database using one instance of the context
            /*            using (var context = new MoodAppContext(options))
                        {
                            context.Contexts.Add(new Context
                            {
                                Id = Guid.NewGuid(),
                                Aspnetuserid = _mockUserId
                            });
                            context.SaveChanges();
                        }*/

            var context = new MoodAppContext(options);
            context.Contexts.Add(new Context
            {
                Id = Guid.NewGuid(),
                Aspnetuserid = _mockUserId
            });
            context.SaveChanges();

            // Use a clean instance of the context to run the test
            PeopleRepository peopleRepository = new PeopleRepository(context);
            List<PersonEntity> people = peopleRepository.GetPeople(_mockUserId);
    
            Assert.Equal(1, people.Count);
            
        }

        /*[Fact]
        public void TestAddAnotherEvent()
        {
            _controller.Add(new Worker.Models.EventModel
            {
                Id = Guid.NewGuid(),
                Title = "Data records",
                Status = 0,
                Type = 0,
                Season = (Global.Season)
            }); ;

            var res = _controller.Get().Result;
            Assert.Equal(res.Count, 1);
        }*/

    }
}