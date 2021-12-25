({
    myAction : function(component, event, helper) {

        var HLIId = component.get("v.selectedHouseLineItem");
        debugger;
        if(HLIId === undefined){
            helper.fetchTask(component);
            return;
        }
        helper.fetchData(component);

    },
    saveActivity : function(component, event, helper){
        debugger;
        helper.saveActivityRecords(component);     
    },
    completeHouseLineItem : function(component, event, helper){
        debugger;
        var inputCmp = component.find("inputCmp");
        var value = inputCmp.get("v.value");
        if(value == ''){
            inputCmp.setCustomValidity("This field is required"); 
            inputCmp.reportValidity();
            return;
        }
        helper.completeHouseLineItemRecord(component);     
    },
    openModal : function(component, event, helper){
        component.set("v.showModal",true);
    },
    closeModal : function(component, event, helper){
        component.set("v.showModal",false);
    }
})