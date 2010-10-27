/* ------------------------------------------------
 * File: Contact.cs
 * 
 * Created: 2/17/2009
 * Modified: 2/17/2009
 * 
 * Copyright © Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;

namespace Yogomee.Services.Integration
{
    [DataContract(Name = "Contact", Namespace = "http://www.yogomee.com/")]
    public sealed class Contact
    {
        [DataMember(Name = "name")]
        public String Name { get; set; }

        [DataMember(Name = "email")]
        public String Email { get; set; }

        [DataMember(Name = "phone")]
        public String Phone { get; set; }
        
        [DataMember(Name = "source")]
        public String Source { get; set; }
    }
}
