<%@ Page Language="C#" MasterPageFile="~/Main.Master"   AutoEventWireup="true" CodeBehind="EditWidget.aspx.cs" Inherits="yoGomee.MainPages.EditWidget" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
        <title>yoGomee edit widget</title>
</asp:Content>
    
<asp:Content ID="Content2" ContentPlaceHolderID="MainSection" Runat="Server">
<script type="text/javascript">

function loadCode(){
        yoGomee.MainPages.EditWidget.GetWidgetCode(<%=WidgetID %>,loadCode_Callback)
}

function loadCode_Callback(response,request){
        if(response.error==null){
            $('#txtYGML').val(response.value);
            createLineNumbers();
        }
}

function saveCode(block){
        var code =$('#txtYGML').val();
        yoGomee.MainPages.EditWidget.SaveWidgetCode(code, <%=WidgetID %>, SaveCode_Callback)
}

function SaveCode_Callback(response,request){
        if(response.error==null){
           $('#txtdebug').val("saved at "+new Date().toLocaleTimeString());
        }else {
            $('#txtdebug').val("error saving.. please try again");
        }
}


function executeCode(){
        $('#txtdebug').val('Executing code server-side.. please wait');
        yoGomee.MainPages.EditWidget.ExecuteCode($('#txtYGML').val(),<%=WidgetID %>, executeCode_Callback);
        
}

function executeCode_Callback(response,request){
        if(response.error==null){
            $('#txtdebug').val(response.value.DebugText);
            
           createLineNumbers();
           var LineNumber = response.value.ErrorLineNumber;
           if(LineNumber>-1){
               $('#linenumber').children('#line'+LineNumber).css('background-color','red');
               $('#linenumber').children('#line'+LineNumber).css('color','white');
           }
        }else{
            alert('There was an ajax error.. please try again');
        }
}

function createLineNumbers(block){

    var div = $('#linenumber');
    div.html('');
    
    for(var i =0;i<25;i++){
        div.html(div.html()+'<span style="font-family:arial" id="line'+(i+1)+'">'+(i+1)+"</span><br/>");
    }

}

</script>

       <div>
                <div style='width:25px;height:400px;float:left;font-size:12px;padding-left:5px;padding-top:2px;' id='linenumber'></div>
                <textarea id='txtYGML' style='width:80%;height:400px;float:left;'></textarea>
                <div style='clear:both;' ></div>
                events output<br />
                <textarea id='txtdebug' style='width:100%;height:200px;'></textarea><br />
                <input type='button' value='Save' onclick='saveCode()'/>
                <input type='button' value='Run' onclick='executeCode()'/>
            </div>
            
            <script>
            loadCode();
            </script>
</asp:Content>

