using AutoMapper;
using Global;
using Repository.Entities;
using System;
using System.Collections.Generic;

namespace Worker.Models
{
    [AutoMap(typeof(PersonEntity), ReverseMap = true)]
    [AutoMap(typeof(List<PersonEntity>), ReverseMap = true)]
    public class PersonModel
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int Age { get; set; }
        public Gender Gender { get; set; }
        public SocialStatus SocialStatus { get; set; }
    }
}
