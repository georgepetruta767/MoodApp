using Repository.EF;
using Repository.Entities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Repository
{
    public class PeopleRepository
    {
        private readonly MoodAppContext _moodAppContext;

        public PeopleRepository(MoodAppContext moodAppContext)
        {
            _moodAppContext = moodAppContext;
        }

        public List<PersonEntity> GetPeople(string userId)
        {
            Guid contextId = _moodAppContext.Contexts.Where(x => x.Aspnetuserid == userId)!.First().Id;

            return _moodAppContext.People.Where(x => x.ContextId == contextId).Select(x => new PersonEntity
            {
                Id = x.Id,
                FirstName = x.Firstname,
                LastName = x.Lastname,
                Age = x.Age,
                Gender = (Global.Gender)x.Gender,
                SocialStatus = (Global.SocialStatus)x.SocialStatus,
            }).ToList();
        }

        public void AddPerson(PersonEntity personEntity, string userId)
        {
            Guid contextId = _moodAppContext.Contexts.Where(x => x.Aspnetuserid == userId)!.First().Id;
            var dbEntity = new Person()
            {
                Id = Guid.NewGuid(),
                Firstname = personEntity.FirstName,
                Lastname = personEntity.LastName,
                Age = personEntity.Age,
                Gender = (int)personEntity.Gender,
                SocialStatus = (int)personEntity.SocialStatus,
                ContextId = contextId
            };

            _moodAppContext.People.Add(dbEntity);

            _moodAppContext.SaveChanges();
        }

        public void UpdatePerson(PersonEntity personEntity)
        {
            var personToUpdate = GetById(personEntity.Id);
            personToUpdate.Firstname = personEntity.FirstName;
            personToUpdate.Lastname = personEntity.LastName;
            personToUpdate.Age = personEntity.Age;
            personToUpdate.Gender = (int)personEntity.Gender;

            _moodAppContext.People.Update(personToUpdate);
            _moodAppContext.SaveChanges();
        }

        public Person GetById(Guid id)
        {
            var person = (from x in _moodAppContext.People where x.Id == id select x).ToList();
            if (person.Count != 0)
                return person.First();
            return null;
        }

        public void DeletePerson(Guid personId)
        {

            var person = GetById(personId);
            var people = _moodAppContext.EventPersonRelations.Where(p => p.PersonId == personId);
            foreach (var personEntity in people)
            {
                _moodAppContext.EventPersonRelations.Remove(personEntity);
            }
            _moodAppContext.People.Remove(person);
            _moodAppContext.SaveChanges();
        }
    }
}
