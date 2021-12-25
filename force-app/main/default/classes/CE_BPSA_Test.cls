@isTest
private class CE_BPSA_Test{

Public Static Client_Chart__c ClientID ;
Public Static Clinical_Evaluation_2__c CE2;
Public Static Clinical_Evaluation_3__c CE3;
Public Static CE_BPSA Obj;// = new CE_BPSA();

public Static testmethod void CE_BPSA_Test(){

Test.startTest();
PrepareData1();
PrepareData2();
Test.StopTest();

}

public Static testmethod void PrepareData1()
{
    

    ClientID = new Client_Chart__c();
    ClientID.Name = 'Test Client';
    Insert ClientID;
    
    CE2 = new Clinical_Evaluation_2__c();
    CE2.Client_Chart__c = ClientID.id;
    CE2.AA_NA_exp__c = 'Test AA_NA_exp__c';
    Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation_2__c.getRecordTypeInfosByName().get('Bio-Psychosocial Assessment').getRecordTypeId();
    CE2.RecordtypeId = BPSARecordTypeId ;
    CE2.Trauma_Assess_History_of_Trauma_NONE__c = true;
    CE2.Client_trauma_interfere_Treatment_NONE__c = true;
    CE2.Suicide_Screening_Thoughts_NONE__c = true;
    CE2.Suicide_Screening_Thoughts_NONE__c = false;
    CE2.Suicide_Screening_Attempts_NONE__c = true;
    CE2.Suicide_Screening_Attempts_NONE__c = false;
    CE2.Family_Supports_In_Treatment_NONE__c = true;
    CE2.Family_Supports_In_Treatment_NONE__c = false;
    CE2.Family_Dependent_on_Treatment_NONE__c = true;
    CE2.Family_Dependent_on_Treatment_NONE__c = false;
    //rendering3
    CE2.BPA_Does_Client_have_any_siblings__c = false;
    CE2.History_of_Subs_abuse_NO__c = false;
    CE2.Is_Client_involved_in_a_significant_rela__c = true;
    CE2.No_Relationship__c = true;
    CE2.No_Children__c = true;
    CE2.Is_Client_satisfied_relationship_Chld__c = true;
    //checkAllRendering5
    CE2.If_no_to_any_of_the_above_P_PP_C__c = true;
    CE2.Client_Raised_in_specific_culture_NO__c = true;
    CE2.Client_practice_specific_culture_NO__c= true;
    CE2.Client_identify_specific_culture_NO__c= true;
    CE2.Client_identify_special_culture_NO__c= true;
    CE2.Client_have_problem_interacting_NO__c= true;
    //checkAllRendering6
    CE2.LegalHistory_Client_involve_in_Crime_NO__c = true;
    CE2.LegalHistory_Client_Crime_History_NO__c= true;
    CE2.Incarceration_History_NONE__c= true;
    CE2.Client_currently_owe_restitution_NO__c= true;
    //checkAllRendering7
    CE2.Client_enrolled_attending_school_NO__c = true;
    CE2.Client_expelled_from_school_2year_NO__c= true;
    CE2.Client_attended_special_classes_NO__c= true;
    CE2.Military_Service_NONE__c= true;
    CE2.Employment_History_NONE__c= true;
    CE2.Client_need_specific_training_NO__c= true;
    CE2.Client_received_any_training_NO__c= true;
    CE2.Client_received_any_training_NO__c= true;
    //checkAllRendering9
    CE2.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_1_NO__c = true;
    CE2.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_3_NO__c = true;
    CE2.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_4_NO__c = true;
    CE2.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_5_YES__c = true;

    CE2.SPIRITUALITY_ASSESS_Prayer_meditation_NO__c= true;
    CE2.SPIRITUALITY_ASSESS_Spiritual_Goals_NO__c= true;
    CE2.SPIRITUALITY_ASSESS_Practice_Religion_NO__c= true;
    CE2.SPIRITUALITY_ASSESS_Type_of_Spiritual_NO__c= true;

    insert CE2; 

    CE3 = new Clinical_Evaluation_3__c();
    CE3.Name = 'Test Clinical Evaluation 3';
    CE3.Clinical_Evaluation_2__c = CE2.ID;
    CE3.Attempt_to_discontinue_cut_back_on_subs__c = 'YES';
    CE3.Attempt_to_discontinue_cut_back_on_subs__c = 'No';
    CE3.Client_under_the_care_of_a_physician__c = 'Yes';
    CE3.Client_under_the_care_of_a_physician__c = 'No';
    CE3.Client_History_Medical_Condition__c = 'Yes';
    CE3.Client_History_Medical_Condition__c = 'No';
    CE3.Client_Family_History_Medical_Condition__c = 'Yes';
    CE3.Client_Family_History_Medical_Condition__c = 'No';
    CE3.Have_you_ever_been_sexually_abused__c = 'Yes';
    CE3.Have_you_ever_been_sexually_abused__c = 'No';
    CE3.Ever_been_involved_in_abusive_relation__c = true;

    CE3.Client_have_any_future_education_goal_NO__c= true;


    //checkAllRendering8
    CE3.Cleint_existing_Positive_Supp_Sys_NO__c = true;
    CE3.Client_Environment_to_conductive_NO__c= true;
    CE3.Client_Engage_in_subs_free_NO__c= true;
    
    CE3.Clinical_Evaluation_2__c = CE2.ID;
    
    Insert CE3;
    
    ApexPages.currentPage().getParameters().put('Id', ClientID.id);
    ApexPages.currentPage().getParameters().put('ceId', CE2.id);
    ApexPages.currentPage().getParameters().put('type', 'Bio-Psychosocial Assessment');
    
    awsBucket__c AWS = new awsBucket__c();
    AWS.Name='FREEPU';
    AWS.accessKeyId__c='Testaccesskey';
    AWS.Bucket__c='TestBucket';
    AWS.secretAccessKey__c='Tessecretkey';
    insert AWS; 
    
    CE_BPSA Obj = new CE_BPSA();
    obj.saveRecord();
    obj.RenderAttemptToDiscontinue = true;
    obj.RenderClientPhysician= true;
    obj.RenderClientHistoryMedCond= true;
    obj.RenderClientFamilyHistoryMedCond= true;
    obj.RenderSexuallyAbusedDrugRelated= true;
    obj.SelectedSignedOption = 'Patient';
    
    Obj.Edit();
    Obj.Cancel();
    Obj.calculateScores();
    Obj.checkAllRendering();
    Obj.checkAllRendering2();
    Obj.checkAllRendering3();
    Obj.checkAllRendering4();
    Obj.checkAllRendering5();
    Obj.checkAllRendering6();
    Obj.checkAllRendering7();
    Obj.checkAllRendering8();
    Obj.checkAllRendering9();
    obj.CloseSignatureForm();
}

public Static testmethod void PrepareData2()
{
    

    ClientID = new Client_Chart__c();
    ClientID.Name = 'Test Client';
    Insert ClientID;
    
    CE2 = new Clinical_Evaluation_2__c();
    CE2.Client_Chart__c = ClientID.id;
    CE2.AA_NA_exp__c = 'Test AA_NA_exp__c';
    Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation_2__c.getRecordTypeInfosByName().get('Bio-Psychosocial Assessment').getRecordTypeId();
    CE2.RecordtypeId = BPSARecordTypeId ;
    CE2.Trauma_Assess_History_of_Trauma_NONE__c = false;
    CE2.Client_trauma_interfere_Treatment_NONE__c = false;
    CE2.Suicide_Screening_Thoughts_NONE__c = false;
    CE2.Suicide_Screening_Attempts_NONE__c = false;
    CE2.Family_Supports_In_Treatment_NONE__c = false;
    CE2.Family_Dependent_on_Treatment_NONE__c = false;
    //rendering3
    CE2.BPA_Does_Client_have_any_siblings__c = true;
    CE2.History_of_Subs_abuse_NO__c = true;
    CE2.Is_Client_involved_in_a_significant_rela__c = false;
    CE2.No_Relationship__c = false;
    CE2.No_Children__c = false;
    CE2.Is_Client_satisfied_relationship_Chld__c = false;
    //checkAllRendering5
    CE2.If_no_to_any_of_the_above_P_PP_C__c = false;
    CE2.Client_Raised_in_specific_culture_NO__c = false;
    CE2.Client_practice_specific_culture_NO__c= false;
    CE2.Client_identify_specific_culture_NO__c= false;
    CE2.Client_have_problem_interacting_NO__c= false;
    //checkAllRendering6
    CE2.LegalHistory_Client_involve_in_Crime_NO__c = false;
    CE2.LegalHistory_Client_Crime_History_NO__c= false;
    CE2.Incarceration_History_NONE__c= false;
    CE2.Client_currently_owe_restitution_NO__c= false;
    //checkAllRendering7
    CE2.Client_enrolled_attending_school_NO__c = false;
    CE2.Client_expelled_from_school_2year_NO__c= false;
    CE2.Client_attended_special_classes_NO__c= false;
    CE2.Military_Service_NONE__c= false;
    CE2.Employment_History_NONE__c= false;
    CE2.Client_need_specific_training_NO__c= false;
    CE2.Client_received_any_training_NO__c= true;
    //checkAllRendering9
    CE2.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_1_NO__c = false;
    CE2.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_3_NO__c = false;
    CE2.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_4_NO__c = false;
    CE2.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_5_YES__c = false;

    CE2.SPIRITUALITY_ASSESS_Prayer_meditation_NO__c= false;
    CE2.SPIRITUALITY_ASSESS_Spiritual_Goals_NO__c= false;
    CE2.SPIRITUALITY_ASSESS_Practice_Religion_NO__c= false;
    CE2.SPIRITUALITY_ASSESS_Type_of_Spiritual_NO__c= false;

    insert CE2; 

    CE3 = new Clinical_Evaluation_3__c();
    CE3.Name = 'Test Clinical Evaluation 3';
    CE3.Clinical_Evaluation_2__c = CE2.ID;
    CE3.Attempt_to_discontinue_cut_back_on_subs__c = 'No';
    CE3.Attempt_to_discontinue_cut_back_on_subs__c = 'Yes';
    CE3.Client_under_the_care_of_a_physician__c = 'No';
    CE3.Client_under_the_care_of_a_physician__c = 'Yes';
    CE3.Client_History_Medical_Condition__c = 'No';
    CE3.Client_History_Medical_Condition__c = 'Yes';
    CE3.Client_Family_History_Medical_Condition__c = 'No';
    CE3.Client_Family_History_Medical_Condition__c = 'Yes';
    CE3.Have_you_ever_been_sexually_abused__c = 'No';
    CE3.Have_you_ever_been_sexually_abused__c = 'Yes';
    CE3.Ever_been_involved_in_abusive_relation__c = false;
    CE3.Client_have_any_future_education_goal_NO__c= false;


    //checkAllRendering8
    CE3.Cleint_existing_Positive_Supp_Sys_NO__c = false;
    CE3.Client_Environment_to_conductive_NO__c= false;
    CE3.Client_Engage_in_subs_free_NO__c= false;
    
    CE3.Clinical_Evaluation_2__c = CE2.ID;
    
    Insert CE3;
    
    ApexPages.currentPage().getParameters().put('Id', ClientID.id);
    ApexPages.currentPage().getParameters().put('ceId', CE2.id);
    ApexPages.currentPage().getParameters().put('type', 'Bio-Psychosocial Assessment');
    
    awsBucket__c AWS = new awsBucket__c();
    AWS.Name='FREEPU';
    AWS.accessKeyId__c='Testaccesskey';
    AWS.Bucket__c='TestBucket';
    AWS.secretAccessKey__c='Tessecretkey';
    insert AWS; 
    
    CE_BPSA Obj = new CE_BPSA();
    obj.SelectedSignedOption = 'SelectedSignedOption';
    obj.ImageUrlAddress = 'ImageUrlAddress';
    obj.saveRecord();
    obj.RenderAttemptToDiscontinue = true;
    obj.RenderClientPhysician= true;
    obj.RenderClientHistoryMedCond= true;
    obj.RenderClientFamilyHistoryMedCond= true;
    obj.RenderSexuallyAbusedDrugRelated= true;
    obj.SelectedSignedOption = 'Staff';
    
    Obj.Edit();
    Obj.Cancel();
    Obj.calculateScores();
    Obj.checkAllRendering();
    Obj.checkAllRendering2();
    Obj.checkAllRendering3();
    Obj.checkAllRendering4();
    Obj.checkAllRendering5();
    Obj.checkAllRendering6();
    Obj.checkAllRendering7();
    Obj.checkAllRendering8();
    Obj.checkAllRendering9();
    Obj.CloseSignatureForm();
}
}