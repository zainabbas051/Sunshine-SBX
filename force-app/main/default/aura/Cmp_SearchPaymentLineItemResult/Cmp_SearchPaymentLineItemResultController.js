({
    doInit : function(component, event, helper) {
	var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
	},
	
    
    showSection : function(component, event, helper) {
        
        debugger;
        component.set('v.isLoaded', false);
        var index = event.getSource().get('v.name');
        var ppliRec = component.get('v.paymentLineItemList');
        ppliRec[index].IsEditable = true;
        let fields = component.find('requiredForm');
        if(ppliRec[index].IsAmountCorrect == 'No'){
            ppliRec[index].IsEditable = false;
        }
        
        component.set('v.paymentLineItemList',ppliRec);
        component.set('v.isLoaded', true);
		  
	},
    saveUpdatedCash : function(component, event, helper) {

        debugger;
        component.set('v.isLoading', true);
        var fireIndex = event.getSource().get('v.name');
        var fieldIndex = 2 * fireIndex;
        let fields = component.find('requiredForm');
        for(var i = 0 ; i < fields.length; i++){
            if(fields[i] != null && (i == fieldIndex || i == fieldIndex + 1)){
                if (fields[i].get('v.validity').valid == false) {
                    fields[i].showHelpMessageIfInvalid();
                    isValid = false;
                }
            }
        }
       
       
     
     
        var ppliRecArray = component.get('v.paymentLineItemList');
        var ppliRec = ppliRecArray[fireIndex];
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = mm + '/' + dd + '/' + yyyy;
           
        ppliRec.paymentLineItem.Status__c='Closed';
        ppliRec.paymentLineItem.Actual_Mode_of_Collection__c='Cash';
        var oldValue = ppliRec.paymentLineItem.Amount_For_Collection__c;
        var collectorNotes =  ppliRec.paymentLineItem.Collector_Notes__c;
        var AmountValue;
        if(ppliRec.IsAmountCorrect == 'Yes'){
            
            if(collectorNotes != null){
                collectorNotes	+='\n\nThe Cash Collected by '+ ppliRec.paymentLineItem.Name_of_Person_Responsible__c+' on '+ppliRec.paymentLineItem.Closed_Date__c+' was confirmed by '+component.get("v.userInfo")+' on '+today;
            }
            else{
                collectorNotes	='\n\nThe Cash Collected by '+ppliRec.paymentLineItem.Name_of_Person_Responsible__c+' on '+ppliRec.paymentLineItem.Closed_Date__c+' was confirmed by '+component.get("v.userInfo")+' on '+today;
            }
        }
        if(ppliRec.IsAmountCorrect == 'No'){
            AmountValue = ppliRec.ActualCashCollected;
        
            if(collectorNotes !=null)
                collectorNotes	+='\n\nThe Cash Collected by '+ppliRec.paymentLineItem.Name_of_Person_Responsible__c+' on '+ppliRec.paymentLineItem.Closed_Date__c+' was confirmed by '+component.get("v.userInfo")+' on '+today;
            else{
                collectorNotes	='\n\nThe Cash Collected by '+ppliRec.paymentLineItem.Name_of_Person_Responsible__c+' on '+ppliRec.paymentLineItem.Closed_Date__c+' was confirmed by '+component.get("v.userInfo")+' on '+today;
            }
        
            collectorNotes	+= '\nCorrected Amount: $'+ AmountValue+' Amount Entered by the collector: $'+oldValue; 
            collectorNotes	+='\n\nAdditional Notes: '+ ppliRec.AdditionalNotes;
        }
            ppliRec.paymentLineItem.Collector_Notes__c  = collectorNotes;
               
        helper.saveRecord(component, event, helper,ppliRec,fireIndex);

        
       
        /*debugger;
       
        ppliRec[0].Status__c='Closed';
        ppliRec[0].Actual_Mode_of_Collection__c='Cash';
        var oldValue=ppliRec[0].Amount_For_Collection__c;
        var today = new Date();
                var dd = String(today.getDate()).padStart(2, '0');
                var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                var yyyy = today.getFullYear();
                
                today = mm + '/' + dd + '/' + yyyy;
              var collectorNotes=  ppliRec[0].Collector_Notes__c;
        if(isAmountCorrect == 'Yes'){       	
           if(ppliRec[0].Collector_Notes__c!=null)
            ppliRec[0].Collector_Notes__c	+='\n\nThe Cash Collected by '+ppliRec[0].Name_of_Person_Responsible__c+' on '+ppliRec[0].Closed_Date__c+' was confirmed by '+component.get("v.userInfo")+' on '+today;
          else 
              ppliRec[0].Collector_Notes__c	='\n\nThe Cash Collected by '+ppliRec[0].Name_of_Person_Responsible__c+' on '+ppliRec[0].Closed_Date__c+' was confirmed by '+component.get("v.userInfo")+' on '+today;
        }
        if(isAmountCorrect == 'No'){
            var AmountValue = inputCmp.get("v.value");
        // is input numeric?
        var isvalid=true;
            if (AmountValue == 0) {
            inputCmp.setCustomValidity("Please enter the actual amount");
            inputCmp.reportValidity();
           isvalid=false;
        } 
        else ppliRec[0].Amount_For_Collection__c=AmountValue;
        
        inputCmp = component.find("AdditionalNotes");
            
        var Notesvalue = inputCmp.get("v.value");
         if (Notesvalue == '') {
            inputCmp.setCustomValidity("This field is required");
            inputCmp.reportValidity();
             isvalid=false;
        } 
    if(isvalid==false)
        return;
        
            else {
                if(ppliRec[0].Collector_Notes__c!=null)
                ppliRec[0].Collector_Notes__c	+='\n\nThe Cash Collected by '+ppliRec[0].Name_of_Person_Responsible__c+' on '+ppliRec[0].Closed_Date__c+' was confirmed by '+component.get("v.userInfo")+' on '+today;
                else
                 ppliRec[0].Collector_Notes__c	='\n\nThe Cash Collected by '+ppliRec[0].Name_of_Person_Responsible__c+' on '+ppliRec[0].Closed_Date__c+' was confirmed by '+component.get("v.userInfo")+' on '+today;
                ppliRec[0].Collector_Notes__c	+= '\nCorrected Amount: $'+ AmountValue+'Amount Entered by the collector: $'+oldValue; 
                ppliRec[0].Collector_Notes__c	+='\n\nAdditional Notes: '+Notesvalue
            }
                ppliRec[0].Cash_Collection_Discrepancy__c=true;
                 
        }
        
        
        var action = component.get("c.saveRecord");
        action.setParams({

            paymentPlanLineItemParam: ppliRec[0]
            
        });
        
        action.setCallback(this, function (a) {
            //get the response state
            var state = a.getState();

            //check if result is successfull
            if (state == "SUCCESS") {
                //Reset Form
                component.set("v.showList",false); 
                component.set("v.referenceId","");
                    try {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: 'Success',
                            message: 'The Payment Plan has been saved',
                            duration: ' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                    catch (err) {
                        alert('The Payment Plan has been saved');
                    }
                 
            }
        });
        $A.enqueueAction(action);*/
    }
})