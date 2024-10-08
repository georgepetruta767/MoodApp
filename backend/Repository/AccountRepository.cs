﻿using Repository.EF;
using System;

namespace Repository
{
    public class AccountRepository
    {
        private readonly MoodAppContext _moodAppContext;

        public AccountRepository(MoodAppContext moodAppContext)
        {
            _moodAppContext = moodAppContext;
        }

        public void AddUserContext(string UserId)
        {
            _moodAppContext.Add(new Context
            {
                Id = Guid.NewGuid(),
                Aspnetuserid = UserId
            });

            _moodAppContext.SaveChanges();
        }
    }
}
