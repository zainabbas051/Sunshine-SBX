({
    
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    doInit : function(component, event, helper) {
        debugger;
       
        component.set("v.progressIndicatorFlag", "step1");
        //helper.toggleTwoSteps(component);
        helper.toggleTwoAndThreeSteps(component);
        helper.getTrainingColumn(component);
        helper.getTrainingData(component);
        helper.getEmployeeColumn(component);
        helper.getEmployeeData(component);
    },
     closeModel : function(component){
        component.set('v.isBulkAdd',false);
        
    },
 SaveRecords : function(component,event, helper){
     debugger;
       helper.CreateTrainings(component,helper);
        //component.set('v.isBulkAdd',false);
        
    },
     updateSelectedTrainings : function(component, event, helper){

       component.set("v.SelectedTrainingdata" ,event.getParam('selectedRows') );
        
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