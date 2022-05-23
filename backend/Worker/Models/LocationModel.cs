using AutoMapper;
using Repository.Entities;
using System;
using System.Collections.Generic;

namespace Worker.Models
{
    [AutoMap(typeof(LocationEntity), ReverseMap = true)]
    [AutoMap(typeof(List<LocationEntity>), ReverseMap = true)]
    public class LocationModel
    {
        public Guid? Id { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
    }
}
