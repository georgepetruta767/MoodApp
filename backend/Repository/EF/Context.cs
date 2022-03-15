using System;
using System.Collections.Generic;

#nullable disable

namespace Repository.EF
{
    public partial class Context
    {
        public Context()
        {
            Events = new HashSet<Event>();
            People = new HashSet<Person>();
        }

        public Guid Id { get; set; }

        public virtual ICollection<Event> Events { get; set; }
        public virtual ICollection<Person> People { get; set; }
    }
}
