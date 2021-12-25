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
        
    },
 SaveRecords : function(component,event, helper){
     debugger;
    
       helper.updateEmployeeData(component,helper);
        //component.set('v.isBulkAdd',false);
        
    },
     updateSelectedTrainings : function(component, event, helper){

       var selectedEmpObj = component.get("v.EmployeeSelected");
       selectedEmpObj.Id = event.getParam('selectedRows')[0].Id;
       component.set("v.EmployeeSelected",selectedEmpObj);
        
    },

    updateSelectedEmployees : function(component, event, helper){

       component.set("v.SelectedEmployeedata" ,event.getParam('selectedRows') );
        
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