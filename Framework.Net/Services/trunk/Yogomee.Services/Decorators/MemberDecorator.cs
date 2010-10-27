using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel.Repositories;
using Yogomee.Services.DomainModel.Factories;
using System.Diagnostics;
using Genetibase.ServiceModel;

namespace Yogomee.Services.Decorators
{
    public class MemberDecorator : Decorator<Member>, IMemberDecorator
    {
        private IMemberFactory _factory;

        public MemberDecorator(
            IMemberFactory factory,
            IMemberRepository repository)
            : base(repository)
        {
            if (factory == null)
                throw new ArgumentNullException("factory");

            _factory = factory;
        }

        protected IMemberRepository MemberRepository
        {
            get
            {
                return Repository as IMemberRepository;
            }
        }

        public Member CreateMember(String email)
        {
            Debug.Assert(_factory != null, "factory != null");

            if (email == null)
                throw new ArgumentNullException("email");

            return _factory.CreateMember(email);
        }

        public override void Add(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            try
            {
                Repository.Add(member);
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault() 
                    {
                        Argument = "member.Email",
                        Message = "Member with specified email address allready exists.",
                        Value = member.Email
                    });
            }
        }

        public Member Get(String email)
        {
            if (String.IsNullOrEmpty(email))
                throw new ArgumentNullException("email");

            try
            {
                return MemberRepository.Get(email);
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault() 
                    {
                        Argument = "email",
                        Message = "Member with specified email address not exists.",
                        Value = email
                    });
            }
        }
    }
}
