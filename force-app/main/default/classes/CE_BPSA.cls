//Test Class : CE_BPSA_Test
public class CE_BPSA {
    
    public string ClientID {get; set;}
    public string ceID {get; set;}
    public string RecordtypeName {get; set;}
    
    public boolean isEdit{get; set;}
    public boolean RenderAttemptToDiscontinue {get; set;}
    public boolean RenderClientPhysician {get; set;}
    public boolean RenderClientHistoryMedCond {get; set;}
    public boolean RenderClientFamilyHistoryMedCond {get; set;}
    public boolean RenderSexuallyAbusedDrugRelated {get; set;}
    public boolean RenderAbusedRelation {get; set;}
    public boolean RenderTraumaHistory {get; set;}
    public boolean RenderTraumaInterfere {get; set;}
    public boolean RenderSuicideThought {get; set;}
    public boolean RenderSuicideAttempt {get; set;}
    public boolean RenderFamilySupport {get; set;}
    public boolean RenderFamilyDependent {get; set;}
    public boolean RenderMentalAssessment {get; set;}
    public boolean RenderExtMotivated {get; set;}
    public boolean RenderGamblingHistory {get; set;}
    public boolean RenderAddictiveBehvr {get; set;}
    public boolean RenderClientRcvSubsAbuse {get; set;}
    public boolean RenderClientHasSiblings {get; set;}
    public boolean RenderHistorySubsAbuse {get; set;}
    public boolean RenderSignificantRelation {get; set;}
    public boolean RenderNoRelationShip {get; set;}
    public boolean RenderChildren {get; set;}
    public boolean RenderSatisfiedChildren {get; set;}
    public boolean RenderPPPCSubsAbuse {get; set;}
    public boolean RenderClientRaisedSpecCulture {get; set;}
    public boolean RenderClientPracticeSpecCulture {get; set;}
    public boolean RenderClientIdentifySpecCulture {get; set;}
    public boolean RenderClientIdentifySpeclCulture {get; set;}
    public boolean RenderClientProblemInteracting {get; set;}
    public boolean RenderClientInvolveLegalCrime {get; set;}
    public boolean RenderClientHaveLegalCrime {get; set;}
    public boolean RenderIncarcerationHistory {get; set;}
    public boolean RenderOweRestitution {get; set;}
    public boolean RenderEnrolledSchool {get; set;}
    public boolean RenderExpelledFromSchool {get; set;}
    public boolean RenderSpecialClasses {get; set;}
    public boolean RenderFutureEduGoals {get; set;}
    public boolean RenderMilitaryService {get; set;}
    public boolean RenderEmploymentHistory {get; set;}
    public boolean RenderNeedVocationalTraining {get; set;}
    public boolean RenderRcvVocationalTraining {get; set;}
    public boolean RenderExistingPosSupport {get; set;}
    public boolean RenderConductiveEnviron {get; set;}
    public boolean RenderEngageSubsFree {get; set;}
    public boolean RenderSpiritualPryMed {get; set;}
    public boolean RenderSpiritualGoals {get; set;}
    public boolean RenderSpiritualPracticeRel {get; set;}
    public boolean RenderSpiritualTypes {get; set;}
    public boolean RenderInterviewFamily1 {get; set;}
    public boolean RenderInterviewFamily2 {get; set;}
    public boolean RenderInterviewFamily3 {get; set;}
    public boolean RenderInterviewFamily4 {get; set;}
    public boolean callJS {get; set;}
    
    public integer ImpairementAndSeverityTotalScore {get; set;}
    
    public Clinical_Evaluation_2__c ceRecord1 {get; set;}
    public Clinical_Evaluation_3__c ceRecord2 {get; set;}
    public Client_Chart__c clientChart {get;set;}
    
    //AWS
    public string accessKeyId {get; set;}
    public string secretAccessKey {get; set;}
    public string OrgName {get; set;}
    final string AWSURL;
    
     //hidden field
    public string SelectedSignedOption {get; set;}
    public string ImageUrlAddress {get; set;}
    
    public User userObj {get; set;}
    
