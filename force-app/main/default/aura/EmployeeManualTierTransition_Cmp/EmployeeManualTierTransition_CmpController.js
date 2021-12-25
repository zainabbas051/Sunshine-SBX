({
    
   
    doInit : function(component, event, helper) {
        debugger;
        component.set("v.spinner", true); 
        component.set("v.progressIndicatorFlag", "step1");
        //helper.toggleTwoSteps(component);
        helper.toggleTwoAndThreeSteps(component);
       
        helper.getEmployeeColumn(component);
        helper.getEmployeeData(component);
        component.set("v.spinner", false); 
    },
     closeModel : function(component){
        component.set('v.isTierTransitionEnabled',false);
        component.set('v.isTier3TransitionEnabled',false);
        
    },
 SaveRecords : function(component,event, helper){
     debugger;
    	var isTier2 = component.get("v.isTierTransitionEnabled");
        var isTier3 = component.get("v.isTier3TransitionEnabled");
        var selectedEmpObjList = component.get("v.SelectedEmployeeList");
     
     for(var i=0;i<selectedEmpObjList.length;i++){
        selectedEmpObjList[i].Certificate_Budget_Utilized__c=0; 
        selectedEmpObjList[i].Tier_2_Transition_Approved_By__c=component.get("v.empID");
        selectedEmpObjList[i].Tier_Allocation__c=component.get("v.selectedTier");
         
     }

       helper.updateEmployeeData(component,helper);
        //component.set('v.isBulkAdd',false);
        
    },
     updateSelectedTrainings : function(component, event, helper){
		debugger;
       var selectedEmpObj = component.get("v.EmployeeSelected");
       selectedEmpObj.Id = event.getParam('selectedRows')[0].Id;
         var trainingsforT2= event.getParam('selectedRows')[0].Tier2_Mandatory_Training_Names__c;
         if(trainingsforT2!=null)
         component.set("v.MandatoryforTier2Certs",trainingsforT2.toString().split(','));
        
         var trainingsforT3= event.getParam('selectedRows')[0].Tier3_Mandatory_Training_Names__c;
        if(trainingsforT3!=null)
        component.set("v.MandatoryforTier3Certs",trainingsforT3.toString().split(','));
        component.set("v.EmployeeSelected",selectedEmpObj);
         component.find("btnNext").set('v.disabled',false);
        
    },

    updateSelectedEmployees : function(component, event, helper){
	debugger;
       component.set("v.SelectedEmployeeList" ,event.getParam('selectedRows') );
       component.find("btnNext").set('v.disabled',false);
        
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
    }
})