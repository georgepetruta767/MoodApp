﻿
using AutoMapper;
using Repository;
using Repository.Entities;
using System;
using System.Collections.Generic;
using Worker.Models;

namespace Worker
{
    public class PeopleWorker
    {
        private PeopleRepository _peopleRepository;
        private IMapper _mapper;
        public PeopleWorker(PeopleRepository peopleRepository, IMapper mapper)
        {
            _peopleRepository = peopleRepository;
            _mapper = mapper;
        }

        public List<PersonModel> GetPeople(string userId)
        {
            var peopleEntity = _peopleRepository.GetPeople(userId);
            return _mapper.Map<List<PersonModel>>(peopleEntity);
        }

        public void AddPerson(PersonModel personModel, string userId)
        {
            var personEntity = _mapper.Map<PersonEntity>(personModel);
            _peopleRepository.AddPerson(personEntity, userId);
        }

        public void UpdatePerson(PersonModel personModel)
        {
            var personEntity = _mapper.Map<PersonEntity>(personModel);
            _peopleRepository.UpdatePerson(personEntity);
        }

        public void DeletePerson(Guid personId)
        {
            _peopleRepository.DeletePerson(personId);
        }
    }
}
