using System;
using System.Collections.Generic;

#nullable disable

namespace Repository.EF
{
    public partial class EventPersonRelation
    {
        public Guid Id { get; set; }
        public Guid EventId { get; set; }
        public Guid PersonId { get; set; }

        public virtual Event Event { get; set; }
        public virtual Person Person { get; set; }
    }
}