    public CE_BPSA()
    {
        system.debug('#Edit='+isEdit);
        ClientID = ApexPages.CurrentPage().getParameters().get('id');
        ceID = ApexPages.CurrentPage().getParameters().get('ceId');
        Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation_2__c.getRecordTypeInfosByName().get('Bio-Psychosocial Assessment').getRecordTypeId();
        ImpairementAndSeverityTotalScore = ImpairementAndSeverityTotalScore!=null? ImpairementAndSeverityTotalScore : 0;
        RecordTypeName = ApexPages.CurrentPage().getParameters().get('type');
        ceRecord1 = new Clinical_Evaluation_2__c();
        ceRecord2 = new Clinical_Evaluation_3__c();
        
        callJS = false;
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        if(ClientID != null)
            clientChart = [SELECT id, RecordType.name 
                           FROM Client_Chart__c WHERE id = :clientId limit 1];
        
        if(ceID == null)
        {
            ceRecord1 = new Clinical_Evaluation_2__c();
            ceRecord1.Client_Chart__c = ClientID;
            ceRecord1.RecordtypeId = BPSARecordTypeId;
            ceRecord2 = new Clinical_Evaluation_3__c();
            ceRecord2.HP_Status__c = 'In Progress';
            //ceRecord2.HP_Evaluation_Date__c = System.today();
        }
        else if(ceID != null && RecordtypeName =='Bio-Psychosocial Assessment')
        {
            ceRecord1 = [select id, AA_NA_exp__c,Addiction_History_and_Consequences__c,Age_of_1st_use_of_any_drug__c,Alcohol_drug_abuse_NA__c,Alcohol_drug_abuse_NO__c,Alcohol_drug_abuse_YES__c,
                                Are_they_supportive_in_treatment__c,ASSESS_OF_MENTAL_AFFECT_Appropriate__c,ASSESS_OF_MENTAL_AFFECT_Flat__c,ASSESS_OF_MENTAL_AFFECT_Inappropriate__c,ASSESS_OF_MENTAL_APPEAR_Clean__c,
                                ASSESS_OF_MENTAL_APPEAR_Disheveled__c,ASSESS_OF_MENTAL_MOOD_Happy__c,ASSESS_OF_MENTAL_MOOD_Labile__c,At_what_age_client_enter_system__c,Barriers_Lack_Of_Safe_Env__c,
                                Barriers_lack_of_support__c,BARRIERS_TREATMENT_CULTURAL__c,BARRIERS_TREATMENT_EXTERNAL_FORCES__c,BARRIERS_TREATMENT_FAMILY_PRESSURES__c,BARRIERS_TREATMENT_FINANCIAL__c,
                                BARRIERS_TREATMENT_LANGUAGE__c,BARRIERS_TREATMENT_MEDICAL_CONDITION__c,BARRIERS_TREATMENT_OTHER__c,BARRIERS_TREATMENT_OUTSIDE_OBLIGATIONS__c,
                                BARRIERS_TREATMENT_PSYCHIATRIC_DIAGNOSIS__c,BPA_Does_Client_have_any_siblings__c,BPA_Where_was_Client_raised_and_by_whom__c,Check_all_always_same_sexual_orientation__c,
                                Check_all_history_of_being_raped__c,Check_all_history_of_gender_id_issue__c,Check_all_history_of_HIV_risk_behavior__c,Check_all_history_of_illegal_sexual_acts__c,
                                Check_all_history_of_incestuous_relation__c,Check_all_history_of_prostitution__c,Check_all_history_of_safe_sex__c,Check_all_history_of_sexual_abuse__c,
                                Check_all_history_of_sexual_molestation__c,Check_all_NONE__c,Children_Age_1__c,Children_Age_2__c,Children_Age_3__c,Children_Age_4__c,Children_Age_5__c,
                                Children_Name_1__c,Children_Name_2__c,Children_Name_3__c,Children_Name_4__c,Children_Name_5__c,Children_Participatory_Parent_1__c,Children_Participatory_Parent_2__c,
                                Children_Participatory_Parent_3__c,Children_Participatory_Parent_4__c,Children_Participatory_Parent_5__c,Client_Additional_info_comments_life__c,
                                Client_attended_special_classes_NO__c,Client_attended_special_classes_YES__c,Client_consider_to_be_Follower__c,Client_consider_to_be_Lead_Fol_elab__c,
                                Client_consider_to_be_Leader__c,Client_currently_owe_restitution_NO__c,Client_enrolled_attending_school_NO__c,Client_enrolled_attending_school_YES__c,
                                Client_ever_been_incarcerated_NO__c,Client_ever_been_incarcerated_YES__c,Client_ever_employeed_NO__c,Client_ever_employeed_YES__c,Client_expelled_from_school_2year_NO__c,
                                Client_expelled_from_school_2year_YES__c,Client_have_high_school_diploma_NO__c,Client_have_high_school_diploma_YES__c,Client_have_problem_interacting_NO__c,
                                Client_have_problem_interacting_YES__c,Client_identify_special_culture_NO__c,Client_identify_special_culture_YES__c,Client_identify_specific_culture_NO__c,
                                Client_identify_specific_culture_YES__c,Client_need_specific_training_NO__c,Client_need_specific_training_YES__c,Client_practice_specific_culture_NO__c,
                                Client_practice_specific_culture_YES__c,Client_Raised_in_specific_culture_NO__c,Client_Raised_in_specific_culture_YES__c,Client_received_any_training_NO__c,
                                Client_recieved_any_training_YES__c,Client_satisfied_Relatnshp_Chldrn__c,Client_served_in_Military_NO__c,Client_served_in_Military_YES__c,
                                CLIENT_S_STRENGTHS_ABILITY_TO_BENEFIT__c,CLIENT_S_STRENGTHS_HAS_FINANCIAL_SUPPORT__c,CLIENT_S_STRENGTHS_HAS_OUTSIDE_SUPPORT__c,CLIENT_S_STRENGTHS_WILLINGNESS_TO_COMP__c,
                                CLIENT_S_STRENGTHS_WILLINGNESS_TO_SEEK__c,CLIENT_S_WEAKNESS_GRIEF_LOSS_ISSUES__c,CLIENT_S_WEAKNESS_INABILITY_RELATIONSHIP__c,CLIENT_S_WEAKNESS_LACK_COPING_SKILLS__c,
                                CLIENT_S_WEAKNESS_LOW_ABILITY_BENEFIT__c,CLIENT_S_WEAKNESS_LOW_SELF_ESTEEM__c,CLIENT_S_WEAKNESS_MULTI_TREATMENT_FAIL__c,CLIENT_S_WEAKNESS_POOR_IMPULSE__c,
                                CLIENT_S_WEAKNESS_POOR_MOTIVATION__c,ClientAdditional_info_comments_education__c,Client_Chart__c,Client_feel_gambling_is_issue__c,Client_have_gambling_history_NONE__c,
                                Client_have_gambling_history_YES__c,Client_other_Addictive_Behaviors_NONE__c,Client_other_Addictive_Behaviors_YES__c,Client_other_Addictive_Disorders_NONE__c,
                                Client_other_Addictive_Disorders_YES__c,Client_Owe_restitution_YES__c,Client_Rcv_Substance_abuse_NO__c,Client_receive_substance_abuse1_DATE__c,
                                Client_receive_substance_abuse1_DURATION__c,Client_receive_substance_abuse1_OUTCOME__c,Client_receive_substance_abuse1_PROVIDER__c,
                                Client_receive_substance_abuse1_TREATMNT__c,Client_receive_substance_abuse2_DATE__c,Client_receive_substance_abuse2_DURATION__c,Client_receive_substance_abuse2_OUTCOME__c,
                                Client_receive_substance_abuse2_PROVIDER__c,Client_receive_substance_abuse2_TREATMNT__c,Client_receive_substance_abuse3_DATE__c,Client_receive_substance_abuse3_DURATION__c,
                                Client_receive_substance_abuse3_OUTCOME__c,Client_receive_substance_abuse3_PROVIDER__c,Client_receive_substance_abuse3_TREATMNT__c,Client_receive_substance_abuse4_DATE__c,
                                Client_receive_substance_abuse4_DURATION__c,Client_receive_substance_abuse4_OUTCOME__c,Client_receive_substance_abuse4_PROVIDER__c,
                                Client_receive_substance_abuse4_TREATMNT__c,Client_substance_abuse_effect_hobbies__c,Client_trauma_interfere_Treatment_NONE__c,Client_trauma_interfere_Treatment_YES__c,
                                Client_treatment_for_eating_disorder_NO__c,Client_treatment_for_eating_disorder__c,CLINICAL_IMPRESSIONS_Impact_of_spirit__c,Cultural_challenge_affect_clientrecovery__c,
                                Cultural_environment_affect_client__c,Cultural_strength_affect_client_recovery__c,Current_Financial_Status__c,Currently_living_with__c,Current_social_environment__c,
                                DEPRESSANTS_ALCOHOL_Age_began_first_use__c,DEPRESSANTS_ALCOHOL_Amount_of_use__c,DEPRESSANTS_ALCOHOL_Last_time_used__c,DEPRESSANTS_ALCOHOL_Route__c,
                                DEPRESSANTS_ALCOHOL_Frequency_of_use__c,DEPRESSANTS_BARBIT_Age_began_first_use__c,DEPRESSANTS_BARBIT_Amount_of_use__c,DEPRESSANTS_BARBIT_Frequency_of_use__c,
                                DEPRESSANTS_BARBIT_Last_time_used__c,DEPRESSANTS_BARBIT_Route__c,DEPRESSANTS_QUAALUDE_Age_began_first_use__c,DEPRESSANTS_QUAALUDE_Amount_of_use__c,
                                DEPRESSANTS_QUAALUDE_Frequency_of_use__c,DEPRESSANTS_QUAALUDE_Last_time_used__c,DEPRESSANTS_QUAALUDE_Route__c,Describe_your_sexual_orientation__c,
                                Does_this_person_use_alcohol_drugs__c,Drug_Craving_0_10__c,Eating_Disorders_Anorexia_Nervosa__c,Eating_Disorders_Bulimia_Nervosa__c,Eating_Disorders_Denied__c,
                                Eating_Disorders_Over_Eating__c,Eating_Disorder_Still_Issue__c,Eating_Disorder_Still_Issue_YES__c,Employment_History_NONE__c,Employment_History1_Employment_Dates__c,
                                Employment_History1_Job_Position__c,Employment_History1_Reason_for_Leaving__c,Employment_History1_Salary__c,Employment_History2_Employment_Dates__c,
                                Employment_History2_Job_Position__c,Employment_History2_Reason_for_Leaving__c,Employment_History2_Salary__c,Employment_History3_Employment_Dates__c,
                                Employment_History3_Job_Position__c,Employment_History3_Reason_for_Leaving__c,Employment_History3_Salary__c,Employment_History4_Employment_Dates__c,
                                Employment_History4_Job_Position__c,Employment_History4_Reason_for_Leaving__c,Employment_History4_Salary__c,Family_Dependent_on_Treatment_NONE__c,
                                Family_Dependent_on_Treatment_YES__c,Family_Supports_In_Treatment_NONE__c,Family_Supports_In_Treatment_YES__c,HALLUCIN_ECSTASY_Age_began_first_use__c,
                                HALLUCIN_ECSTASY_Amount_of_use__c,HALLUCIN_ECSTASY_Frequency_of_use__c,HALLUCIN_ECSTASY_Last_time_used__c,HALLUCIN_ECSTASY_Route__c,HALLUCIN_LSD_Acid_Age_began_first_use__c,
                                HALLUCIN_LSD_Acid_Amount_of_use__c,HALLUCIN_LSD_Acid_Frequency_of_use__c,HALLUCIN_LSD_Acid_Last_time_used__c,HALLUCIN_LSD_Acid_Route__c,
                                HALLUCIN_MARIJUANA_Age_began_first_use__c,HALLUCIN_MARIJUANA_Amount_of_use__c,HALLUCIN_MARIJUANA_Frequency_of_use__c,HALLUCIN_MARIJUANA_Last_time_used__c,
                                HALLUCIN_MARIJUANA_Route__c,HALLUCIN_OTHER_Age_began_first_use__c,HALLUCIN_OTHER_Amount_of_use__c,HALLUCIN_OTHER_Frequency_of_use__c,HALLUCIN_OTHER_Last_time_used__c,
                                HALLUCIN_OTHER_Route__c,HALLUCIN_PCP_Age_began_first_use__c,HALLUCIN_PCP_Amount_of_use__c,HALLUCIN_PCP_Frequency_of_use__c,HALLUCIN_PCP_Last_time_used__c,
                                HALLUCIN_PCP_Route__c,Highest_grade_degree_obtained__c,History_of_Children_Criminal_Involvement__c,History_of_Children_Mental_Health_Prob__c,History_of_Children_None__c,
                                History_of_Children_Substance_Abuse__c,History_of_Father_Criminal_Involvement__c,History_of_Father_MentalHealthProb__c,History_of_Father_None__c,
                                History_of_Father_SubstanceAbuse__c,History_of_Mother_Criminal_Involvement__c,History_of_Mother_MentalHealthProb__c,History_of_Mother_None__c,
                                History_of_Mother_SubstanceAbuse__c,History_of_Other_CriminalInvolve__c,History_of_Other_None__c,History_of_Other_Subs_Abuse__c,History_of_Partner_Criminal_Involvement__c,
                                History_of_Partner_Mental_Health_Problem__c,History_of_Partner_None__c,History_of_Partner_Substance_Abuse__c,History_of_Past_Partner_Criminal_Invest__c,
                                History_of_Past_Partner_MentalHealthProb__c,History_of_Past_Partner_None__c,History_of_Past_Partner_Substance_Abuse__c,History_of_Sibling_Criminal_Involve__c,
                                History_of_Sibling_MentalHealthProb__c,History_of_Siblings_None__c,History_of_Siblings_Subs_Abuse__c,History_of_Step_Parent_CriminalInvolve__c,
                                History_of_Step_Parent_MentlHelthProb__c,History_of_Step_Parent_None__c,History_of_Step_Parent_SubsAbuse__c,History_of_other_metal_problem__c,History_of_Subs_abuse__c,
                                History_of_Subs_abuse_NO__c,How_did_the_family_get_along_relate_to__c,How_client_supporting_their_alcohol_use__c,How_long_Client_used_Drugs_of_Choice_1__c,
                                How_long_has_this_problem_been_going_on__c,How_much_Client_used_Drugs_of_Choice_1__c,How_much_Drug_is_used_in_past_10_days__c,How_much_Drug_is_used_in_past_20_hour__c,
                                How_much_Drug_is_used_in_past_70_hour__c,If_involved_in_a_significant_rela__c,If_no_to_any_of_the_above_P_PP_C__c,If_Relationship_is_Client_satisfied_wit__c,
                                If_Yes_HIstory_of_MotherFathrSiblngOth__c,If_yes_to_any_of_the_above_P_PP_C__c,Incarceration_History_NONE__c,Incarceration_History1_Charges__c,
                                Incarceration_History1_Date__c,Incarceration_History1_Disposition__c,Incarceration_History1_Duration_Location__c,Incarceration_History2_Charges__c,
                                Incarceration_History2_Date__c,Incarceration_History2_Disposition__c,Incarceration_History2_Duration_Location__c,Incarceration_History3_Charges__c,
                                Incarceration_History3_Date__c,Incarceration_History3_Dispositon__c,Incarceration_History3_Duration_Location__c,Incarceration_History4_Charges__c,
                                Incarceration_History4_Date__c,Incarceration_History4_Disposition__c,Incarceration_History4_Duration_Location__c,Incarceration_History5_Charges__c,
                                Incarceration_History5_Date__c,Incarceration_History5_Disposition__c,Incarceration_History5_Duration_Location__c,INTERVIEW_WITH_SIGN_FAMILY_MEMBER_1_NO__c,
                                INTERVIEW_WITH_SIGN_FAMILY_MEMBER_1_YES__c,INTERVIEW_WITH_SIGN_FAMILY_MEMBER_2_NO__c,INTERVIEW_WITH_SIGN_FAMILY_MEMBER_2_WHY__c,INTERVIEW_WITH_SIGN_FAMILY_MEMBER_2_YES__c,
                                INTERVIEW_WITH_SIGN_FAMILY_MEMBER_3_NO__c,INTERVIEW_WITH_SIGN_FAMILY_MEMBER_3_YES__c,INTERVIEW_WITH_SIGN_FAMILY_MEMBER_4_NO__c,INTERVIEW_WITH_SIGN_FAMILY_MEMBER_4_YES__c,
                                INTERVIEW_WITH_SIGN_FAMILY_MEMBER_5_NO__c,INTERVIEW_WITH_SIGN_FAMILY_MEMBER_5_YES__c,Is_Client_involved_in_a_significant_rela__c,Is_Client_satisfied_relationship_Chld__c,
                                Ivolved_in_abusive_relationship_elab__c,LegalHistory_Client_Crime_History_NO__c,LegalHistory_Client_Crimnal_History_YES__c,LegalHistory_Client_involve_in_Crime_NO__c,
                                LegalHistory_Client_involve_in_Crime_YES__c,Length_of_time_of_the_last_RUN__c,List_Drugs_of_Choice_1__c,List_Drugs_of_Choice_2__c,List_Drugs_of_Choice_3__c,
                                List_Drugs_of_Choice_4__c,List_hobbies_enjoyed_by_Client__c,Military_Service_Benefits_Recieved__c,Military_Service_Branch__c,Military_Service_Length_of_Service__c,
                                Military_Service_NONE__c,Military_Service_Type_of_Discharge__c,No_2_All_HIstory_of_MotherFathrSiblngOth__c,No_Children__c,No_Relationship__c,
                                OPIATES_DILAUDID_Age_began_first_use__c,OPIATES_DILAUDID_Amount_of_use__c,OPIATES_DILAUDID_Frequency_of_used__c,OPIATES_DILAUDID_Last_time_used__c,OPIATES_DILAUDID_Route__c,
                                OPIATES_HEROINE_Age_began_first_use__c,OPIATES_HEROINE_Amount_of_use__c,OPIATES_HEROINE_Frequency_of_use__c,OPIATES_HEROINE_Last_time_used__c,OPIATES_HEROINE_Route__c,
                                OPIATES_METHADONE_Age_began_first_use__c,OPIATES_METHADONE_Amount_of_use__c,OPIATES_METHADONE_Frequency_of_use__c,OPIATES_METHADONE_Last_time_used__c,
                                OPIATES_METHADONE_Route__c,OPIATES_OTHER_Age_began_first_use__c,OPIATES_OTHER_Amount_of_use__c,OPIATES_OTHER_Frequency_of_use__c,OPIATES_OTHER_Last_time_used__c,
                                OPIATES_OTHER_Route__c,OPIATES_PERCODAN_Age_began_first_use__c,OPIATES_PERCODAN_Amount_of_use__c,OPIATES_PERCODAN_Frequency_of_use__c,OPIATES_PERCODAN_Last_time_used__c,
                                OPIATES_PERCODAN_Route__c,OPIATES_VICODIN_Age_began_first_use__c,OPIATES_VICODIN_Amount_of_use__c,OPIATES_VICODIN_Frequency_of_use__c,OPIATES_VICODIN_Last_time_used__c,
                                OPIATES_VICODIN_Route__c,OTHER_DRUGS_TYPE1_Age_began_first_use__c,OTHER_DRUGS_TYPE1_Amount_of_use__c,OTHER_DRUGS_TYPE1_Frequency_of_use__c,
                                OTHER_DRUGS_TYPE1_Last_time_used__c,OTHER_DRUGS_TYPE1_Route__c,OTHER_DRUGS_TYPE2_Age_began_first_use__c,OTHER_DRUGS_TYPE2_Amount_of_use__c,
                                OTHER_DRUGS_TYPE2_Frequency_of_use__c,OTHER_DRUGS_TYPE2_Last_time_used__c,OTHER_DRUGS_TYPE2_Route__c,OTHER_DRUGS_TYPE3_Age_began_first_use__c,
                                OTHER_DRUGS_TYPE3_Amount_of_use__c,OTHER_DRUGS_TYPE3_Frequency_of_use__c,OTHER_DRUGS_TYPE3_Last_time_used__c,OTHER_DRUGS_TYPE3_Route__c,
                                OTHER_DRUGS_TYPE4_Age_began_first_use__c,OTHER_DRUGS_TYPE4_Amount_of_use__c,OTHER_DRUGS_TYPE4_Frequency_of_use__c,OTHER_DRUGS_TYPE4_Last_time_used__c,
                                OTHER_DRUGS_TYPE4_Route__c,Problems_affect_client_hobbies_INTEREST__c,Problems_affect_client_hobbies_JOB__c,Problems_affect_client_hobbies_MONEY__c,
                                Problems_affect_client_hobbies_NO_TIME__c,Problems_affect_client_hobbies_OTHER__c,Problems_affect_client_hobbies_PHYSICAL__c,Problems_affect_client_hobbies_TIME__c,
                                Problems_affect_client_hobbies_TRANSPORT__c,RECOVERY_ENVIRON_ADDITIONAL_INFO__c,RECOVERY_ENVIRON_CLIENT_VE_SUPPORT_NO__c,RECOVERY_ENVIRON_CLIENT_VE_SUPPORT_YES__c,
                                RECOVERY_ENVIRON_CLIENT_LEISURE_NO__c,RECOVERY_ENVIRON_CLIENT_LEISURE_YES__c,RECOVERY_ENVIRON_CLIENT_LIVING_ENVIR_NO__c,RECOVERY_ENVIRON_CLIENT_LIVING_ENVIR_YES__c,
                                RECOVERY_ENVIRON_STRENGTH_DOES_CLIENT__c,RELAPSE_HISTORY__c,Sexual_abuse_NO__c,Sexual_abuse_YES__c,Sibling_Age1__c,Sibling_Age2__c,Sibling_Age3__c,Sibling_Age4__c,
                                Sibling_Age5__c,Sibling_Name1__c,Sibling_Name2__c,Sibling_Name3__c,Sibling_Name4__c,Sibling_Name5__c,Sibling_Grewup_Together1__c,Sibling_Grewup_Together2__c,
                                Sibling_Grewup_Together3__c,Sibling_Grewup_Together4__c,Sibling_Grewup_Together5__c,SPIRITUALITY_ASSESS_10_a_Compro_ValueSys__c,SPIRITUALITY_ASSESS_10_Drug_of_Choice__c,
                                SPIRITUALITY_ASSESS_Believe_in_God__c,SPIRITUALITY_ASSESS_Describe_Philosophy__c,SPIRITUALITY_ASSESS_Express_Spirituality__c,SPIRITUALITY_ASSESS_Faith_help_cope_prob__c,
                                SPIRITUALITY_ASSESS_Practice_Religion_NO__c,SPIRITUALITY_ASSESS_Practice_ReligionYES__c,SPIRITUALITY_ASSESS_Prayer_meditation_NO__c,
                                SPIRITUALITY_ASSESS_Prayer_meditationYES__c,SPIRITUALITY_ASSESS_Role_of_Church__c,SPIRITUALITY_ASSESS_Spiritual_Goals_NO__c,SPIRITUALITY_ASSESS_Spiritual_Goals_YES__c,
                                SPIRITUALITY_ASSESS_Type_of_Spiritual_NO__c,SPIRITUALITY_ASSESS_Type_of_SpiritualYES__c,SPIRITUALITY_ASSESS_Who_provides_hope__c,STEP_INVOLVEMENT__c,
                                STIMULANTS_AMPHETA_Age_began_first_use__c,STIMULANTS_AMPHETA_Amount_of_use__c,STIMULANTS_AMPHETA_Frequency_of_use__c,STIMULANTS_AMPHETA_Last_time_used__c,
                                STIMULANTS_AMPHETA_Route__c,STIMULANTS_CAFFEINE_Age_began_first_use__c,STIMULANTS_CAFFEINE_Amount_of_use__c,STIMULANTS_CAFFEINE_Frequency_of_use__c,
                                STIMULANTS_CAFFEINE_Last_time_used__c,STIMULANTS_CAFFEINE_Route__c,STIMULANTS_COCAINE_Age_began_first_use__c,STIMULANTS_COCAINE_Amount_of_use__c,
                                STIMULANTS_COCAINE_Frequency_of_use__c,STIMULANTS_COCAINE_Last_time_used__c,STIMULANTS_COCAINE_Route__c,STIMULANTS_CRACK_Age_began_first_use__c,
                                STIMULANTS_CRACK_Amount_of_use__c,STIMULANTS_CRACK_Frequency_of_use__c,STIMULANTS_CRACK_Last_time_used__c,STIMULANTS_CRACK_Route__c,
                                STIMULANTS_INHALANTS_Age_began_first_use__c,STIMULANTS_INHALANTS_Amount_of_use__c,STIMULANTS_INHALANTS_Frequency_of_use__c,STIMULANTS_INHALANTS_Last_time_used__c,
                                STIMULANTS_INHALANTS_Route__c,STIMULANTS_METH_Age_began_first_use__c,STIMULANTS_METH_Amount_of_use__c,STIMULANTS_METH_Frequency_of_use__c,STIMULANTS_METH_Last_time_used__c,
                                STIMULANTS_METH_Route__c,STIMULANTS_NICOTINE_Age_began_first_use__c,STIMULANTS_NICOTINE_Amount_of_use__c,STIMULANTS_NICOTINE_Frequency_of_use__c,
                                STIMULANTS_NICOTINE_Last_time_used__c,STIMULANTS_NICOTINE_Route__c,STIMULANTS_SPEED_Age_began_first_use__c,STIMULANTS_SPEED_Amount_of_use__c,
                                STIMULANTS_SPEED_Frequency_of_use__c,STIMULANTS_SPEED_Last_time_used__c,STIMULANTS_SPEED_Route__c,Suicide_Screening_Attempts_NONE__c,Suicide_Screening_Thoughts_NONE__c,
                                Suicide_Screening_Thoughts_YES__c,Suicide_Attempt_text__c,TIME_ABSTINENT_FROM_PRIOR_TREATMENT__c,TRANQUILIZER_LIBRIUM_Age_began_first_use__c,
                                TRANQUILIZER_LIBRIUM_Amount_of_use__c,TRANQUILIZER_LIBRIUM_Frequency_of_use__c,TRANQUILIZER_LIBRIUM_Last_time_used__c,TRANQUILIZER_LIBRIUM_Route__c,
                                TRANQUILIZER_OTHER_Age_began_first_use__c,TRANQUILIZER_OTHER_Amount_of_use__c,TRANQUILIZER_OTHER_Frequency_of_use__c,TRANQUILIZER_OTHER_Last_time_used__c,
                                TRANQUILIZER_OTHER_Route__c,TRANQUILIZER_VALIUM_Age_began_first_use__c,TRANQUILIZER_VALIUM_Amount_of_use__c,TRANQUILIZER_VALIUM_Frequency_of_use__c,
                                TRANQUILIZER_VALIUM_Last_time_used__c,TRANQUILIZER_VALIUM_Route__c,TRANQUILIZER_XANAX_Age_began_first_use__c,TRANQUILIZER_XANAX_Amount_of_use__c,
                                TRANQUILIZER_XANAX_Frequency_of_use__c,TRANQUILIZER_XANAX_Last_time_used__c,TRANQUILIZER_XANAX_Route__c,Trauma_Assess_History_of_Trauma_NONE__c,
                                Trauma_Assess_History_of_Trauma_YES__c,Trauma_Assessment_Checkbox1_YES__c,Trauma_Assessment_Checkbox2_YES__c,Trauma_Assessment_Checkbox3_YES__c,
                                Trauma_Assessment_Checkbox4_YES__c,Trauma_Assessment_Checkbox5_YES__c,Trauma_Assessment_Checkbox6_YES__c,Trauma_Assessment_Checkbox7_YES__c,
                                Trauma_Assessment_Checkbox8_YES__c,Trauma_Assessment_Checkbox9_YES__c,TREATMENT_RELAPSE_HISTORY_Describe__c,Treatment_Outcomes__c,TRTMNT_ACCEPT_Client_ext_motivated_NO__c,
                                TRTMNT_ACCEPT_Client_ext_motivatedYES__c,TRTMNT_ACCEPT_Client_int_motivated_NO__c,TRTMNT_ACCEPT_Client_int_motivated_YES__c,WHAT_PRECIPITING_EVENTS_LEADS_TO_RELAPSE__c,
                                Whom_does_Client_feel_closest_to_and_why__c, Client_Chart__r.Treatment_Center__r.Name, Client_Chart__r.Name
                                from Clinical_Evaluation_2__c where id=:ceID];
            
            ceRecord2 = [select id, due_date_time__c,Additional_Info_environment__c,Assessment_of_Mental_Status_Affect__c,Assessment_of_Mental_Status_Appearance__c,Assessment_of_Mental_Status_Behaviour__c,
                                Assessment_of_Mental_Status_Check__c,Assessment_of_Mental_Status_Insight__c,Assessment_of_Mental_Status_Judgement__c,Assessment_of_Mental_Status_Mood__c,
                                Assessment_of_Mental_Status_Orient__c,Assessment_of_Mental_Status_Orient_None__c,Assessment_of_Mental_Status_Text__c,ASSESS_OF_MENTAL_BEHAVIOR_Cooperative__c,
                                ASSESS_OF_MENTAL_BEHAVIOR_Uncooperative__c,ASSESS_OF_MENTAL_INSIGHT_Fair__c,ASSESS_OF_MENTAL_INSIGHT_Good__c,ASSESS_OF_MENTAL_INSIGHT_Immature__c,
                                ASSESS_OF_MENTAL_INSIGHT_Mature__c,ASSESS_OF_MENTAL_INSIGHT_Poor__c,ASSESS_OF_MENTAL_MOOD_Angry__c,ASSESS_OF_MENTAL_MOOD_Anxious__c,ASSESS_OF_MENTAL_MOOD_Depressed__c,
                                ASSESS_OF_MENTAL_MOOD_Sad__c,ASSESS_OF_MENTAL_ORIENTATION_None__c,ASSESS_OF_MENTAL_ORIENTATION_Person__c,Attempt_to_discontinue_cut_back_on_subs__c,
                                Attempt_to_discontinue_Circumstances__c,BPSA_Withdrawal_symptoms__c,Cleint_existing_Positive_Supp_Sys_NO__c,Cleint_existing_Positive_Supp_Sys_Txt__c,
                                CLIENT_S_PERCEPTION_LIABILITY_1__c,CLIENT_S_PERCEPTION_LIABILITY_2__c,CLIENT_S_PERCEPTION_LIABILITY_3__c,CLIENT_S_PERCEPTION_STRENGTHS_1__c,
                                CLIENT_S_PERCEPTION_STRENGTHS_2__c,CLIENT_S_PERCEPTION_STRENGTHS_3__c,Client_s_Physician_Name__c,Client_Engage_in_subs_free_NO__c,Client_Engage_in_subs_free_Txt__c,
                                Client_Environment_to_conductive_NO__c,Client_Environment_to_conductive_Txt__c,Client_Family_History_Medical_Condition__c,Client_Family_History_Medical_Cond_List__c,
                                Client_Family_History_Medical_Cond_Text__c,Client_have_any_future_education_goal__c,Client_have_any_future_education_goal_NO__c,Client_History_Medical_Condition__c,
                                Client_History_Medical_Condition_List__c,Client_History_Medical_Condition_text__c,Client_Strength_to_assisst__c,Client_under_the_care_of_a_physician__c,
                                Clinical_Evaluation_2__c,DIMENSION_1_Withdrawal_Potential__c,DIMENSION_2_Medical__c,DIMENSION_3_Cognitive_Behavioral__c,DIMENSION_4_Readiness_For_Treatment__c,
                                DIMENSION_5_Relapse_Risk__c,DIMENSION_6_Recovery_Environment__c,Ever_been_involved_in_abusive_relation__c,Have_you_ever_been_sexually_abused__c,
                                If_yes_was_it_alcohol_drug_related__c,INTEGRATED_DIAGNOSTIC_SUMMARY__c,Involved_in_Abusive_Relation_Text__c,LEVEL_OF_IMPAIRMENT_Drug_Alcohol_Usage__c,
                                LEVEL_OF_IMPAIRMENT_Employment__c,LEVEL_OF_IMPAIRMENT_Family_Social__c,LEVEL_OF_IMPAIRMENT_Legal__c,LEVEL_OF_IMPAIRMENT_Medical__c,LEVEL_OF_IMPAIRMENT_Peer_Support__c,
                                LEVEL_OF_IMPAIRMENT_Problems__c,LEVEL_OF_IMPAIRMENT_PSYCHIATRIC_MENTAL__c,LIST_PROBLEMS_IN_BIO_PSYCHOSOCIAL_1__c,LIST_PROBLEMS_IN_BIO_PSYCHOSOCIAL_2__c,
                                LIST_PROBLEMS_IN_BIO_PSYCHOSOCIAL_3__c,LIST_PROBLEMS_IN_BIO_PSYCHOSOCIAL_4__c,LIST_PROBLEMS_IN_BIO_PSYCHOSOCIAL_5__c,LIST_PROBLEMS_IN_BIO_PSYCHOSOCIAL_6__c,
                                LIST_PROBLEMS_IN_BIO_PSYCHOSOCIAL_7__c,LIST_PROBLEMS_IN_BIO_PSYCHOSOCIAL_8__c,LIST_PROBLEMS_TO_ADDRESS_TREATMENT_1__c,LIST_PROBLEMS_TO_ADDRESS_TREATMENT_2__c,
                                LIST_PROBLEMS_TO_ADDRESS_TREATMENT_3__c,LIST_PROBLEMS_TO_ADDRESS_TREATMENT_4__c,LIST_PROBLEMS_TO_ADDRESS_TREATMENT_5__c,LIST_PROBLEMS_TO_ADDRESS_TREATMENT_6__c,
                                LIST_PROBLEMS_TO_ADDRESS_TREATMENT_7__c,LIST_PROBLEMS_TO_ADDRESS_TREATMENT_8__c,OTHER_DRUGS_TYPE1_Substance__c,OTHER_DRUGS_TYPE2_Substance__c,OTHER_DRUGS_TYPE3_Substance__c,
                                OTHER_DRUGS_TYPE4_Substance__c,RATIONALE_FOR_TREATMENT__c,REASON_FOR_TREATMENT_AT_THIS_TIME__c, HP_Status__c, Client_Closed_Date__c, Client_Image_Url_Closed__c, Client_Signed_User_Closed__c, Intern_Closed_Date__c,
                                Intern_Signature_URL__c, Intern_Signed_User__c, Staff_Closed_Date__c, Staff_Signature_URL_Closed__c, Staff_Signed_User_Closed__c, SignedBy__c 
                                from Clinical_Evaluation_3__c where Clinical_Evaluation_2__c =: ceID];
        }
        
        if (ceRecord2.HP_Status__c == null || ceRecord2.HP_Status__c == 'Open' || ceRecord2.HP_Status__c == 'In Progress') {

            ceRecord2.HP_Status__c = 'In Progress';
            ceRecord2.SignedBy__c = 'None';
            //ceRecord2.HP_Evaluation_Date__c = System.today();
        }
        userObj = [Select id, name, title,Has_Overwrite_Access__c, User_Role__c from user where id =: userinfo.getUserID()];
        
        checkAllBoolTrue();
        calculateScores();
    }
    
