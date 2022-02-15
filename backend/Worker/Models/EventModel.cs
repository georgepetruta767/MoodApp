using AutoMapper;
using Global;
using Repository.Entities;
using System;
using System.Collections.Generic;

namespace Worker.Models
{
    [AutoMap(typeof(EventEntity), ReverseMap = true)]
    [AutoMap(typeof(List<EventEntity>), ReverseMap = true)]
    public class EventModel
    {
        public string Title { get; set; }
        public List<Guid> PeopleIds { get; set; }
        public DateTime StartingTime { get; set; }
        public EventStatus Status { get; set; } 
        public int? Grade { get; set; }
    }
}
