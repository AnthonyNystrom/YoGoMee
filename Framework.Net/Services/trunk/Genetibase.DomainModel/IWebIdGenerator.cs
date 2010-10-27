/* ------------------------------------------------
 * IWebIdGenerator.cs
 * Copyright © 2009 Oleg Shnitko
 * mailto:olegshnitko@gmail.com
 * ---------------------------------------------- */

using System;

namespace Genetibase.DomainModel
{
    public interface IWebIdGenerator
    {
        String NewWebId();
    }
}
