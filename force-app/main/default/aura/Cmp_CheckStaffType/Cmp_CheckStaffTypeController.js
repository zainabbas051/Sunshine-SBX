({
    setAccessType : function(component, event, helper) {
      debugger;
        var accessType = event.currentTarget.dataset.id; //it will return thisDiv
        component.set('v.AccessType',accessType);
        var action = component.get("c.getPasswordFromCustomSetting");
        action.setParams({ AccessType : accessType });
        action.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
             
                component.set('v.password',response.getReturnValue());

            }
            else if (state === "INCOMPLETE") {
                
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
       
        if(accessType == 'Supervisor' ||accessType == 'Director' ){
            component.set("v.showModal", true);
            return;
        }
         
        helper.callCheckList(component,event,accessType);
    }, 
    doInit: function(component) {
    /*    // Set the attribute value. 
        // You could also fire an event here instead.
     
         var action = component.get("c.getPasswordFromCustomSetting");
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
             
                component.set('v.password',response.getReturnValue());
				//password
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
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
         $A.enqueueAction(action);     */   
    },
    checkPassword : function(component,event,helper){
        
        var passwords =   component.get('v.password');
        var passwordEnterByUser =   component.get('v.passwordEnterByUser');
        var isValid = false;
        for(var i in passwords){
            if(passwords[i]  == passwordEnterByUser){
                isValid = true;
            }
        }
        if(!isValid){
            
             component.set('v.errorMessage', 'Invalid Password');
             return;
        }
        debugger;
   		helper.callCheckList(component,event, component.get('v.AccessType'));
        
    },
    
    
    closeModel : function(component,event,helper){
         component.set("v.showModal", false);
    }

})