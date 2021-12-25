({
	doInit : function(component, event, helper) {
		
        debugger;
        component.set('v.isLoading', true);
        helper.fetchData(component, event, helper);
          
         
    },
    
    openModal : function(component,event,helper){

        component.set('v.errorMessage','');
        component.set('v.showModal',true);
        debugger;
        var arrayData = event.currentTarget.dataset.oppid;
        var arr = arrayData.split(',');
        var todayDate = new Date();
        var diffTime = Math.abs(todayDate - new Date(arr[5]));
        var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
        if(diffDays > 3)
        {
            arr[4] = false;
            
        }
      
        component.set('v.addmittedPresent',arr[4]);
        component.set("v.selectedOppID",arr[0]);
        component.set("v.selectedSunshineCenter",arr[1]);
        component.set("v.selectedOppName",arr[2]);
        component.set("v.selectedCLientCloseDate",arr[3]);
        component.set("v.isbiWeeklySurveyCreated",arr[6]);
        
       

    },

    closeModel : function(component,event,helper){
        component.set('v.showModal',false);
    },
    
    create : function(component, event, helper) {
		
        
        ////////////////////////
		/*var component_target = event.currentTarget;
        debugger;
        var arrayData = component_target.dataset.oppid;
        var arr = arrayData.split(',');
 
        var OppID=arr[0];
        var sunshineCenter = arr[1];
        var ClientName= arr[2];
        var ClientAdmissionDate=arr[3];
        var isWeeklySurveyCreated=arr[6];
   
        component.set("v.selectedOppID",OppID);
        component.set("v.selectedSunshineCenter",sunshineCenter);
        component.set("v.selectedOppName",ClientName);
        component.set("v.selectedCLientCloseDate",ClientAdmissionDate);*/
		var OCSType=component.get('v.SelectedStage');
         component.set("v.errorMessage", '');
        var biWeeklyCreated= component.get('v.isbiWeeklySurveyCreated');
        debugger;
        if(OCSType == ''){
            
                component.set("v.errorMessage", 'Please select');
                return;
        }
        
        
        if(OCSType=="Bi-Weekly")
        {
  
        var AdmittedDated = new Date(component.get("v.selectedCLientCloseDate"));   
           
       
        var todayDate = new Date();
        var diffTime = Math.abs(todayDate - new Date(AdmittedDated));
        var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));     
        var noOfRecs= Math.floor(diffDays/14);
           
        var dueDate= new Date(AdmittedDated);
     	
            
            if(noOfRecs==0){
                component.set('v.showModal',false);
                dueDate.setDate(dueDate.getDate() + ((noOfRecs+1)*14));
                
                 try{
                   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Bi-Weekly Outcome survey will be due on: '+dueDate.toLocaleDateString("en-US"),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'Error',
                    mode: 'pester'
                });
        		toastEvent.fire();
        }
      catch(err)
    {
    alert("Bi-Weekly Outcome survey will be due on: "+dueDate.toLocaleDateString("en-US"));
	}
            return;
            }
           
            if(noOfRecs>0){
                var nextDueDate= new Date(AdmittedDated);
                nextDueDate.setDate(nextDueDate.getDate() + ((noOfRecs+1)*14));
                dueDate.setDate(dueDate.getDate() + ((noOfRecs)*14));
                 var exceededTime = Math.abs(todayDate - new Date(dueDate));
        	     var exceededDays = Math.ceil(exceededTime / (1000 * 60 * 60 * 24)); 
                
                if(exceededDays>3 || biWeeklyCreated=='true' ){
                    component.set('v.showModal',false);
                 try{
                   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'You Cannot Create Bi-Weekly Outcome Survey Until Next Due Date:'+nextDueDate.toLocaleDateString("en-US"),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'Error',
                    mode: 'pester'
                });
        		toastEvent.fire();
        }
      catch(err)
    {
    alert("You Cannot Create Bi-Weekly Outcome Survey Until Next Due Date:"+nextDueDate.toLocaleDateString("en-US"));
	}
            return;
                }
                else if(exceededDays<=3 )
                {
                   
                    helper.view(component,event,helper);
                    component.set('v.showModal',false);
                    
                }
                
            }
        }
        else{
        helper.view(component,event,helper);
        component.set('v.showModal',false);    
            
        }
        

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
         cmp.set('v.SurveyId',null);
          cmp.set('v.isLoading', true);
          cmp.set('v.showCmp',true);
          helper.fetchData(cmp, event);
         }
        
    }
})