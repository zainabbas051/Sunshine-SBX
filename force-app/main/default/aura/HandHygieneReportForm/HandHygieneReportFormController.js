({
    defaultAction : function(component, event, helper) {
     
         debugger;
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
 
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
 
            if (sParameterName[0] === 'Id') { //lets say you are looking for param name - firstName
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
                component.set('v.RecordId',sParameterName[1]);
           
            }
           
        }           
        debugger;
        if(component.get("v.RecordId") != undefined){
            helper.getRecordDetails(component);
            component.set("v.disabled",true);
        }
        
        component.set('v.showLoading',false);  
      
    },
    
   
    saveInc : function(component,event,helper){

        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

       
       
        if(allValid){
            helper.saveHandHygineReport(component);
        }
          
        
    },

    cancelForm  : function(component,event,helper){
       component.set('v.showForm',false);
       var pageURL=  decodeURIComponent(window.location);
        if(pageURL.search("certificationportalincident")>-1)
        {
            component.set('v.returntoMain',true);
          
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          'url': pageURL
        });
        urlEvent.fire();
        }         
         //$A.get('e.force:refreshView').fire();
    },
    
    returnMain  : function(component,event,helper){
       
       var pageURL=  decodeURIComponent(window.location);         
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          'url': pageURL
        });
        urlEvent.fire();
               
         //$A.get('e.force:refreshView').fire();
    },

    navigate : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
           'url': '../apex/handHygieneReportPDF_HTML?id=' + component.get('v.RecordId')
         });
         urlEvent.fire();
       }
    
})