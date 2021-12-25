({
    doInit : function(component, event, helper) {
        helper.fetchData(component);
    },

    create : function(component,event){
        debugger;
        // Get the component event by using the
        // name value from aura:registerEvent
        var cmpEvent = component.getEvent("cmpEvent");
        var paremRefrence = event.target.id;
        var opptyId = paremRefrence.split('_')[0];
        var sunshineName = paremRefrence.split('_')[1];
        //alert(sunshineName);
        cmpEvent.setParams({"opptyId" : opptyId , "accountType" : sunshineName});
        cmpEvent.fire();

    }
})