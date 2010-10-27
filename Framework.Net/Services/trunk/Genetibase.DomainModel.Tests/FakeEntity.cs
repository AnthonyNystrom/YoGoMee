/* ------------------------------------------------
 * FakeEntity.cs
 * Copyright © 2009 Alex Nesterov, Oleg Shnitko
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;

namespace Genetibase.DomainModel.Tests
{
    [Table(Name = "FakeTable")]
    public sealed class FakeEntity
    {
        public FakeEntity()
        {
        }

        [Column(Name = "Id", IsPrimaryKey = true)]
        public Int32 Id
        { get; internal set; }

        [Column(Name = "Name")]
        public String Name
        { get; set; }

        public Int32 PropertyFake
        { get; set; }
    }
}
