using System;
using System.Collections.Generic;
using System.Text;

namespace Repository.Entities
{
    public class LocationEntity
    {
        public Guid? Id { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
    }
}
