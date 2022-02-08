using Repository.EF;
using System;
using System.Collections.Generic;
using System.Text;

namespace Repository
{
    public class EventsRepository
    {
        private readonly MoodAppContext _moodAppContext;

        public EventsRepository(MoodAppContext moodAppContext)
        {
            _moodAppContext = moodAppContext;
        }
    }
}