    private map<string,integer> fillMapWithScores()
    {
        map<string,integer> mapToReturn = new map<string,integer>();
        List<CE_BPSA_ImpairmentScoreCS__c> myCs = CE_BPSA_ImpairmentScoreCS__c.getall().values();
        for(CE_BPSA_ImpairmentScoreCS__c cs: myCs)
        {
            mapToReturn.put(cs.Name,integer.ValueOf(cs.value__c));
        }
        
        return mapToReturn; 
    }
    
    public pageReference saveRecord()
    {
        try
        {
            PageReference pr;
            upsert ceRecord1;
            Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation_3__c.getRecordTypeInfosByName().get('Bio-Psychosocial Assessment').getRecordTypeId();
            ceRecord2.Clinical_Evaluation_2__c = ceRecord1.id;
            ceRecord2.RecordtypeID = BPSARecordTypeId;
            upsert ceRecord2;
            
            if(ceID == null)
            {
                pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
                pr.getParameters().put('ID',ClientID);
                pr.getParameters().put('ceId',ceRecord1.Id);
                pr.getParameters().put('type',RecordTypeName);
                pr.getParameters().put('rt',clientChart.RecordType.Name);
                pr.setRedirect(true); 
                return pr;
            }
            else if(ceID != null)
            {
                pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
                pr.getParameters().put('ID',ClientID);
                pr.getParameters().put('ceId',ceID);
                pr.getParameters().put('type',RecordTypeName);
                pr.getParameters().put('rt',clientChart.RecordType.Name);
                pr.setRedirect(true); 
                return pr;
            }
        }
        catch(exception ex)
        {
            ApexPages.AddMessages(ex);
        }
        return null;
        
    }
    
