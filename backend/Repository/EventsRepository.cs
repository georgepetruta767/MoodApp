using Global;
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
                StartingTime = eventEntity.StartingTime,
                Status = (int)eventEntity.Status
            };

            _moodAppContext.Events.Add(eventDBEntity);

            foreach (var person in eventEntity.People)
            {
                var relationDbEntity = new EventPersonRelation()
                {
                    Id = Guid.NewGuid(),
                    EventId = eventDBEntity.Id,
                    PersonId = person.Id
                };

                _moodAppContext.Add(relationDbEntity);
            }

            _moodAppContext.SaveChanges();
        }

        public List<EventEntity> GetEvents()
        {
            return _moodAppContext.Events.Select(x => new EventEntity
            {
                Id = x.Id,
                Title = x.Title,
                People = MapPeople(_moodAppContext.EventPersonRelations.Select(y => y).Where(y => y.EventId == x.Id).Select(y => y.Person).ToList()),
                StartingTime = x.StartingTime,
                Status = (EventStatus)x.Status,
                Grade = (int)x.Grade
            }).ToList();
        }

        public static List<PersonEntity> MapPeople(List<Person> people)
        {
            var peopleEntities = new List<PersonEntity>();
            people.ForEach(x => peopleEntities.Add(new PersonEntity
            {
                Age = x.Age,
                FirstName = x.Firstname,
                LastName = x.Lastname,
                Id = x.Id,
                Gender = (Gender)x.Gender,
                SocialStatus = (SocialStatus)x.SocialStatus
            }));

            return peopleEntities;
        }

        public void UpdateEvent(EventEntity eventEntity)
        {
            var eventToUpdate = GetById((Guid)eventEntity.Id);
            //eventToUpdate.EndingTime = eventEntity.EndingTime;
            eventToUpdate.Status = (int)eventEntity.Status;
            //eventToUpdate.Grade = eventEntity.Grade;
            _moodAppContext.Update(eventToUpdate);
            _moodAppContext.SaveChanges();
        }

        public Event GetById(Guid id)
        {
            var searchedEvent = (from x in _moodAppContext.Events where x.Id == id select x).ToList();
            if (searchedEvent.Count != 0)
                return searchedEvent.First();
            return null;
        }
    }
}
