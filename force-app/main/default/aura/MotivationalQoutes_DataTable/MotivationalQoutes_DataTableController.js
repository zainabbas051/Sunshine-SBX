({
    doInit : function(component, event, helper) {
        helper.getColumn(component);
        helper.getData(component,helper);
    },
    
    clickNew : function(component,event,helper){
        component.set('v.isNew',true);
    },
    handleRowAction : function(component,event){
        var row = event.getParam('row');
        component.set("v.selectedId" ,row.Id)
        component.set('v.isNew',true);

       // alert(row.Id + 'row');
    }
})