    public void QuickSaveRecord()
    {
        try
        {
            
            upsert ceRecord1;
            Id BPSARecordTypeId = Schema.SObjectType.Clinical_Evaluation_3__c.getRecordTypeInfosByName().get('Bio-Psychosocial Assessment').getRecordTypeId();
            ceRecord2.Clinical_Evaluation_2__c = ceRecord1.id;
            ceRecord2.RecordtypeID = BPSARecordTypeId;
            upsert ceRecord2;
           
        }
        catch(exception ex)
        {
            ApexPages.AddMessages(ex);
        }
        
    }
    
        public PageReference Edit()
    {
        PageReference pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
        pr.getParameters().put('ID',ClientID);
        pr.getParameters().put('ceId',ceID);
        pr.getParameters().put('type',RecordTypeName);
        pr.getParameters().put('readOnly','false');
        pr.getParameters().put('rt',clientChart.RecordType.Name);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        
        return pr;
        
    }
    
    public pageReference Cancel()
    {
        PageReference pr;
        if(ceID == null)
        {
            pr = new PageReference('/apex/ClinicalEvaluationHomePage');
            pr.getParameters().put('ID',ClientID);
            pr.getParameters().put('type',RecordTypeName);
            pr.getParameters().put('rt',clientChart.RecordType.Name);
            pr.setRedirect(true); 
            return pr;
        }
        else if(ceID != null)
        {
            pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
            pr.getParameters().put('ID',ClientID);
            pr.getParameters().put('ceId',ceID);
            pr.getParameters().put('type',RecordTypeName);
            pr.getParameters().put('rt',clientChart.RecordType.Name);
            pr.setRedirect(true); 
            return pr;
        }
        return null;
    }
    
