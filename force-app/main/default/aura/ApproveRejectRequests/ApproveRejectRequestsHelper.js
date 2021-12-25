({
	fetchData: function (component) {

		debugger;
		var action = component.get("c.getCertificationRequests");
		var empID = component.get("v.empID");
		action.setParams({
			"superVisorId": empID
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var data = response.getReturnValue();
				for (var i = 0; i < data.lstNewCert.length; i++) {
					var row = data.lstNewCert[i];
					if (row.Related_Employee__r) row.EmployeeName = row.Related_Employee__r.Name;
					if (row.Related_Certification__r) row.CertName = row.Certification_Name__c;
				}
				for (var i = 0; i < data.lstCompletedCert.length; i++) {
					var row = data.lstCompletedCert[i];
					if (row.Related_Employee__r) row.EmployeeName = row.Related_Employee__r.Name;
					if (row.Related_Certification__r) row.CertName = row.Certification_Name__c;
				}
                
                for (var i = 0; i < data.lstReimbursementCert.length; i++) {
					var row = data.lstReimbursementCert[i];
					if (row.Related_Employee__r) row.EmployeeName = row.Related_Employee__r.Name;
					if (row.Related_Certification__r) row.CertName = row.Certification_Name__c;
				}


				debugger;
				component.set("v.employeeCertData", data);
			}
		});
		$A.enqueueAction(action);
	},
    /*
	approveCertHelper: function (component) {

		debugger;
		var empID = component.get("v.empID");
		var tier1Ids = component.get("v.selectedRowsT1");
		var tier2Ids = component.get("v.selectedRowsT2");
		var tier3Ids = component.get("v.selectedRowsT3");
		var newIds = [];
		var d = new Date();
		var todayDate = d.getDate();
		for (var i in tier1Ids) {

			tier1Ids[i].Approved_Denied_Notes__c = 'Approved';
			newIds.push(tier1Ids[i]);
		}
		for (var i in tier2Ids) {

			tier2Ids[i].Approved_Denied_Notes__c = 'Approved';
			newIds.push(tier2Ids[i]);
		}

	
        var auraIds = ['DoT', 'Notes'];

    var allValid = auraIds.reduce(function(validFields, auraId) {
        // Find component corresponding to the aura:id
        var inputCmp = component.find(auraId);
        inputCmp.reportValidity();
        return validFields && inputCmp.checkValidity;
         alert(inputCmp.checkValidity);
    });
       
        if (allValid) {
		var action = component.get("c.approveCertification");
		action.setParams({
			"approveLst": newIds,
			"SupervisorId": empID
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.find('notifLib').showToast({
					"title": "Success!",
					"variant": "success",
					"message": "The record has been updated successfully."
				});
				//$A.get('e.force:refreshView').fire();
			}
		});
		$A.enqueueAction(action);
        }
	},
	
    rejectCertHelper: function (component) {

			debugger;
			var empID = component.get("v.empID");
			var tier1Ids = component.get("v.selectedRowsT1");
			var tier2Ids = component.get("v.selectedRowsT2");

			var newIds = [];
			for (var i in tier1Ids) {
				newIds.push(tier1Ids[i]);
			}
			for (var i in tier2Ids) {
				newIds.push(tier2Ids[i]);
			}
			

			var action = component.get("c.rejectCertification");
			action.setParams({
				"rejectLst": newIds,
				"SupervisorId": empID
			});

			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					component.find('notifLib').showToast({
						"title": "Success!",
						"variant": "success",
						"message": "The record has been updated successfully."
					});
					component.set("v.showModal", false);
					// $A.get('e.force:refreshView').fire();
				}
			});
			$A.enqueueAction(action);

		}

		,*/
	updateEmployeeData: function (component, helper) {
		var employeeData = component.get("v.EmployeeSelected");
		employeeData.Employee_Last_Annual_Performance__c = component.get("v.defaultRaiting");
		var action = component.get("c.updateEmployee");
		action.setParams({
			"selectedEmpObj": employeeData
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.find('notifLib').showToast({
					"title": "Success!",
					"variant": "success",
					"message": "The record has been updated successfully."
				});
				$A.get('e.force:refreshView').fire();
				//component.set("v.showModal", false);
			}
		});
		$A.enqueueAction(action);
	},
	toggleButton1: function (component, event, helper) {
		debugger;
		var selectedRows = event.getParam('selectedRows');
		component.set("v.approveBtnDisabled", true);
		component.set("v.selectedRowsT1", selectedRows);

		if (selectedRows.length > 0) {
			component.set("v.approveBtnDisabled", false);
		}

	},

	toggleButton2: function (component, event, helper) {
		debugger;
		var selectedRows = event.getParam('selectedRows');
		component.set("v.approveBtnDisabled", true);
		component.set("v.selectedRowsT2", selectedRows);

		if (selectedRows.length > 0) {
			component.set("v.approveBtnDisabled", false);
		}

	},


	toggleOneAndTwoSteps: function (component) {
		var stepOne = component.find("stepOne");
		$A.util.toggleClass(stepOne, 'slds-hide');
		var stepTwo = component.find("stepTwo");
		$A.util.toggleClass(stepTwo, 'slds-hide');
	},
	toggleTwoAndThreeSteps: function (component) {

		var stepTwo = component.find("stepTwo");
		$A.util.toggleClass(stepTwo, 'slds-hide');
		var stepThree = component.find("stepThree");
		$A.util.toggleClass(stepThree, 'slds-hide');
	},
	toggleTwoSteps: function (component) {
		var stepTwo = component.find("stepTwo");
		$A.util.toggleClass(stepTwo, 'slds-hide');

	},
	toggleThreeSteps: function (component) {
		var stepThree = component.find("stepThree");
		$A.util.toggleClass(stepThree, 'slds-hide');

	},


	getEmployeeCertColumn: function (component) {


		component.set('v.employeeCertColumn', [{
				label: 'Training Name',
				fieldName: 'CertName',
				type: 'text'
			},
			{
				label: 'Requested By',
				fieldName: 'EmployeeName',
				type: 'text'
			}

		]);

	},
	approveCertHelper: function (component) {

		debugger;
		var empID = component.get("v.empID");
		var tier1Ids = component.get("v.selectedRowsT1");
		var tier2Ids = component.get("v.selectedRowsT2");
        var tier3Ids = component.get("v.selectedRowsT3");

		var newIds = [];
		var d = new Date();
		var todayDate = d.getDate();
        var auraIds; 
		for (var i in tier1Ids) {

			var notes = component.find("notesA").get("v.value");
            tier1Ids[i].Approved_Denied_Notes__c = notes;
            var dateOfTraining = component.find("DoT").get("v.value");
            tier1Ids[i].Date_of_Training__c=dateOfTraining;
            tier1Ids[i].Certification_Due_Date__c=dateOfTraining;
           
			newIds.push(tier1Ids[i]);
		}
		for (var i in tier2Ids) {

			var notes = component.find("notesA").get("v.value");
            tier2Ids[i].Approved_Denied_Notes__c = notes;
            
            var dateOfTraining;
            
            if(component.find("DoT") != null){
                dateOfTraining = component.find("DoT").get("v.value");
                tier2Ids[i].Date_of_Training__c = dateOfTraining;
                tier2Ids[i].Certification_Due_Date__c=dateOfTraining;
            }	
			newIds.push(tier2Ids[i]);
		}
        
        for (var i in tier3Ids) {

			var notes = component.find("notesA").get("v.value");
            
            tier3Ids[i].Approved_Denied_Notes__c = notes;
            var payoutDate = component.find("PoD").get("v.value");
            tier3Ids[i].Reimbursement_Request_Payout_Date__c=payoutDate;
            var ReimbursAmt = component.find("RAmt").get("v.value");
            tier3Ids[i].Eligible_Reimbursement_Amount__c=ReimbursAmt;
			newIds.push(tier3Ids[i]);
		}
	var auraIds;
	//var state=component.get("v.isNewRequest");
        if(component.get("v.isNewRequest")==true){
	auraIds = ['0', 'DoT'];
        }
        else if(component.get("v.isCompletedRequest")==true){
            auraIds = ['0'];
            
        }
            else if(component.get("v.isReimbursRequest")==true){
                auraIds = ['0', 'PoD'];
            }
         var allValid =true;
     allValid = auraIds.reduce(function(validFields, auraId) {
       debugger;
        // Find component corresponding to the aura:id
        var inputCmp = component.find(auraId);
        inputCmp.showHelpMessageIfInvalid();
        inputCmp.reportValidity();
        
        return validFields && inputCmp.get('v.validity').valid;
         //alert(inputCmp.checkValidity);
    });
     
        if (allValid) {
		
		var action = component.get("c.approveCertification");
		action.setParams({
			"approveLst": newIds,
			"SupervisorId": empID
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.find('notifLib').showToast({
					"title": "Success!",
					"variant": "success",
					"message": "The record has been updated successfully."
				});
				this.fetchData(component);
			//	var cmpEvent = component.getEvent("cmpRefreshEvent");
				//cmpEvent.fire();
				//component.set("v.showModal",false);
				
                location.reload();
				//$A.get('e.force:refreshView').fire();
			//component.set("v.IsAuthenticated",true);
				
			}
		});
		$A.enqueueAction(action);

	}
    },

	rejectCertHelper: function (component) {

		debugger;
		var empID = component.get("v.empID");
		var tier1Ids = component.get("v.selectedRowsT1");
		var tier2Ids = component.get("v.selectedRowsT2");
        var tier3Ids = component.get("v.selectedRowsT3");

		var newIds = [];
		for (var i in tier1Ids) {
            var notes = component.find("notesA").get("v.value");
            tier1Ids[i].Approved_Denied_Notes__c = notes;
			newIds.push(tier1Ids[i]);
            
		}
		for (var i in tier2Ids) {
            var notes = component.find("notesA").get("v.value");
            tier2Ids[i].Approved_Denied_Notes__c = notes;
			newIds.push(tier2Ids[i]);
		}

		for (var i in tier3Ids) {
            var notes = component.find("notesA").get("v.value");
            tier3Ids[i].Reimbursement_Notes__c = notes;
			newIds.push(tier3Ids[i]);
		}
        var state=component.get("v.isNewRequest");
        var auraIds = ['0', 'notesA'];
	var allValid =true;
    /* allValid = auraIds.reduce(function(validFields, auraId) {
       debugger;
        // Find component corresponding to the aura:id
        var inputCmp = component.find(auraId);
        inputCmp.showHelpMessageIfInvalid();
        inputCmp.reportValidity();
        
        return validFields && inputCmp.get('v.validity').valid;
         //alert(inputCmp.checkValidity);
    });
     */
        if (allValid) {
		var action = component.get("c.rejectCertification");
		action.setParams({
			"rejectLst": newIds,
			"SupervisorId": empID
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.find('notifLib').showToast({
					"title": "Success!",
					"variant": "success",
					"message": "The record has been updated successfully."
				});
				this.fetchData(component);
				//var cmpEvent = component.getEvent("cmpRefreshEvent");
			//	cmpEvent.fire();
				component.set("v.showModal",false);
				
				location.reload();
               // $A.get('e.force:refreshView').fire();
			}
		});
		$A.enqueueAction(action);
        }
	}
})