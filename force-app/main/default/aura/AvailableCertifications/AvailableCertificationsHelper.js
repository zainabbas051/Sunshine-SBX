({
    
    getColumn : function(component) {


        component.set('v.columns', [
			
            {label: 'Certification Name', fieldName: 'Name', type: 'text'},
            {label: 'Certification Cost', fieldName: 'Certification_Cost__c', type: 'text'},
           
            
            {
                type:  'button',
                typeAttributes: 
                {
                  iconName: 'utility:send',
                  label: 'Apply', 
                  name: 'editRecord', 
                  title: 'sendRequest', 
                  disabled: false, 
                  value: ''
                }
              }
           
        	
        ]);
    },

    getData : function(component,helper){
       debugger;
        var empID = component.get("v.empID");
        var empTier=component.get("v.empTier");
        var empSunshineCenter=component.get("v.sunshineCenter");
        var action = component.get("c.GetAvailableCertification");
        action.setParams({ empID : empID ,
                          "Tier" : empTier,
                          "sunshineCenter" :empSunshineCenter });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
            }
        });
        $A.enqueueAction(action);
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
                component.set("v.employeeData", resultData);
                component.set("v.sunshineCenter", resultData.Sunshine_Center_NameF__c);
                this.getData(component,this);
            }
        });
        $A.enqueueAction(action);
    },

    createCertificationRequest : function(component,helper,row){
       debugger; 
        var employeeData = component.get("v.employeeData");
        var budgetLeft = employeeData.Available_BudgetF__c;
        var isBudgetOver =  component.get('v.IsBudgetExeeded');
        component.set('v.paidBy','Company');
         if(budgetLeft < row.Certification_Cost__c ){
            isBudgetOver = true; 
            component.set('v.IsBudgetExeeded',isBudgetOver);
            component.set('v.selectedRow',row);
            var exceededAmount = row.Certification_Cost__c - budgetLeft;
            if(exceededAmount < row.Certification_Cost__c){
             component.set('v.paidBy','Partially By Employee');
            }
            component.set('v.costPaidByEmployee',exceededAmount);
            if(exceededAmount == row.Certification_Cost__c){
                component.set('v.paidBy','Employee');     
            }
            return;
        }
        this.finalizeRequestHelper(component);
       // this.getenableRequestBtn(component);
         // alert(btnStatus);
    },

    getenableRequestBtn : function(component){
       
        var empID=component.get("v.empID");
        var action = component.get("c.getEnableRequestBtn");
        action.setParams({ empID : empID });
         // alert(Hi2);
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var btnStatus = response.getReturnValue();
              
                component.set("v.enableRequestBtn", btnStatus);
            }
        });
        $A.enqueueAction(action);
    },
    finalizeRequestHelper : function(component){
        debugger;
        var empID = component.get("v.empID");
        var certID = component.get("v.certificationId");
        var action = component.get("c.createCertificationRequest");
        var row = component.get('v.selectedRow');
        action.setParams({ empID : empID ,
                         certId : certID,
                         paidBy : component.get('v.paidBy'),
                         paidByEmp : component.get('v.costPaidByEmployee')});

        action.setCallback(this,function(response) {
           
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = component.get('v.data');
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                component.set('v.data', rows);
                var cmpEventBudget = component.getEvent("UpdateEmpBudget");
                cmpEventBudget.fire();
                var evt = $A.get("e.c:UpdateRequestedCertifications");
        		//evt.setParams({ "Update": true});
        		evt.fire();   
              
                try {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: 'Success',
                            message: 'The Certification request has been created',
                            duration: ' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        component.set('v.isNew',false);
                      	
                      
                    }
                
                    catch (err) {
                        alert('The Certification request has been created');
                    }
                component.set("v.enableRequestBtn", false);
                
            }
        });
        $A.enqueueAction(action);
    },
    applyCertHelper : function(component){
        debugger;
        var empCert =  component.get("v.empCert");
        var employeeData = component.get("v.employeeData");
        var budgetLeft = employeeData.Available_BudgetF__c;
        var isBudgetOver =  component.get('v.IsBudgetExeeded');
        empCert.Certification_Cost_Paid_By__c = 'Company';  
         if(budgetLeft < empCert.Other_Certification_Cost__c ){
            isBudgetOver = true; 
            component.set('v.IsBudgetExeeded',isBudgetOver);
            var exceededAmount = empCert.Other_Certification_Cost__c - budgetLeft;
            if(exceededAmount < empCert.Other_Certification_Cost__c){
             empCert.Certification_Cost_Paid_By__c='Partially By Employee';
            }
             component.set('v.costPaidByEmployee',exceededAmount);
            empCert.Employee_Responsibility_Amount__c= exceededAmount;
            if(exceededAmount == empCert.Other_Certification_Cost__c){
                 empCert.Certification_Cost_Paid_By__c = 'Employee';     
            }
            return;
        }
        this.finalizeOtherCert(component);
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
                
                  
               
            }
        });
        $A.enqueueAction(action);
    },
    finalizeOtherCert : function(component){
        this.getCurrentUserDetail(component);
        var empCert =  component.get("v.empCert");
        var empId =  component.get("v.empID");
        var empObj =  component.get("v.empObj");
        empCert.Status__c = 'Requested';
        empCert.Related_Employee__c = empId;
 		empCert.Employee_Email__c=empObj.email__c;
        empCert.Supervisor_Email__c=empObj.Supervisor_Name__r.email__c;
        var action = component.get("c.createOtherCertificationRequest");
        action.setParams({ css : empCert});
        action.setCallback(this,function(response) {
             var state = response.getState();
            
            	if (state === "SUCCESS") {
				
                    var cmpEventBudget = component.getEvent("UpdateEmpBudget");
                cmpEventBudget.fire();
                var evt = $A.get("e.c:UpdateRequestedCertifications");
        		//evt.setParams({ "Update": true});
        		evt.fire();   
              
                    try {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: 'Success',
                            message: 'The Certification request has been created',
                            duration: ' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        component.set('v.isNew',false);
                      	
                      
                    }
                
                    catch (err) {
                        alert('The Certification request has been created');
                    }
                }
        });
         $A.enqueueAction(action);
    }
})