using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using Worker;
using Worker.Models;

namespace backend.Controllers
{
    [ApiController]
    [Route("moodapp/api/[controller]/[action]")]
    public class EventsController : ControllerBase
    {
        private EventsWorker _eventsWorker;

        public EventsController(EventsWorker eventsWorker)
        {
            _eventsWorker = eventsWorker;
        }

        [HttpPost]
        public void Add([FromBody] EventModel eventModel)
        {
            _eventsWorker.AddEvent(eventModel);
        }

        [HttpGet]
        public async Task<List<EventModel>> Get()
        {
            return _eventsWorker.GetEvents();
        }

        [HttpPost]
        public void Update([FromBody] EventModel eventModel)
        {
            _eventsWorker.UpdateEvent(eventModel);
        }
    }
}
