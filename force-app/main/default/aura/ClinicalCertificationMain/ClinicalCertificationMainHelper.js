({
	helperMethod : function() {
		
	},

	getEmployeeData : function(component){

		
        var empID = component.get("v.empID");
        var action = component.get("c.getEmployeeDetail");
        action.setParams({ empId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
				component.set('v.totalBudget',resultData.Utilized_Budget__c);
                component.set('v.availableBudget',resultData.Available_BudgetF__c);              
            }
        });
        $A.enqueueAction(action);
    },
    getEmployeeProfileInfo : function(component){

        var empID = component.get("v.empID");
        var action = component.get("c.getEmployeeProfileInfo");
        action.setParams({ empId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                if(resultData.Tabs_Access__c.indexOf('Incident Report') != -1){
                    component.set('v.showIncidentReport',true);
                    component.set('v.selectedTab','in');
                }  
                if(resultData.Tabs_Access__c.indexOf('Certification Dashboard') != -1){
                    component.set('v.showClinicalDashboard',true);
                    component.set('v.selectedTab','cl');
                }              
            }
        });
        $A.enqueueAction(action);
    }



})