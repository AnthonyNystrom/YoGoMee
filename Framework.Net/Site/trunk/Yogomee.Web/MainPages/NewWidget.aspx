<%@ Page Language="C#" MasterPageFile="~/Main.Master"  AutoEventWireup="true" CodeBehind="NewWidget.aspx.cs" Inherits="yoGomee.MainPages.NewWidget" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
        <title>yoGomee new widget</title>
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="MainSection" Runat="Server">
    <div>
    <asp:Label runat="server" ID="lblMessage" ></asp:Label><br />
    name <asp:TextBox runat="server" ID="txtName"></asp:TextBox><br />
    description <asp:TextBox runat="server" Width="350" Height="200" TextMode="MultiLine" ID="txtDescription"></asp:TextBox> 
        <asp:Button runat="server" ID="btnNew" Text="Create" onclick="btnNew_Click"/>
   
   
    </div>
</asp:Content>
