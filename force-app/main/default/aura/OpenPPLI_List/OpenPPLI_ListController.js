({
    defaultAction : function(component, event, helper) {


        component.set('v.columns', [
            {label: 'Client Name', fieldName: 'ClientName', type: 'text'},
            //{label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View Details', name: 'view_details', title: 'Click to View Details'}},
            {label: 'Total Due', fieldName : 'TotalDue', type : 'currency'},
            {label: 'Name', fieldName: 'Name', type: 'date'},
            {label: 'Due Date', fieldName: 'DueDate', type: 'date'},
            {label: 'Amount', fieldName: 'Amount', type: 'currency'},
            //{label : 'Pay', fieldName:'Pay', type: 'url'},
            //{label: 'Pay', fieldName : 'Pay', type : 'button', initialWidth: 135},
            {label: 'Pay', type : 'button', initialWidth: 135,typeAttributes: { label: 'Pay', name: 'view_details', title: 'Click to Pay'}},
        ]);

        helper.getAllPPLIsUpdated(component);
        helper.expandAllRows(component, event);
    },
    expandAllRows : function(component, event, helper){
        helper.expandAllRows(component, event);
    },
    onChangeStatus : function(component, event, helper) {
        //debugger;
        helper.getPPLIsByFilter(component);
    },

    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        
        helper.manageDataPaging(component, event);
        //helper.getPPLIsByFilter(component);
        helper.expandAllRows(component, event);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        var pageSize = component.get("v.pageSize"); 
        var pagedData = component.get("v.pagedData");
        var newCalc = pageSize + pagedData.length;
        //if(pageNumber == 2)
           // newCalc  = pageSize *2;
        component.set("v.pageNumber", pageNumber-1);
        var recordCounter = component.get("v.recordCounter");
         
        recordCounter = recordCounter - newCalc;
        if(recordCounter < 0)
            recordCounter = 0;
        component.set("v.recordCounter",recordCounter);     
        helper.manageDataPaging(component, event);

        //helper.getPPLIsByFilter(component);
        helper.expandAllRows(component, event);
    },
    handleRowAction: function (component, event, helper) {
        //debugger;
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log('@Clie='+row.ClientId);
        switch (action.name) {
            case 'view_details':
                component.set('v.selectedRecordId',row.ClientId);
                break;
        }
    }
})