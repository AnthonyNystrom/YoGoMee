package domainModel.repositories
{
	import com.adobe.serialization.json.JSON;
	
	import defer.Deferred;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Gomee;
	import domainModel.entities.Profile;
	import domainModel.entities.User;
	import domainModel.utils.YoService;

	public class ProfileRepository implements IProfileRepository
	{
		private var _uow:UnitOfWork;
		
		public function ProfileRepository(uow:UnitOfWork)
		{
			_uow = uow;
		}
		
		public function get service():YoService
		{
			return _uow.service;
		}
		
		public function getProfile(user:User = null):Deferred
		{
			function check_user(...args):Deferred
			{
				if (user == null)
				{
					return _uow.userRepository.getMe();
				}
				
				return Deferred.succeed(user);
			}
			
			function send(_user:User):Deferred
			{
				user = _user;
				return service.send("/users/" + user.id + "/profile", "GET");
			}
			
			function create(result:Object):Deferred
			{
				var profile:Profile = new Profile();
				profile.id = result.id;
				profile.user = user;
				profile.firstName = result.firstName;
				profile.lastName = result.lastName;
				profile.email = result.email;
				profile.twitterLogin = result.twitterLogin;
				profile.twitterSecret = "";
				profile.twitterUpdateOnAddGomee = result.twitterUpdateOnAddGomee;
				profile.twitterUpdateOnSaveGomee = result.twitterUpdateOnSaveGomee;
				profile.twitterUpdateOnDeleteGomee = result.twitterUpdateOnDeleteGomee;
				 
				var gomees:Array = new Array();
				
				for(var i:int = 0; i < result.gomees.length; i++)
				{
					var resultg:Object = result.gomees[i];
					var gomee:Gomee = new Gomee();
					gomee.id = resultg.id;
					gomee.owner = user;
					gomee.lat = resultg.lat;
					gomee.lng = resultg.lng;
					gomee.caption = resultg.caption;
					gomee.address = resultg.address;
					gomee.description = resultg.description;
					gomee.type = resultg.type;
					gomee.common = resultg.common;
					gomee.tags = resultg.tags;
					
					gomees.push(gomee);
				}
				
				profile.setGomees(gomees);
				
				return Deferred.succeed(profile);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(check_user);
			d.addCallback(send);
			d.addCallback(create);
			
			Deferred.callLater(0, d.callback, null);			
			return d;
		}
		
		public function saveProfile(profile:Profile):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/profile", "PUT", null, JSON.encode(profile));
			}
			
			function complete(...args):Deferred
			{
				return Deferred.succeed(profile);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(complete);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
	}
}