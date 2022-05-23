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
        public Guid? Id { get; set; }
        public string Title { get; set; }
        public List<PersonModel> People { get; set; }
        public DateTime? StartingTime { get; set; }
        public DateTime? EndingTime { get; set; }
        public EventStatus Status { get; set; } 
        public EventType Type { get; set; }
        public int? Grade { get; set; }
        public int? AmountSpent { get; set; }
        public Season Season { get; set; }
        public LocationModel? Location { get; set; }
    }
}
