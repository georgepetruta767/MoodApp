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
                Age = x.Age
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
    }
}
