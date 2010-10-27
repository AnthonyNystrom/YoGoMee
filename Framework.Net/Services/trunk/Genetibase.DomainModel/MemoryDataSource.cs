/* ------------------------------------------------
 * MemoryDataSource.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;

namespace Genetibase.DomainModel
{
    [SuppressMessage("Microsoft.Naming", "CA1710", Justification = "Name of the interface matches design considerations.")]
    public sealed class MemoryDataSource<T> : IDataSource<T>
    {
        private IRuleService _ruleService;
        private List<T> _source;
        private PropertyInfo _identityProperty;
        private Int32 _nextId = 1;

        public MemoryDataSource(IRuleService ruleService, String identityPropertyName)
        {
            if (ruleService == null)
                throw new ArgumentNullException("ruleService");
            if (String.IsNullOrEmpty(identityPropertyName))
                throw new ArgumentNullException("identityPropertyName");

            _ruleService = ruleService;
            _source = new List<T>();
            _identityProperty = typeof(T).GetProperty(identityPropertyName);

            if (_identityProperty == null)
                throw new ArgumentException(
                    String.Format(
                        CultureInfo.InvariantCulture
                        , "Identity property \"{0}\" not found in {1}."
                        , identityPropertyName
                        , typeof(T).ToString()));
        }

        public IEnumerator<T> GetEnumerator()
        {
            Debug.Assert(_source != null, "_source != null");
            return _source.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            Debug.Assert(_source != null, "_source != null");
            return _source.GetEnumerator();
        }

        public Type ElementType
        {
            get
            {
                Debug.Assert(_source != null, "_source != null");
                return _source.AsQueryable().ElementType;
            }
        }

        public Expression Expression
        {
            get
            {
                Debug.Assert(_source != null, "_source != null");
                return _source.AsQueryable().Expression;
            }
        }

        public IQueryProvider Provider
        {
            get
            {
                Debug.Assert(_source != null, "_source != null");
                return _source.AsQueryable().Provider;
            }
        }

        public void Add(T entity)
        {
            if (entity == null)
                throw new ArgumentNullException("entity");

            Debug.Assert(_source != null, "_source != null");
            _source.Add(entity);
            Debug.Assert(_identityProperty != null, "_identityProperty != null");
            _identityProperty.SetValue(entity, _nextId, null);
            _nextId++;
        }

        public Boolean Remove(T entity)
        {
            Debug.Assert(_source != null, "_source != null");
            return _source.Remove(entity);
        }

        public void ValidateChanges()
        {
            Debug.Assert(_ruleService != null, "_ruleService != null");
            foreach (var entity in _source)
            {
                var brokenRules = _ruleService.CollectBrokenRules<T>(entity);
                if (brokenRules.Count() > 0)
                    throw new BrokenRuleException<T>(brokenRules, entity);
            }
        }

        public void PersistAll()
        {
            ValidateChanges();
        }
    }
}
