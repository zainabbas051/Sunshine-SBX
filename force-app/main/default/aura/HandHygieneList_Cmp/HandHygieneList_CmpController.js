({
    init : function(component, event, helper) {

       	debugger;
        component.set('v.columns', [
            {label: 'Report Name', fieldName: 'linkName', type: 'url',
                typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            
            {label: 'Date-Time', fieldName: 'DateAndTime__c',type: 'date',
             typeAttributes:{day:'2-digit',month:'2-digit',year:'2-digit',
             hour:'2-digit',minute:'2-digit',second:'2-digit',hour12:true}},
            {label: 'Completed By', fieldName: 'Completed_By_Name__c', type: 'text'},
            {label: 'Staff Name', fieldName: 'Staff_Member_Observed__c', type: 'text'},
            {label: 'Sunshine Centre', fieldName: 'Sunshine_Center_Name__c', type: 'text'},
        ]);
       
        helper.getEmployeeSunshine(component)
        component.set("v.RecordId",undefined);

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