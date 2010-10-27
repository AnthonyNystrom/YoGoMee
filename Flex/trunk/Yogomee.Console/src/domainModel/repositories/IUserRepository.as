package domainModel.repositories
{
	import com.google.maps.LatLng;
	
	import defer.Deferred;
	
	import domainModel.entities.User;
	
	public interface IUserRepository
	{
		function addUser(user:User):Deferred;
		
		function getMe():Deferred;
		function getUser(id:String):Deferred;
		
		function getUsers(ll1:LatLng, ll2:LatLng):Deferred;
		function getFriends():Deferred;
	}
}