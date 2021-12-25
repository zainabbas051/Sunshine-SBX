({
	saveRecord : function(component, event, helper ,ppLineItem,indexNumber) {

        var action = component.get("c.saveRecord");
        var ppLineArray = component.get("v.paymentLineItemList");
        action.setParams({

            jsonString: JSON.stringify(ppLineItem)
            
        });
      
        action.setCallback(this, function (a) {
            //get the response state
            var state = a.getState();
          
            //check if result is successfull
            if (state == "SUCCESS") {
                //Reset Form
             //   component.set("v.showList",false); 
                component.set("v.referenceId","");
                ppLineArray.splice(indexNumber, 1);  
                component.set("v.paymentLineItemList", ppLineArray);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: 'Success',
					message: 'The Payment Plan has been saved',
					duration: ' 5000',
					key: 'info_alt',
					type: 'success',
					mode: 'pester'
				});
                toastEvent.fire(); 
                component.set('v.isLoading', false); 
               // $A.get('e.force:refreshView').fire();
                //location.reload(); 
                //alert(ppLineArray);
             //   component.set("v.paymentLineItemList",ppLineArray);
             //   component.set("v.paymentLineItemList",ppLineArray);
             //   this.findCashFromServer(component);
			}
			else if (state === "ERROR") {
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
				}
			}
        });
        $A.enqueueAction(action);
    },
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