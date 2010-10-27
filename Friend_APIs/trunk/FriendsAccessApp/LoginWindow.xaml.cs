using System;
using System.Windows;

namespace YGMEUserContactAccessApp
{
    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class LoginWindow : Window
    {
        public bool LoggedIn { get; set; }
        public String UserId { get; set; }
        public String Password { get; set; }

        public LoginWindow()
        {
            InitializeComponent();
        }

        //Login
        private void button2_Click(object sender, RoutedEventArgs e)
        {
            LoggedIn = true;
            UserId = textBox1.Text;
            Password = passwordBox1.Password;

            Close();
        }

        //Cancel
        private void button1_Click(object sender, RoutedEventArgs e)
        {
            LoggedIn = false;

            Close();
        }
    }
}
