using System;
using System.Collections.Generic;
using System.Text;

namespace Worker.Models
{
    public class AppSettings
    {
        public Authorization Authorization { get; set; }
        public GoogleAuth GoogleAuth { get; set; }
    }

    public class Authorization
    {
        public string Secret { get; set; }
    }

    public class GoogleAuth
    {
        public string ClientId { get; set; }
    }
}
