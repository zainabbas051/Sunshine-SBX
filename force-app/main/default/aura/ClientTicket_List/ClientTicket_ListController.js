({
    defaultAction : function(component, event, helper) {


        component.set('v.columns', [
            {label: 'Case Number', fieldName: 'CaseNumber', type: 'text'},
            {label: 'Subject', fieldName: 'Subject', type: 'text'},
            {label: 'Status', fieldName: 'Status', type: 'text'},
            {label: 'Is Escalated', fieldName: 'Escalated__c', type: 'boolean'},
            {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View Details', name: 'view_details', title: 'Click to View Details'}},
        ]);

        helper.getAllCases(component)
    },

    onChangeStatus : function(component, event, helper) {
        debugger;
        helper.getCasesByFilter(component);
    },

    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getCasesByFilter(component);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getCasesByFilter(component);
    },
    handleRowAction: function (component, event, helper) {
        debugger;
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'view_details':
                component.set('v.selectedRecordId',row.Id);
                break;
        }
    }
})