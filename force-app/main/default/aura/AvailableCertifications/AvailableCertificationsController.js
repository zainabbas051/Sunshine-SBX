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
    showOther:function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        debugger;
        var buttonLabel = event.getSource().get("v.label");
        if(buttonLabel=="Add Other"){
            
        component.set("v.showOther", true);
        
		event.getSource().set("v.label","Cancel"); 
        event.getSource().set("v.variant","destructive");
        event.getSource().set("v.iconName",null);
        }
        if(buttonLabel=="Cancel"){
            component.set("v.showOther", false);
            event.getSource().set("v.label","Add Other"); 
        event.getSource().set("v.variant","brand");
        event.getSource().set("v.iconName","utility:add");
            
        }
       
    },
    CancelOther:function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        debugger;
       
        component.set("v.showOther", false); 
        //this.superRerender();
    },
    doInit : function(component, event, helper) {
        helper.getEmployeeData(component);
        helper.getColumn(component);
        //helper.getData(component,helper);
       // helper.getEmployeeData(component);
    },
    UpdateData : function(component, event, helper) {
        helper.getColumn(component);
        helper.getData(component,helper);
       
    },
    onRowSelection : function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var row = event.getParam('row');
      

        //cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    handleRowAction : function(component,event,helper){
        var row = event.getParam('row');
        component.set("v.selectedId" ,row.Id);
        component.set("v.certificationId" ,row.Id);    
        helper.createCertificationRequest(component,helper,row);
        
    },

    closeModel : function(component){
        component.set('v.isNew',false);
        component.set('v.IsBudgetExeeded',false);
    },

    finalizeRequest : function(component,event,helper){
        var isOther = component.get('v.showOther');
        if(isOther){
            helper.finalizeOtherCert(component);
            return;
        }
        helper.finalizeRequestHelper(component);
    },
    applyCert : function(component,event,helper){
         var allValid = component.find('empCertField').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if(!allValid){
            return;
        }
        debugger;
        helper.applyCertHelper(component)
    }
    
   
})