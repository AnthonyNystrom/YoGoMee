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
    public class TargetDecorator : Decorator<Target>, ITargetDecorator
    {
        private ITargetFactory _factory;

        public TargetDecorator(
            ITargetFactory factory,
            ITargetRepository repository)
            : base(repository)
        {
            if (factory == null)
                throw new ArgumentNullException("factory");

            _factory = factory;
        }

        protected ITargetRepository TargetRepository
        {
            get
            {
                return Repository as ITargetRepository;
            }
        }

        public Target CreateTarget(Member member, Gomee gomee)
        {
            Debug.Assert(_factory != null, "_factory != null");

            if (member == null)
                throw new ArgumentNullException("member");
            if (gomee == null)
                throw new ArgumentNullException("gomee");

            return _factory.CreateGomeeTarget(member, gomee);
        }

        public IEnumerable<Target> GetFor(Gomee gomee)
        {
            if (gomee == null)
                throw new ArgumentNullException("gomee");

            return TargetRepository.GetFor(gomee);
        }

        public IEnumerable<Target> GetFor(Member member)
        {
            if (member == null)
                throw new ArgumentNullException("member");

            return TargetRepository.GetFor(member);
        }
    }
}
