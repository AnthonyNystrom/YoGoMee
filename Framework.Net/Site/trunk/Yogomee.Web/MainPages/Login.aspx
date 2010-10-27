<%@ Page Language="C#" MasterPageFile="~/Main.Master"  AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="yoGomee.MainPages.Login" %>



<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
        <title>yoGomee login</title>
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="MainSection" Runat="Server">
    <div>
    <asp:Label runat="server" ID="lblMessage" ></asp:Label><br />
    email <asp:TextBox runat="server" ID="txtEmail" Text="lawrence.botley@gmail.com"></asp:TextBox><br />
    password <asp:TextBox runat="server" ID="txtPassword" Text="password" /></asp:TextBox> <asp:Button runat="server" ID="btnLogin" onclick="btnLogin_Click" Text="Login"/>
    </div>
</asp:Content>

