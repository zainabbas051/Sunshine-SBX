({
    fetchData : function(component) {
        var action = component.get("c.GetOpportunityRecord");
           
		action.setCallback(this,
		function(response) {
			var state = response.getState();
            
			if (state === "SUCCESS") {
				var data = response.getReturnValue();
                
                  for(var i = 0; i < data.length; i++){
                      var recordName = data[i].Name;
                      var recordNames = recordName.split(' ');
                      data[i].Name = recordNames[0] + ' ' + recordNames[1].substring(0,1);
               			//alert('test');
                }
				              
				component.set('v.ListOfOpportunity', data);
                
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
			//component.set("v.isLoading", false);
		});
		$A.enqueueAction(action);
    }
})