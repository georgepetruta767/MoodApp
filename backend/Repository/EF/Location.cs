using System;
using System.Collections.Generic;

#nullable disable

namespace Repository.EF
{
    public partial class Location
    {
        public Location()
        {
            Events = new HashSet<Event>();
        }

        public Guid Id { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string City { get; set; }

        public virtual ICollection<Event> Events { get; set; }
    }
}
