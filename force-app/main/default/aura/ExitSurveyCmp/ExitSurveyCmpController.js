({
    doInit: function(component, event, helper) {
		component.set("v.ClientExitSurveyObj",{'sobjectType': 'Client_Exit_Surveys__c',
                                                   });
         component.set("v.ClientOutcomeSurveyObj", {
            'sobjectType': 'Client_Outcome_Survey__c',
        });
        
        
    },
	
    
    save : function(component, event, helper) {
		
        ////////////////////////
      debugger;
        component.set('v.isLoading', true);
        var survey = component.get('v.ClientExitSurveyObj');
        
        survey.Client_Name__c=component.get('v.clientName');
        survey.Admission_Date__c=component.get('v.clientAdmissionDate');
        survey.Best_Email_Address_to_Reach_You__c=component.get('v.clientEmail');
        survey.Best_Phone_Number_to_Reach_You__c=component.get('v.clientPhone');
      
        var oppID = component.get('v.oppID');
        var blankAnswers="";
        var IsValid=true;
        var sunshineCenter= component.get("v.AccountType");
        var OutComeSurvey = component.get('v.ClientOutcomeSurveyObj');
 		OutComeSurvey.RAS_R_Enabled_Outcome_Survey__c=true;
        var childCmp = component.find("outcomeComp");
        /////Validation/////

       if($A.util.isEmpty(survey.Pre_Admission_Experience__c) || $A.util.isUndefined(survey.Pre_Admission_Experience__c)){
           blankAnswers+="\nQuestion 1"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Intake_Process__c) || $A.util.isUndefined(survey.Intake_Process__c)){
           blankAnswers+="\nQuestion 2"; 
           IsValid=false;
            
        }
         if($A.util.isEmpty(survey.Detox_Physician__c) || $A.util.isUndefined(survey.Detox_Physician__c)){
           blankAnswers+="\nQuestion 3"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Individual_Therapy__c) || $A.util.isUndefined(survey.Individual_Therapy__c)){
           blankAnswers+="\nQuestion 4"; 
           IsValid=false;
            
        }
         if($A.util.isEmpty(survey.Individual_Therapy_primary_Issues__c) || $A.util.isUndefined(survey.Individual_Therapy_primary_Issues__c)){
           blankAnswers+="\nQuestion 4a"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Individual_Therapy_primary_therapist__c) || $A.util.isUndefined(survey.Individual_Therapy_primary_therapist__c)){
           blankAnswers+="\nQuestion 4c"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Group_Therapy__c) || $A.util.isUndefined(survey.Group_Therapy__c)){
           blankAnswers+="\nQuestion 5"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Group_Therapy_Enjoyment__c) || $A.util.isUndefined(survey.Group_Therapy_Enjoyment__c)){
           blankAnswers+="\nQuestion 5c"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Case_Management__c) || $A.util.isUndefined(survey.Case_Management__c)){
           blankAnswers+="\nQuestion 6"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Case_Management_education_prim_issues__c) || $A.util.isUndefined(survey.Case_Management_education_prim_issues__c)){
           blankAnswers+="\nQuestion 6a"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Case_Management_Manager_Name__c) || $A.util.isUndefined(survey.Case_Management_Manager_Name__c)){
           if(sunshineCenter!='Willowsprings Recovery')
           {
           blankAnswers+="\nQuestion 6d"; 
           IsValid=false;
           }
            
        }
        
         if($A.util.isEmpty(survey.Food__c) || $A.util.isUndefined(survey.Food__c)){
           blankAnswers+="\nQuestion 7"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Facilities__c) || $A.util.isUndefined(survey.Facilities__c)){
           blankAnswers+="\nQuestion 8"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Gym__c) || $A.util.isUndefined(survey.Gym__c)){
           blankAnswers+="\nQuestion 9"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Support_Meetings__c) || $A.util.isUndefined(survey.Support_Meetings__c)){
           blankAnswers+="\nQuestion 10"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Client_Advisors__c) || $A.util.isUndefined(survey.Client_Advisors__c)){
           blankAnswers+="\nQuestion 11"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Client_Advisors_Fvt_Staff_Member_Name__c) || $A.util.isUndefined(survey.Client_Advisors_Fvt_Staff_Member_Name__c)){
           blankAnswers+="\nQuestion 11a"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.Outings__c) || $A.util.isUndefined(survey.Outings__c)){
           blankAnswers+="\nQuestion 12"; 
           IsValid=false;
            
        }
        if($A.util.isEmpty(survey.refer_Monarch_Shores_to_a_loved_ones__c) || $A.util.isUndefined(survey.refer_Monarch_Shores_to_a_loved_ones__c)){
           blankAnswers+="\nQuestion 13"; 
           IsValid=false;
            
        }
        
         ////////////////////for 2nd form Validation/////////////

    if ($A.util.isEmpty(OutComeSurvey.Feeling_nervous_anxious_or_on_edge__c) || $A.util.isUndefined(OutComeSurvey.Feeling_nervous_anxious_or_on_edge__c)) {
        blankAnswers += "\nGAD Question 1";
        IsValid = false;

     }
     if ($A.util.isEmpty(OutComeSurvey.Not_being_able_to_sleep_or_control_worry__c) || $A.util.isUndefined(OutComeSurvey.Not_being_able_to_sleep_or_control_worry__c)) {
        blankAnswers += "\nGAD Question 2";
        IsValid = false;

     }

     if ($A.util.isEmpty(OutComeSurvey.Worrying_too_much_about_different_thing__c) || $A.util.isUndefined(OutComeSurvey.Worrying_too_much_about_different_thing__c)) {
        blankAnswers += "\nGAD Question 3";
        IsValid = false;

     }

     if ($A.util.isEmpty(OutComeSurvey.Trouble_relaxing__c) || $A.util.isUndefined(OutComeSurvey.Trouble_relaxing__c)) {
        blankAnswers += "\nGAD Question 4";
        IsValid = false;

     }
     if ($A.util.isEmpty(OutComeSurvey.Being_so_restless_that_it_is_hard_to_sit__c) || $A.util.isUndefined(OutComeSurvey.Being_so_restless_that_it_is_hard_to_sit__c)) {
        blankAnswers += "\nGAD Question 5";
        IsValid = false;

     }
     if ($A.util.isEmpty(OutComeSurvey.Becoming_easily_annoyed_or_irritable__c) || $A.util.isUndefined(OutComeSurvey.Becoming_easily_annoyed_or_irritable__c)) {
        blankAnswers += "\nGAD Question 6";
        IsValid = false;

     }

     if ($A.util.isEmpty(OutComeSurvey.feeling_afraid_asif_something_awful_will__c) || $A.util.isUndefined(OutComeSurvey.feeling_afraid_asif_something_awful_will__c)) {
        blankAnswers += "\nGAD Question 7";
        IsValid = false;

     }

     if ($A.util.isEmpty(OutComeSurvey.Little_interest_pleasure_in_doing_things__c) || $A.util.isUndefined(OutComeSurvey.Little_interest_pleasure_in_doing_things__c)) {
        blankAnswers += "\nPHQ Question 1";
        IsValid = false;

     }

     if ($A.util.isEmpty(OutComeSurvey.Feeling_down_depressed_or_hopeless__c) || $A.util.isUndefined(OutComeSurvey.Feeling_down_depressed_or_hopeless__c)) {
        blankAnswers += "\nPHQ Question 2";
        IsValid = false;

     }


     if ($A.util.isEmpty(OutComeSurvey.Trouble_falling_or_staying_asleep__c) || $A.util.isUndefined(OutComeSurvey.Trouble_falling_or_staying_asleep__c)) {
        blankAnswers += "\nPHQ Question 3";
        IsValid = false;

     }

     if ($A.util.isEmpty(OutComeSurvey.Feeling_tired_or_having_little_energy__c) || $A.util.isUndefined(OutComeSurvey.Feeling_tired_or_having_little_energy__c)) {
        blankAnswers += "\nPHQ Question 4";
        IsValid = false;

     }

     if ($A.util.isEmpty(OutComeSurvey.Poor_appetite_or_overeating__c) || $A.util.isUndefined(OutComeSurvey.Poor_appetite_or_overeating__c)) {
        blankAnswers += "\nPHQ Question 5";
        IsValid = false;

     }
     if ($A.util.isEmpty(OutComeSurvey.Feeling_bad_about_yourself_or_faliure__c) || $A.util.isUndefined(OutComeSurvey.Feeling_bad_about_yourself_or_faliure__c)) {
        blankAnswers += "\nPHQ Question 6";
        IsValid = false;

     }
     if ($A.util.isEmpty(OutComeSurvey.Trouble_concentrating_on_things__c) || $A.util.isUndefined(OutComeSurvey.Trouble_concentrating_on_things__c)) {
        blankAnswers += "\nPHQ Question 7";
        IsValid = false;

     }

     if ($A.util.isEmpty(OutComeSurvey.Moving_or_speaking_so_slowly__c) || $A.util.isUndefined(OutComeSurvey.Moving_or_speaking_so_slowly__c)) {
        blankAnswers += "\nPHQ Question 8";
        IsValid = false;

     }
     if ($A.util.isEmpty(OutComeSurvey.Thoughts_that_you_would_be_betteroff_ded__c) || $A.util.isUndefined(OutComeSurvey.Thoughts_that_you_would_be_betteroff_ded__c)) {
        blankAnswers += "\nPHQ Question 9";
        IsValid = false;

     }
     if ($A.util.isEmpty(OutComeSurvey.If_you_checkedoff_any_problem_previously__c) || $A.util.isUndefined(OutComeSurvey.If_you_checkedoff_any_problem_previously__c)) {
        blankAnswers += "\nPHQ Question 10";
        IsValid = false;

     }
        
      if ($A.util.isEmpty(OutComeSurvey.I_have_a_desire_to_succeed__c) || $A.util.isUndefined(OutComeSurvey.I_have_a_desire_to_succeed__c)) {
         blankAnswers += "\nRAS Question 1";
         IsValid = false;

      }

      if ($A.util.isEmpty(OutComeSurvey.I_have_my_own_plan_for_how_to_stay_well__c) || $A.util.isUndefined(OutComeSurvey.I_have_my_own_plan_for_how_to_stay_well__c)) {
         blankAnswers += "\nRAS Question 2";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_have_goals_in_life_that_I_want_to_get__c) || $A.util.isUndefined(OutComeSurvey.I_have_goals_in_life_that_I_want_to_get__c)) {
         blankAnswers += "\nRAS Question 3";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_believe_I_can_meet_my_current_goals__c) || $A.util.isUndefined(OutComeSurvey.I_believe_I_can_meet_my_current_goals__c)) {
         blankAnswers += "\nRAS Question 4";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_have_a_purpose_in_life__c) || $A.util.isUndefined(OutComeSurvey.I_have_a_purpose_in_life__c)) {
         blankAnswers += "\nRAS Question 5";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.when_I_don_t_care_about_myself_other_do__c) || $A.util.isUndefined(OutComeSurvey.when_I_don_t_care_about_myself_other_do__c)) {
         blankAnswers += "\nRAS Question 6";
         IsValid = false;

      }
     

     
      if ($A.util.isEmpty(OutComeSurvey.Fear_doesn_t_stop_me_from_living__c) || $A.util.isUndefined(OutComeSurvey.Fear_doesn_t_stop_me_from_living__c)) {
         blankAnswers += "\nRAS Question 7";
         IsValid = false;

      }

      
      if ($A.util.isEmpty(OutComeSurvey.I_can_handle_what_happens_in_my_life__c) || $A.util.isUndefined(OutComeSurvey.I_can_handle_what_happens_in_my_life__c)) {
         blankAnswers += "\nRAS Question 8";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_like_myself__c) || $A.util.isUndefined(OutComeSurvey.I_like_myself__c)) {
         blankAnswers += "\nRAS Question 9";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.If_people_really_knew_me_they_would_like__c) || $A.util.isUndefined(OutComeSurvey.If_people_really_knew_me_they_would_like__c)) {
         blankAnswers += "\nRAS Question 10";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_have_an_idea_of_who_I_want_to_become__c) || $A.util.isUndefined(OutComeSurvey.I_have_an_idea_of_who_I_want_to_become__c)) {
         blankAnswers += "\nRAS Question 11";
         IsValid = false;

      }

      
      if ($A.util.isEmpty(OutComeSurvey.Something_good_will_eventually_happen__c) || $A.util.isUndefined(OutComeSurvey.Something_good_will_eventually_happen__c)) {
         blankAnswers += "\nRAS Question 12";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_m_hopeful_about_my_future__c) || $A.util.isUndefined(OutComeSurvey.I_m_hopeful_about_my_future__c)) {
         blankAnswers += "\nRAS Question 13";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_continue_to_have_new_interests__c) || $A.util.isUndefined(OutComeSurvey.I_continue_to_have_new_interests__c)) {
         blankAnswers += "\nRAS Question 14";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.Coping_with_my_mental_illness__c) || $A.util.isUndefined(OutComeSurvey.Coping_with_my_mental_illness__c)) {
         blankAnswers += "\nRAS Question 15";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.My_symptoms_interfere_less_with_my_life__c) || $A.util.isUndefined(OutComeSurvey.My_symptoms_interfere_less_with_my_life__c)) {
         blankAnswers += "\nRAS Question 16";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.My_symptoms_seem_to_be_a_problem__c) || $A.util.isUndefined(OutComeSurvey.My_symptoms_seem_to_be_a_problem__c)) {
         blankAnswers += "\nRAS Question 17";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_know_when_to_ask_for_help__c) || $A.util.isUndefined(OutComeSurvey.I_know_when_to_ask_for_help__c)) {
         blankAnswers += "\nRAS Question 18";
         IsValid = false;

      }

      if ($A.util.isEmpty(OutComeSurvey.I_am_willing_to_ask_for_help__c) || $A.util.isUndefined(OutComeSurvey.I_am_willing_to_ask_for_help__c)) {
         blankAnswers += "\nRAS Question 19";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_ask_for_help_when_I_need_it__c) || $A.util.isUndefined(OutComeSurvey.I_ask_for_help_when_I_need_it__c)) {
         blankAnswers += "\nRAS Question 20";
         IsValid = false;

      }

      
      if ($A.util.isEmpty(OutComeSurvey.I_can_handle_stress__c) || $A.util.isUndefined(OutComeSurvey.I_can_handle_stress__c)) {
         blankAnswers += "\nRAS Question 21";
         IsValid = false;

      }
      if ($A.util.isEmpty(OutComeSurvey.I_have_people_I_can_count_on__c) || $A.util.isUndefined(OutComeSurvey.I_have_people_I_can_count_on__c)) {
         blankAnswers += "\nRAS Question 22";
         IsValid = false;

      }
      
      if ($A.util.isEmpty(OutComeSurvey.Even_when_I_don_t_believe_in_myself__c) || $A.util.isUndefined(OutComeSurvey.Even_when_I_don_t_believe_in_myself__c)) {
         blankAnswers += "\nRAS Question 23";
         IsValid = false;

      }
