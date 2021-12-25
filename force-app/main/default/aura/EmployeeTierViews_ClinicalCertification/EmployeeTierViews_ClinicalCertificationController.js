({
    doInit : function(component, event, helper) {

        component.set('v.employeeColumn', [
            {label: 'Training Name', fieldName: 'CertName', type: 'text'},
            {label: 'Employee Name', fieldName: 'EmployeeName', type: 'text'},
            {label: 'Certification Link', fieldName: 'Certification_URL__c', type: 'url'}
            ]);
        
        helper.fetchData(component);
        
       
    },

     showNewCertRequest : function(component,event,helper){
      	component.set("v.NewCompleteRequest",false);
         component.set("v.NewReimbursRequest",false);
         component.set("v.showModal",true);
         
         component.set("v.NewRequest",true);
        
     }
    ,
    showCompletedCertRequest : function(component,event,helper){
        component.set("v.NewRequest",false);
        component.set("v.NewReimbursRequest",false);
        component.set("v.showModal",true);
        
         component.set("v.NewCompleteRequest",true);
     },
    showReimbursRequest : function(component,event,helper){
        component.set("v.NewRequest",false);
        component.set("v.NewReimbursRequest",true);
        component.set("v.showModal",true);
        
         component.set("v.NewCompleteRequest",false);
     },
    closeModel : function(component,event,helper){
        component.set("v.showModal",false);

    }
    ,
    toggleButton1 : function(component,event,helper){
		debugger;
        var selectedRows = event.getParam('selectedRows');
        component.set("v.approveBtnDisabled",true); 
        component.set("v.selectedRowsT1",selectedRows);  
       
        if(selectedRows.length > 0){
            component.set("v.approveBtnDisabled",false); 
        }

    },

    toggleButton2 : function(component,event,helper){
debugger;
        var selectedRows = event.getParam('selectedRows');
        component.set("v.approveBtnDisabled",true); 
        component.set("v.selectedRowsT2",selectedRows); 
        
        if(selectedRows.length > 0){
            component.set("v.approveBtnDisabled",false); 
        } 

    },

    toggleButton3 : function(component,event,helper){

        var selectedRows = event.getParam('selectedRows');
        component.set("v.approveBtnDisabled",true); 
        component.set("v.selectedRowsT3",selectedRows);  
        var totalSelectedRows =  (component.get("v.selectedRowsT1") != null) ? component.get("v.selectedRowsT1").length : 0;
        totalSelectedRows +=  (component.get("v.selectedRowsT2") != null) ? component.get("v.selectedRowsT2").length : 0;
        totalSelectedRows += (component.get("v.selectedRowsT3") != null) ? component.get("v.selectedRowsT3").length : 0;
        if(totalSelectedRows > 0){
            component.set("v.approveBtnDisabled",false); 
        }
         
    },

    handleApproveCert : function(component,event,helper){
        helper.approveCertHelper(component);
    },

    handleRejectCert : function(component,event,helper){
        helper.rejectCertHelper(component);
    }
})