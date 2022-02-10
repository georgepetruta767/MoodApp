using System;
using System.Collections.Generic;

namespace Repository.Entities
{
    public class EventEntity
    {
        public Guid Id { get; set; }
        public string Title { get; set; }
        public List<Guid> PeopleIds { get; set; }
        public DateTime? Date { get; set; }
    }
}
