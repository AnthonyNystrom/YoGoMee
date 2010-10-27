/* ------------------------------------------------
 * RuleService.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace Genetibase.DomainModel
{
    public class RuleService : IRuleService
    {
        private IDictionary<Type, IList<Object>> _ruleMap;

        public RuleService()
        {
            _ruleMap = new Dictionary<Type, IList<Object>>();
        }

        [SuppressMessage("Microsoft.Design", "CA1004", Justification = "We do not consider compatibility with languages that do not support generics.")]
        public IEnumerable<Rule<T>> GetRules<T>()
        {
            foreach (var ruleList in from entry in _ruleMap where entry.Key == typeof(T) select entry.Value)
                foreach (var rule in ruleList)
                    yield return (Rule<T>)rule;
        }

        [SuppressMessage("Microsoft.Design", "CA1004", Justification = "We do not consider compatibility with languages that do not support generics.")]
        public IRuleService AddRule<T>(Rule<T> rule)
        {
            if (rule == null)
                throw new ArgumentNullException("rule");

            IList<Object> rules;

            if (!_ruleMap.ContainsKey(typeof(T)))
            {
                rules = new List<Object>();
                _ruleMap.Add(typeof(T), rules);
            }
            else
            {
                rules = _ruleMap[typeof(T)];
            }

            rules.Add(rule);
            return this;
        }

        [SuppressMessage("Microsoft.Design", "CA1004", Justification = "We do not consider compatibility with languages that do not support generics.")]
        [SuppressMessage("Microsoft.Design", "CA1006", Justification = "We do not consider compatibility with languages that do not support generics.")]
        public IEnumerable<Rule<T>> CollectBrokenRules<T>(T entity)
        {
            if (_ruleMap.ContainsKey(typeof(T)))
                return GetRules<T>().Where(r => !r.Check(entity));
            return new List<Rule<T>>();
        }
    }
}
