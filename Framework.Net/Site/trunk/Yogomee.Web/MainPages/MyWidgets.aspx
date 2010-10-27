<%@ Page Language="C#" MasterPageFile="~/Main.Master"   AutoEventWireup="true" CodeBehind="MyWidgets.aspx.cs" Inherits="yoGomee.MainPages.MyWidgets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
        <title>yoGomee widget store</title>
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="MainSection" Runat="Server">
<h1>My Widgets</h1>
<%=MyWidgetsListerHTML%>

<br />

<h1>Installed Widgets</h1>

<%=InstalledWidgetsListerHTML%>


<script>
function showSettings(id){
    var qstring = '';
    
    if(id!=null){
        qstring += '?instw='+id;
    }
 
    $.blockUI({ message: $('#divwidgetsettings'), css: { width: '582px',height: '500px',top:'100px' } }); 
    $('#settingsiframe').attr('src','/widgetsettings/'+qstring);
}

function updateWidget(iwID){
        yoGomee.MainPages.MyWidgets.UpdateWidget(iwID,updateWidget_Callback)
}

function closePopup(){
       $('#settingsiframe').attr('src','about:blank'); // blank it to avoid reload by unBlock
       $.unblockUI();
}

function updateWidget_Callback(response,request){
        if(response.error==null){
           alert('updated');
        }else{
            alert('error updating widget');
        }
}



updateWidget
</script>

<div id="divwidgetsettings" style="display:none;padding:5px"> 
      <iframe id='settingsiframe' src="about:blank" style="width:565px;height:490px;border:0px;" frameborder="0"></iframe>
</div> 


</asp:Content>