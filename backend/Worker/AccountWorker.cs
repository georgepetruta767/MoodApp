using Repository;

namespace Worker
{
    public class AccountWorker
    {
        private AccountRepository _accountRepository;

        public AccountWorker(AccountRepository accountRepository)
        {
            _accountRepository = accountRepository;
        }

        public void AddUserContext(string UserId)
        {
            _accountRepository.AddUserContext(UserId);
        }
    }
}
