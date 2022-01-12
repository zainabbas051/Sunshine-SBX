({
    init : function(component, event, helper) {

       	debugger;
        component.set('v.columns', [
            {label: 'Report Name', fieldName: 'linkName', type: 'url',
                typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'Date of Symptoms Identified', fieldName: 'Date_Identified_Formula__c', type: 'date',sortable:true},
            {label: 'Completed By', fieldName: 'Completed_By_Name__c', type: 'text'},
            {label: 'Client/Staff Name', fieldName: 'Client_Name__c', type: 'text'},
            {label: 'Sunshine Centre', fieldName: 'Sunshine_Center_Name__c', type: 'text'},
        ]);
       
        helper.getEmployeeSunshine(component)
        component.set("v.RecordId",undefined);

    },

    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    },

    showForm : function(component,event,helper){
        debugger;
            component.set('v.showFormPL',true);
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        debugger;
        switch (action.name) {
            case 'show_details':
                component.set("v.RecordId",row.Id);
                component.set("v.showForm",true);
                break;
        }
    },
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getAllData(component);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getAllData(component);
    },
    doSearch : function(component,event,helper){
        component.set("v.pageNumber", 1);
        helper.getSearchDate(component);
    },
    doReset : function(component,event,helper){

        component.set("v.maxDate", null);
        component.set("v.minDate", null);

        if(component.get("v.sunshineEnabled")){
            component.set("v.selectedSunshine", 'All');
        } 
        component.set("v.pageNumber", 1);
        helper.getAllData(component);
    }
})