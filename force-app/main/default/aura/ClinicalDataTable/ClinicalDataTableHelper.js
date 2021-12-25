({
    getColumn : function(component) {
        component.set('v.columns', [
            {label: 'Content Name', fieldName: 'Name', type: 'text'},
            {label: 'Author', fieldName: 'Author__c', type: 'text'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date' , typeAttributes: { month: '2-digit', day: '2-digit', year : "numeric"}},
            {
                type:  'button',
                typeAttributes: 
                {
                  iconName: 'utility:edit',
                  label: 'Edit', 
                  name: 'editRecord', 
                  title: 'editTitle', 
                  disabled: false, 
                  value: 'test'
                }
              }          
        ]);
    },

    getData : function(component,helper){
        var action = component.get("c.GetClinicalQoutes");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
            }
        });
        $A.enqueueAction(action);
    }
})