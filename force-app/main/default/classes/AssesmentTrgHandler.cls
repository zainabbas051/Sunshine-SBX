//TestClass: AssesmentTrgHandlerTest
public class AssesmentTrgHandler{

    public static void onAfterUpdate(List<Pre_Admission_Assessment__c> lstPreAdmission){
            
            
            UpdateOpportunity(lstPreAdmission);
            
    }
    
    static void UpdateOpportunity(List<Pre_Admission_Assessment__c> lstPreAdmission){
          
          List<Opportunity> lstOppty = new List<Opportunity>();
          
          for(Pre_Admission_Assessment__c iPre : lstPreAdmission){
              
               Opportunity ioppty = new Opportunity();
                 ioppty.id=  iPre.Opportunity__c;            
                ioppty.Age__c=iPre.Age__c;
                ioppty.Age_of_First_Use_Drug_1__c=iPre.Age_of_First_Use_Drug_1__c;
                ioppty.Age_of_First_Use_Drug_2__c=iPre.Age_of_First_Use_Drug_2__c;
                ioppty.Age_of_First_Use_Drug_3__c=iPre.Age_of_First_Use_Drug_3__c;
                ioppty.Aggressive_Behavior__c=iPre.Aggressive_Behavior__c;
                ioppty.Allergic_Reaction__c=iPre.Allergic_Reaction__c;
                ioppty.Allergies__c=iPre.Allergies__c;
                ioppty.Ambulation__c=iPre.Ambulation__c;
                ioppty.Any_Current_Infectious_Diseases__c=iPre.Any_Current_Infectious_Diseases__c;
                ioppty.Any_Other_Chronic_Medical_Conditions__c=iPre.Any_Other_Chronic_Medical_Conditions__c;
                ioppty.Any_Pending_Charges__c=iPre.Any_Pending_Charges__c;
                ioppty.Any_Physical_Limitations__c=iPre.Any_Physical_Limitations__c;
                ioppty.Are_you_followed_by_Neurologist__c=iPre.Are_you_followed_by_Neurologist__c;
                ioppty.Client_Aware_of_Step_Down_to_PHP__c=iPre.Client_Aware_of_Step_Down_to_PHP__c;
                ioppty.CPAP_Needed__c=iPre.CPAP_Needed__c;
                ioppty.Current_Employer__c=iPre.Current_Employer__c;
                ioppty.Currently_Pregnant__c=iPre.Currently_Pregnant__c;
                ioppty.Are_you_currently_taking_seizure_medicat__c =iPre.Currently_taking_any_seizure_medication__c;
                ioppty.Current_Medications__c=iPre.Current_Medications__c;
                ioppty.Current_Suicidal_Ideations__c=iPre.Current_Suicidal_Ideations__c;
                ioppty.Current_Tx_For_Infectious_Diseases__c=iPre.Current_Tx_For_Infectious_Diseases__c;
                ioppty.Current_Use_Details_Drug_1__c=iPre.Current_Use_Details_Drug_1__c;
                ioppty.Current_Use_Details_Drug_2__c=iPre.Current_Use_Details_Drug_2__c;
                ioppty.Current_Use_Details_Drug_3__c=iPre.Current_Use_Details_Drug_3__c;
                ioppty.Dangerous_Behavior_while_Using__c=iPre.Dangerous_Behavior_while_Using__c;
                ioppty.Date_of_Last_Use_Drug_1__c=iPre.Date_of_Last_Use_Drug_1__c;
                ioppty.Date_of_Last_Use_Drug_2__c=iPre.Date_of_Last_Use_Drug_2__c;
                ioppty.Date_of_Last_Use_Drug_3__c=iPre.Date_of_Last_Use_Drug_3__c;
                ioppty.Days_Committed_to_Treatment__c=iPre.Days_Committed_to_Treatment__c;
                ioppty.Detox_Needed__c=iPre.Detox_Needed__c;
                ioppty.Diet__c=iPre.Diet__c;
                ioppty.DOB__c=iPre.DOB__c;
                ioppty.DOC_Notes__c=iPre.DOC_Notes__c;
                ioppty.Do_you_have_history_of_seizure_disorder__c=iPre.Do_you_have_history_of_seizure_disorder__c;
                ioppty.Drug_of_Choice_1__c=iPre.Drug_of_Choice_1__c;
                ioppty.Drug_of_Choice_2__c=iPre.Drug_of_Choice_2__c;
                ioppty.Drug_of_Choice_3__c=iPre.Drug_of_Choice_3__c;
                ioppty.Employment_Status__c=iPre.Employment_Status__c;
                ioppty.Ethnicity__c=iPre.Ethnicity__c;
                ioppty.Family_Contact_Email__c=iPre.Family_Contact_Email_1__c;
                ioppty.Family_Contact_Email_2__c=iPre.Family_Contact_Email_2__c;
                ioppty.Family_Contact_Email_3__c=iPre.Family_Contact_Email_3__c;
                ioppty.Family_Contact_Name__c=iPre.Family_Contact_Name_1__c;
                ioppty.Family_Contact_Name_2__c=iPre.Family_Contact_Name_2__c;
                ioppty.Family_Contact_Name_3__c=iPre.Family_Contact_Name_3__c;
                ioppty.Family_Contact_Phone__c=iPre.Family_Contact_Phone_1__c;
                ioppty.Family_Contact_Phone_2__c=iPre.Family_Contact_Phone_2__c;
                ioppty.Family_Contact_Phone_3__c=iPre.Family_Contact_Phone_3__c;
                ioppty.Family_Contact_Relationship__c=iPre.Family_Contact_Relationship_1__c;
                ioppty.Family_Contact_Relationship_2__c=iPre.Family_Contact_Relationship_2__c;
                ioppty.Family_Contact_Relationship_3__c=iPre.Family_Contact_Relationship_3__c;
                ioppty.Family_History_Notes__c=iPre.Family_History_Notes__c;
                ioppty.Family_History_of_Mental_Disorder__c =iPre.Family_History_of_Mental_Health_Disorder__c;
                ioppty.Family_History_of_Suicide__c=iPre.Family_History_of_Suicide__c;
                ioppty.FMLA_Needed__c=iPre.FMLA_Needed__c;
                ioppty.Frequency_of_Use_Drug_1__c =iPre.Frequency_Length_of_Use_Drug_1__c;
                ioppty.Frequency_of_Use_Drug_2__c =iPre.Frequency_Length_of_Use_Drug_2__c;
                ioppty.Frequency_of_Use_Drug_3__c =iPre.Frequency_Length_of_Use_Drug_3__c;
                ioppty.Height__c=iPre.Height__c;
                ioppty.History_of_Arson__c=iPre.History_of_Arson__c;
                ioppty.History_of_Seizures__c=iPre.History_of_Seizures__c;
                ioppty.History_of_Violence__c=iPre.History_of_Violence__c;
                ioppty.Hospitalized_for_Withdrawal_DTs_Seizures__c=iPre.Hospitalized_for_Withdrawal_DTs_Seizures__c;
                ioppty.Hx_of_Head_Injury_Neurologic_Dysfunction__c=iPre.Hx_of_Head_Injury_Neurologic_Dysfunction__c;
                ioppty.Is_seizure_due_to_substance_cessation__c=iPre.Is_seizure_due_to_substance_cessation__c;
                ioppty.Issues_Treatment_for_Chronic_Pain__c=iPre.Issues_Treatment_for_Chronic_Pain__c;
                ioppty.Legal_Contact_Info__c=iPre.Legal_Contact_Info__c;
                ioppty.Legal_Contact_Required__c=iPre.Legal_Contact_Required__c;
                ioppty.Legal_history_Notes__c=iPre.Legal_history_Notes__c;
                ioppty.Length_of_Employment__c=iPre.Length_of_Employment__c;
                ioppty.Lives_with_Name_Age__c=iPre.Lives_with_Name_Age__c;
                ioppty.Longest_Sobriety__c=iPre.Longest_Sobriety__c;
                ioppty.Marital_Status__c=iPre.Marital_Status__c;
                ioppty.Medical_Conditions__c=iPre.Medical_Conditions__c;
                ioppty.Medical_History_Notes__c=iPre.Medical_History_Notes__c;
                ioppty.Method_of_Use_Drug_1__c=iPre.Method_of_Use_Drug_1__c;
                ioppty.Method_of_Use_Drug_2__c=iPre.Method_of_Use_Drug_2__c;
                ioppty.Method_of_Use_Drug_3__c=iPre.Method_of_Use_Drug_3__c;
                ioppty.Negative_Consequences_of_Using__c=iPre.Negative_Consequences_of_Using__c;
                ioppty.Probation_Parole__c=iPre.On_Probation_Parole__c;
                ioppty.Other_Employment_Info__c=iPre.Other_Employment_Info__c;
                ioppty.Other_Housing_Issues__c=iPre.Other_Housing_Issues__c;
                ioppty.Other_Issues__c=iPre.Other_Issues__c;
                ioppty.Other_Languages_Spoken__c=iPre.Other_Languages_Spoken__c;
                ioppty.Other_Medical_Issues__c=iPre.Other_Medical_Issues__c;
                ioppty.Past_Suicidal_Ideations__c=iPre.Past_Suicidal_Ideations__c;
                ioppty.Precipitating_Event__c=iPre.Precipitating_Event__c;
                ioppty.Preferred_Language_Spoken__c=iPre.Preferred_Language_Spoken__c;
                ioppty.Prescribed_but_not_Taken_Medication__c=iPre.Prescribed_but_not_Taken_Medication__c;
                ioppty.Previous_ACAs__c=iPre.Previous_ACAs__c;
                ioppty.Previous_Suicide_Attempts__c=iPre.Previous_Suicide_Attempts__c;
                ioppty.Previous_Treatment_Episodes__c=iPre.Previous_Treatment_Episodes__c;
                ioppty.Previous_Treatment_Notes__c=iPre.Previous_Treatment_Notes__c;
                ioppty.Psychiatric_Co_occurring_Issues__c=iPre.Psychiatric_Co_occurring_Issues__c;
                ioppty.Psychiatric_Diagnosis__c=iPre.Psychiatric_Diagnosis__c;
                ioppty.Psych_Notes__c=iPre.Psych_Notes__c;
                ioppty.Race__c=iPre.Race__c;
                ioppty.Reason_Why_Not_Taking__c=iPre.Reason_Why_Not_Taking__c;
                ioppty.Recent_Hospitalization_Surgery__c=iPre.Recent_Hospitalization_Surgery__c;
                ioppty.Self_Diagnosed__c=iPre.Self_Diagnosed__c;
                ioppty.Self_Injurious_Mutilating_Behavior__c=iPre.Self_Injurious_Mutilating_Behavior__c;
                ioppty.Sex__c=iPre.Sex__c;
                ioppty.Sexual_Offenses__c=iPre.Sexual_Offenses__c;
                ioppty.Suicide_Notes__c=iPre.Suicide_Notes__c;
                ioppty.Supporting_Withdrawal_Notes__c=iPre.Supporting_Withdrawal_Notes__c;
                ioppty.Supportive_Environment__c=iPre.Supportive_Environment__c;
                ioppty.Trauma__c=iPre.Trauma__c;
                ioppty.Trauma_Notes__c=iPre.Trauma_Notes__c;
                ioppty.Triggers__c=iPre.Triggers__c;
                ioppty.Current_Pain_Management__c =iPre.Under_Care_of_Dr_for_Pain_Management__c;
                ioppty.Upcoming_Court_Dates__c=iPre.Upcoming_Court_Dates__c;
                ioppty.Veteran_Status__c=iPre.Veteran_Status__c;
                ioppty.Weight__c=iPre.Weight__c;
                ioppty.When_was_your_last_seizure__c=iPre.When_was_your_last_seizure__c;
                ioppty.Why_Treatment_Now__c=iPre.Why_Treatment_Now__c;
                ioppty.Willing_to_Discontinue_Pain_Meds__c =iPre.Willing_to_Discontinue_all_Pain_Meds__c;
                ioppty.Withdrawal_Symptoms__c=iPre.Withdrawal_Symptoms__c;
                ioppty.Languages_Spoken__c = iPre.Languages_Spoken__c;

               
               lstOppty.add(ioppty);
               
               
          }
          
          if(lstOppty.isEmpty() == false){
              
              update lstOppty;
          }
    }
}