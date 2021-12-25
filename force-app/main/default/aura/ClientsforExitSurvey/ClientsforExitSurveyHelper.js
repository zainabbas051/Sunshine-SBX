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
                }
				
               /* var RecordName = data[0].Name;
                var spName=RecordName.split(" ");
               	spName[0]+" "+spName[1].split("")[0]; */  
                
               
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
        var ExitSurveyEvent = $A.get("e.c:ShowExitSurvey_Event");
        var sunshineCenter = component.get("v.selectedSunshineCenter");
        var OppName = component.get("v.selectedOppName");
        var OppCloseDate = component.get("v.selectedCLientCloseDate");
         var kipuPrimaryTherapist = component.get("v.selectedkipuPrimaryTherapist");
         var kipuCaseManager = component.get("v.selectedkipuCaseManager");

		var ClientEmail = component.get("v.selectedCLientEmail");
        var ClientPhone = component.get("v.selectedCLientPhone");
       	component.set("v.showCmp",false); 
        ExitSurveyEvent.setParams({ "OpportunityID" : OppID,
                                           "sunshineCenter" : sunshineCenter,
                                            "ReadOnly" : false,
                                           "returnCmp" : "create",
                                   "OpportunityName" :OppName,
                                   "OpportunityAdmissionDate":OppCloseDate,
                                   "kipuPrimaryTherapist":kipuPrimaryTherapist,
                                   "kipuCaseManager" :kipuCaseManager,
                                   "Email" : ClientEmail,
                                   "Phone" : ClientPhone
                                          
                                          });
		//fire event
        ExitSurveyEvent.fire();
    }
    
    
})