using System;

namespace YGMEUserContactAccessAPI
{
    public class Contact
    {
        private readonly ContactSource source;

        public String Name { get; set;  }
        public String Email { get; set; }
        public String Phone { get; set; }

        public ContactSource Source
        {
            get
            {
                return source;
            }
        }

        public Contact() { }

        public Contact(String name, String email, ContactSource source) : this(name, email, null, source)
        {
            this.source = source;
        }

        public Contact(String name, String email, String phone, ContactSource source) : this(name, email, phone)
        {
            this.source = source;
        }

        public Contact(String name, String email) : this(name, email, null as String) { }

        public Contact(String name, String email, String phone)
        {
            Name = name;
            Email = email;
            Phone = phone;
        }
    }
}
