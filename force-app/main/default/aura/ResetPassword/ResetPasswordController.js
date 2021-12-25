({
    resetPassword : function(component,event,helper){
        debugger;

        component.set("v.isError",false)
        var password = component.get("v.Password");
        var reTypePassword = component.get("v.Retypepassword");
        if(password != reTypePassword){
            component.set("v.isError",true);
            return;
        }
        //Calling the Apex Function
        var action = component.get("c.ResetPassword");
        //Setting the Apex Parameter
		action.setParams({

            password: password,
            RecordId :component.get('v.RecordId')
			
        });

        //Setting the Callback
		action.setCallback(this, function (a) {
            //get the response state
			var state = a.getState();
            //check if result is successfull
            if (state == "SUCCESS") {
                if(a.getReturnValue() == true){
                    component.find('notifLib').showToast({
                        "title": "Success!",
                        "variant": "success",
                        "message": "Password has been updated Successfully"
                    });
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                    "url": "/ccp/s/certificationportallogin"
                    });
                    urlEvent.fire();
                    return;
                }
                component.find('notifLib').showToast({
                    "title": "Error!",
                    "variant": "Error",
                    "message": "There is some error please contact your System Admin"
                });
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    },
    doInit : function(component, event, helper) {
       debugger;
       var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
       var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
       var sParameterName;
       var i;

       for (i = 0; i < sURLVariables.length; i++) {
           sParameterName = sURLVariables[i].split('='); //to split the key from the value.

           if (sParameterName[0] === 'Id') { //lets say you are looking for param name - firstName
               sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
           }
       }
       component.set('v.RecordId',sParameterName[1]);
    }  
})