using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Worker;

namespace backend.Controllers
{
    public class EventsController
    {
        private EventsWorker _eventsWorker;

        public EventsController(EventsWorker eventsWorker)
        {
            _eventsWorker = eventsWorker;
        }
    }
}
