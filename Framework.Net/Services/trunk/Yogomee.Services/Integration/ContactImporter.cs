using System;
using System.Collections.Generic;

namespace Yogomee.Services.Integration
{
    public abstract class ContactImporter : IDisposable
    {
        private String userId;
        private String password;
        private Boolean isLoggedIn;
        private List<Contact> contacts;

        public String UserId
        {
            get
            {
                return userId;
            }
            set
            {
                Logout(true);
                userId = value;
            }
        }

        public String Password
        {
            get
            {
                return password;
            }
            set
            {
                Logout(true);
                password = value;
            }
        }

        public abstract Boolean RequiresManualLogin { get; }

        public Boolean IsLoggedIn
        {
            get
            {
                return isLoggedIn;
            }

            set
            {
                isLoggedIn = value;
            }
        }

        public List<Contact> Contacts
        {
            get
            {
                return contacts;
            }

            set
            {
                contacts = value;
            }
        }

        public ContactImporter() { }       

        public ContactImporter(String userId, String password)
        {
            UserId = userId;
            Password = password;
        }

        protected void Logout(Boolean keepUserInfo)
        {
            isLoggedIn = false;

            if (!keepUserInfo)
            {
                userId = "";
                password = "";
            }

            contacts = null;
        }

        public void Logout()
        {
            Logout(false);
        }

        public void Dispose()
        {
            Logout();
            GC.SuppressFinalize(this);
        }

        public Boolean DoLogin(String userId, String password)
        {
            UserId = userId;
            Password = password;
            return DoLogin();
        }

        public abstract Boolean DoLogin();
        public abstract Boolean ImportContacts();
    }
}
