/* ------------------------------------------------
 * IRuleService.cs
 * Copyright © 2009 Alex Nesterov, Oleg Shnitko
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;

namespace Genetibase.DomainModel
{
    public interface IRuleService
    {
        IRuleService AddRule<T>(Rule<T> rule);

        [SuppressMessage("Microsoft.Design", "CA1004", Justification = "We do not consider compatibility with languages that do not support generics.")]
        [SuppressMessage("Microsoft.Design", "CA1006", Justification = "We do not consider compatibility with languages that do not support generics.")]
        IEnumerable<Rule<T>> GetRules<T>();

        [SuppressMessage("Microsoft.Design", "CA1004", Justification = "We do not consider compatibility with languages that do not support generics.")]
        [SuppressMessage("Microsoft.Design", "CA1006", Justification = "We do not consider compatibility with languages that do not support generics.")]
        IEnumerable<Rule<T>> CollectBrokenRules<T>(T entity);
    }
}
