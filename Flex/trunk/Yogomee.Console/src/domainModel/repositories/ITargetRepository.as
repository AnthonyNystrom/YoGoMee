package domainModel.repositories
{
	import com.google.maps.LatLngBounds;
	
	import defer.Deferred;
	
	import domainModel.entities.Event;
	import domainModel.entities.Gomee;
	import domainModel.entities.Target;
	import domainModel.entities.User;
	
	public interface ITargetRepository
	{
		function addTarget(target:Target):Deferred;
		function removeTarget(target:Target):Deferred;
		
		function getTarget(id:String):Deferred;
		function getTargets(bounds:LatLngBounds):Deferred;
		function getUserTargets(bounds:LatLngBounds, user:User = null):Deferred;
		function getGomeeTargets(gomee:Gomee):Deferred;
		function getEventTargets(event:Event):Deferred;
	}
}