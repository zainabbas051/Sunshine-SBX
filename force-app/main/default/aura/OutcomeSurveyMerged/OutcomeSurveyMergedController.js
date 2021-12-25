({
   doInit: function (component, event, helper) {
      component.set("v.ClientOutcomeSurveyObj", {
         'sobjectType': 'Client_Outcome_Survey__c',
      });


   },

   GADQuestionButtonGroupHandler: function (component, event, helper) {
      debugger;
      component.set('v.TotalGADScore', 0);
      helper.SetGADQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Feeling_nervous_anxious_or_on_edge__c"), component);
      helper.SetGADQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Not_being_able_to_sleep_or_control_worry__c"), component);
      helper.SetGADQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Worrying_too_much_about_different_thing__c"), component);
      helper.SetGADQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Trouble_relaxing__c"), component);
      helper.SetGADQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Being_so_restless_that_it_is_hard_to_sit__c"), component);
      helper.SetGADQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Becoming_easily_annoyed_or_irritable__c"), component);
      helper.SetGADQuestionNumber(component.get("v.ClientOutcomeSurveyObj.feeling_afraid_asif_something_awful_will__c"), component);
   },

   PHQQuestionButtonGroupHandler: function (component, event, helper) {
      component.set('v.TotalPHQScore', 0);

      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Little_interest_pleasure_in_doing_things__c"), component);
      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Feeling_down_depressed_or_hopeless__c"), component);
      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Trouble_falling_or_staying_asleep__c"), component);
      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Feeling_tired_or_having_little_energy__c"), component);
      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Poor_appetite_or_overeating__c"), component);
      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Feeling_bad_about_yourself_or_faliure__c"), component);
      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Trouble_concentrating_on_things__c"), component);
      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Moving_or_speaking_so_slowly__c"), component);
      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Thoughts_that_you_would_be_betteroff_ded__c"), component);
      helper.SetPHQQuestionNumber(component.get("v.ClientOutcomeSurveyObj.If_you_checkedoff_any_problem_previously__c"), component);
   },
   RASQuestionButtonGroupHandler: function (component, event, helper) {
      component.set('v.TotalRASScore', 0);

      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_have_a_desire_to_succeed__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_have_my_own_plan_for_how_to_stay_well__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_have_goals_in_life_that_I_want_to_get__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_believe_I_can_meet_my_current_goals__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_have_a_purpose_in_life__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.when_I_don_t_care_about_myself_other_do__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_understand_how_to_control_my_symptoms__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_can_handle_it_if_I_get_sick_again__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_can_identify_what_triggers_my_symptoms__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_can_help_myself_become_better__c"), component);

      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Fear_doesn_t_stop_me_from_living__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_know_that_there_are_mental_health_srvc__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.There_are_things_that_I_can_do_that_help__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_can_handle_what_happens_in_my_life__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_like_myself__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.If_people_really_knew_me_they_would_like__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_am_a_better_person_than_before__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Although_my_symptoms_may_get_worse__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.If_I_keep_trying_I_will_get_better__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_have_an_idea_of_who_I_want_to_become__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Things_happen_for_a_reason__c"), component);

      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Something_good_will_eventually_happen__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_am_the_person_most_responsible__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_m_hopeful_about_my_future__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_continue_to_have_new_interests__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.It_is_important_to_have_fun__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Coping_with_my_mental_illness__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.My_symptoms_interfere_less_with_my_life__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.My_symptoms_seem_to_be_a_problem__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_know_when_to_ask_for_help__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_am_willing_to_ask_for_help__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_ask_for_help_when_I_need_it__c"), component);

      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Being_able_to_work_is_important_to_me__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_know_what_helps_me_get_better__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_can_learn_from_my_mistakes__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_can_handle_stress__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_have_people_I_can_count_on__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.I_can_identify_the_early_warning_signs__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.Even_when_I_don_t_believe_in_myself__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.It_is_important_to_have_variety_of_frind__c"), component);
      helper.SetRASQuestionNumber(component.get("v.ClientOutcomeSurveyObj.It_is_important_to_have_healthy_habits__c"), component);


   },
   setAttribute: function (cmp, event) {
      debugger;
      var params = event.getParam('arguments');
      if (params) {
         //   var oppID = params.OppId;
         //  cmp.set('v.oppID', oppID);            
         // add your code here
      }

   },

   save: function (component, event, helper) {

      ////////////////////////
      debugger;
      var oppID;
      var survey = component.get('v.ClientOutcomeSurveyObj');
      survey.Client_Name__c = component.get('v.clientName');
      survey.Admission_Date__c = component.get('v.clientAdmissionDate');
      survey.Total_GAD_Score__c = component.get('v.TotalGADScore');
      survey.Total_PHQ_Score__c = component.get('v.TotalPHQScore');
      survey.Total_RAS_Score__c = component.get('v.TotalRASScore');
      survey.Type__c=='Bi-Weekly';
      component.set('v.ClientOutcomeSurveyObj',survey);
      var params = event.getParam('arguments');
      if (params) {
         oppID = params.OppId;
      }

      debugger;
      var blankAnswers = "";
      var IsValid = true;
      /////Validation Start/////

      if ($A.util.isEmpty(survey.Feeling_nervous_anxious_or_on_edge__c) || $A.util.isUndefined(survey.Feeling_nervous_anxious_or_on_edge__c)) {
         blankAnswers += "\nGAD Question 1";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.Not_being_able_to_sleep_or_control_worry__c) || $A.util.isUndefined(survey.Not_being_able_to_sleep_or_control_worry__c)) {
         blankAnswers += "\nGAD Question 2";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Worrying_too_much_about_different_thing__c) || $A.util.isUndefined(survey.Worrying_too_much_about_different_thing__c)) {
         blankAnswers += "\nGAD Question 3";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Trouble_relaxing__c) || $A.util.isUndefined(survey.Trouble_relaxing__c)) {
         blankAnswers += "\nGAD Question 4";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.Being_so_restless_that_it_is_hard_to_sit__c) || $A.util.isUndefined(survey.Being_so_restless_that_it_is_hard_to_sit__c)) {
         blankAnswers += "\nGAD Question 5";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.Becoming_easily_annoyed_or_irritable__c) || $A.util.isUndefined(survey.Becoming_easily_annoyed_or_irritable__c)) {
         blankAnswers += "\nGAD Question 6";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.feeling_afraid_asif_something_awful_will__c) || $A.util.isUndefined(survey.feeling_afraid_asif_something_awful_will__c)) {
         blankAnswers += "\nGAD Question 7";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Little_interest_pleasure_in_doing_things__c) || $A.util.isUndefined(survey.Little_interest_pleasure_in_doing_things__c)) {
         blankAnswers += "\nPHQ Question 1";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Feeling_down_depressed_or_hopeless__c) || $A.util.isUndefined(survey.Feeling_down_depressed_or_hopeless__c)) {
         blankAnswers += "\nPHQ Question 2";
         IsValid = false;

      }


      if ($A.util.isEmpty(survey.Trouble_falling_or_staying_asleep__c) || $A.util.isUndefined(survey.Trouble_falling_or_staying_asleep__c)) {
         blankAnswers += "\nPHQ Question 3";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Feeling_tired_or_having_little_energy__c) || $A.util.isUndefined(survey.Feeling_tired_or_having_little_energy__c)) {
         blankAnswers += "\nPHQ Question 4";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Poor_appetite_or_overeating__c) || $A.util.isUndefined(survey.Poor_appetite_or_overeating__c)) {
         blankAnswers += "\nPHQ Question 5";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.Feeling_bad_about_yourself_or_faliure__c) || $A.util.isUndefined(survey.Feeling_bad_about_yourself_or_faliure__c)) {
         blankAnswers += "\nPHQ Question 6";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.Trouble_concentrating_on_things__c) || $A.util.isUndefined(survey.Trouble_concentrating_on_things__c)) {
         blankAnswers += "\nPHQ Question 7";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Moving_or_speaking_so_slowly__c) || $A.util.isUndefined(survey.Moving_or_speaking_so_slowly__c)) {
         blankAnswers += "\nPHQ Question 8";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.Thoughts_that_you_would_be_betteroff_ded__c) || $A.util.isUndefined(survey.Thoughts_that_you_would_be_betteroff_ded__c)) {
         blankAnswers += "\nPHQ Question 9";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.If_you_checkedoff_any_problem_previously__c) || $A.util.isUndefined(survey.If_you_checkedoff_any_problem_previously__c)) {
         blankAnswers += "\nPHQ Question 10";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_have_a_desire_to_succeed__c) || $A.util.isUndefined(survey.I_have_a_desire_to_succeed__c)) {
         blankAnswers += "\nRAS Question 1";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.I_have_my_own_plan_for_how_to_stay_well__c) || $A.util.isUndefined(survey.I_have_my_own_plan_for_how_to_stay_well__c)) {
         blankAnswers += "\nRAS Question 2";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_have_goals_in_life_that_I_want_to_get__c) || $A.util.isUndefined(survey.I_have_goals_in_life_that_I_want_to_get__c)) {
         blankAnswers += "\nRAS Question 3";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_believe_I_can_meet_my_current_goals__c) || $A.util.isUndefined(survey.I_believe_I_can_meet_my_current_goals__c)) {
         blankAnswers += "\nRAS Question 4";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_have_a_purpose_in_life__c) || $A.util.isUndefined(survey.I_have_a_purpose_in_life__c)) {
         blankAnswers += "\nRAS Question 5";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.when_I_don_t_care_about_myself_other_do__c) || $A.util.isUndefined(survey.when_I_don_t_care_about_myself_other_do__c)) {
         blankAnswers += "\nRAS Question 6";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_understand_how_to_control_my_symptoms__c) || $A.util.isUndefined(survey.I_understand_how_to_control_my_symptoms__c)) {
         blankAnswers += "\nRAS Question 7";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_can_handle_it_if_I_get_sick_again__c) || $A.util.isUndefined(survey.I_can_handle_it_if_I_get_sick_again__c)) {
         blankAnswers += "\nRAS Question 8";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_can_identify_what_triggers_my_symptoms__c) || $A.util.isUndefined(survey.I_can_identify_what_triggers_my_symptoms__c)) {
         blankAnswers += "\nRAS Question 9";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_can_help_myself_become_better__c) || $A.util.isUndefined(survey.I_can_help_myself_become_better__c)) {
         blankAnswers += "\nRAS Question 10";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.Fear_doesn_t_stop_me_from_living__c) || $A.util.isUndefined(survey.Fear_doesn_t_stop_me_from_living__c)) {
         blankAnswers += "\nRAS Question 11";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.I_know_that_there_are_mental_health_srvc__c) || $A.util.isUndefined(survey.I_know_that_there_are_mental_health_srvc__c)) {
         blankAnswers += "\nRAS Question 12";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.There_are_things_that_I_can_do_that_help__c) || $A.util.isUndefined(survey.There_are_things_that_I_can_do_that_help__c)) {
         blankAnswers += "\nRAS Question 13";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.I_can_handle_what_happens_in_my_life__c) || $A.util.isUndefined(survey.I_can_handle_what_happens_in_my_life__c)) {
         blankAnswers += "\nRAS Question 14";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_like_myself__c) || $A.util.isUndefined(survey.I_like_myself__c)) {
         blankAnswers += "\nRAS Question 15";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.If_people_really_knew_me_they_would_like__c) || $A.util.isUndefined(survey.If_people_really_knew_me_they_would_like__c)) {
         blankAnswers += "\nRAS Question 16";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_am_a_better_person_than_before__c) || $A.util.isUndefined(survey.I_am_a_better_person_than_before__c)) {
         blankAnswers += "\nRAS Question 17";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.Although_my_symptoms_may_get_worse__c) || $A.util.isUndefined(survey.Although_my_symptoms_may_get_worse__c)) {
         blankAnswers += "\nRAS Question 18";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.If_I_keep_trying_I_will_get_better__c) || $A.util.isUndefined(survey.If_I_keep_trying_I_will_get_better__c)) {
         blankAnswers += "\nRAS Question 19";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_have_an_idea_of_who_I_want_to_become__c) || $A.util.isUndefined(survey.I_have_an_idea_of_who_I_want_to_become__c)) {
         blankAnswers += "\nRAS Question 20";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Things_happen_for_a_reason__c) || $A.util.isUndefined(survey.Things_happen_for_a_reason__c)) {
         blankAnswers += "\nRAS Question 21";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Something_good_will_eventually_happen__c) || $A.util.isUndefined(survey.Something_good_will_eventually_happen__c)) {
         blankAnswers += "\nRAS Question 22";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_am_the_person_most_responsible__c) || $A.util.isUndefined(survey.I_am_the_person_most_responsible__c)) {
         blankAnswers += "\nRAS Question 23";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_m_hopeful_about_my_future__c) || $A.util.isUndefined(survey.I_m_hopeful_about_my_future__c)) {
         blankAnswers += "\nRAS Question 24";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_continue_to_have_new_interests__c) || $A.util.isUndefined(survey.I_continue_to_have_new_interests__c)) {
         blankAnswers += "\nRAS Question 25";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.It_is_important_to_have_fun__c) || $A.util.isUndefined(survey.It_is_important_to_have_fun__c)) {
         blankAnswers += "\nRAS Question 26";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.Coping_with_my_mental_illness__c) || $A.util.isUndefined(survey.Coping_with_my_mental_illness__c)) {
         blankAnswers += "\nRAS Question 27";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.My_symptoms_interfere_less_with_my_life__c) || $A.util.isUndefined(survey.My_symptoms_interfere_less_with_my_life__c)) {
         blankAnswers += "\nRAS Question 28";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.My_symptoms_seem_to_be_a_problem__c) || $A.util.isUndefined(survey.My_symptoms_seem_to_be_a_problem__c)) {
         blankAnswers += "\nRAS Question 29";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_know_when_to_ask_for_help__c) || $A.util.isUndefined(survey.I_know_when_to_ask_for_help__c)) {
         blankAnswers += "\nRAS Question 30";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.I_am_willing_to_ask_for_help__c) || $A.util.isUndefined(survey.I_am_willing_to_ask_for_help__c)) {
         blankAnswers += "\nRAS Question 31";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_ask_for_help_when_I_need_it__c) || $A.util.isUndefined(survey.I_ask_for_help_when_I_need_it__c)) {
         blankAnswers += "\nRAS Question 32";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Being_able_to_work_is_important_to_me__c) || $A.util.isUndefined(survey.Being_able_to_work_is_important_to_me__c)) {
         blankAnswers += "\nRAS Question 33";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.I_know_what_helps_me_get_better__c) || $A.util.isUndefined(survey.I_know_what_helps_me_get_better__c)) {
         blankAnswers += "\nRAS Question 34";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.I_can_learn_from_my_mistakes__c) || $A.util.isUndefined(survey.I_can_learn_from_my_mistakes__c)) {
         blankAnswers += "\nRAS Question 35";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.I_can_handle_stress__c) || $A.util.isUndefined(survey.I_can_handle_stress__c)) {
         blankAnswers += "\nRAS Question 36";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_have_people_I_can_count_on__c) || $A.util.isUndefined(survey.I_have_people_I_can_count_on__c)) {
         blankAnswers += "\nRAS Question 37";
         IsValid = false;

      }
      if ($A.util.isEmpty(survey.I_can_identify_the_early_warning_signs__c) || $A.util.isUndefined(survey.I_can_identify_the_early_warning_signs__c)) {
         blankAnswers += "\nRAS Question 38";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.Even_when_I_don_t_believe_in_myself__c) || $A.util.isUndefined(survey.Even_when_I_don_t_believe_in_myself__c)) {
         blankAnswers += "\nRAS Question 39";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.It_is_important_to_have_variety_of_frind__c) || $A.util.isUndefined(survey.It_is_important_to_have_variety_of_frind__c)) {
         blankAnswers += "\nRAS Question 40";
         IsValid = false;

      }

      if ($A.util.isEmpty(survey.It_is_important_to_have_healthy_habits__c) || $A.util.isUndefined(survey.It_is_important_to_have_healthy_habits__c)) {
         blankAnswers += "\nRAS Question 41";
         IsValid = false;

      }
      component.set('v.isChildHasError',false);
      if(IsValid == false){
         component.set('v.isChildHasError',true);
      }
     // IsValid = true;

      /////Validation End/////

      if (IsValid == false && blankAnswers != "") {

         try {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               title: 'Error',
               message: 'Please Select an Option for: ' + blankAnswers,
               duration: ' 5000',
               key: 'info_alt',
               type: 'Error',
               mode: 'pester'
            });
            toastEvent.fire();
         }
         catch (err) {
            alert('Please Select an Option for: ' + blankAnswers);
         }
         return;
      }

      //Calling the Apex Function
      var action = component.get("c.saveRecord");

      //Setting the Apex Parameter

      action.setParams({

         ClientOutcomeSurveyParam: survey,
         oppID: oppID
      });

      //Setting the Callback
      action.setCallback(this, function (a) {
         //get the response state
         var state = a.getState();

         //check if result is successfull
         if (state == "SUCCESS") {
            //Reset Form

            //	 component.set("v.ClientSatisfactionObj",survey);
            try {
               var toastEvent = $A.get("e.force:showToast");
               toastEvent.setParams({
                  title: 'Success',
                  message: 'The survey form has been saved',
                  duration: ' 5000',
                  key: 'info_alt',
                  type: 'success',
                  mode: 'pester'
               });
               toastEvent.fire();
            }
            catch (err) {
               alert('The survey form has been saved');
            }
            //  alert('The Survey form has been submitted');
            //  var OutcomeSurveyEvent = $A.get("e.c:ShowOutcomeSurvey_Invert");
            //set params
            // OutcomeSurveyEvent.setParams({"recordId" : null,
            //   "returnCmp" : "create"});
            //component.set('v.oppID',null);
            //fire event
            // OutcomeSurveyEvent.fire();

         }
      });

      //adds the server-side action to the queue        
      $A.enqueueAction(action);
   },

   handleChange: function (cmp, event) {
      var changeValue = event.getParam("value");

   },

   handleApplicationEvent: function (component, event) {
      /*  
         var recordId = event.getParam("recordId");
         var readOnly= event.getParam("ReadOnly");
         var returnCmp= event.getParam("returnCmp");
         var oppID= event.getParam("OpportunityID");  
         var sunshineCenter= event.getParam("sunshineCenter");  
        var ClientName=event.getParam("OpportunityName"); 
        var ClientAdmissionDate=event.getParam("OpportunityAdmissionDate");
         component.set('v.SurveyId',recordId);
         component.set('v.oppID',oppID);
        component.set('v.clientName',ClientName);
        component.set('v.clientAdmissionDate',ClientAdmissionDate);
        component.set('v.IsReadOnly',readOnly);
       	component.set('v.returnCmp',returnCmp);
        component.set("v.AccountType",sunshineCenter);
        component.set("v.ClientOutcomeSurveyObj",{'sobjectType': 'Client_Outcome_Survey__c',
                                                   });
               var returnCmp=component.get('v.returnCmp');
        
        component.set("v.ClientOutcomeSurveyObj.Type__c",event.getParam("stageType"));
               
*/
   },

   handleApplicationEventInvert: function (cmp, event, helper) {
      /*      
            var IsAuthenticated = event.getParam("IsAuthenticated");
            cmp.set('v.SurveyId',null);
            */

   },
   back: function (component, event, helper) {
      /*
       var OutcomeSurveyEvent = $A.get("e.c:ShowOutcomeSurvey_Invert");
       var returnCmp=component.get('v.returnCmp');
               //set params
            
               OutcomeSurveyEvent.setParams({"recordId" : null,
                                                  "returnCmp" : returnCmp
                                                 });
               component.set('v.oppID',null);
               //fire event
              OutcomeSurveyEvent.fire();
              */
   },
   handleShowHide: function (component, event, helper) {
      component.set('v.SurveyId', null);//get event
   }
});