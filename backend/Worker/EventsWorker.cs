using AutoMapper;
using Repository;
using Repository.Entities;
using System.Collections.Generic;
using Worker.Models;

namespace Worker
{
    public class EventsWorker
    {
        private EventsRepository _eventsRepository;
        private IMapper _mapper;

        public EventsWorker(EventsRepository eventsRepository, IMapper mapper)
        {
            _eventsRepository = eventsRepository;
            _mapper = mapper;
        }

        public void AddEvent(EventModel eventModel)
        {
            var _eventEntity = _mapper.Map<EventEntity>(eventModel);
            _eventsRepository.AddEvent(_eventEntity);
        }

        public List<EventModel> GetEvents()
        {
            var eventsEntity = _eventsRepository.GetEvents();
            return _mapper.Map<List<EventModel>>(eventsEntity);
        }

        public void UpdateEvent(EventModel eventModel)
        {
            var eventEntity = _mapper.Map<EventEntity>(eventModel);
            _eventsRepository.UpdateEvent(eventEntity);
        }
    }
}
