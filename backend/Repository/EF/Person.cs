using System;
using System.Collections.Generic;

#nullable disable

namespace Repository.EF
{
    public partial class Person
    {
        public Person()
        {
            EventPersonRelations = new HashSet<EventPersonRelation>();
        }

        public Guid Id { get; set; }
        public string Firstname { get; set; }
        public string Lastname { get; set; }
        public int Age { get; set; }
        public int Gender { get; set; }

        public virtual ICollection<EventPersonRelation> EventPersonRelations { get; set; }
    }
}
