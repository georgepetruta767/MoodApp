using System;
using System.Collections.Generic;
using System.Text;

namespace Worker.Models
{
    public class AppSettings
    {
        public Authorization Authorization { get; set; }
    }

    public class Authorization
    {
        public string Secret { get; set; }

    }
}
