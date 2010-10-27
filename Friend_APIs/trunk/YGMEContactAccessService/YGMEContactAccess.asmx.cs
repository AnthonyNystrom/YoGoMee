using System;
using System.ComponentModel;
using System.Web.Services;
using YGMEUserContactAccessAPI;
using System.Collections.Generic;

namespace YGMEContactAccessService
{
    /// <summary>
    /// Provides access to the YGME Contact API
    /// </summary>
    [WebService(Namespace = "http://www.yogomee.com")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class YGMEContactAccess : WebService
    {
        [WebMethod]
        public List<Contact> GetContactsByType(String username, String password, Type importerType)
        {            
            List<Contact> contactList = new List<Contact>();

            if (importerType != null)
            {
                ContactImporter importer = ContactImporterFactory.Create(importerType, username, password);

                importer.DoLogin();
                importer.ImportContacts();

                contactList = importer.Contacts;

                importer.Logout();
            }

            return contactList;
        }

        [WebMethod]
        public List<Contact> GetContacts(String username, String password, String contactService)
        {
            foreach (Type importerType in GetImporterList())
            {
                //Try just the name
                if (importerType.Name.Equals(contactService))
                {
                    return GetContactsByType(username, password, importerType);
                }
                //Try adding the importer suffix
                else if(importerType.Name.Equals(contactService + "Importer"))
                {
                    return GetContactsByType(username, password, importerType);
                }
            }

            throw new ArgumentException("Contact source \"" + contactService + "\" does not exist.");
        }

        public List<Type> GetImporterList()
        {
            return ContactImporterFactory.Importers;
        }
    }
}
