using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Genetibase.ServiceModel;
using Yogomee.Services.Responses;
using Yogomee.Services.DomainModel;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.Storage;
using System.Globalization;
using Yogomee.Services.Properties;
using Yogomee.Services.DomainModel.Entities;

namespace Yogomee.Services
{
    public class TargetService : ITargetService
    {
        private IServiceContext _serviceContext;

        public TargetService()
        {
            _serviceContext = new ServiceContext();
        }

        public TargetResponse AddTarget(Int32 memberId, Int32 gomeeId, Int32 targetId)
        {
            _serviceContext.ContentType = "text/html";

            TargetResponse response = new TargetResponse();
            IUnitOfWork uow = null;
            ITargetFactory factory = null;

            try
            {
                uow = new UnitOfWork();
                factory = new TargetFactory();

                var member = uow.MemberRepository.Get(memberId);
                var targetMember = uow.MemberRepository.Get(targetId);
                var gomees = uow.GomeeRepository.GetMineFor(member);

                if (gomees.Where(g => g.Id == gomeeId).Count() == 0)
                    throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "gomeeId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Gomee"),
                        Value = gomeeId.ToString(CultureInfo.InvariantCulture)
                    });

                var gomee = gomees.Where(g => g.Id == gomeeId).Single();

                var target = factory.CreateGomeeTarget(targetMember, gomee);
                uow.TargetRepository.Add(target);
                uow.PersistAll();

                response.Id = target.Id;
                response.MemberId = target.Member.Id;
                response.GomeeId = target.Gomee.Id;
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

        public void RemoveTarget(Int32 memberId, Int32 gomeeId, Int32 targetId)
        {
            _serviceContext.ContentType = "text/html";

            IUnitOfWork uow = null;
            ITargetFactory factory = null;

            try
            {
                uow = new UnitOfWork();
                factory = new TargetFactory();

                var member = uow.MemberRepository.Get(memberId);
                var targetMember = uow.MemberRepository.Get(targetId);

                var gomee = uow.GomeeRepository.GetMineFor(member).Where(g => g.Id == gomeeId).SingleOrDefault();
                if (gomee == null)
                    gomee = uow.GomeeRepository.GetTheirsFor(member).Where(g => g.Id == gomeeId).SingleOrDefault();

                uow.PersistAll();
            }
            catch (ArgumentException e)
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
