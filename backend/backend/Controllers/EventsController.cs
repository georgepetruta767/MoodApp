using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using Worker;
using Worker.Models;

namespace backend.Controllers
{
    [ApiController]
    [Route("moodapp/api/[controller]/[action]")]
    [Authorize]
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
            string userId = User.FindFirstValue(ClaimTypes.Name);
            _eventsWorker.AddEvent(eventModel, userId);
        }

        [HttpGet]
        public async Task<List<EventModel>> Get()
        {
            string userId = User.FindFirstValue(ClaimTypes.Name);
            return _eventsWorker.GetEvents(userId);
        }

        [HttpGet]
        public async Task<EventModel> GetEventById([FromQuery] Guid id)
        {
            return _eventsWorker.GetEventById(id);
        }

        [HttpGet]
        public async Task<List<EventModel>> GetEventsByDate([FromQuery] DateTime date)
        {
            string userId = User.FindFirstValue(ClaimTypes.Name);
            return _eventsWorker.GetEventsByDate(userId, date);
        }

        [HttpPost]
        public void Update([FromBody] EventModel eventModel)
        {
            _eventsWorker.UpdateEvent(eventModel);
        }

        [HttpDelete]
        public void Delete([FromQuery] Guid id)
        {
            _eventsWorker.DeleteEvent(id);
        }
    }
}
