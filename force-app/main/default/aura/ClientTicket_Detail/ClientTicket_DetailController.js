({
    defaultAction : function(component, event, helper) {

        helper.readUrl(component);
        helper.getRecordDetail(component);
        
    },

    changeEscalated : function (component,event,helper){
       
       var chkValue = component.find('escalationChckbox').get('v.checked')
       component.set('v.escalatedCheckBox',chkValue);
       
    },

    saveClientTicket : function(component,event,helper){
        helper.updateTicketInfo(component);
    },

    editForm : function(component,event,helper){
        component.set('v.disabled',false);
    },
    closeCase : function(component,event,helper){

        var caseObj = component.get('v.caseObj');
        caseObj.Status = 'Closed';
        component.set('v.disabled',true);
        component.set('v.caseObj',caseObj);
        helper.updateTicketInfo(component);
    },
    enableEscalate : function(component,event,helper){
        component.set('v.escalatePopUp',true);
    },
    cancelForm : function(component,event,helper){
        component.set('v.RecordId',undefined);
    },
    deptChange : function(component,event,helper){
        helper.deptChangeHelper(component)
    }

   
})