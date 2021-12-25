({
	 getData : function(component,helper){
        debugger;
        
        var empID=component.get("v.empID");
        var action = component.get("c.GetSupervisorSummary");
        action.setParams({ "supervisorId" : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
               var recordData;
				recordData = resultData['Tier 1-Total Reports'];
                component.set("v.T1numberOfReports", recordData == undefined ? 0 : recordData );
                recordData = resultData['Tier 1-Total Completed Certifications'];
                 component.set("v.T1completedCertifications", recordData == undefined ? 0 : recordData);
                recordData = resultData['Tier 1-Total In-Progress Certifications'];
                 component.set("v.T1inProgressCertifications", recordData == undefined ? 0 : recordData);
                recordData = resultData['Tier 1-Utilized Budget']; 
                component.set("v.T1UtilizedBudget", recordData == undefined ? 0 : recordData);
                recordData = resultData['Tier 1-Available Budget']; 
                component.set("v.T1AvailableBudget", recordData == undefined ? 0 : recordData);
                
                recordData = resultData['Tier 2-Total Reports'];
                component.set("v.T2numberOfReports", recordData == undefined ? 0 : recordData );
                recordData = resultData['Tier 2-Total Completed Certifications'];
                 component.set("v.T2completedCertifications", recordData == undefined ? 0 : recordData);
                recordData = resultData['Tier 2-Total In-Progress Certifications'];
                 component.set("v.T2inProgressCertifications", recordData == undefined ? 0 : recordData);
                recordData = resultData['Tier 2-Utilized Budget']; 
                component.set("v.T2UtilizedBudget", recordData == undefined ? 0 : recordData);
                recordData = resultData['Tier 2-Available Budget']; 
                component.set("v.T2AvailableBudget", recordData == undefined ? 0 : recordData);  
                 
                recordData = resultData['Tier 3-Total Reports'];
                component.set("v.T3numberOfReports", recordData == undefined ? 0 : recordData );
                recordData = resultData['Tier 3-Total Completed Certifications'];
                 component.set("v.T3completedCertifications", recordData == undefined ? 0 : recordData);
                recordData = resultData['Tier 3-Total In-Progress Certifications'];
                 component.set("v.T3inProgressCertifications", recordData == undefined ? 0 : recordData);
                recordData = resultData['Tier 3-Utilized Budget']; 
                component.set("v.T3UtilizedBudget", recordData == undefined ? 0 : recordData);
                recordData = resultData['Tier 3-Available Budget']; 
                component.set("v.T3AvailableBudget", recordData == undefined ? 0 : recordData);
            }
        });
        $A.enqueueAction(action);
    },
    getT2EmployeeData : function(component){
       debugger;
        var empID = component.get("v.empID");

            var action = component.get("c.getTeir2Employees");
        
               
        action.setParams({ superVisorId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                if(resultData!=null)
                component.set("v.EmployeedataT2", resultData);
                
            }
        });
        $A.enqueueAction(action);
    }
    ,
    getT3EmployeeData : function(component){
       debugger;
        var empID = component.get("v.empID");
        
                    
          var  action = component.get("c.getTeir3Employees");

       
        action.setParams({ superVisorId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.EmployeedataT3", resultData);
                
            }
        });
        $A.enqueueAction(action);
    }
})