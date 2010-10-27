/* ------------------------------------------------
 * Linq2SqlDataSource.cs
 * Copyright © 2009 Oleg Shnitko
 * mailto:olegshnitko@gmail.com
 * ---------------------------------------------- */

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Linq;
using System.Linq;
using System.Linq.Expressions;

namespace Genetibase.DomainModel
{
    public class Linq2SqlDataSource<T> : IDataSource<T> where T : class
    {
        private DataContext _context;
        private IRuleService _ruleService;

        public Linq2SqlDataSource(IRuleService ruleService, DataContext context)
        {
            if (context == null)
                throw new ArgumentNullException("context");

            _context = context;
            _ruleService = ruleService;
        }

        public Linq2SqlDataSource(IRuleService ruleServcie, String connectionString)
        {
            if (ruleServcie == null)
                throw new ArgumentNullException("ruleServcie");
            if (String.IsNullOrEmpty(connectionString))
                throw new ArgumentNullException("connectionString");

            _ruleService = ruleServcie;
            _context = new DataContext(connectionString);
        }

        private Table<T> _table;

        private Table<T> Table
        {
            get
            {
                if (_table == null)
                {
                    _table = _context.GetTable<T>();
                }
                return _table;
            }
        }

        public void Add(T entity)
        {
            Table.InsertOnSubmit(entity);
        }

        public bool Remove(T entity)
        {
            if (!Table.Contains(entity))
                return false;

            Table.DeleteOnSubmit(entity);
            return true;
        }

        public void ValidateChanges()
        {
            ValidateChanges(_context.GetChangeSet().Updates);
            ValidateChanges(_context.GetChangeSet().Inserts);
        }

        public void PersistAll()
        {
            ValidateChanges();
            _context.SubmitChanges();
        }

        private void ValidateChanges(IList<Object> changes)
        {
            var updates = changes.Where(o => o.GetType().Equals(typeof(T)));
            foreach (var updated in updates)
            {
                var updatedT = (T)updated;
                var brokenRules = _ruleService.CollectBrokenRules<T>(updatedT);
                if (brokenRules.Count() > 0)
                    throw new BrokenRuleException<T>(brokenRules, updatedT);
            }
        }

        public IEnumerator<T> GetEnumerator()
        {
            return Table.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public Type ElementType
        {
            get
            {
                return Table.AsQueryable().ElementType;
            }
        }

        public Expression Expression
        {
            get
            {
                return Table.AsQueryable().Expression;
            }
        }

        public IQueryProvider Provider
        {
            get
            {
                return Table.AsQueryable().Provider;
            }
        }
    }
}
