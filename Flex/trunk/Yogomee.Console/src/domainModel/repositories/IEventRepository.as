package domainModel.repositories
{
	import com.google.maps.LatLngBounds;
	
	import defer.Deferred;
	
	import domainModel.entities.Event;
	import domainModel.entities.Gomee;
	import domainModel.entities.User;
	
	public interface IEventRepository
	{
		function addEvent(event:Event):Deferred;
		function saveEvent(event:Event):Deferred;
		function removeEvent(event:Event):Deferred;
		
		function getEvent(id:String):Deferred;
		function getEvents(bounds:LatLngBounds):Deferred;
		function getUserEvents(bounds:LatLngBounds, user:User = null):Deferred;
		function getGomeeEvents(gomee:Gomee):Deferred;
	}
}