    public void calculateScores()
    {
        map<string,integer> mapofScores = fillMapWithScores();
        ImpairementAndSeverityTotalScore = 0;
        
        ImpairementAndSeverityTotalScore += (ceRecord2.LEVEL_OF_IMPAIRMENT_Problems__c != null && mapofScores.containsKey(ceRecord2.LEVEL_OF_IMPAIRMENT_Problems__c)) ? mapofScores.get(ceRecord2.LEVEL_OF_IMPAIRMENT_Problems__c) : 0;
        ImpairementAndSeverityTotalScore += (ceRecord2.LEVEL_OF_IMPAIRMENT_Medical__c != null && mapofScores.containsKey(ceRecord2.LEVEL_OF_IMPAIRMENT_Medical__c)) ? mapofScores.get(ceRecord2.LEVEL_OF_IMPAIRMENT_Medical__c) : 0;
        ImpairementAndSeverityTotalScore += (ceRecord2.LEVEL_OF_IMPAIRMENT_Employment__c != null && mapofScores.containsKey(ceRecord2.LEVEL_OF_IMPAIRMENT_Employment__c)) ? mapofScores.get(ceRecord2.LEVEL_OF_IMPAIRMENT_Employment__c) : 0;
        ImpairementAndSeverityTotalScore += (ceRecord2.LEVEL_OF_IMPAIRMENT_Family_Social__c != null && mapofScores.containsKey(ceRecord2.LEVEL_OF_IMPAIRMENT_Family_Social__c)) ? mapofScores.get(ceRecord2.LEVEL_OF_IMPAIRMENT_Family_Social__c) : 0;
        ImpairementAndSeverityTotalScore += (ceRecord2.LEVEL_OF_IMPAIRMENT_Peer_Support__c != null && mapofScores.containsKey(ceRecord2.LEVEL_OF_IMPAIRMENT_Peer_Support__c)) ? mapofScores.get(ceRecord2.LEVEL_OF_IMPAIRMENT_Peer_Support__c) : 0;
        ImpairementAndSeverityTotalScore += (ceRecord2.LEVEL_OF_IMPAIRMENT_PSYCHIATRIC_MENTAL__c != null && mapofScores.containsKey(ceRecord2.LEVEL_OF_IMPAIRMENT_PSYCHIATRIC_MENTAL__c)) ? mapofScores.get(ceRecord2.LEVEL_OF_IMPAIRMENT_PSYCHIATRIC_MENTAL__c) : 0;
        ImpairementAndSeverityTotalScore += (ceRecord2.LEVEL_OF_IMPAIRMENT_Legal__c != null && mapofScores.containsKey(ceRecord2.LEVEL_OF_IMPAIRMENT_Legal__c)) ? mapofScores.get(ceRecord2.LEVEL_OF_IMPAIRMENT_Legal__c) : 0;
        ImpairementAndSeverityTotalScore += (ceRecord2.LEVEL_OF_IMPAIRMENT_Drug_Alcohol_Usage__c != null && mapofScores.containsKey(ceRecord2.LEVEL_OF_IMPAIRMENT_Drug_Alcohol_Usage__c)) ? mapofScores.get(ceRecord2.LEVEL_OF_IMPAIRMENT_Drug_Alcohol_Usage__c) : 0;
    
        
    }
    
