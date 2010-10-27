/* ------------------------------------------------
 * GViewPort.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System.Runtime.Serialization;

namespace Yogomee.Services.GMaps
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class GViewPort
    {
        [DataMember(Name = "center")]
        public GCoordinate Center;
        [DataMember(Name = "span")]
        public GCoordinate Span;
        [DataMember(Name = "sw")]
        public GCoordinate SW;
        [DataMember(Name = "ne")]
        public GCoordinate NE;
    }
}
