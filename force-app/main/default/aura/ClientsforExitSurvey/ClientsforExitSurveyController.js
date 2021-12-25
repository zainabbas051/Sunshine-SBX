({
	doInit : function(component, event, helper) {
		
        component.set('v.isLoading', true);
        helper.fetchData(component, event, helper);
          
         
	},
    
    create : function(component, event, helper) {
		
        
        ////////////////////////
		 var component_target = event.currentTarget;
        debugger;
        
        var arrayData = component_target.dataset.oppid;
        var index=component_target.dataset.oppid;
        var selectedOpp = component.get("v.ListOfOpportunity")[index];
        var OppID=selectedOpp.Id;
        var sunshineCenter =selectedOpp.Sunshine_Center_Name__c
        var ClientName= selectedOpp.Name;
        var ClientAdmissionDate=selectedOpp.CloseDate;
        var kipuPrimaryTherapist=selectedOpp.KIPU_Primary_Therapist__c;
        var kipuCaseManager=selectedOpp.KIPU_Case_Manager__c;
        var ClientEmail= selectedOpp.Email__c;
        var ClientPhone=selectedOpp.Phone__c;
        component.set("v.selectedOppID",OppID);
        component.set("v.selectedSunshineCenter",sunshineCenter);
        component.set("v.selectedOppName",ClientName);
        component.set("v.selectedCLientCloseDate",ClientAdmissionDate);
        component.set("v.selectedCLientEmail",ClientEmail);
        component.set("v.selectedCLientEmail",ClientPhone);
        component.set("v.selectedkipuPrimaryTherapist",kipuPrimaryTherapist);
        component.set("v.selectedkipuCaseManager",kipuCaseManager);
        helper.view(component,event,helper);
        

	},
    view : function(component,event,helper){
        
       
        var component_target = event.currentTarget;
   		var OppID = component_target.dataset.oppid;
        var sunshineCenter = component_target.dataset.sunshineCenter;
         var SatisfactionSurveyEvent = $A.get("e.c:ClientSatifaction_Event");
        //set params
        SatisfactionSurveyEvent.setParams({"recordId" : surveyRecord.Id,
                                           "OpportunityID" : OppID,
                                           "sunshineCenter" : sunshineCenter,
                                            "ReadOnly" : false,
                                           "returnCmp" : "create"
                                          
                                          });
		//fire event
        SatisfactionSurveyEvent.fire();
     /*   var action = component.get("c.GetLatestSurveyRecord");
        
        //Setting the Apex Parameter
        action.setParams({
          
            opportunityID : OppID
        });
        
        //Setting the Callback
       // var surveyRecord;
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            surveyRecord=a.getReturnValue();
            //check if result is successfull
            if(state == "SUCCESS"){
                //Reset Form
  			var readonly;
        if(surveyRecord.Status__c=='Open'){
            readonly=false
        }
        else
            readonly=true;      
                component.set("v.showCmp",false)
        //get event
        */
       
        
               
                
         //   } 
      //  });
        
		//adds the server-side action to the queue        
       // $A.enqueueAction(action);
        
    },
    handleShowHide : function(component, event, helper) {
		
        var show = event.getParam("ShowCreateSurveyCmp");
        component.set('v.showCmp', show);//get event
        if(show==true){
        component.set('v.isLoading', true);
        helper.fetchData(component, event, helper);
        var ShowSurveyGridViewCmp_Event = $A.get("e.c:ShowSurveyGridviewCmp_Event");
        //set params
        ShowSurveyGridViewCmp_Event.setParams({"ShowSurveyGridviewCmp" : false             
                                          });
		//fire event
        ShowSurveyGridViewCmp_Event.fire();
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
    handleApplicationEvent : function(cmp,event,helper){
        
           var recordId = event.getParam("recordId");
          var returnCmp = event.getParam("returnCmp");
        
         if(returnCmp=="create"){
        // cmp.set('v.SurveyId',null);
          cmp.set('v.SurveyId',null);
          cmp.set('v.isLoading', true);
          cmp.set('v.showCmp',true);
          helper.fetchData(cmp, event);
         }
        
    }
})