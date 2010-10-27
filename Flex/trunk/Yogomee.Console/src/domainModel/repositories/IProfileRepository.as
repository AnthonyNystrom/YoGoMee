package domainModel.repositories
{
	import defer.Deferred;
	
	import domainModel.entities.Profile;
	import domainModel.entities.User;
	
	public interface IProfileRepository
	{
		function getProfile(user:User = null):Deferred;
		function saveProfile(profile:Profile):Deferred;		
	}
}