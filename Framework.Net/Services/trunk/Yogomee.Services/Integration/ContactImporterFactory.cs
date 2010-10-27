using System;
using System.Collections.Generic;
using System.Reflection;

namespace Yogomee.Services.Integration
{
    public static class ContactImporterFactory
    {
        public static readonly String NAMESPACE = "YGMEUserContactAccessAPI";
        public static readonly String BASECLASS = NAMESPACE + ".ContactImporter";

        private static List<Type> _importers;

        public static List<Type> Importers
        {
            get
            {
                if (_importers == null)
                {
                    _importers = new List<Type>()
                    {
                        typeof(YahooImporter),
                        typeof(MyspaceImporter),
                        typeof(LinkedInImporter),
                        typeof(HotmailImporter),
                        typeof(GmailImporter) 
                    };
                }

                return _importers;
            }
        }

        public static ContactImporter Create(String importerName)
        {
            foreach (Type type in Importers)
            {
                if (type.Name.Equals(importerName))
                {
                    return Create(type);
                }
            }

            return null;
        }

        public static ContactImporter Create(String importerName, String username, String password)
        {
            foreach (Type type in Importers)
            {
                if (type.Name.Equals(importerName))
                {
                    return Create(type, username, password);
                }
            }

            return null;
        }

        public static ContactImporter Create(Type importerType)
        {
            return Activator.CreateInstance(importerType) as ContactImporter;
        }

        public static ContactImporter Create(Type importerType, String username, String password)
        {
            return Activator.CreateInstance(importerType, username, password) as ContactImporter;
        }
    }
}
