using System;
using System.Collections.Generic;

namespace YGMEUserContactAccessAPI
{
    public abstract class ContactImporter : IDisposable
    {
        private String userId;
        private String password;
        private bool isLoggedIn;
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

        public abstract bool RequiresManualLogin { get; }

        public bool IsLoggedIn
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

        protected void Logout(bool keepUserInfo)
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

        public bool DoLogin(String userId, String password)
        {
            UserId = userId;
            Password = password;
            return DoLogin();
        }

        public abstract bool DoLogin();
        public abstract bool ImportContacts();
    }
}
