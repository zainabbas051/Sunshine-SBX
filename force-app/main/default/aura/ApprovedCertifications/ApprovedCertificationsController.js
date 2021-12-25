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
  

        helper.uploadFileInAWS(component,helper,row,'Completed');
        
     },
    showCompletedModal : function(component,event,helper){
        debugger;
        event.preventDefault();
	   
       var row=event.getSource().get('v.value');
        component.set("v.selectedRow",row);
        component.set("v.isComplete",true);
  
        
     },
    CompleteCertReq : function(component,event,helper){
        debugger;
        
        event.preventDefault();
	   
       var row=event.getSource().get('v.value');
        if(row.Certification_URL__c==null){
             try {

                    $A.get('e.force:refreshView').fire();
                
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: 'Error',
                            message: 'Please Upload the Certificate',
                            duration: ' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                    catch (err) {
                        alert('Please Upload the Certificate');
                    }
                
            return;
        }
        component.set("v.selectedRow",row);
       helper.completeOngoingCertifications(component,row);
        helper.getData(component,helper);
  
        
     },
    closeModel : function(component,event,helper){
       
        component.set("v.isComplete",false);
  
        
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