    public PageReference CloseSignatureForm() {
    
        callJs = false;
        if (SelectedSignedOption == 'Staff' &&  userObj.User_Role__c == NULL) {

            ceRecord2.Staff_Signature_URL_Closed__c = AWSURL + ImageUrlAddress;
            ceRecord2.Staff_Signed_User_Closed__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            ceRecord2.Staff_Closed_Date__c = DateTime.Now();
            ceRecord2.SignedBy__c = 'Staff';
        } /*else if (SelectedSignedOption == 'Patient') {

            ceRecord2.Client_Image_Url_Closed__c = AWSURL + ImageUrlAddress;
            ceRecord2.Client_Signed_User_Closed__c = '(Patient) ' + ceRecord1.Client_Chart__r.Name;
            ceRecord2.Client_Closed_Date__c = DateTime.Now();
            ceRecord2.SignedBy__c = 'Client';
        } */else if (userObj.User_Role__c != NULL) {

            ceRecord2.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
            ceRecord2.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
            ceRecord2.Intern_Closed_Date__c = DateTime.Now();
            ceRecord2.SignedBy__c = 'Client';
            ceRecord2.HP_Status__c = 'Review Pending';
            //ceRecord2.HP_Evaluation_Date__c = System.today();
        }

        if ((ceRecord2.Staff_Signed_User_Closed__c != null || String.isNotBlank(ceRecord2.Staff_Signed_User_Closed__c ))){// && (ceRecord2.Client_Signed_User_Closed__c != null || String.isNotBlank(ceRecord2.Client_Signed_User_Closed__c ))) {
            ceRecord2.HP_Status__c = 'Closed';
            ceRecord2.SignedBy__c = 'All'; // signing is complete
            ceRecord2.HP_Evaluation_Date__c = System.today();
        }
        
        if(ceRecord2.HP_Status__c != 'Closed'){
         callJS = true;
        }
         
       update ceRecord2;
       return null;
 

    }
    
    
    public void checkAllRendering()
    {
        if(ceRecord2.Attempt_to_discontinue_cut_back_on_subs__c == 'Yes'){
            RenderAttemptToDiscontinue = true;
        }
        else if(ceRecord2.Attempt_to_discontinue_cut_back_on_subs__c == 'No'){
            RenderAttemptToDiscontinue = false;
        }
        if(ceRecord2.Client_under_the_care_of_a_physician__c == 'Yes')
        {
            RenderClientPhysician = true;
        }
        else if(ceRecord2.Client_under_the_care_of_a_physician__c == 'No')
        {
            RenderClientPhysician = false;
        }
        if(ceRecord2.Client_History_Medical_Condition__c == 'Yes')
        {
            RenderClientHistoryMedCond = true;
        }
        else if(ceRecord2.Client_History_Medical_Condition__c == 'No')
        {
            RenderClientHistoryMedCond = false;
        }
        if(ceRecord2.Client_Family_History_Medical_Condition__c == 'Yes')
        {
            RenderClientFamilyHistoryMedCond = true;
        }
        else if(ceRecord2.Client_Family_History_Medical_Condition__c == 'No')
        {
            RenderClientFamilyHistoryMedCond = false;
        }
        if(ceRecord2.Have_you_ever_been_sexually_abused__c == 'Yes')
        {
            RenderSexuallyAbusedDrugRelated = true;
        }
        else if(ceRecord2.Have_you_ever_been_sexually_abused__c == 'No')
        {
            RenderSexuallyAbusedDrugRelated = false;
        }
        if(ceRecord2.Ever_been_involved_in_abusive_relation__c)
        {
            RenderAbusedRelation = true;
        }
        else if(!ceRecord2.Ever_been_involved_in_abusive_relation__c)
        {
            RenderAbusedRelation = false;
        }
        
        
    }
    
