using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Worker;
using System.Collections.Generic;
using Worker.Models;
using System.Threading.Tasks;
using System;
using Microsoft.AspNetCore.Identity;
using Repository.Entities;
using System.Security.Claims;

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
            var userId = User.FindFirstValue(ClaimTypes.Name);
            return _peopleWorker.GetPeople(userId);
        }

        [HttpPost]
        public void Add([FromBody] PersonModel personModel)
        {
            var userId = User.FindFirstValue(ClaimTypes.Name);
            _peopleWorker.AddPerson(personModel, userId);
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
