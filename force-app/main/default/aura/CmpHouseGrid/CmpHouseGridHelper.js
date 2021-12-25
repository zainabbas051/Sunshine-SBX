({
    getHouselist : function(component) {

        var action = component.get("c.getHouseList");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.Houses", response.getReturnValue());
                component.set("v.loaded",false);//loading stop
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);

    }
})