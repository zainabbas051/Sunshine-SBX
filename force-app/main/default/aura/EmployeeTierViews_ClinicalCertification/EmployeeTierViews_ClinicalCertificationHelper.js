({
    fetchData : function(component) {

        debugger;
        var action = component.get("c.getCertificationRequests");
        var empID=component.get("v.empID");
        action.setParams({
            "superVisorId" : empID
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                for (var i = 0; i < data.lstNewCert.length; i++) {
                    var row = data.lstNewCert[i];
                    if (row.Related_Employee__r) row.EmployeeName = row.Related_Employee__r.Name;
                    if (row.Related_Certification__r) row.CertName = row.Related_Certification__r.Name;
                }
                for (var i = 0; i < data.lstCompletedCert.length; i++) {
                    var row = data.lstCompletedCert[i];
                    if (row.Related_Employee__r) row.EmployeeName = row.Related_Employee__r.Name;
                    if (row.Related_Certification__r) row.CertName = row.Related_Certification__r.Name;
                }
                
                for (var i = 0; i < data.lstReimbursementCert.length; i++) {
                    var row = data.lstReimbursementCert[i];
                    if (row.Related_Employee__r) row.EmployeeName = row.Related_Employee__r.Name;
                    if (row.Related_Certification__r) row.CertName = row.Related_Certification__r.Name;
                }
                
                
                debugger;
                component.set("v.employeeData", data);
            }
        });
        $A.enqueueAction(action);
    },
/*
    approveCertHelper : function(component){

        debugger;
        var empID=component.get("v.empID");
        var tier1Ids = component.get("v.selectedRowsT1");  
        var tier2Ids = component.get("v.selectedRowsT2");  
        var tier3Ids = component.get("v.selectedRowsT3");  
        var newIds =[];
        var d = new Date();
		var todayDate = d.getDate();
        for(var i in tier1Ids){
   
            tier1Ids[i].Approved_Denied_Notes__c='Approved';
            newIds.push(tier1Ids[i]);
        }
        for(var i in tier2Ids){

            tier2Ids[i].Approved_Denied_Notes__c='Approved';
            newIds.push(tier2Ids[i]);
        }
        for(var i in tier3Ids){

            tier3Ids[i].Approved_Denied_Notes__c='Approved';
            newIds.push(tier3Ids[i]);
        }

        var action = component.get("c.approveCertification");
        action.setParams({
            "approveLst" : newIds,
            "SupervisorId" : empID
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "The record has been updated successfully."
                });
              //  $A.get('e.force:refreshView').fire();
                
            }   
        });
        $A.enqueueAction(action);

    },

    rejectCertHelper : function(component){

        debugger;
        var empID=component.get("v.empID");
        var tier1Ids = component.get("v.selectedRowsT1");  
        var tier2Ids = component.get("v.selectedRowsT2");  
        var tier3Ids = component.get("v.selectedRowsT3");  
        var newIds =[];
        for(var i in tier1Ids){
            newIds.push(tier1Ids[i]);
        }
        for(var i in tier2Ids){
            newIds.push(tier2Ids[i]);
        }
        for(var i in tier3Ids){
            newIds.push(tier3Ids[i]);
        }

        var action = component.get("c.rejectCertification");
        action.setParams({
            "rejectLst" : newIds,
            "SupervisorId" : empID
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "The record has been updated successfully."
                });
                $A.get('e.force:refreshView').fire();
            }   
        });
        $A.enqueueAction(action);

    }
    */
})