package controls.map.controllers
{
	import controls.map.marker.YoHomeMarker;
	import controls.map.marker.YoMarker;
	import controls.map.marker.YoProfileMarker;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Profile;
	
	import mx.core.UIComponent;

	public class ProfileMarkersController extends GomeeMarkersController
	{
		public function ProfileMarkersController(layer:UIComponent)
		{
			super(layer);
		}
		
		protected override function getId(object:Object):Object
		{
			return super.getId(object.gomee);
		}
		
		protected override function updateMarker(marker:YoMarker, object:Object):void
		{
			super.updateMarker(marker, object.gomee);
			
			var p:Profile = object.profile as Profile;
			var m:YoProfileMarker = marker as YoProfileMarker;
			
			if(p == null || m == null)
			{
				return;
			}
			else
			{
				m.login = p.user.login;
				m.firstName = p.firstName;
				m.lastName = p.lastName;
				m.email = p.email;
				m.twitterLogin = p.twitterLogin;
				m.twitterSecret = p.twitterSecret;
				m.twitterUpdateOnAddGomee = p.twitterUpdateOnAddGomee;
				m.twitterUpdateOnSaveGomee = p.twitterUpdateOnSaveGomee;
				m.twitterUpdateOnDeleteGomee = p.twitterUpdateOnDeleteGomee;	
			}
		}
		
		protected override function createMarker():YoMarker
		{
			return new YoHomeMarker();
		}
	}
}