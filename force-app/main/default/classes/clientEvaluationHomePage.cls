//Test Class : clientEvaluationHomePage_Test
public class clientEvaluationHomePage {
    public List<Clinical_Evaluation__c> lstCEs{get;set;}
    public List<Clinical_Evaluation_2__c> lstCE2{get;set;}
    public List<Clinical_Evaluation_3__c> lstCE3{get;set;}
    
    Clinical_Evaluation__c selectedCE {get;set;}
    public string clientId {get;set;}
    public Boolean addNewForm {get;set;}
    public Boolean addNewSelect {get;set;}
    public Boolean addNewPreAdd {get;set;}
    public Boolean readPreAdd {get;set;}
    public Boolean addNewF2F {get;set;}
    public Boolean mainForm {get;set;}
    public Boolean back {get;set;}
    
    public boolean RenderAddNewPPA {get; set;}
    public boolean RenderAddNewF2F {get; set;}
    public boolean RenderAddNewPE {get; set;}
    public boolean RenderAddNewBPSA {get; set;}
    
    public Id recId {get;set;}
    
    public string CE3RecID {get;set;}
    
    public String hidVal {get;set;}
    
    public string RecordTypeName {get; set;}
    
    public String CurrentCEId {get; set;} 
    public String CurrentCERType {get; set;} 
    public Boolean readPreAddPAA {get;set;}
    public Boolean readPreAddF2F {get;set;}
    public Clinical_Evaluation__c CEToView {get; set;}
    public map<string,Clinical_Evaluation__c> mapOfCEs {get; set;}
    
    public list<string> ListOfForms {get; set;}
    
    
    public clientEvaluationHomePage(){
        clientId = ApexPages.CurrentPage().getParameters().get('id');
        fillListOfForms();
        RecordTypeName = '';
        
        RenderAddNewPPA = false;
        RenderAddNewF2F = false;
        RenderAddNewPE = false;
        RenderAddNewBPSA = false;
        
        if(clientId != null){
            loadCERecs(clientId);
            mainForm = true;
            back = false;
        }
        else{
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Client Chart ID(cid) parameter missing in URL.');
            ApexPages.addMessage(errMsg);
        }
    }
    
    public void addNewCEForm()
    {
        system.debug('#RecordTypeName'+RecordTypeName);
        if(RecordTypeName == 'Bio-Psychosocial Assessment')
        {
            RenderAddNewBPSA = true;
            RenderAddNewPPA = false;
            RenderAddNewF2F = false;
            RenderAddNewPE = false;
            mainForm = false;
            
        }
        else if(RecordTypeName == 'Face to Face Evaluation')
        {
            RenderAddNewF2F = true;
            RenderAddNewBPSA = false;
            RenderAddNewPPA = false;
            RenderAddNewPE = false;
            mainForm = false;
        }
        else if(RecordTypeName == 'Phsych Evaluation')
        {
            RenderAddNewPE = true;
            RenderAddNewF2F = false;
            RenderAddNewBPSA = false;
            RenderAddNewPPA = false;
            mainForm = false;
            
        }
        else if(RecordTypeName == 'Pre Admission Assesment')
        {
            RenderAddNewPPA = true;
            RenderAddNewPE = false;
            RenderAddNewF2F = false;
            RenderAddNewBPSA = false;
            mainForm = false;
            
            
        }
    }
    
    public pageReference addNewHPForm()
    {
        PageReference pr = new PageReference('/apex/CE_HP?id='+ clientId);
        pr.getParameters().put('type','History And Physical');
        pr.getParameters().put('mode','edit');
        pr.setRedirect(True);
        return pr;
    }
    public pageReference addNewPsychEvalForm()
    {
        PageReference pr = new PageReference('/apex/PsychEvaluation?id='+ clientId);
        pr.getParameters().put('type','Phsych Evaluation');
        pr.getParameters().put('readOnly','false');
        pr.setRedirect(True);
        return pr;
    }
    
    public pageReference OpenHPForm()
    {
        PageReference pr = new PageReference('/apex/CE_HP');
        pr.getParameters().put('Id',clientId);
        pr.getParameters().put('type','History And Physical');
        pr.getParameters().put('ceId',CE3RecID);
        pr.setRedirect(True);
        return pr;
    }
    
