using AutoMapper;
using Repository;
using Repository.Entities;
using System;
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

        public void AddEvent(EventModel eventModel, string userId)
        {
            var _eventEntity = _mapper.Map<EventEntity>(eventModel);
            _eventsRepository.AddEvent(_eventEntity, userId);
        }

        public List<EventModel> GetEvents(string userId)
        {
            var eventsEntity = _eventsRepository.GetEvents(userId);
            return _mapper.Map<List<EventModel>>(eventsEntity);
        }

        public List<EventModel> GetEventsByDate(string userId, DateTime eventsDate)
        {
            var eventsEntity = _eventsRepository.GetEventsByDate(userId, eventsDate);
            return _mapper.Map<List<EventModel>>(eventsEntity);
        }


        public EventModel GetEventById(Guid id)
        {
            return _mapper.Map<EventModel>(_eventsRepository.GetEventById(id));
        }

        public void UpdateEvent(EventModel eventModel)
        {
            var eventEntity = _mapper.Map<EventEntity>(eventModel);
            _eventsRepository.UpdateEvent(eventEntity);
        }

        public void DeleteEvent(Guid id)
        {
            _eventsRepository.DeleteEvent(id);
        }
    }
}