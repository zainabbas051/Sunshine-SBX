({
    
    
   
    doInit : function(component, event, helper) {
        helper.getColumn(component);
        helper.getData(component,helper);
    },
    
    UpdateData : function(component, event, helper) {
        helper.getColumn(component);
        helper.getData(component,helper);
    },
    clickNew : function(component,event,helper){
        component.set("v.selectedId" ,'');
        component.set('v.isNew',true);
    },
    onRowSelection : function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var row = event.getParam('row');
        alert(row);

        //cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    handleRowActionReinbursement : function(component,event,helper){
        debugger;
        event.preventDefault();
	   var action = event.getParam('action');
       var row=event.getSource().get('v.value');

            helper.updateOngoingCertifications(component,helper,row,'Request Reinbursement');
    },
    handleRowActionCompleted : function(component,event,helper){
        debugger;
        event.preventDefault();
	   var action = event.getParam('action');
       var row= component.get('v.selectedRow');
  

        helper.uploadFileInAWS(component,helper,row,'Request Reinbursement');

        
     },
    showCompletedModal : function(component,event,helper){
        debugger;
        event.preventDefault();
	   
       var row=event.getSource().get('v.value');
        component.set("v.selectedRow",row);
        component.set("v.isReimburse",true);
  
        
     },
    closeModel : function(component){
        component.set("v.isReimburse",false);
    },
     handleFileUploadMain: function(component, event, helper) {
        debugger;
        var file = component.find("MainfileUpload").get("v.files")[0];
        var reader = new FileReader();

        reader.onload = function() {
            var fileContent = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContent.indexOf(base64) + base64.length;

            fileContent = fileContent.substring(dataStart);
            component.set('v.fileContent1', fileContent);
            component.set('v.fileName1', file.name);
        }
        reader.readAsDataURL(file);
        
    },
         
    
   
})