using Repository.EF;
using Repository.Entities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Repository
{
    public class EventsRepository
    {
        private readonly MoodAppContext _moodAppContext;

        public EventsRepository(MoodAppContext moodAppContext)
        {
            _moodAppContext = moodAppContext;
        }

        public void AddEvent(EventEntity eventEntity)
        {
            var eventDBEntity = new Event()
            {
                Id = Guid.NewGuid(),
                Title = eventEntity.Title,
                StartingTime = eventEntity.Date
            };

            _moodAppContext.Events.Add(eventDBEntity);

            foreach (var personId in eventEntity.PeopleIds)
            {
                var relationDbEntity = new EventPersonRelation()
                {
                    Id = Guid.NewGuid(),
                    EventId = eventDBEntity.Id,
                    PersonId = personId
                };

                _moodAppContext.Add(relationDbEntity);
            }

            _moodAppContext.SaveChanges();
        }
        public List<EventEntity> GetEvents()
        {
            return (List<EventEntity>)_moodAppContext.Events.Select(x => new EventEntity
            {
                Id = x.Id,
                Title = x.Title,
                PeopleIds = _moodAppContext.EventPersonRelations.Select(y => y).Where(y => y.EventId == x.Id).Select(y => y.PersonId).ToList(),
                Date = (DateTime)x.StartingTime
            });

        }
    }
}