    private void fillListOfForms()
    {
        ListOfForms = new list<string>();
        ListOfForms.add('Bio-Psychosocial Assessment');
        ListOfForms.add('Face to Face Evaluation');
        ListOfForms.add('Phsych Evaluation');
        //ListOfForms.add('Psych Evaluation');
        ListOfForms.add('Pre Admission Assesment');
        ListOfForms.add('History And Physical');
    }
    
    public void backButton(){
        if(addNewSelect == true){
            mainForm = true;
            back = false;
            addNewSelect = false;
        }
        else if(addNewPreAdd == true){
            addNewPreAdd = false;
            addNewSelect = true;
        }
        else if(addNewF2F == true){
            addNewF2F = false;
            addNewSelect = true;
        }
        else if(readPreAdd == true){
            readPreAdd = false;
            mainForm = true;
        }
        else if(readPreAddPAA == true)
        {
            readPreAddPAA = false;
            mainForm = true;
        }
        else if(readPreAddF2F == true)
        {
            readPreAddF2F = false;
            mainForm = true;
        }
    }
    public void addNew(){
        addNewSelect = true;
        mainForm = false;
        back = true;
    }
    public void addNewPreAdd(){
        addNewPreAdd = true;
        addNewSelect = false;
        readPreAddPAA = false;
        readPreAddF2F = false;
        
    }
    public void readPreAdd(String row){
        System.debug('row === '+row );
        readPreAdd = true;
        mainForm = false;
        back = true;
    }
    
    /*public void readPreAdd2()
    {
        CEToView = mapOfCEs.containsKey(CurrentCEId)? mapOfCEs.get(CurrentCEId) : new Clinical_Evaluation__c();
        if(CurrentCERType == 'Pre Admission Assesment')
        {
            readPreAddPAA = true;
            readPreAddF2F = false;
            mainForm = false;
            back = true;
        }
        else if(CurrentCERType == 'Face to Face')
        {
            readPreAddPAA = false;
            readPreAddF2F = true;
            mainForm = false;
            back = true;
        }
    }*/
    
    public pageReference OpenForm()
    {
        PageReference pr;
        if(CurrentCERType == 'Pre Admission Assesment')
        {
            pr = new PageReference('/apex/PAA_Edit_Read?id='+ clientId);
            pr.getParameters().put('ceid',CurrentCEId);
            pr.getParameters().put('mode','read');
            pr.setRedirect(True);
            return pr;
        }
        
        else if(CurrentCERType == 'Face to Face Evaluation')
        {
            pr = new PageReference('/apex/CE_FFE_Edit_Read?id='+ CurrentCEId);
            pr.getParameters().put('mode','read');
            pr.setRedirect(True);
            return pr;
        }
        return null;
    }
    
    public void addNewFaceToFace(){
        addNewF2F = true;
        addNewSelect = false;
    }
    
