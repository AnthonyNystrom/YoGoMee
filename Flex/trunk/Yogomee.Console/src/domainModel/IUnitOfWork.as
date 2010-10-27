package domainModel
{
	import defer.Deferred;
	
	import domainModel.repositories.IEventRepository;
	import domainModel.repositories.IGomeeRepository;
	import domainModel.repositories.IInvitationRepository;
	import domainModel.repositories.IProfileRepository;
	import domainModel.repositories.ITargetRepository;
	import domainModel.repositories.IUserRepository;
	import domainModel.utils.YoService;
	
	public interface IUnitOfWork
	{
		function get userRepository():IUserRepository;
		function get profileRepository():IProfileRepository;
		function get gomeeRepository():IGomeeRepository;
		function get eventRepository():IEventRepository;
		function get targetRepository():ITargetRepository;
		function get invitationRepository():IInvitationRepository;
		
		function get service():YoService;
		
		function persistAll():Deferred;
	}
}