({

	login: function (component, event, helper) {
		debugger;
	
		var inputCmp = component.find("reqField");
		var isValid = true;
		for (var i=0; i < inputCmp.length; i++) {
			var value = inputCmp[i].get("v.value");
			if(value == undefined){
				$A.util.addClass(inputCmp[i], "slds-grow");
				component.set("v.isError",true);		
				isValid = false;
			}
		}
		if(!isValid){
			return;
		}
		
		var username = component.get('v.Username');
		var password = component.get('v.Password');
		//Calling the Apex Function
		var action = component.get("c.Login");

		//Setting the Apex Parameter
		action.setParams({

			Username: username,
			Password: password,
			IpAddress : component.get('v.ipAddress')
		});


		//Setting the Callback
		action.setCallback(this, function (a) {
			//get the response state
			var state = a.getState();


			//check if result is successfull
			if (state == "SUCCESS") {
				//Reset Form
				var Employee = a.getReturnValue();
				if (Employee != null && Employee.isActive__c == true) {

					var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/ccp/s/certificationportaldashboard?empId=" + Employee.Id+'&sup=false&empTier='+Employee.Tier_Allocation__c
                    });
					if (Employee.User_Role__c == 'Supervisor'){
                        urlEvent.setParams({
                            "url": "/ccp/s/certificationportaldashboard?empId=" + Employee.Id+'&sup=true&empTier='+Employee.Tier_Allocation__c
                        });
                    }

                    urlEvent.fire();
				}
				
				
				else if (Employee != null && Employee.isActive__c == false) {


					component.find('notifLib').showToast({
						"title": "Error!",
						"variant": "Error",
						"message": "The User you are trying to log in as has been In Activated. Please contact the Administrator"
					});
					return;	

				}
				
				else {
					component.find('notifLib').showToast({
						"title": "Error!",
						"variant": "Error",
						"message": "The UserName and Password Combination you are trying to Enter is either Incorrect or Does Not Exist"
					});
					return;
				}

			}
		});

		//adds the server-side action to the queue        
		$A.enqueueAction(action);
	},
    
    Reset: function (component, event, helper) {
		
		debugger;
		var inputCmp = component.find("reqField");
		for (var i=0; i < inputCmp.length; i++) {
			var value = inputCmp[i].get("v.value");
			if(value == undefined){
				$A.util.addClass(inputCmp[i], "slds-grow");
				component.set("v.isError",true);		
				return;
			}
		}
       
		
		//Calling the Apex Function
		var action = component.get("c.SendResetPasswordEmail");

		//Setting the Apex Parameter
		action.setParams({

			Username: value
			
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
						"mode":"sticky",
						"message": "Please check email to reset the paassword"
					});
					return;
				}
				component.find('notifLib').showToast({
					"title": "Error!",
					"variant": "Error",
					"mode":"sticky",
					"message": "User dosn't exist"
				});
			}
		});

		//adds the server-side action to the queue        
		$A.enqueueAction(action);
	},

	showResetForm : function (component, event, helper) {
		component.set('v.isReset',true);
	},

	doInit : function(component,event,helper){

		// get the client Ip start
		var request = new XMLHttpRequest();
		//request.open('GET', "https://api.ipify.org/", true);
		request.open('GET',"https://ipinfo.io/json",true);
		var ipAddress = '';
		request.onload = function () {
			debugger;
			if (request.status >= 200 && request.status < 400) {
				ipAddress = request.responseText;
				component.set('v.ipAddress',ipAddress);
				console.log(ipAddress);
			} else {
				// We reached our target server, but it returned an error
				console.log(request.statusText);
			}
		}
		request.onerror = function () {
			// There was a connection error of some sort
			console.log(request.statusText);
		}
		request.send();
		// get the client Ip end
	}
    
})