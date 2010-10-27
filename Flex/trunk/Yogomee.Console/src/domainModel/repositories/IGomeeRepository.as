package domainModel.repositories
{
	import com.google.maps.LatLng;
	
	import defer.Deferred;
	
	import domainModel.entities.Gomee;
	import domainModel.entities.User;
	
	public interface IGomeeRepository
	{
		function addGomee(gomee:Gomee):Deferred;
		function saveGomee(gomee:Gomee):Deferred;
		function removeGomee(gomee:Gomee):Deferred;
		function getGomee(id:String):Deferred;
		
		function getGomees(ll1:LatLng, ll2:LatLng, user:User = null, tags:Array = null):Deferred;
	}
}