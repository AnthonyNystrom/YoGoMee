using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using YGMEUserContactAccessAPI;
using System.Collections.ObjectModel;

namespace YGMEUserContactAccessApp
{
    /// <summary>
    /// Interaction logic for Main.xaml
    /// </summary>
    public partial class Main : Window
    {
        public Main()
        {
            InitializeComponent();

            foreach (Type type in ContactImporterFactory.Importers)
            {
                listBox1.Items.Add(type.Name.Replace("Importer", ""));
            }
        }

        private void listBox1_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ContactImporter temp = ContactImporterFactory.Create(listBox1.SelectedItem.ToString() + "Importer");

            if (temp.RequiresManualLogin)
            {
                temp.DoLogin();

                ImportContacts(temp);
            }
            else
            {
                LoginWindow login = new LoginWindow();
                login.ShowDialog();

                if (login.LoggedIn)
                {
                    ContactImporter importer = ContactImporterFactory.Create(listBox1.SelectedItem.ToString() + "Importer",
                        login.UserId, login.Password);

                    ImportContacts(importer);
                }
            }
        }


        private void listBox1_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            if (listBox1.SelectedItem != null)
            {
                LoginWindow login = new LoginWindow();
                login.ShowDialog();

                if (login.LoggedIn)
                {
                    ContactImporter importer = ContactImporterFactory.Create(listBox1.SelectedItem.ToString() + "Importer",
                        login.UserId, login.Password);

                    ImportContacts(importer);
                }
            }
        }

        private void ImportContacts(ContactImporter importer)
        {

            if (importer.DoLogin())
            {
                importer.ImportContacts();

                ContactCollection contacts = new ContactCollection();

                foreach (Contact c in importer.Contacts)
                {
                    contacts.Add(c);
                }

                listView1.ItemsSource = contacts;

                importer.Logout();
            }
            else
            {
                MessageBox.Show("Login failed, please try again");
            }
        }

        private class ContactCollection : ObservableCollection<Contact> {}
    }
}
