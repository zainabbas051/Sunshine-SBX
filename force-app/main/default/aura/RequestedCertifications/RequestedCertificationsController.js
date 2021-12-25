({
    
   
    doInit : function(component, event, helper) {
        helper.getColumn(component);
        helper.getData(component,helper);
    },
    
    UpdateData : function(component, event, helper) {
        helper.getColumn(component);
        helper.getData(component,helper);
    },
    clickNew : function(component,event,helper){
        component.set("v.selectedId" ,'');
        component.set('v.isNew',true);
    },
    onRowSelection : function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var row = event.getParam('row');
     

        //cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    handleRowAction : function(component,event,helper){
        debugger;
        var row = event.getSource().get('v.value');
        component.set("v.selectedId" ,row.Id);
        component.set("v.certificationId" ,row.Id);
        
         helper.cancelCertificationRequest(component,helper,row,event);
         //helper.getenableRequestBtn(component);
		 //helper.getData(component,helper);
       // alert(row.Id + 'row');
    }
    
   
})