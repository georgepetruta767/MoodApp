using System;
using System.Collections.Generic;
using System.Text;

namespace Worker.Models
{
    class PersonModel
    {
        public Guid Id { get; set; }
        public string Firstname { get; set; }
        public string Lastname { get; set; }
        public int Age { get; set; }
    }
}
