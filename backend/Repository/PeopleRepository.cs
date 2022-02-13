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

        public List<PersonEntity> GetPeople()
        {
            return _moodAppContext.People.Select(x => new PersonEntity
            {
                Id = x.Id,
                FirstName = x.Firstname,
                LastName = x.Lastname,
                Age = x.Age,
                Gender = (Global.Gender)x.Gender
            }).ToList();
        }

        public void AddPerson(PersonEntity personEntity)
        {
            var dbEntity = new Person()
            {
                Id = Guid.NewGuid(),
                Firstname = personEntity.FirstName,
                Lastname = personEntity.LastName,
                Age = personEntity.Age,
                Gender = (int)personEntity.Gender
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
            _moodAppContext.People.Remove(person);
            _moodAppContext.SaveChanges();
        }
    }
}
