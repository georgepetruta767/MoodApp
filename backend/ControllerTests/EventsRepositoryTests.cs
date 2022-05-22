using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Moq;
using Repository;
using Repository.EF;
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
            _mockDbContext = new Mock<MoodAppContext>();
            var x = new List<Context>
            {
                new Context
                {
                    Id=Guid.NewGuid(),
                    Aspnetuserid=_mockUserId
                }
            };

            /*var mockContext = new Mock<DbSet<Context>>();

            mockContext.Object.Add(new Context
            {
                Id = Guid.NewGuid(),
                Aspnetuserid = _mockUserId
            });

            _mockDbContext.Setup(p => p.Set<Context>().Add(It.IsAny<Context>())).Returns(new Table
            {
                Id = Guid.NewGuid(),
                Aspnetuserid = _mockUserId
            });*/

            _mockDbContext.Setup(x => x.Contexts).Returns(x);
            _repository = new EventsRepository(_mockDbContext.Object);
        }

        [Fact]
        public void TestAddEvent()
        {
            _repository.AddEvent(new Repository.Entities.EventEntity
            {
                Id = Guid.NewGuid(),
                Title = "Data records",
                Status = 0,
                Type = 0,
                Season = (Global.Season)1
            }, _mockUserId) ;

            Assert.Equal(1, _repository.GetEvents(_mockUserId).Count);
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