({
    getHouselist: function (component) {

        var action = component.get("c.getHouseList");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.Houses", response.getReturnValue());
                var Houses=response.getReturnValue();
                var CCHouses=Houses.filter(function(h) {
  										return h.Sunshine_Center__r.Name=='Chapters Capistrano';
									} );
                component.set("v.CCHouses", CCHouses);
               var MSHouses=Houses.filter(function(h) {
  										return h.Sunshine_Center__r.Name=='Monarch Shores';
									} );
                component.set("v.MSHouses", MSHouses);
                var MSRHouses=Houses.filter(function(h) {
  										return h.Sunshine_Center__r.Name=='Mountain Springs Recovery';
									} );
                component.set("v.MSRHouses", MSRHouses);
                component.set("v.loaded", false); //loading stop
            } else {
                console.log("Failed with state: " + state);
            }
        });

        $A.enqueueAction(action);

    }
})