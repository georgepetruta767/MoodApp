using Global;
using System;
using System.Collections.Generic;

namespace Repository.Entities
{
    public class EventEntity
    {
        public Guid? Id { get; set; }
        public string Title { get; set; }
        public List<PersonEntity> People { get; set; }
        public DateTime? StartingTime { get; set; }
        public EventStatus Status { get; set; }
        public DateTime? EndingTime { get; set; }
        public int? Grade { get; set; }
    }
}
