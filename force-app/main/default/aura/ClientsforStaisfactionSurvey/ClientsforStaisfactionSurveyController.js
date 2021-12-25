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
        var surveyCount;
        
        if(selectedOpp.Client_Satisfaction_Surveys__r==null)
            surveyCount=0;
        else
        surveyCount=selectedOpp.Client_Satisfaction_Surveys__r.length;
        debugger;
        var surveyNumber=surveyCount+1;
        component.set("v.surveyNumber",surveyNumber)
         if(surveyNumber % 2 == 0)
            component.set("v.isEven",true)
        
      
        
        var sunshineCenter =selectedOpp.Sunshine_Center_Name__c
        var kipuPrimaryTherapist=selectedOpp.KIPU_Primary_Therapist__c;
        var kipuCaseManager=selectedOpp.KIPU_Case_Manager__c;
        component.set("v.selectedOppID",OppID);
        component.set("v.selectedSunshineCenter",sunshineCenter);
        component.set("v.selectedKIPUPrimaryTherapist",kipuPrimaryTherapist);
        component.set("v.selectedKIPUCaseManager",kipuCaseManager);
        
       
    /*   //Calling the Apex Function
        var action = component.get("c.createRecord");
          var toastEvent = $A.get("e.force:showToast");
        //Setting the Apex Parameter
        action.setParams({
          
            OpportunityID : OppID
        });
        
        //Setting the Callback
        //
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                //Reset Form
          alert("The Survey form has been created.")
    		  
  
                
            } 
        });
        
		//adds the server-side action to the queue        
        $A.enqueueAction(action); */
        helper.view(component,event,helper);
        

	},
    view : function(component,event,helper){
        debugger;
       
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
        
        debugger;
        var IsAuthenticated = event.getParam("IsAuthenticated");
        var sunshinecenter= event.getParam("SunshineCenter");
        cmp.set('v.IsAuthenticated',IsAuthenticated);
        cmp.set('v.SunshineCenter',sunshinecenter);
        cmp.set('v.isLoading', true);
        helper.fetchData(cmp, event, helper);
          
        
    },
    handleApplicationEvent : function(cmp,event,helper){
        debugger;
          // var recordId = event.getParam("recordId");
          var returnCmp = event.getParam("returnCmp");
         if(returnCmp=="create"){
        // cmp.set('v.SurveyId',null);
          cmp.set('v.isLoading', true);
          cmp.set('v.showCmp',true);
          helper.fetchData(cmp, event);
         }
        
    }
})