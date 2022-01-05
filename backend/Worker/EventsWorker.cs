using Repository;
using System;
using System.Collections.Generic;
using System.Text;

namespace Worker
{
    public class EventsWorker
    {
        private EventsRepository _eventsRepository;

        public EventsWorker(EventsRepository eventsRepository)
        {
            _eventsRepository = eventsRepository;
        }

    }
}
