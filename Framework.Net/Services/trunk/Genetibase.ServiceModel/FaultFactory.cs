/* ------------------------------------------------
 * FaultFactory.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.ServiceModel;

namespace Genetibase.ServiceModel
{
    public static class FaultFactory
    {
        public static FaultException<T> CreateFaultException<T>(T fault) where T : FaultBase
        {
            if (fault == null)
                throw new ArgumentNullException("fault");

            return new FaultException<T>(fault, fault.Message ?? "");
        }
    }
}
