({
    saveEmpowerment : function(cmp) {
		var data = cmp.get("v.data");
   			data = this.joinArray(data);
        var action = cmp.get("c.saveEmpowerment");
        var empObj = cmp.get("v.empowerObj");
        var protestantType = cmp.get("v.ProtestantType");
        empObj.Support_Meetings_Interested_In__c=data;
        empObj.Related_Opportunity__c  = cmp.get("v.opptyId");
        if(protestantType!="" && empObj.What_Kind_of_Religious_Services__c=="Protestant")
        {
           empObj.What_Kind_of_Religious_Services__c= protestantType;
        } 	 			 			
          action.setParams({ EmpObj : empObj });
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
               
                cmp.find('notifLib').showToast({
            	"variant": "success",
            	"title":"Success",
            	"message": "Record has been saved Successfully",
           
        		});
                
                cmp.set("v.showForm",false);
 
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
                         cmp.find('notifLib').showToast({
            			"variant": "error",
            			"title":"Error",
            			"message": errors[0].message,
           
        				});
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    splitString : function(value){
    if (value == null) return null;  

    if(Array.isArray(value) == true) return value;

    return value.split(';');
},
    
    joinArray : function(value){
    if(value == null) return null;  

    if(Array.isArray(value) == false) return value;

    return value.join(';');
}
})