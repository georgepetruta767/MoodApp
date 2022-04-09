using System;
using System.Collections.Generic;
using System.Text;

namespace Worker.Models
{
    public class AppSettings
    {
        public Authorization Authorization { get; set; }
        public Authentication Authentication { get; set; }
    }

    public class Authorization
    {
        public string Secret { get; set; }
    }

    public class Authentication
    {
        public Google Google { get; set; }
    }

    public class Google
    {
        public string ClientId { get; set; }
        public string ClientSecret { get; set; } 
    }
}
