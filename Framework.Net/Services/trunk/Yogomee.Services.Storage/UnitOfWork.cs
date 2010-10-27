using System;
using NHibernate;
using NHibernate.Cfg;
using Yogomee.Services.DomainModel;
using Yogomee.Services.DomainModel.Repositories;
using Yogomee.Services.Storage.Repositories;
using NHibernate.Tool.hbm2ddl;

namespace Yogomee.Services.Storage
{
    public class UnitOfWork : IUnitOfWork, IDisposable
    {
        private static Configuration _configuration;

        private static Configuration Configuration
        {
            get
            {
                if (_configuration == null)
                {
                    _configuration = new Configuration();
                    _configuration.Configure();
                    _configuration.AddAssembly(typeof(UnitOfWork).Assembly);
                }

                return _configuration;
            }
        }

        private static ISessionFactory _sessionFactory;

        private static ISessionFactory SessionFactory
        {
            get
            {
                if (_sessionFactory == null)
                {
                    _sessionFactory = Configuration.BuildSessionFactory();
                }

                return _sessionFactory;
            }
        }

        private ISession _session;
        
        private ISession Session
        {
            get
            {
                if (_session == null)
                {
                    _session = SessionFactory.OpenSession();
                    Transaction = _session.BeginTransaction();
                }

                return _session;
            }
        }

        private ITransaction Transaction
        {
            get;
            set;
        }

        private IMemberRepository _memberRepository;

        public IMemberRepository MemberRepository
        {
            get
            {
                if (_memberRepository == null)
                {
                    _memberRepository = new MemberRepository(Session);
                }

                return _memberRepository;
            }
        }

        private IFriendRepository _friendRepository;

        public IFriendRepository FriendRepository
        {
            get
            {
                if (_friendRepository == null)
                {
                    _friendRepository = new FriendRepository(Session);
                }

                return _friendRepository;
            }
        }

        private IGomeeRepository _gomeeRepository;

        public IGomeeRepository GomeeRepository
        {
            get
            {
                if (_gomeeRepository == null)
                {
                    _gomeeRepository = new GomeeRepository(Session);
                }

                return _gomeeRepository;
            }
        }

        private ITargetRepository _targetRepository;

        public ITargetRepository TargetRepository
        {
            get
            {
                if (_targetRepository == null)
                {
                    _targetRepository = new TargetRepository(Session);
                }

                return _targetRepository;
            }
        }


        public void PersistAll()
        {
            Transaction.Commit();
            Transaction = Session.BeginTransaction();
        }

        public void Dispose()
        {
            if (Session.IsOpen)
            {
                Transaction.Rollback();
                Session.Close();
            }
        }

        public void Close()
        {
            Dispose();
        }
    }
}
