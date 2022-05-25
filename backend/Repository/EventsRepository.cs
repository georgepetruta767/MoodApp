using Global;
using Microsoft.EntityFrameworkCore;
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

        public void AddEvent(EventEntity eventEntity, string userId)
        {
            Guid contextId = _moodAppContext.Contexts.Where(x => x.Aspnetuserid == userId)!.First().Id;

            var eventDBEntity = new Event()
            {
                Id = Guid.NewGuid(),
                Title = eventEntity.Title,
                StartingTime = eventEntity.StartingTime,
                Status = (int)eventEntity.Status,
                Season = (int)eventEntity.Season,
                ContextId = contextId,
                Type = (int)eventEntity.Type
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

        public List<EventEntity> GetEvents(string userId)
        {
            Guid contextId = _moodAppContext.Contexts.Where(x => x.Aspnetuserid == userId)!.First().Id;

            var events = _moodAppContext.Events.Include(x => x.EventPersonRelations).ThenInclude(x => x.Person);

            return events.Where(x => x.ContextId == contextId).Select(x => new EventEntity
            {
                Id = x.Id,
                Title = x.Title,
                People = MapPeople(x.EventPersonRelations.Select(x => x.Person).ToList()),
                StartingTime = x.StartingTime,
                EndingTime = x.EndingTime,
                Status = (EventStatus)x.Status,
                Grade = (int)x.Grade,
                Type = (EventType)x.Type,
                AmountSpent = x.AmountSpent
            }).ToList();
        }

        public List<EventEntity> GetEventsByDate(string userId, DateTime eventsDate)
        {
            Guid contextId = _moodAppContext.Contexts.Where(x => x.Aspnetuserid == userId)!.First().Id;

            var events = _moodAppContext.Events.Include(x => x.EventPersonRelations).ThenInclude(x => x.Person);

            return events.Where(x => x.ContextId == contextId && x.StartingTime.Date == eventsDate.Date).Select(x => new EventEntity
            {
                Id = x.Id,
                Title = x.Title,
                People = MapPeople(x.EventPersonRelations.Select(x => x.Person).ToList()),
                StartingTime = x.StartingTime,
                EndingTime = x.EndingTime,
                Status = (EventStatus)x.Status,
                Grade = (int)x.Grade,
                Type = (EventType)x.Type,
                AmountSpent= x.AmountSpent
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

        public double GetDistance(double longitude, double latitude, double otherLongitude, double otherLatitude)
        {
            var d1 = latitude * (Math.PI / 180.0);
            var num1 = longitude * (Math.PI / 180.0);
            var d2 = otherLatitude * (Math.PI / 180.0);
            var num2 = otherLongitude * (Math.PI / 180.0) - num1;
            var d3 = Math.Pow(Math.Sin((d2 - d1) / 2.0), 2.0) + Math.Cos(d1) * Math.Cos(d2) * Math.Pow(Math.Sin(num2 / 2.0), 2.0);

            return 6376500.0 * (2.0 * Math.Atan2(Math.Sqrt(d3), Math.Sqrt(1.0 - d3)));
        }

        public void UpdateEvent(EventEntity eventEntity)
        {
            var eventToUpdate = GetById((Guid)eventEntity.Id);
            eventToUpdate.StartingTime = eventEntity.StartingTime;
            eventToUpdate.EndingTime = eventEntity.EndingTime;
            eventToUpdate.Status = (int)eventEntity.Status;
            eventToUpdate.Grade = eventEntity.Grade;
            eventToUpdate.Type = (int)eventEntity.Type;
            eventToUpdate.AmountSpent = eventEntity.AmountSpent;
            eventToUpdate.Title = eventEntity.Title;

            if(eventEntity.Location != null)
            {
                var locations = _moodAppContext.Locations;
                bool doesLocationExist = false;

                foreach (var location in locations)
                {
                    var distance = GetDistance(eventEntity.Location.Longitude, eventEntity.Location.Latitude, location.Longitude, location.Latitude);

                    if (distance < 30)
                    {
                        eventToUpdate.Location = location;
                        doesLocationExist = true;
                    }
                }

                if (!doesLocationExist)
                {
                    var locationDbEntity = new Location
                    {
                        Id = Guid.NewGuid(),
                        Longitude = eventEntity.Location.Longitude,
                        Latitude = eventEntity.Location.Latitude,
                        City = eventEntity.Location.City,
                        Country = eventEntity.Location.Country
                    };

                    _moodAppContext.Locations.Add(locationDbEntity);

                    eventToUpdate.Location = locationDbEntity;
                }
            }


            eventToUpdate.EventPersonRelations.Clear();
            var relations = _moodAppContext.EventPersonRelations.Where(x => x.EventId == eventToUpdate.Id);

            foreach(var relationDbEntity in relations)
            {
                _moodAppContext.EventPersonRelations.Remove(relationDbEntity);
            }

            foreach (var person in eventEntity.People)
            {
                var relationDbEntity = new EventPersonRelation()
                {
                    Id = Guid.NewGuid(),
                    EventId = eventToUpdate.Id,
                    PersonId = person.Id
                };

                _moodAppContext.EventPersonRelations.Add(relationDbEntity);
                eventToUpdate.EventPersonRelations.Add(relationDbEntity);
            }

            _moodAppContext.Update(eventToUpdate);
            _moodAppContext.SaveChanges();
        }

        public EventEntity GetEventById(Guid id)
        {
            var searchedEvent = _moodAppContext.Events.Where(x => x.Id == id).Select(x => new EventEntity
            {
                Id = x.Id,
                Title = x.Title,
                Location = x.LocationId != null ? new LocationEntity
                {
                    City = x.Location.City,
                    Country = x.Location.Country,
                    Longitude = x.Location.Longitude,
                    Latitude = x.Location.Latitude,
                    Id = x.Location.Id
                } : null,
                People = MapPeople(x.EventPersonRelations.Select(x => x.Person).ToList()),
                StartingTime = x.StartingTime,
                EndingTime = x.EndingTime,
                Status = (EventStatus)x.Status,
                Grade = (int)x.Grade,
                Type = (EventType)x.Type,
                Season = (Season)x.Season,
                AmountSpent = x.AmountSpent
            }).ToList();

            if (searchedEvent.Count != 0)
                return searchedEvent.First();
            return null;
        }

        public Event GetById(Guid id)
        {
            var searchedEvent = (from x in _moodAppContext.Events where x.Id == id select x).ToList();
            if (searchedEvent.Count != 0)
                return searchedEvent.First();
            return null;
        }

        public void DeleteEvent(Guid eventId)
        {
            var searchedEvent = GetById(eventId);
            var people = _moodAppContext.EventPersonRelations.Where(e => e.EventId == eventId);

            foreach(var personEntity in people)
            {
                _moodAppContext.EventPersonRelations.Remove(personEntity);
            }

            _moodAppContext.Events.Remove(searchedEvent);
            _moodAppContext.SaveChanges();
        }
    }
}
