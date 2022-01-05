using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Worker;
using Worker.Models;

namespace backend.Controllers
{
    [ApiController]
    [Route("moodapp/api/[controller]/[action]")]
    public class EventsController
    {
        private EventsWorker _eventsWorker;

        public EventsController(EventsWorker eventsWorker)
        {
            _eventsWorker = eventsWorker;
        }

        [HttpPost]
        public void Add([FromBody] EventModel eventModel)
        {

        }
    }
}
