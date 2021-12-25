({
	saveCardInformation : function(component){
		debugger;
        var action = component.get("c.saveCardInformation");
        var CardInformationObj = component.get("v.CardInformationObj");
       
		action.setParams({
            //incJsonStr: JSON.stringify(incidentObj)
            cardObj: CardInformationObj
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "message": "Report has been created Successfully",
                    "variant": "Success"
                });
               // component.set('v.showForm',false);
               // component.set("v.disabled",true);
                
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    }
})