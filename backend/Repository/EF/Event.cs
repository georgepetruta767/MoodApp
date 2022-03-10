using System;
using System.Collections.Generic;

#nullable disable

namespace Repository.EF
{
    public partial class Event
    {
        public Event()
        {
            EventPersonRelations = new HashSet<EventPersonRelation>();
        }

        public Guid Id { get; set; }
        public string Title { get; set; }
        public Guid? LocationId { get; set; }
        public int? Grade { get; set; }
        public int Status { get; set; }
        public int Type { get; set; }
        public DateTime? StartingTime { get; set; }
        public DateTime? EndingTime { get; set; }
        public int Season { get; set; }
        public int? AmountSpent { get; set; }
        public Guid ContextId { get; set; }

        public virtual Context Context { get; set; }
        public virtual Location Location { get; set; }
        public virtual ICollection<EventPersonRelation> EventPersonRelations { get; set; }
    }
}
