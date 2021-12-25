({
    
   
    doInit : function(component, event, helper) {
       // helper.getColumn(component);
        helper.getData(component,helper);
    },
    
    UpdateData : function(component, event, helper) {
       // helper.getColumn(component);
        helper.getData(component,helper);
    },
    clickNew : function(component,event,helper){
        component.set("v.selectedId" ,'');
        component.set('v.isNew',true);
    },
    showBulkAdd : function(component,event,helper){
 	debugger;
        component.set('v.isBulkAdd',true);
    },
    onRowSelection : function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var row = event.getParam('row');
        alert(row);

        //cmp.set('v.selectedRowsCount', selectedRows.length);
    },

    navigateToRecord : function(component,event,helper){
        debugger;
       // component.set('v.isBulkAdd',true);
        
       
        component.set('v.selectedEmployeeId',event.target.getAttribute('data-index'));

        component.set('v.isEmployeeRedirect',true);
       
    }
    
    
   
})