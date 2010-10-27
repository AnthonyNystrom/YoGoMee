package domainModel
{
	import defer.Deferred;
	
	import domainModel.repositories.EventRepository;
	import domainModel.repositories.GomeeRepository;
	import domainModel.repositories.IEventRepository;
	import domainModel.repositories.IGomeeRepository;
	import domainModel.repositories.IInvitationRepository;
	import domainModel.repositories.IProfileRepository;
	import domainModel.repositories.ITargetRepository;
	import domainModel.repositories.IUserRepository;
	import domainModel.repositories.InvitationRepository;
	import domainModel.repositories.ProfileRepository;
	import domainModel.repositories.TargetRepository;
	import domainModel.repositories.UserRepository;
	import domainModel.utils.YoService;
	
	public class UnitOfWork
		implements IUnitOfWork
	{
		private var _service:YoService;
		
		public function UnitOfWork(service:YoService)
		{
			_service = service;
		}
		
		public function get service():YoService
		{
			return _service;
		}
		
		private var _userRepository:UserRepository;
		
		public function get userRepository():IUserRepository
		{
			if(_userRepository == null)
			{
				_userRepository = new UserRepository(this);
			}
			
			return _userRepository;
		}
		
		private var _gomeeRepository:GomeeRepository;
		
		public function get gomeeRepository():IGomeeRepository
		{
			if(_gomeeRepository == null)
			{
				_gomeeRepository = new GomeeRepository(this);
			}
			
			return _gomeeRepository;
		}
		
		private var _eventRepository:EventRepository;
		
		public function get eventRepository():IEventRepository
		{
			if(_eventRepository == null)
			{
				_eventRepository = new EventRepository(this);
			}
			
			return _eventRepository;
		}
		
		private var _profileRepository:ProfileRepository;
		
		public function get profileRepository():IProfileRepository
		{
			if(_profileRepository == null)
			{
				_profileRepository = new ProfileRepository(this);
			}
			
			return _profileRepository;
		}
		
		private var _targetRepository:TargetRepository;
		
		public function get targetRepository():ITargetRepository
		{
			if(_targetRepository == null)
			{
				_targetRepository = new TargetRepository(this);
			}
			
			return _targetRepository;
		}
		
		private var _invitationRepository:InvitationRepository;
		
		public function get invitationRepository():IInvitationRepository
		{
			if(_invitationRepository == null)
			{
				_invitationRepository = new InvitationRepository(this);
			}
			
			return _invitationRepository;
		}
		
		public function persistAll():Deferred
		{
			return null;
		} 	
	}
}