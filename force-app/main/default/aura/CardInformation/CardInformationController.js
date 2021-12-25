({
	saveCardInformation : function(component,event,helper){
	helper.saveCardInformation(component);
       /* var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

       
       
        if(allValid){
            helper.saveCardInformation(component);
        }*/
          
        
    },
     cancelForm  : function(component,event,helper){
       //component.set('v.showForm',false);
       /*var pageURL=  decodeURIComponent(window.location);
        if(pageURL.search("certificationportalincident")>-1)
        {
            component.set('v.returntoMain',true);
          
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          'url': pageURL
        });
        urlEvent.fire();
        } 
         */
         $A.get('e.force:refreshView').fire();
    }
})