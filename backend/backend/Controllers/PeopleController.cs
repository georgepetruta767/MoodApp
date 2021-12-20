using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Worker;
using System.Collections.Generic;
using Worker.Models;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [ApiController]
    [Route("moodapp/api/[controller]/[action]")]
    public class PeopleController : ControllerBase
    {
        //private PeopleWorker _peopleWorker;

        public PeopleController()
        {
            //_peopleWorker = peopleWorker;
        }
        
        [HttpGet]
        [AllowAnonymous]
        public async Task<List<PersonModel>> Get()
        {
            List<PersonModel> people = new List<PersonModel>();
            people.Add(new PersonModel("aoifsj", "oaishc", 32));
            people.Add(new PersonModel("sofiduh", "iufhofuh", 83));
            return await Task.FromResult(people);
        }
    }
}
