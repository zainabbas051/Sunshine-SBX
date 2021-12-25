({
	findCashFromServer : function(component) {
		
            var action = component.get("c.getPaymentLineItem");
            var referenceIdVar = component.get("v.referenceId");
            var sunShineCenterVar = component.get("v.sunshineCentre");
            action.setParams({  referenceId : referenceIdVar , sunShineCentre : sunShineCenterVar  });
            action.setCallback(this, function(response) {
            	var state = response.getState();
                     if (state === "SUCCESS") {
                            
                         component.set("v.ppList",response.getReturnValue())
                         component.set("v.showList",true);
                     }
                   else if (state === "ERROR") {
                         var errors = response.getError();
                       if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                   }
            });
           $A.enqueueAction(action);
    }
           
})