using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using Yogomee.Services.Responses;
using Genetibase.ServiceModel;
using System.Globalization;
using Yogomee.Services.Properties;
using Yogomee.Services.DomainModel;
using Yogomee.Services.Storage;
using Yogomee.Services.DomainModel.Factories;

namespace Yogomee.Services
{
    public class MemberService : IMemberService
    {
        private IServiceContext _serviceContext;

        public MemberService()
        {
            _serviceContext = new ServiceContext();
        }

        public MemberResponse AddMember(String email)
        {
            _serviceContext.ContentType = "text/html";

            MemberResponse response = new MemberResponse();
            IUnitOfWork uow = null;
            IMemberFactory factory = null;

            try
            {
                uow = new UnitOfWork();
                factory = new MemberFactory();

                var member = factory.CreateMember(email);
                uow.MemberRepository.Add(member);
                uow.PersistAll();

                response.Id = member.Id;
                response.Email = member.Email;
            }
            catch (ArgumentNullException)
            { 
                throw FaultFactory.CreateFaultException(
                        new ArgumentFault()
                        {
                            Argument = "email",
                            Message = String.Format(
                                CultureInfo.InvariantCulture,
                                Resources.CannotBeNullOrEmptyString_String,
                                "Email",
                                0),
                            Value = email
                        });
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "email",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityAllreadyExist_String,
                            "Member"),
                        Value = email
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

        public MemberResponse GetMember(Int32 memberId)
        {
            _serviceContext.ContentType = "text/html";

            MemberResponse response = new MemberResponse();
            IUnitOfWork uow = null;
            
            try
            {
                uow = new UnitOfWork();

                var member = uow.MemberRepository.Get(memberId);

                response.Id = member.Id;
                response.Email = member.Email;
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

        public void RemoveMember(Int32 memberId)
        {
            _serviceContext.ContentType = "text/html";

            IUnitOfWork uow = null;

            try
            {
                uow = new UnitOfWork();

                var member = uow.MemberRepository.Get(memberId);
                
                var gomees = uow.GomeeRepository.GetMineFor(member);
                foreach (var gomee in gomees)
                {
                    var gomeeTargets = uow.TargetRepository.GetFor(gomee);
                    foreach (var target in gomeeTargets)
                    {
                        uow.TargetRepository.Remove(target);
                    }

                    uow.GomeeRepository.Remove(gomee);
                }

                var targets = uow.TargetRepository.GetFor(member);
                foreach (var target in targets)
                {
                    uow.TargetRepository.Remove(target);
                }

                uow.MemberRepository.Remove(member);
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
    }
}
