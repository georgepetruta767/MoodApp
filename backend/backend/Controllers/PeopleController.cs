using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Worker;
using System.Collections.Generic;
using Worker.Models;
using System.Threading.Tasks;
using System;

namespace backend.Controllers
{
    [ApiController]
    [Route("moodapp/api/[controller]/[action]")]
    [Authorize]
    public class PeopleController : ControllerBase
    {
        private PeopleWorker _peopleWorker;

        public PeopleController(PeopleWorker peopleWorker)
        {
            _peopleWorker = peopleWorker;
        }
        
        [HttpGet]
        public async Task<List<PersonModel>> Get()
        {
            return _peopleWorker.GetPeople();
        }

        [HttpPost]
        public void Add([FromBody] PersonModel personModel)
        {
            _peopleWorker.AddPerson(personModel);
        }

        [HttpPost]
        public void Update([FromBody] PersonModel personModel)
        {
            _peopleWorker.UpdatePerson(personModel);
        }

        [HttpDelete]
        public void Delete([FromQuery] Guid id)
        {
            _peopleWorker.DeletePerson(id);
        }
    }
}
