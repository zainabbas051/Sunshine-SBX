({
	getenableRequestBtn : function(component){
       
        var empID=component.get("v.empID");
        var action = component.get("c.getEnableRequestBtn");
        action.setParams({ empID : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var btnStatus = response.getReturnValue();
                component.set("v.enableRequestBtn", btnStatus);
            }
        });
        $A.enqueueAction(action);
        

    },

    getCurrentUserDetail : function(component){

       debugger;
        var empID=component.get("v.empID");
        var action = component.get("c.empInfo");
        action.setParams({ empID : empID });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
               var resultData=response.getReturnValue();
                component.set("v.empObj",resultData);
                var isSupervisor=false;
                if(resultData.User_Role__c=='Supervisor')
                component.set("v.isSuperVisor",true);
                  
               
            }
        });
        $A.enqueueAction(action);
    }
})