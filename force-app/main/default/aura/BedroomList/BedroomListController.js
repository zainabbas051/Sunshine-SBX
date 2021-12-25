({
    showBedroomList : function(component, event, helper) {
        debugger;
        helper.getBedroomlist(component);
    },

    showTaskList : function(component, event, helper) {
        debugger;
        component.set("v.loaded",true);//loading start 
        component.set("v.selectedBed", event.currentTarget.dataset.value);
        component.set("v.showTask", true);
       
    }
})