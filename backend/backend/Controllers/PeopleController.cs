using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Worker;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [ApiController]
    [Route("moodapp/api/[controller]/[action]")]
    public class PeopleController : ControllerBase
    {
        private PeopleWorker _peopleWorker;

        public PeopleController(PeopleWorker peopleWorker)
        {
            _peopleWorker = peopleWorker;
        }
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> GetPeople()
        {
            return _peopleWorker.GetPeople();
        }
    }
}
