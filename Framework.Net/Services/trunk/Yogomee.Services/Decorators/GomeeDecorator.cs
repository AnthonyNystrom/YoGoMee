using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Yogomee.Services.DomainModel.Entities;
using Yogomee.Services.DomainModel.Factories;
using Yogomee.Services.DomainModel.Repositories;
using System.Diagnostics;

namespace Yogomee.Services.Decorators
{
    public class GomeeDecorator : Decorator<Gomee>, IGomeeDecorator
    {
        private IGomeeFactory _factory;

        public GomeeDecorator(
            IGomeeFactory factory,
            IGomeeRepository repository)
            : base(repository)
        {
            if (factory == null)
                throw new ArgumentNullException("factory");

            _factory = factory;
        }

        protected IGomeeRepository GomeeRepository
        {
            get
            {
                return Repository as IGomeeRepository;
            }
        }

        public Gomee CreateGomee(Member member)
        {
            Debug.Assert(_factory != null, "_factory != null");

            if (member == null)
                throw new ArgumentNullException("member");

            return _factory.CreateGomee(member);
        }

        public IEnumerable<Gomee> GetMineFor(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            return GomeeRepository.GetMineFor(member);
        }

        public IEnumerable<Gomee> GetTheirsFor(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            return GomeeRepository.GetTheirsFor(member);
        }
    }
}
