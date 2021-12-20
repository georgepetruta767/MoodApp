using System;
using System.Collections.Generic;
using System.Text;

namespace Worker.Models
{
    public class PersonModel
    {
        public PersonModel(string fName, string lName, int age)
        {
            this.Age = age;
            this.FirstName = fName;
            this.LastName = lName;
            this.Id = new Guid();
        }
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int Age { get; set; }
    }
}
