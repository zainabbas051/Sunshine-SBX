({
    myAction : function(component, event, helper) {
        debugger;
        var d= new Date();
        var maintenanceType = component.get('v.maintenanceType');
        component.find('selectYearFilter').set('v.value' , d.getFullYear());
        component.set("v.selectedYear",d.getFullYear()); 
        if(maintenanceType == 'Monthly'){
            component.find('selectFilter').set('v.value' , d.getMonth()+1); //updating the picklist value
            component.set("v.selectedDate",d.getMonth()+1); // assigning the value 
        }
        if(maintenanceType == 'Quarterly'){
            debugger;
            var quarter = Math.floor(d.getMonth()/ 3)
            component.find('selectFilter').set('v.value' , quarter+1);//updating the picklist value
            component.set("v.selectedDate",quarter+1); // assigning the value 
        }
        helper.fetchData(component);
    },
    completeHouseLineItem : function(component, event, helper){
        debugger;
        var inputCmp = component.find("inputCmp");
        var value = inputCmp.get("v.value");
        if(value == ''){
            inputCmp.setCustomValidity("This field is required"); 
            inputCmp.reportValidity();
            return;
        }
        helper.completeHouseLineItemRecord(component);     
        helper.fetchData(component);
    },
    enableCompleteBtn : function(component,event){
       
       debugger;
       var data = component.get("v.data");
       var accessType = component.get("v.AccessType");
       if(accessType == 'BHT'){
            for(var i in data){    
                component.set('v.isCompleted',true);
                if(data[i].BHT_Status__c == true && data[i].Staff_Completed_By__c == undefined){
                    component.set('v.isCompleted',false);  
                    break;
                }
            }    
        }
        else if(accessType == 'Supervisor')
        for(var i in data){    
            component.set('v.isCompleted',true);
            if(data[i].Supervisor_Status__c == true && data[i].Supervisor_Completed_Date__c == undefined){
                component.set('v.isCompleted',false);  
                break;
            }
        } 
    },
    openModal : function(component, event, helper){
        component.set("v.showModal",true);
    },
    closeModal : function(component, event, helper){
        component.set("v.showModal",false);
    },
    onFilterSelection : function(component,event,helper){
        
        var d2= new Date();
        var currentMonth=d2.getMonth();
        debugger;
        var maintenanceType = component.get('v.maintenanceType');
        if(component.find('selectFilter').get('v.value')==0 && maintenanceType == 'Monthly'){
            component.find('selectFilter').set('v.value' , currentMonth+1);
        }
        if(component.find('selectFilter').get('v.value')==0 && maintenanceType == 'Quarterly'){
            var quarter = Math.floor(currentMonth/ 3)
            component.find('selectFilter').set('v.value' , quarter+1);
        }     
        component.set("v.selectedDate",component.find('selectFilter').get('v.value'));
        helper.fetchData(component);
    },

    onYearFilterSelection : function(component,event,helper){
        component.set("v.selectedYear",component.find('selectYearFilter').get('v.value'));
       
        helper.fetchData(component);
    }
})