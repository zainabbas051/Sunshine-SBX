({
	doInit : function(component, event, helper) {
		
        
         
	},
    
    select : function(component,event,helper){
        
       
        var component_target = event.currentTarget;
   		var attribute = component_target.dataset.myvalue;
        var status = component_target.dataset.myvalue2;
        var readonly;
        if(status=='Open'){
            readonly=false
        }
        else
            readonly=true;      
        //get event
        var SatisfactionSurveyEvent = $A.get("e.c:ClientSatifaction_Event");
        //set params
        SatisfactionSurveyEvent.setParams({"recordId" : attribute,
                                            "ReadOnly" : readonly,
                                            "returnCmp" : "view"
                                          
                                          });
        component.set('v.SurveyId',attribute);
		//fire event
        SatisfactionSurveyEvent.fire();
        
    },
     handleApplicationEvent : function(cmp,event,helper){
        
           var recordId = event.getParam("recordId");
          var returnCmp = event.getParam("returnCmp");
        
         if(returnCmp=="view"){
         cmp.set('v.SurveyId',null);
          cmp.set('v.isLoading', true);
          cmp.set('v.showCmp',true);
          helper.refreshData(cmp, event);
         }
        
    },
    handleClientSurveyLoggein : function(cmp,event,helper){
        
        var IsAuthenticated = event.getParam("IsAuthenticated");
        var sunshinecenter= event.getParam("SunshineCenter");
        cmp.set('v.IsAuthenticated',IsAuthenticated);
        cmp.set('v.SunshineCenter',sunshinecenter);
        cmp.set('v.isLoading', true);
        helper.fetchData(cmp, event, helper);
          
        
    },
    handleShowHideGridView : function(cmp,event,helper){

     var show = event.getParam("ShowSurveyGridviewCmp");
     
    
        cmp.set('v.showCmp',show);
        if(show==true){
        cmp.set('v.isLoading', true);
        helper.fetchData(cmp, event, helper);

        var ShowCreateSurveyCmp = $A.get("e.c:ShowCreateSurveyCmp_Event");
        //set params
        ShowCreateSurveyCmp.setParams({"ShowCreateSurveyCmp" : false             
                                          });
		//fire event
        ShowCreateSurveyCmp.fire();
        }
      
        
        

          
        
    }

})