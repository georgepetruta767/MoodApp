﻿using Global;
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
                ContextId = contextId
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
            eventToUpdate.StartingTime = eventEntity.StartingTime;
            eventToUpdate.EndingTime = eventEntity.EndingTime;
            eventToUpdate.Status = (int)eventEntity.Status;
            eventToUpdate.Grade = eventEntity.Grade;

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
