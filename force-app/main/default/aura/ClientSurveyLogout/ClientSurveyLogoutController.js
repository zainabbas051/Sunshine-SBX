({
	Logout : function(component, event, helper) {
        var LoggedOutEvt = $A.get("e.c:ClientSurveyLoggedin");
                //set params
                LoggedOutEvt.setParams({"IsAuthenticated" : false});
                LoggedOutEvt.setParams({"SunshineCenter" : ""});
                component.set('v.IsAuthenticated',false);
                //fire event
               LoggedOutEvt.fire();
		
	},
    ShowSurveyListView : function(component, event, helper) {
	var ShowSurveyGridViewCmp = $A.get("e.c:ShowSurveyGridviewCmp_Event");
                //set params
                ShowSurveyGridViewCmp.setParams({"ShowSurveyGridviewCmp" : true});
               
                //fire event
               ShowSurveyGridViewCmp.fire();        
		
	},
    ShowCreateSurveyComponent : function(component, event, helper) {
        var ShowCreateSurveyCmp = $A.get("e.c:ShowCreateSurveyCmp_Event");
        debugger;
                //set params
                ShowCreateSurveyCmp.setParams({"ShowCreateSurveyCmp" : true});
               
                //fire event
               ShowCreateSurveyCmp.fire();
		
	},
    
     handleClientSurveyLoggein : function(cmp,event,helper){
        
        var IsAuthenticated = event.getParam("IsAuthenticated");
         var showLogout = event.getParam("showLogout");
        cmp.set('v.IsAuthenticated',IsAuthenticated);
         cmp.set('v.showLogoutBtn',showLogout);
         if(IsAuthenticated==false){
         var SatisfactionSurveyEvent = $A.get("e.c:ClientSatisfactionSurveyEvent_Invert");
                //set params
                SatisfactionSurveyEvent.setParams({"recordId" : null});
                cmp.set('v.SurveyId',null);
                //fire event
               SatisfactionSurveyEvent.fire();
         }
          
        
    }
})