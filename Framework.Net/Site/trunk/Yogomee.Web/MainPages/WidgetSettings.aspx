<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WidgetSettings.aspx.cs" Inherits="yoGomee.MainPages.WidgetSettings" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>

	<script type="text/javascript"src="/js/jquery-1.1.3.1.pack.js"></script>


</head>
<body>
<form id="Form1" runat="server">

	
<script type="text/javascript">
function save(){

var fields = new Array();

$('.widgetField').each(function (i) {
    fields[i] =  $(this).val();   
});


    yoGomee.MainPages.WidgetSettings.SaveInputParameters(<%=InstalledWidgetID %>,fields, saveInputParameters_Callback)
}

function saveInputParameters_Callback(response,request){
    if(response.error==null){
        parent.closePopup();
    }else {
        alert('error saving');
    }
}


</script>

<h1><%=WidgetName %> settings</h1>

<%=UIFieldsHTML %>

<input type="button" onclick="parent.closePopup();" value="close" />
<input type="button" onclick="save();" value="save" />

</form>
</body>
</html>