({
	fetchData: function(component, event, helper) {
       
		var action = component.get("c.GetOpportunityRecord");
        action.setParams({
          
            sunShineCenter : component.get("v.SunshineCenter")
        });
          
    
		action.setCallback(this,
		function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var data = response.getReturnValue();
   				 for(var i = 0; i < data.length; i++){
						data[i];
               			debugger;
                      var recordName = data[i].Name;
                      var recordNames = recordName.split(' ');
                    if(recordNames[1]!=null)
                      data[i].Name = recordNames[0] + ' ' + recordNames[1].substring(0,1);
                     else
                         data[i].Name = recordNames[0];
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
			component.set("v.isLoading", false);
		});
		$A.enqueueAction(action);
	},
    refreshData: function(component, event) {
		var action = component.get("c.GetOpportunityRecord");
      
        action.setParams({
          
            sunShineCenter : component.get("v.SunshineCenter")
        });
        
		action.setCallback(this,
		function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var data = response.getReturnValue();
				 for(var i = 0; i < data.length; i++){
						data[i];
               			debugger;
                      var recordName = data[i].Name;
                      var recordNames = recordName.split(' ');
                      if(recordNames[1]!=null)
                      data[i].Name = recordNames[0] + ' ' + recordNames[1].substring(0,1);
                     else
                         data[i].Name = recordNames[0];
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
			component.set("v.isLoading", false);
		});
		$A.enqueueAction(action);
	},
    view : function(component,event,helper){
    
        var component_target = event.currentTarget;
   		var OppID = component.get("v.selectedOppID");
        var SatisfactionSurveyEvent = $A.get("e.c:ClientSatifaction_Event");
        var sunshineCenter = component.get("v.selectedSunshineCenter");
       var kipuPrimaryTherapist= component.get("v.selectedKIPUPrimaryTherapist");
       var kipuCaseManager= component.get("v.selectedKIPUCaseManager");
       	component.set("v.showCmp",false); 
       // alert(component.get("v.isEven"));
        SatisfactionSurveyEvent.setParams({ "OpportunityID" : OppID,
                                           "sunshineCenter" : sunshineCenter,
                                           "kipuPrimaryTherapist" :kipuPrimaryTherapist,
                                           "kipuCaseManager" :kipuCaseManager,
                                            "ReadOnly" : false,
                                           "returnCmp" : "create",
                                           "isEven" : component.get("v.isEven"),
                                           "surveyNumber" : component.get("v.surveyNumber")
                                          });
		//fire event
        SatisfactionSurveyEvent.fire();

        
    }
    
    
})