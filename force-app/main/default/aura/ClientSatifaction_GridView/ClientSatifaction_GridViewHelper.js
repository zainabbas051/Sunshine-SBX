({
	fetchData: function(component, event, helper) {
      
		var action = component.get("c.GetSurveyRecord");
        action.setParams({
          
            sunShineCenter : component.get("v.SunshineCenter")
        });
          
        
		action.setCallback(this,
		function(response) {
			var state = response.getState();
            var userId = $A.get("$SObjectType.CurrentUser.Id");
			if (state === "SUCCESS") {
				var data = response.getReturnValue();
                debugger;
				component.set('v.ListOfSurvey', data);
                
			}
			else if (state === "ERROR") {
                debugger;
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set('v.errorMessage', "Error message: " + errors[0].message);
					}
				} else {
					console.error("Unknown error");
				}
			}
			component.set("v.isLoading", false);
		});
		$A.enqueueAction(action);
	},
    refreshData: function(component, event) {
		var action = component.get("c.GetSurveyRecord");
      
        action.setParams({
          
            sunShineCenter : component.get("v.SunshineCenter")
        });
        
		action.setCallback(this,
		function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var data = response.getReturnValue();
				component.set('v.ListOfSurvey', data);
                
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set('v.errorMessage', "Error message: " + errors[0].message);
					}
				} else {
					console.error("Unknown error");
				}
			}
			component.set("v.isLoading", false);
		});
		$A.enqueueAction(action);
	}
 })