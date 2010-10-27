using System;
using System.Collections.Generic;
using System.Reflection;

namespace YGMEUserContactAccessAPI
{
    public static class ContactImporterFactory
    {
        public static readonly String NAMESPACE = "YGMEUserContactAccessAPI";
        public static readonly String BASECLASS = NAMESPACE + ".ContactImporter";

        private static List<Type> importers = new List<Type>();
        private static bool initialized;

        public static List<Type> Importers
        {
            get
            {
                if (!initialized)
                {
                    Initialize();
                }

                return importers;
            }
        }

        public static void Initialize()
        {
            initialized = true;

            Assembly asm = Assembly.GetExecutingAssembly();

            foreach (Type type in asm.GetTypes())
            {
                if (type.Namespace == NAMESPACE && 
                    type.BaseType.Equals(Type.GetType(BASECLASS)))
                {
                    importers.Add(type);
                }
            }
        }

        public static ContactImporter Create(String importerName)
        {
            if (!initialized)
            {
                Initialize();
            }

            foreach (Type type in importers)
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
            if (!initialized)
            {
                Initialize();
            }

            foreach(Type type in importers)
            {
                if(type.Name.Equals(importerName))
                {
                    return Create(type, username, password);                    
                }
            }

            return null;
        }

        public static ContactImporter Create(Type importerType)
        {
            if (importerType.Namespace == NAMESPACE && importerType.BaseType.Equals(Type.GetType(BASECLASS)))
            {
                return Activator.CreateInstance(importerType) as ContactImporter;
            }

            throw new ArgumentException("The provided type is of an unsupported base class.");
        }

        public static ContactImporter Create(Type importerType, String username, String password)
        {
            if (importerType.Namespace == NAMESPACE && importerType.BaseType.Equals(Type.GetType(BASECLASS)))
            {
                return Activator.CreateInstance(importerType, username, password) as ContactImporter;
            }

            throw new ArgumentException("The provided type is of an unsupported base class.");
        }
    }
}
