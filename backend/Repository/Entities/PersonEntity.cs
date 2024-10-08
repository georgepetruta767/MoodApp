﻿using Global;
using System;

namespace Repository.Entities
{
    public class PersonEntity
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int Age { get; set; }
        public Gender Gender { get; set; }
        public SocialStatus SocialStatus { get; set; }
    }
}
