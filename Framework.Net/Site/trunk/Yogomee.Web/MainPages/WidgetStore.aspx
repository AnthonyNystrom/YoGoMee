<%@ Page Language="C#" MasterPageFile="~/Main.Master"   AutoEventWireup="true" CodeBehind="WidgetStore.aspx.cs" Inherits="yoGomee.MainPages.WidgetStore" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
        <title>yoGomee widget store</title>
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="MainSection" Runat="Server">

<%=WidgetListerHTML%>

</asp:Content>