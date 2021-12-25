({
    
   
    getData : function(component,helper){
        
        var empID=component.get("v.empID");
        var action = component.get("c.getEmployeeList");
        action.setParams({ supervisorId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
               /* var WSRData=resultData.filter(function(h) {
  										return h.Sunshine_Center_Relation_To__c.Name=='Willowsprings Recovery';
									} );
                component.set("v.WSRdata", WSRData);
               var MSRData=resultData.filter(function(h) {
  										return h.Sunshine_Center_Relation_To__c.Name=='Mountain Springs Recovery';

									} );
                component.set("v.MSRdata", MSRData);
                
                var MSData=resultData.filter(function(h) {
  										return h.Sunshine_Center_Relation_To__c.Name=='Monarch Shores';

									} );
                component.set("v.MSdata", MSData);
                
                var CCData=resultData.filter(function(h) {
  										return h.Sunshine_Center_Relation_To__c.Name=='Chapters Capistrano';

									} );
                component.set("v.CCdata", CCData);
                */
                
                
            }
        });
        $A.enqueueAction(action);
    }
})