({
    
   
    doInit : function(component, event, helper) {
        debugger;
        //component.set("v.spinner", true); 
        component.set("v.progressIndicatorFlag", "step1");
        //helper.toggleTwoSteps(component);
        helper.toggleTwoAndThreeSteps(component);
       
        component.set('v.EmployeeCertcolumns', [
            {label: 'Training Name', fieldName: 'CertName', type: 'text'},
            {label: 'Employee Name', fieldName: 'EmployeeName', type: 'text'},
            {label: 'Certification Link', fieldName: 'Certification_URL__c', type: 'url'}
            ]);
        
        helper.fetchData(component);
        //component.set("v.spinner", false); 
    },
     closeModel : function(component){
         debugger;
         component.set("v.showModal",false);
        
        
    },
 SaveRecords : function(component,event, helper){
     debugger;
    	var isTier2 = component.get("v.isTierTransitionEnabled");
        var isTier3 = component.get("v.isTier3TransitionEnabled");
        var selectedEmpObj = component.get("v.EmployeeSelected");
     if(isTier2){
     	selectedEmpObj.Tier_2_Transition_Approved_By__c=component.get("v.empID");
         selectedEmpObj.Tier_Allocation__c='Tier 2';
 }
     if(isTier3){
         selectedEmpObj.Tier_3_Transition_Approved_By__c=component.get("v.empID");
         selectedEmpObj.Tier_Allocation__c='Tier 3';
     }
       helper.updateEmployeeData(component,helper);
        //component.set('v.isBulkAdd',false);
        
    },
     updateSelectedTrainings : function(component, event, helper){
		debugger;
       var selectedEmpObj = component.get("v.EmployeeSelected");
       selectedEmpObj.Id = event.getParam('selectedRows')[0].Id;
       component.set("v.EmployeeSelected",selectedEmpObj);
         component.find("btnNext").set('v.disabled',false);
        
    },

    updateSelectedEmployees : function(component, event, helper){
	debugger;
       component.set("v.SelectedEmployeedata" ,event.getParam('selectedRows') );
        
    },

    refreshViewHandler : function(component, event, helper){
        event.stopPropagation();
    },

    goToStepTwo : function(component, event, helper) {
        helper.toggleOneAndTwoSteps(component);
        component.set("v.progressIndicatorFlag", "step2");
    },
    goToStepThree : function(component, event, helper) {
        helper.toggleTwoAndThreeSteps(component);
        component.set("v.progressIndicatorFlag", "step3");
    },
    
    goBackToStepOne : function(component, event, helper) {
        helper.toggleOneAndTwoSteps(component);
        component.set("v.progressIndicatorFlag", "step1");
    },
   goBackToStepTwo : function(component, event, helper) {
        helper.toggleTwoAndThreeSteps(component);
        component.set("v.progressIndicatorFlag", "step2");
    },
    
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
    },
    toggleButton2 : function(component,event,helper){
   debugger;
        var selectedRows = event.getParam('selectedRows');
        //component.set("v.approveBtnDisabled",true); 
        component.set("v.selectedRowsT2",selectedRows); 
        
        component.set("v.dateOfCompletion",selectedRows[0].Certification_Completed_Date__c);
        component.set("v.CertCost",selectedRows[0].Certification_Cost__c);
        component.set("v.AvailableBudget",selectedRows[0].Available_Employee_Budget__c);
        component.set("v.PaidBy",selectedRows[0].Certification_Cost_Paid_By__c);
        
        if(selectedRows.length > 0){
           component.find("btnNext").set('v.disabled',false); 
        } 

    },
	toggleButton1 : function(component,event,helper){
		debugger;
        var selectedRows = event.getParam('selectedRows');
        //component.set("v.approveBtnDisabled",true); 
        component.set("v.selectedRowsT1",selectedRows); 
        debugger;
        component.set("v.CertCost",selectedRows[0].Certification_Cost__c);
        component.set("v.AvailableBudget",selectedRows[0].Available_Employee_Budget__c +(selectedRows[0].Certification_Cost__c-selectedRows[0].Employee_Responsibility_Amount__c));
        component.set("v.PaidBy",selectedRows[0].Certification_Cost_Paid_By__c);
        
        if(selectedRows.length > 0){
           component.find("btnNext").set('v.disabled',false); 
        } 

    },
    toggleButton3 : function(component,event,helper){
		var selectedRows = event.getParam('selectedRows');
        //component.set("v.approveBtnDisabled",true); 
        component.set("v.selectedRowsT3",selectedRows); 
        component.set("v.CertCost",selectedRows[0].Related_Certification__r.Certification_Cost__c);
        component.set("v.AvailableBudget",selectedRows[0].Available_Employee_Budget__c +selectedRows[0].Related_Certification__r.Certification_Cost__c);
        component.set("v.PaidBy",selectedRows[0].Certification_Cost_Paid_By__c);
        console.log('$$$' +selectedRows[0].Employee_Responsibility_Amount__c);
        component.set("v.EmpAmt",selectedRows[0].Employee_Responsibility_Amount__c);
        component.set("v.ReimbursAmt",selectedRows[0].Related_Certification__r.Certification_Cost__c-selectedRows[0].Employee_Responsibility_Amount__c);
        
        if(selectedRows.length > 0){
           component.find("btnNext").set('v.disabled',false); 
        } 

        
        /*
        var selectedRows = event.getParam('selectedRows');
        component.set("v.approveBtnDisabled",true); 
        component.set("v.selectedRowsT3",selectedRows);  
        var totalSelectedRows =  (component.get("v.selectedRowsT1") != null) ? component.get("v.selectedRowsT1").length : 0;
        totalSelectedRows +=  (component.get("v.selectedRowsT2") != null) ? component.get("v.selectedRowsT2").length : 0;
        totalSelectedRows += (component.get("v.selectedRowsT3") != null) ? component.get("v.selectedRowsT3").length : 0;
        if(totalSelectedRows > 0){
            component.set("v.approveBtnDisabled",false); 
        }
      */   
    },
    handleApproveCert : function(component,event,helper){
        helper.approveCertHelper(component);
    },

    handleRejectCert : function(component,event,helper){
        helper.rejectCertHelper(component);
    }
    ,
     handleReimbursCert : function(component,event,helper){
        helper.reimbursCertHelper(component);
    }

})