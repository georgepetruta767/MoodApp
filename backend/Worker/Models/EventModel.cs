using AutoMapper;
using Global;
using Repository.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Worker.Models
{
    [AutoMap(typeof(EventEntity), ReverseMap = true)]
    [AutoMap(typeof(List<EventEntity>), ReverseMap = true)]
    public class EventModel
    {
        public String Title { get; set; }
        public List<Guid> PeopleIds { get; set; }
        public DateTime Date { get; set; }
        public EventStatus Status { get; set; } 
    }
}
