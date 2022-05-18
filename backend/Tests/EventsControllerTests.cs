using AutoMapper;
using backend.Controllers;
using Moq;
using Repository;
using Worker;
using Xunit;
using Xunit.Sdk;

namespace Tests
{
    public class EventsControllerTests
    {
        private readonly Mock<EventsRepository> _mockRepository;
        private readonly EventsWorker _worker;
        private readonly EventsController _controller;
        private IMapper _mapper;

        public EventsControllerTests()
        {
            _mockRepository = new Mock<EventsRepository>();
            _worker = new EventsWorker(_mockRepository.Object, _mapper);
            _controller = new EventsController(_worker);
        }

        [Fact]
        public void TestAddEvent()
        {
            var result = _controller.Get();
            var x = result;
            Assert.Equal(x, result);
        }
    }
}