    public void checkAllRendering2()
    {
        if(ceRecord1.Trauma_Assess_History_of_Trauma_NONE__c)
        {
            RenderTraumaHistory = false;
        }
        else if(!ceRecord1.Trauma_Assess_History_of_Trauma_NONE__c)
        {
            RenderTraumaHistory = true;
        }
        if(ceRecord1.Client_trauma_interfere_Treatment_NONE__c)
        {
            RenderTraumaInterfere = false;
        }
        else if(!ceRecord1.Client_trauma_interfere_Treatment_NONE__c)
        {
            RenderTraumaInterfere = true;
        }
        if(ceRecord1.Suicide_Screening_Thoughts_NONE__c)
        {
            RenderSuicideThought = false;
        }
        else if(!ceRecord1.Suicide_Screening_Thoughts_NONE__c)
        {
            RenderSuicideThought = true;
        }
        if(ceRecord1.Suicide_Screening_Attempts_NONE__c)
        {
            RenderSuicideAttempt = false;
        }
        else if(!ceRecord1.Suicide_Screening_Attempts_NONE__c)
        {
            RenderSuicideAttempt = true;
        }
        if(ceRecord1.Family_Supports_In_Treatment_NONE__c)
        {
            RenderFamilySupport = false;
        }
        else if(!ceRecord1.Family_Supports_In_Treatment_NONE__c)
        {
            RenderFamilySupport = true;
        }
        if(ceRecord1.Family_Dependent_on_Treatment_NONE__c)
        {
            RenderFamilyDependent = false;
        }
        else if(!ceRecord1.Family_Dependent_on_Treatment_NONE__c)
        {
            RenderFamilyDependent = true;
        }
        
        
    }
    
    public void checkAllRendering3()
    {
        if(ceRecord2.Assessment_of_Mental_Status_Check__c)
        {
            RenderMentalAssessment = false;
        }
        else if(!ceRecord2.Assessment_of_Mental_Status_Check__c)
        {
            RenderMentalAssessment = true;
        }
        if(ceRecord1.TRTMNT_ACCEPT_Client_ext_motivated_NO__c)
        {
            RenderExtMotivated = false;
        }
        else if(!ceRecord1.TRTMNT_ACCEPT_Client_ext_motivated_NO__c)
        {
            RenderExtMotivated = true;
        }
        if(ceRecord1.Client_have_gambling_history_NONE__c)
        {
            RenderGamblingHistory = false;
        }
        else if(!ceRecord1.Client_have_gambling_history_NONE__c)
        {
            RenderGamblingHistory = true;
        }
        if(ceRecord1.Client_other_Addictive_Behaviors_NONE__c)
        {
            RenderAddictiveBehvr = false;
        }
        else if(!ceRecord1.Client_other_Addictive_Behaviors_NONE__c)
        {
            RenderAddictiveBehvr = true;
        }
        if(ceRecord1.Client_Rcv_Substance_abuse_NO__c)
        {
            RenderClientRcvSubsAbuse = false;
        }
        else if(!ceRecord1.Client_Rcv_Substance_abuse_NO__c)
        {
            RenderClientRcvSubsAbuse = true;
        }
    }
    
    
    public void checkAllRendering4()
    {
        if(ceRecord1.BPA_Does_Client_have_any_siblings__c)
        {
            RenderClientHasSiblings = false;
        }
        else if(!ceRecord1.BPA_Does_Client_have_any_siblings__c)
        {
            RenderClientHasSiblings = true;
        }
        if(ceRecord1.History_of_Subs_abuse_NO__c)
        {
            RenderHistorySubsAbuse = false;
        }
        else if(!ceRecord1.History_of_Subs_abuse_NO__c)
        {
            RenderHistorySubsAbuse = true;
        }
        if(ceRecord1.Is_Client_involved_in_a_significant_rela__c)
        {
            RenderSignificantRelation = false;
        }
        else if(!ceRecord1.Is_Client_involved_in_a_significant_rela__c)
        {
            RenderSignificantRelation = true;
        }
        if(ceRecord1.No_Relationship__c)
        {
            RenderNoRelationShip = false;
        }
        else if(!ceRecord1.No_Relationship__c)
        {
            RenderNoRelationShip = true;
        }
        if(ceRecord1.No_Children__c)
        {
            RenderChildren = false;
        }
        else if(!ceRecord1.No_Children__c)
        {
            RenderChildren = true;
        }
        if(ceRecord1.Is_Client_satisfied_relationship_Chld__c)
        {
            RenderSatisfiedChildren = false;
        }
        else if(!ceRecord1.Is_Client_satisfied_relationship_Chld__c)
        {
            RenderSatisfiedChildren = true;
        }
    }
    
    public void checkAllRendering5()
    {
        if(ceRecord1.If_no_to_any_of_the_above_P_PP_C__c)
        {
            RenderPPPCSubsAbuse = false;
        }
        else if(!ceRecord1.If_no_to_any_of_the_above_P_PP_C__c)
        {
            RenderPPPCSubsAbuse = true;
        }
        if(ceRecord1.Client_Raised_in_specific_culture_NO__c)
        {
            RenderClientRaisedSpecCulture = false;
        }
        else if(!ceRecord1.Client_Raised_in_specific_culture_NO__c)
        {
            RenderClientRaisedSpecCulture = true;
        }
        if(ceRecord1.Client_practice_specific_culture_NO__c)
        {
            RenderClientPracticeSpecCulture = false;
        }
        else if(!ceRecord1.Client_practice_specific_culture_NO__c)
        {
            RenderClientPracticeSpecCulture = true;
        }
        if(ceRecord1.Client_identify_specific_culture_NO__c)
        {
            RenderClientIdentifySpecCulture = false;
        }
        else if(!ceRecord1.Client_identify_specific_culture_NO__c)
        {
            RenderClientIdentifySpecCulture = true;
        }
        if(ceRecord1.Client_identify_special_culture_NO__c)
        {
            RenderClientIdentifySpeclCulture = false;
        }
        else if(!ceRecord1.Client_identify_special_culture_NO__c)
        {
            RenderClientIdentifySpeclCulture = true;
        }
        if(ceRecord1.Client_have_problem_interacting_NO__c)
        {
            RenderClientProblemInteracting = false;
        }
        else if(!ceRecord1.Client_have_problem_interacting_NO__c)
        {
            RenderClientProblemInteracting = true;
        }
    }
    