    public void loadCERecs(Id recId){
        /*lstCEs = [Select RecordType.Name,X02_Saturations__c,FFE_PSA_AA_NA__c,FFE_Access_to_Guns__c,FFE_Additional_comments_notes__c,PAA_Additional_Legal_Employment_Comments__c,PAA_Additional_Medical_Notes__c,FFE_AlcoholDrugH_Age1__c,FFE_AlcoholDrugH_Age2__c,
                      FFE_AlcoholDrugH_Age3__c,FFE_AlcoholDrugH_Age4__c,FFE_AlcoholDrugH_Age5__c,FFE_AlcoholDrugH_Age6__c,FFE_AlcoholDrugH_Amount1__c,FFE_AlcoholDrugH_Amount2__c,FFE_AlcoholDrugH_Amount3__c,FFE_AlcoholDrugH_Amount4__c,FFE_AlcoholDrugH_Amount5__c,
                      FFE_AlcoholDrugH_Amount6__c,FFE_AlcoholDrugH_Rate1__c,FFE_AlcoholDrugH_Rate2__c,FFE_AlcoholDrugH_Rate3__c,FFE_AlcoholDrugH_Rate4__c,FFE_AlcoholDrugH_Rate5__c,FFE_AlcoholDrugH_Rate6__c,FFE_AlcoholDrugH_DateLastUse1__c,FFE_AlcoholDrugH_DateLastUse2__c,
                      FFE_AlcoholDrugH_DateLastUse3__c,FFE_AlcoholDrugH_DateLastUse4__c,FFE_AlcoholDrugH_DateLastUse5__c,FFE_AlcoholDrugH_DateLastUse6__c,FFE_AlcoholDrugH_Name1__c,FFE_AlcoholDrugH_Name2__c,FFE_AlcoholDrugH_Name3__c,FFE_AlcoholDrugH_Name4__c,FFE_AlcoholDrugH_Name5__c,
                      FFE_AlcoholDrugH_Name6__c,FFE_AlcoholDrugH_Route1__c,FFE_AlcoholDrugH_Route2__c,FFE_AlcoholDrugH_Route3__c,FFE_AlcoholDrugH_Route4__c,FFE_AlcoholDrugH_Route5__c,FFE_AlcoholDrugH_Route6__c,FFE_Age_s_of_children__c,FFE_Alcohol_drugs_present_in_environment__c,
                      PAA_Alcohol_Current_Use__c,PAA_Alcohol_First_Use_Age__c,PAA_Alcohol_Method_of_Use__c,FFE_Alcohol_present_in_environment_Expla__c,PAA_Amphetamines_Current_Use__c,PAA_Amphetamines_First_Use_Age__c,PAA_Amphetamines_Method_of_Use__c,PAA_Any_existing_medical_condition__c,
                      PAA_Any_outstanding_legal_issues__c,PAA_Any_outstanding_legal_issuesC__c,FFE_Appetite__c,PAA_Are_you_currently_pregnant__c,PAA_Are_you_taking_any_medications__c,PAA_Are_you_taking_any_medicationsC__c,PAA_Attempted_suicide__c,PAA_Attempted_suicideC__c,
                      PAA_Barbiturates_Current_Use__c,PAA_Barbiturates_First_Use_Age__c,PAA_Barbiturates_Method_of_Use__c,FFE_BP_diastolic__c,FF_BP_Systolic__c,FFE_Breathalyzer__c,Client_Chart__c,FFE_Client_occupation_where_continued_Ex__c,FFE_Client_occupation_where_continued_us__c,
                      FFE_Client_Recognize_Usage_Excessive__c,FFE_Client_Recognize_Usage_Excessive_Exp__c,PAA_CocaineCrack_Current_Use__c,PAA_CocaineCrack_First_Use_Age__c,PAA_CocaineCrack_Method_of_Use__c,Current_Medication__c,FFE_Current_Medication_Amount_1__c,FFE_Current_Medication_Amount_10__c,
                      FFE_Current_Medication_Amount_2__c,FFE_Current_Medication_Amount_3__c,FFE_Current_Medication_Amount_4__c,FFE_Current_Medication_Amount_5__c,FFE_Current_Medication_Amount_6__c,FFE_Current_Medication_Amount_7__c,FFE_Current_Medication_Amount_8__c,FFE_Current_Medication_Amount_9__c,
                      PAA_Current_Substance_Usage_Notes__c,FFE_Current_Suicidal_ideations_Explain__c,FFE_Current_Suicidal_ideations__c,PAA_Dangerous_Behaviors_When_Under_Influ__c,FFE_DoctorVisit_Date1__c,FFE_DoctorVisit_Date2__c,FFE_DoctorVisit_Date3__c,FFE_DoctorVisit_Date4__c,FFE_DoctorVisit_Date5__c,
                      FFE_Medication_Date1__c,PAA_DesignerDrugs_Current_Use__c,PAA_DesignerDrugs_First_Use_Age__c,PAA_DesignerDrugs_Method_of_Use__c,FFE_PSA_Detox__c,PAA_Diagnosed_traumatic_brain_injury__c,FFE_Difficulty_falling_asleep__c,FFE_Difficulty_gratification_drug_explai__c,FFE_Difficulty_postponing_gratification__c,
                      FFE_Difficulty_staying_asleep__c,FFF_Does_client_have_cravings_Explain_1__c,FFE_Does_the_client_have_cravings__c,FFE_Does_the_client_live_where_Explain__c,FFE_Does_the_client_live_where_treatment__c,FFE_Does_their_environment_undermine_eff__c,FFE_Does_their_environment_undermine_Exp__c,FFE_Domestic_Violence_explain__c,
                      FFE_Domestic_Violence__c,PAA_Do_you_have_a_family_history_of_suic__c,PAA_Do_you_have_a_family_history_ofC__c,PAA_Do_you_have_any_allergies__c,PAA_Do_you_have_any_Homicidal_tendencies__c,PAA_Do_you_have_a_recent_history_of_assa__c,PAA_Do_you_have_a_recent_history_ofC__c,PAA_Do_you_use_insulin_injections__c,
                      Drug_Screen__c,PAA_DXM_Current_Use__c,PAA_DXM_First_Use_Age__c,PAA_DXM_Method_of_Use__c,FFE_Evaluation_End_Time__c,FFE_Evaluation_Start_Time__c,PAA_Explain_if_any_outstanding_legal_iss__c,PAA_Explain_self_injuroius_behaviour__c,PAA_family_history_of_mental_health_diso__c,PAA_Family_history_of_mental_health_disC__c,
                      FFE_Family_history_of_Psychatric__c,PAA_family_history_of_substance_abuse__c,FFE_Family_history_of_substance_abuse__c,PAA_family_history_of_substance_abuseC__c,FFE_family_history_of_substance_abuseC__c,PAA_If_family_mental_health_disorders_ex__c,FFE_Family_Psychiatric_Behavior_explain__c,FFE_LPA_For_how_long__c,
                      FFE_Gambling_Addiction_Does_the_client_h__c,FFE_Gambling_Addiction_Explain__c,PAA_Hallucinogens_Current_Use__c,PAA_Hallucinogens_First_Use_Age__c,PAA_Hallucinogens_Method_of_Use__c,FFE_Has_patient_failed_lower_level_of_Ca__c,PAA_Have_any_following_medical_condition__c,PAA_Have_you_engage_in_self_injurious__c,
                      FFE_Have_you_ever_been_DX_with_MH_issues__c,FFE_MH_Height__c,PAA_Heroin_Current_Use__c,PAA_Heroin_First_Use_Age__c,PAA_Heroin_Method_of_Use__c,PAA_History_of_arson_or_fire_setting__c,PAA_History_of_arson_or_fire_settingC__c,FFE_PSA_Home_group__c,PAA_How_many_times_you_been_to_treatment__c,PAA_How_old_are_you__c,
                      PAA_If_Allergies_explain__c,PAA_If_attempted_suicide_explain__c,PAA_If_family_history_of_suicide_explain__c,PAA_If_family_substance_abuse_Explain__c,PAA_If_history_of_arson_or_fire_setting__c,PAA_If_Involuntary_psychiatric_hold_51_5__c,PAA_If_physician_for_pain_management__c,PAA_If_recently_hospitalized_surgery_exp__c,
                      PAA_If_taking_medications_which__c,PAA_If_we_need_PHI_consent_explain__c,PAA_If_Yes_Homicidal_tendencies__c,PAA_If_Yes_Medical_condition_seizures_tu__c,PAA_If_you_have_a_recent_history_of_assa__c,FFE_If_you_have_DX_with_MH_issues_explai__c,FFE_PMH_Inpatient__c,PAA_Insufflate_Current_Use__c,PAA_Insufflate_First_Use_Age__c,
                      PAA_Insufflate_Method_of_Use__c,PAA_Intake_Date_and_Time__c,PAA_involuntary_psychiatric_hold__c,PAA_Involuntary_psychiatric_hold_51_50C__c,FFE_PSA_IOP__c,FFE_PMH_IOP__c,FFE_is_client_purging__c,FFE_is_client_purging_How_long_Explain__c,FFE_Legal_Issues__c,FFE_Legal_Issues_explain__c,
                      FFE_Legal_Issues_PO_Involved_ROI_Signed__c,FFE_Lives_With__c,PAA_Longest_period_of_sobriety__c,FFE_ls_client_restricting_food__c,PAA_Marijuana_Current_Use__c,PAA_Marijuana_First_Use_Age__c,PAA_Marijuana_Method_of_Use__c,FFE_Marital_Status__c,PAA_Medical_condition_seizures_tube__c,
                      PAA_Medical_condition_seizuresC__c,FFE_Medical_History__c,FFE_Medication_Date_10__c,FFE_Medication_Date_2__c,FFE_Medication_Date_3__c,FFE_Medication_Date_4__c,FFE_Medication_Date_5__c,FFE_Medication_Date_6__c,FFE_Medication_Date_7__c,FFE_Medication_Date_8__c,FFE_Medication_Date_9__c,
                      PAA_Methamphetamine_Current_Use__c,PAA_Methamphetamine_First_Use_Age__c,PAA_Methamphetamine_Method_of_Use__c,PAA_Method_of_payment__c,Most_Recent_Hospital_Doctor_visitsC__c,FFE_Medication_Name1__c,FFE_Medication_Name2__c,FFE_Medication_Name3__c,FFE_Medication_Name4__c,
                      FFE_Medication_Name5__c,FFE_Medication_Name6__c,FFE_Medication_Name7__c,FFE_Medication_Name8__c,FFE_Medication_Name9__c,FFE_Medication_Name10__c,PAA_Notes_Other_Dangerous_Behaviors__c,PAA_notice_to_you_employer_seeking_Expl__c,PAA_notice_to_you_employer_seeking_subst__c,
                      PAA_Notice_to_you_employer_seekingC__c,FFE_Number_of_Children__c,FFE_PSA_OP__c,FFE_PMH_OP__c,PAA_OtherOpiates_Current_Use__c,PAA_OtherOpiates_First_Use_Age__c,PAA_OtherOpiates_Method_of_Use__c,PAA_Other_Pre_Admission_Notes__c,FFE_Other_Trauma__c,FFE_Other_Trauma_explain__c,
                      FFE_Patient_failed_lower_level_of_Care_e__c,FFE_Perpetrator__c,FFE_Perpetrator_explain__c,FFE_PSA_PHP__c,FFE_PMH_PHP__c,PAA_Physician_for_pain_Management__c,PAA_Physician_for_pain_ManagementC__c,PAA_Date__c,FFE_Precipitating_Crisis__c,PAA_Precipitating_Event_for_Entering_Tre__c,
                      FFE_Presently_in_recovery_from_an_eating__c,PAA_Previous_Treatment_Notes__c,FFE_Prior_IMP_Psychiatric_TX__c,FFE_Prior_IMP_Psychiatric_TX_Explain__c,FFE_Prior_Mental_Health_Dates__c,PAA_Prior_Mental_Health_DatesC__c,Prior_Substance_abuse_treatment_with_dat__c,PAA_Prior_Substance_abuse_treatmentC__c,
                      FFE_Prior_Suicide_attempts_Explain__c,FFE_Prior_Suicide_attempts__c,PAA_Program_Cost_Quoted_to_Client__c,FFE_SPA_Psychiatrist__c,FFE_PMH_Psychiatrist__c,FFE_PMH_Psychologist__c,FFE_Psychotropic_Meds_Explain__c,FFE_Psychotropic_Meds__c,FFE_SPA_Psychologist__c,Pulse__c,FFE_Reason_for_Visit1__c,FFE_Reason_for_Visit2__c,
                      FFE_Reason_for_Visit3__c,Reason_for_Visit4__c,FFE_Reason_for_Visit5__c,PAA_Recently_hospitalized_recent_surgery__c,PAA_Recently_hospitalized_recent_surgerC__c,FFE_PSA_Rehab_Res__c,FFE_PMH_Rehab_Res__c,FFE_Relationship__c,FFE_Report_Filed_Perpetrator__c,Respirations__c,FFE_MH_Seizures__c,
                      FFE_Self_Mutilating_Behaviour_Explain__c,FFE_Self_Mutilating_Behaviour__c,FFE_Severity_dysfuntional_behaviors__c,FFE_Sexual_Behavior_Relational_issues_Re__c,FFE_Sexual_Behavior_Acting_Out__c,FFE_Sexual_Behavior_Acting_Out_Explain__c,FFE_Sexual_Behavior_Recovry_Explain__c,PAA_Sexual_offenses_involving_assault_mi__c,
                      FFE_Sleep__c,FFE_Sober_Support_System__c,FFE_PSA_Sponsor__c,Status__c,PAA_Suicidal_Tendencies__c,PAA_Suicidal_tendencies_2_or_less__c,PAA_TmzpmHlcn_Current_Use__c,PAA_TmzpmHlcn_First_Use_Age__c,PAA_TmzpmHlcn_Method_of_Use__c,FFE_Temperature__c,PAA_TrqlzBzpsFrstUsAge__c,PAA_TrqlzBzpsCrrntUse__c,PAA_TrqlzBzpsMthdofUse__c,
                      FFE_DoctorVisit_Treatment1__c,FFE_DoctorVisit_Treatment2__c,FFE_DoctorVisit_Treatment3__c,FFE_DoctorVisit_Treatment4__c,FFE_DoctorVisit_Treatment5__c,PAA_Treatment_Duration_1__c,PAA_Treatment_Duration_2__c,PAA_Treatment_Duration_3__c,PAA_Treatment_Facility_Name_1__c,PAA_Treatment_Facility_Name_2__c,PAA_Treatment_Facility_Name_3__c,
                      PAA_Treatment_length_in_days__c,PAA_Treatment_Level_of_Care_1__c,PAA_Treatment_Level_of_Care_2__c,PAA_Treatment_Level_of_Care_3__c,PAA_triggers_to_using_Sobriety__c,FFE_Ultimatum_given__c,PAA_ve_consequence_to_your_drug_alcohol__c,FFE_Victim_of_Abuse__c,FFE_Victim_of_Abuse_explain__c,FFE_Violence_Homicidal_Ideations__c,
                      FFE_Violence_Homicidal_Ideations_explain__c,FFE_MH_Weight__c,PAA_We_need_PHI_consent__c,PAA_We_need_PHI_consentC__c,PAA_What_is_you_current_living_arrangem__c,PAA_What_is_your_current_height_and_weig__c,FFE_What_serious_consequences_client_lif__c,PAA_What_substance_s_do_you_currently_us__c,FFE_LPA_When__c,
                      PAA_When_last_saw_a_doctor_and_why__c,FFE_Who_Brought_you_to_treatment__c,FFE_Who_Will_be_involved_in_treatment__c,PAA_Withdrawal_Symptoms__c,PAA_Withdrawal_Symptoms_Notes__c 
                      from Clinical_Evaluation__c where Client_Chart__c =:recId ];*/
        lstCEs = [Select id, Client_Chart__r.Name, Recordtype.name, Status__c, PAA_Date__c,Client_Chart__c, Due_Date_Time__c, (Select Id, SignedBy__c,Staff_Signature_URL_Closed__c, Staff_Closed_Date__c, Client_Image_Url_Closed__c, Staff_Signed_User_Closed__c  from Clinical_Evaluations_3__r order by CreatedDate DESC Limit 1) from Clinical_Evaluation__c where Client_Chart__c =:recId AND recordType.name != 'Phsych Evaluation'];
        lstCE2 = [select id, Client_Chart__r.Name, Recordtype.name, Client_Chart__c,(Select Id,Name,HP_Status__c,HP_Evaluation_Date__c, due_date_time__c, Staff_Signature_URL_Closed__c, Staff_Closed_Date__c, SignedBy__c, Client_Image_Url_Closed__c, Staff_Signed_User_Closed__c, Intern_Signed_User__c from Clinical_Evaluations_3__r order by CreatedDate DESC Limit 1) from Clinical_Evaluation_2__c where Client_Chart__c =:recId];
        lstCE3 = [select id, Client_Chart__r.Name, Recordtype.name,HP_Status__c,HP_Evaluation_Date__c, Client_Chart__c, due_date_time__c, Staff_Signature_URL_Closed__c, Staff_Closed_Date__c, SignedBy__c from Clinical_Evaluation_3__c where recordtype.name!='Bio-Psychosocial Assessment' AND Client_Chart__c =:recId];
        mapOfCEs = new map<string, Clinical_Evaluation__c>();
        for(Clinical_Evaluation__c CE:lstCEs)
        {
            mapOfCEs.put(CE.Id, CE);
        }
    }
}