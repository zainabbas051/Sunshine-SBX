({
    
   

    getColumn : function(component) {

        var actions = [
           
            
        ];
        
        component.set('v.columns', [
			
            {label: 'Challenge Name', fieldName: 'Name', type: 'text'},
            {label: 'Type', fieldName: 'Type__c', type: 'text'},
            {label: 'Streak Duration', fieldName: 'Streak_Duration__c', type: 'text'} ,
            {label: 'Participants', fieldName: 'Participant__c', type: 'text'} ,
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
       debugger;
        var action = component.get("c.GetChallengesConfig");
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