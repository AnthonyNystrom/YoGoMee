package domainModel.repositories
{
	import defer.Deferred;
	
	import domainModel.entities.Invitation;
	import domainModel.entities.User;
	
	public interface IInvitationRepository
	{
		function addInvitation(user:User, invitation:Invitation):Deferred;
		function removeInvitation(invitation:Invitation):Deferred;
		
		function acceptInvitation(invitation:Invitation):Deferred;
		function rejectInvitation(invitation:Invitation):Deferred;
		
		function getSentInvitations(type:int, status:int):Deferred;
		function getReceivedInvitations(type:int, status:int):Deferred;
	}
}