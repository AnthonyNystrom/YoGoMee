using System;

namespace YGMEUserContactAccessAPI
{
    public class ContactSource
    {
        private readonly String name;
        private readonly Type type;

        public String Name
        {
            get
            {
                return name;
            }
        }

        public Type ImporterType
        {
            get
            {
                return type;
            }
        }

        public ContactSource() { }

        public ContactSource(String name, Type importerType)
        {
            this.name = name;
            type = importerType;
        }

        public ContactSource(String name)
        {
            foreach (Type currentType in ContactImporterFactory.Importers)
            {
                if (currentType.Name.Equals(name + "Importer"))
                {                    
                    type = currentType;
                }
            }

            if (type == null)
            {
                throw new ArgumentException("The provided name does not match a supported importer class.");
            }

            this.name = name;
        }

        public static ContactSource GmailContactSource = new ContactSource("Gmail");
        public static ContactSource HotmailContactSource = new ContactSource("Hotmail");
        public static ContactSource LinkedInContactSource = new ContactSource("LinkedIn");
        public static ContactSource MyspaceContactSource = new ContactSource("Myspace");
        public static ContactSource YahooContactSource = new ContactSource("Yahoo");        
    }
}
