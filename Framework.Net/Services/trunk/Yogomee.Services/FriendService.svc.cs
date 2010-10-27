/* ------------------------------------------------
 * FriendService.svc.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Linq;
using Genetibase.ServiceModel;
using Yogomee.Services.Integration;
using System.Collections.Generic;
using Yogomee.Services.Responses;
using Yogomee.Services.DomainModel;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.Storage;
using System.Globalization;
using Yogomee.Services.Properties;

namespace Yogomee.Services
{
    public class FriendService : IFriendService
    {
        private IServiceContext _serviceContext;

        public FriendService()
        {
            _serviceContext = new ServiceContext();
        }

        public Contact[] GetContacts(String username, String password, String contactService)
        {
            _serviceContext.ContentType = "text/html";

            if (String.IsNullOrEmpty(username))
                throw FaultFactory.CreateFaultException<ArgumentFault>(
                    new ArgumentFault { Argument = "username", Message = "username cannot be null or an empty string." });
            if (String.IsNullOrEmpty(contactService))
                throw FaultFactory.CreateFaultException<ArgumentFault>(
                    new ArgumentFault { Argument = "contactService", Message = "contactService cannot be null or an empty string." });

            foreach (var importerType in GetImporterList())
            {
                // Try just the name
                if (importerType.Name.Equals(contactService, StringComparison.OrdinalIgnoreCase))
                {
                    return GetContacts(username, password, importerType);
                }
                // Try adding the importer suffix
                else if (importerType.Name.Equals(contactService + "Importer", StringComparison.OrdinalIgnoreCase))
                {
                    return GetContacts(username, password, importerType);
                }
            }

            throw FaultFactory.CreateFaultException<ArgumentFault>(
                new ArgumentFault
                {
                    Argument = "contactService",
                    Value = contactService,
                    Message = String.Format("Contact source \"{0}\" does not exist.", contactService)
                });
        }

        public FriendResponse AddFriend(
            Int32 memberId,
            Int32 friendMemberId)
        {
            _serviceContext.ContentType = "text/html";

            FriendResponse response = new FriendResponse();
            IUnitOfWork uow = null;
            IFriendFactory factory = null;

            try
            {
                uow = new UnitOfWork();
                factory = new FriendFactory();

                var member1 = uow.MemberRepository.Get(memberId);
                var member2 = uow.MemberRepository.Get(friendMemberId);

                var friend = factory.CreateFriend(member1, member2);
                uow.FriendRepository.Add(friend);
                uow.PersistAll();

                response.Id = friend.Id;
                response.Member1Id = friend.Member1.Id;
                response.Member2Id = friend.Member2.Id;
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "memberId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Member"),
                        Value = memberId.ToString(CultureInfo.InvariantCulture)
                    });
            }
            finally
            {
                if (uow != null)
                {
                    uow.Close();
                }
            }

            return response;
        }

        public void RemoveFriend(
            Int32 memberId,
            Int32 friendMemberId)
        {
            _serviceContext.ContentType = "text/html";

            IUnitOfWork uow = null;

            try
            {
                uow = new UnitOfWork();

                var member = uow.MemberRepository.Get(memberId);
                var friends = uow.FriendRepository.GetFor(member);

                var friend = friends
                    .Where(f => f.Member1.Id == friendMemberId || f.Member2.Id == friendMemberId)
                    .SingleOrDefault();

                if (friend == null)
                    throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "friendMemberId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Friend"),
                        Value = friendMemberId.ToString(CultureInfo.InvariantCulture)
                    });

                uow.FriendRepository.Remove(friend);
                uow.PersistAll();
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "memberId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Member"),
                        Value = memberId.ToString(CultureInfo.InvariantCulture)
                    });
            }
            finally
            {
                if (uow != null)
                {
                    uow.Close();
                }
            }
        }

        public FriendsResponse GetFriends(
            Int32 memberId,
            Int32 firstIndex,
            Int32 lastIndex)
        {
            _serviceContext.ContentType = "text/html";

            if (firstIndex < 0)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "firstIndex",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.IndexLessThan_String,
                            "firstIndex",
                            0),
                        Value = firstIndex.ToString(CultureInfo.InvariantCulture)
                    });

            if (lastIndex < 0)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "lastIndex",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.IndexLessThan_String,
                            "lastIndex",
                            0),
                        Value = lastIndex.ToString(CultureInfo.InvariantCulture)
                    });

            if (lastIndex < firstIndex)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "lastIndex",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.IndexLessThan_String,
                            "lastIndex",
                            "firstIndex"),
                        Value = lastIndex.ToString(CultureInfo.InvariantCulture)
                    });

            FriendsResponse response = new FriendsResponse();
            IUnitOfWork uow = null;

            try
            {
                uow = new UnitOfWork();
                var member = uow.MemberRepository.Get(memberId);

                var friends = uow.FriendRepository.GetFor(member);
                var members = friends
                    .Skip(firstIndex)
                    .Take(lastIndex - firstIndex + 1)
                    .Select(f =>
                    {
                        var m = f.Member1;
                        if (m.Id == memberId)
                        {
                            m = f.Member2;
                        }

                        return new MemberResponse()
                        {
                            Id = m.Id,
                            Email = m.Email
                        };
                    });

                response.AllCount = friends.Count();
                response.ResponseCount = members.Count();
                response.FirstIndex = firstIndex;
                response.Friends = members.ToArray();
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "memberId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Member"),
                        Value = memberId.ToString(CultureInfo.InvariantCulture)
                    });
            }
            finally
            {
                if (uow != null)
                {
                    uow.Close();
                }
            }

            return response;
        }

        private Contact[] GetContacts(String username, String password, Type importerType)
        {
            var contactList = new List<Contact>();

            if (importerType != null)
            {
                var importer = ContactImporterFactory.Create(importerType, username, password);

                importer.DoLogin();
                importer.ImportContacts();

                contactList = importer.Contacts;

                importer.Logout();
            }

            return contactList.ToArray();
        }

        private static IEnumerable<Type> GetImporterList()
        {
            return ContactImporterFactory.Importers;
        }
    }
}