    public void checkAllRendering6()
    {
        if(ceRecord1.LegalHistory_Client_involve_in_Crime_NO__c)
        {
            RenderClientInvolveLegalCrime = false;
        }
        else if(!ceRecord1.LegalHistory_Client_involve_in_Crime_NO__c)
        {
            RenderClientInvolveLegalCrime = true;
        }
        if(ceRecord1.LegalHistory_Client_Crime_History_NO__c)
        {
            RenderClientHaveLegalCrime = false;
        }
        else if(!ceRecord1.LegalHistory_Client_Crime_History_NO__c)
        {
            RenderClientHaveLegalCrime = true;
        }
        if(ceRecord1.Incarceration_History_NONE__c)
        {
            RenderIncarcerationHistory = false;
        }
        else if(!ceRecord1.Incarceration_History_NONE__c)
        {
            RenderIncarcerationHistory = true;
        }
        if(ceRecord1.Client_currently_owe_restitution_NO__c)
        {
            RenderOweRestitution = false;
        }
        else if(!ceRecord1.Client_currently_owe_restitution_NO__c)
        {
            RenderOweRestitution = true;
        }
    }
    
    public void checkAllRendering7()
    {
        if(ceRecord1.Client_enrolled_attending_school_NO__c)
        {
            RenderEnrolledSchool = false;
        }
        else if(!ceRecord1.Client_enrolled_attending_school_NO__c)
        {
            RenderEnrolledSchool = true;
        }
        if(ceRecord1.Client_expelled_from_school_2year_NO__c)
        {
            RenderExpelledFromSchool = false;
        }
        else if(!ceRecord1.Client_expelled_from_school_2year_NO__c)
        {
            RenderExpelledFromSchool = true;
        }
        if(ceRecord1.Client_attended_special_classes_NO__c)
        {
            RenderSpecialClasses = false;
        }
        else if(!ceRecord1.Client_attended_special_classes_NO__c)
        {
            RenderSpecialClasses = true;
        }
        if(ceRecord2.Client_have_any_future_education_goal_NO__c)
        {
            RenderFutureEduGoals = false;
        }
        else if(!ceRecord2.Client_have_any_future_education_goal_NO__c)
        {
            RenderFutureEduGoals = true;
        }
        if(ceRecord1.Military_Service_NONE__c)
        {
            RenderMilitaryService = false;
        }
        else if(!ceRecord1.Military_Service_NONE__c)
        {
            RenderMilitaryService = true;
        }
        if(ceRecord1.Employment_History_NONE__c)
        {
            RenderEmploymentHistory = false;
        }
        else if(!ceRecord1.Employment_History_NONE__c)
        {
            RenderEmploymentHistory = true;
        }
        if(ceRecord1.Client_need_specific_training_NO__c)
        {
            RenderNeedVocationalTraining = false;
        }
        else if(!ceRecord1.Client_need_specific_training_NO__c)
        {
            RenderNeedVocationalTraining = true;
        }
        if(ceRecord1.Client_received_any_training_NO__c)
        {
            RenderRcvVocationalTraining = false;
        }
        else if(!ceRecord1.Client_received_any_training_NO__c)
        {
            RenderRcvVocationalTraining = true;
        }
    }
    
    public void checkAllRendering8()
    {
        if(ceRecord2.Cleint_existing_Positive_Supp_Sys_NO__c)
        {
            RenderExistingPosSupport = false;
        }
        else if(!ceRecord2.Cleint_existing_Positive_Supp_Sys_NO__c)
        {
            RenderExistingPosSupport = true;
        }
        if(ceRecord2.Client_Environment_to_conductive_NO__c)
        {
            RenderConductiveEnviron = false;
        }
        else if(!ceRecord2.Client_Environment_to_conductive_NO__c)
        {
            RenderConductiveEnviron = true;
        }
        if(ceRecord2.Client_Engage_in_subs_free_NO__c)
        {
            RenderEngageSubsFree = false;
        }
        else if(!ceRecord2.Client_Engage_in_subs_free_NO__c)
        {
            RenderEngageSubsFree = true;
        }
        if(ceRecord1.SPIRITUALITY_ASSESS_Prayer_meditation_NO__c)
        {
            RenderSpiritualPryMed = false;
        }
        else if(!ceRecord1.SPIRITUALITY_ASSESS_Prayer_meditation_NO__c)
        {
            RenderSpiritualPryMed = true;
        }
        if(ceRecord1.SPIRITUALITY_ASSESS_Spiritual_Goals_NO__c)
        {
            RenderSpiritualGoals = false;
        }
        else if(!ceRecord1.SPIRITUALITY_ASSESS_Spiritual_Goals_NO__c)
        {
            RenderSpiritualGoals = true;
        }
        if(ceRecord1.SPIRITUALITY_ASSESS_Practice_Religion_NO__c)
        {
            RenderSpiritualPracticeRel = false;
        }
        else if(!ceRecord1.SPIRITUALITY_ASSESS_Practice_Religion_NO__c)
        {
            RenderSpiritualPracticeRel = true;
        }
        if(ceRecord1.SPIRITUALITY_ASSESS_Type_of_Spiritual_NO__c)
        {
            RenderSpiritualTypes = false;
        }
        else if(!ceRecord1.SPIRITUALITY_ASSESS_Type_of_Spiritual_NO__c)
        {
            RenderSpiritualTypes = true;
        }
    }
    
    public void checkAllRendering9()
    {
        if(ceRecord1.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_1_NO__c)
        {
            RenderInterviewFamily1 = false;
        }
        else if(!ceRecord1.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_1_NO__c)
        {
            RenderInterviewFamily1 = true;
        }
        if(ceRecord1.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_3_NO__c)
        {
            RenderInterviewFamily2 = false;
        }
        else if(!ceRecord1.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_3_NO__c)
        {
            RenderInterviewFamily2 = true;
        }
        if(ceRecord1.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_4_NO__c)
        {
            RenderInterviewFamily3 = false;
        }
        else if(!ceRecord1.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_4_NO__c)
        {
            RenderInterviewFamily3 = true;
        }
        if(ceRecord1.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_5_YES__c)
        {
            RenderInterviewFamily4 = false;
        }
        else if(!ceRecord1.INTERVIEW_WITH_SIGN_FAMILY_MEMBER_5_YES__c)
        {
            RenderInterviewFamily4 = true;
        }
    }
    
    public void checkAllBoolTrue()
    {
        RenderTraumaHistory = true;
        RenderTraumaInterfere = true;
        RenderSuicideThought = true;
        RenderSuicideAttempt = true;
        RenderFamilySupport = true;
        RenderFamilyDependent = true;
        RenderMentalAssessment = true;
        RenderExtMotivated = true;
        RenderGamblingHistory = true;
        RenderAddictiveBehvr = true;
        RenderClientRcvSubsAbuse = true;
        RenderClientHasSiblings = true;
        RenderHistorySubsAbuse = true;
        RenderSignificantRelation = true;
        RenderNoRelationShip = true;
        RenderChildren = true;
        RenderSatisfiedChildren = true;
        RenderPPPCSubsAbuse = true;
        RenderClientRaisedSpecCulture = true;
        RenderClientPracticeSpecCulture = true;
        RenderClientIdentifySpecCulture = true;
        RenderClientIdentifySpeclCulture = true;
        RenderClientProblemInteracting = true;
        RenderClientInvolveLegalCrime = true;
        RenderClientHaveLegalCrime = true;
        RenderIncarcerationHistory = true;
        RenderOweRestitution = true;
        RenderEnrolledSchool = true;
        RenderExpelledFromSchool = true;
        RenderSpecialClasses = true;
        RenderFutureEduGoals = true;
        RenderMilitaryService = true;
        RenderEmploymentHistory = true;
        RenderNeedVocationalTraining = true;
        RenderRcvVocationalTraining = true;
        RenderExistingPosSupport = true;
        RenderConductiveEnviron = true;
        RenderEngageSubsFree = true;
        RenderSpiritualPryMed = true;
        RenderSpiritualGoals = true;
        RenderSpiritualPracticeRel = true;
        RenderSpiritualTypes = true;
        RenderInterviewFamily1 = true;
        RenderInterviewFamily2 = true;
        RenderInterviewFamily3 = true;
        RenderInterviewFamily4 = true;
    }
    
}