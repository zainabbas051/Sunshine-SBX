({
    doInit: function(component, event, helper) {
	debugger;
        helper.getEmpProfile(component);
        helper.getBudgetDetail(component);
        
        var budgetDetail= component.get("v.budgetUtilization");
       // component.set("v.budgetUtilization",budgetDetail.Utilized_Budget__c);
        
    },
    
    updateEmpInfo: function(component, event, helper) {
        debugger;
        helper.updateEmp(component);           
    },
    handleTagChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
         
        //Update the Selected Values  
        component.set("v.selectedTagList", selectedValues);
    }
     
    ,
    handleFileUploadIcon: function(component, event, helper) {
        debugger;
        var file = component.find("ThumbnailfileUpload").get("v.files")[0];
        var reader = new FileReader();

        reader.onload = function() {
            var fileContent = reader.result;
            var base64 = 'base64,';
            var dataStart = fileContent.indexOf(base64) + base64.length;

            fileContent = fileContent.substring(dataStart);
            component.set('v.fileContent', fileContent);
            component.set('v.fileName2', file.name);
        }
        reader.readAsDataURL(file);
         
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

    handleSubmit: function(component, event, helper) {
        debugger;
        event.preventDefault();
        helper.uploadFileInAWS(component);
    },

    cancelAction: function(component) {
        component.set("v.isEdit", false);
    },

    updateEmpData : function(component,event,helper){
        debugger;
        helper.updateEmp(component);  
    },
     editForm: function(component) {
        component.set("v.isEdit", true);
    },
    handleSuccess:function(component,event,helper){
      debugger;
        helper.getBudgetDetail(component);
        $A.get('e.force:refreshView').fire();
    },
    handleOnload: function(component, event, helper) {
       
     /*   var record = event.getParam("recordUi");
      var v=  component.find("budgetId").get("v.value");
      debugger;
      */
    },
    handleBudget:function(component,event){
   
        debugger;
        helper.getBudgetDetail(component);
      //  $A.get('e.force:refreshView').fire();
       /* var budgetValue = component.get('v.budgetUtilization');
        component.find("budgetId").set("v.value", budgetValue);  
        */
    },
     // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    }
})