debugger;
      
       if ($A.util.isEmpty(OutComeSurvey.It_is_important_to_have_variety_of_frind__c) || $A.util.isUndefined(OutComeSurvey.It_is_important_to_have_variety_of_frind__c)) {
         blankAnswers += "\nRAS Question 24";
         IsValid = false;

      }
        
        if (survey.Interested_in_Alumni_Program__c==='Yes' && $A.util.isEmpty(survey.How_to_connect_for_alumni_program__c)) {
         blankAnswers += "\nHow to connect for alumni program";
         IsValid = false;

      }
        if (survey.Interested_in_Alumni_Program__c==='Yes' && survey.How_to_connect_for_alumni_program__c=='Email' && $A.util.isEmpty(survey.Best_Email_Address_to_Reach_You__c)) {
         blankAnswers += "\nBest Email Address to Reach You?";
         IsValid = false;

      }

         if (survey.Interested_in_Alumni_Program__c==='Yes' && survey.How_to_connect_for_alumni_program__c=='Phone' && $A.util.isEmpty(survey.Best_Phone_Number_to_Reach_You__c)) {
         blankAnswers += "\nBest Phone Number to Reach You?";
         IsValid = false;

      }


        
       if(IsValid==false && blankAnswers!="")
        {
            
            try{
                   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Please Select an Option for: ' + blankAnswers,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'Error',
                    mode: 'pester'
                });
        		toastEvent.fire();
        }
      catch(err)
    {
    alert('Please Select an Option for: ' + blankAnswers);
}
           component.set('v.isLoading', false);
            return;
        }
      
        //Calling the Apex Function
        var   Hybrideaction= component.get("c.saveHybrideRecord");
     Hybrideaction.setParams({

            ClientExitSurveyParam: survey,
            ClientOutcomeSurveyParam: OutComeSurvey,
            oppID: oppID
        });
        //Setting the Callback
        Hybrideaction.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                //Reset Form
               
               //	 component.set("v.ClientSatisfactionObj",survey);
            try{	
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'The survey form has been saved',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
        		toastEvent.fire();
    }
    catch(err)
    {
    alert('The survey form has been saved');
}
              //  alert('The Survey form has been submitted');
                 var SatisfactionSurveyEvent = $A.get("e.c:ShowExitSurvey_Event_Invert");
                //set params
                SatisfactionSurveyEvent.setParams({"recordId" : null,
                                                   "returnCmp" : "create"});
                component.set('v.oppID',null);
                //fire event
               SatisfactionSurveyEvent.fire();
                
            } 
             component.set("v.isLoading", false);
        });
        
		//adds the server-side action to the queue        
        $A.enqueueAction(Hybrideaction);
        

	},

    handleChange: function (cmp, event) {
        var changeValue = event.getParam("value");

    },
    
    handleApplicationEvent : function(component,event){
        
         var recordId = event.getParam("recordId");
         var readOnly= event.getParam("ReadOnly");
         var returnCmp= event.getParam("returnCmp");
         var oppID= event.getParam("OpportunityID");  
         var sunshineCenter= event.getParam("sunshineCenter");  
        var ClientName=event.getParam("OpportunityName"); 
        var ClientAdmissionDate=event.getParam("OpportunityAdmissionDate");
        var ClientEmail=event.getParam("Email");
        var ClientPhone=event.getParam("Phone");
         component.set('v.SurveyId',recordId);
         component.set('v.oppID',oppID);
        component.set('v.clientName',ClientName);
        component.set('v.clientAdmissionDate',ClientAdmissionDate);
        component.set('v.clientEmail',ClientEmail);
        component.set('v.clientPhone',ClientPhone);
        component.set('v.IsReadOnly',readOnly);
       	component.set('v.returnCmp',returnCmp);
        component.set("v.AccountType",sunshineCenter);
        component.set("v.ClientExitSurveyObj",{'sobjectType': 'Client_Exit_Surveys__c',
                                                   });
        component.set("v.ClientOutcomeSurveyObj", {
            'sobjectType': 'Client_Outcome_Survey__c',
        });
               var returnCmp=component.get('v.returnCmp');
               

    },
        
    handleApplicationEventInvert: function(cmp,event,helper){
        
        var IsAuthenticated = event.getParam("IsAuthenticated");
       // cmp.set('v.SurveyId',null);
        
    },
    back : function(component, event, helper) {
         var SatisfactionSurveyEvent = $A.get("e.c:ShowExitSurvey_Event_Invert");
        var returnCmp=component.get('v.returnCmp');
                //set params
             
                SatisfactionSurveyEvent.setParams({"recordId" : null,
                                                   "returnCmp" : returnCmp
                                                  });
                component.set('v.oppID',null);
                //fire event
               SatisfactionSurveyEvent.fire();
    },
     handleShowHide : function(component, event, helper) {
		
      
      //  component.set('v.SurveyId', null);//get event
        
   
	}
});