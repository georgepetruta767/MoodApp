using System;
using System.Collections.Generic;
using System.Text;

namespace Repository.Entities
{
    public class PersonEntity
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int Age { get; set; }
    }
}
