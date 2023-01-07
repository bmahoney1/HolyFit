using System;
using System.Collections.Generic;

using Xamarin.Forms;

namespace Holy
{	
	public partial class LoginPage : ContentPage
	{	
		public LoginPage ()
		{
			InitializeComponent ();
		}

		private void Button_Clicked(object sender, EventArgs e)
		{
			if (txtUsername.Text == "admin" && txtPassword.Text == "123")
			{

			}
			else
			{
				DisplayAlert("Alert", "Username or Password is incorrect!", "Okay");
			}

		}

		private void TapGestureRecognizer_Tappped(object sender, EventArgs e)
		{

		}

	}
}

