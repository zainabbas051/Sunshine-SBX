//Test Class : PAA_Edit_Read_Test
public class PAA_Edit_Read {
    public Contact contact {get;set;}
    public Clinical_Evaluation__c ce {get; set;}
    public Clinical_Evaluation_3__c ce3Record{get; set;}
    public Boolean loadForm {get;set;}
    public Client_Chart__c clientChart {get;set;}
    
    public string clientId {get;set;}
    public string ceID {get; set;}
    public string RecordtypeName {get; set;}
    
    
    public Boolean allergy1{get;set;}
    public Boolean allergy2{get;set;}
    public Boolean allergy3{get;set;}
    public Boolean allergy4{get;set;}
    public Boolean allergy5{get;set;}
    public Boolean allergy6{get;set;}
    
    public Boolean isEdit{get; set;}
    public boolean callJS{get; set;}
    
    //AWS
    public string accessKeyId {get; set;}
    public string secretAccessKey {get; set;}
    public string OrgName {get; set;}
    final string AWSURL;
    
     //hidden field
    public string SelectedSignedOption {get; set;}
    public string ImageUrlAddress {get; set;}
    
    public User userObj {get; set;}    
    
    
    public PAA_Edit_Read(){
        userObj = new user();
        ce3Record = new Clinical_Evaluation_3__c();
        ce = new Clinical_Evaluation__c();
        
        ce = new Clinical_Evaluation__c();
        callJS = false;
        if(Test.isRunningTest())
        {
            accessKeyId = '';
            OrgName = '';
        }
        else{
            accessKeyId = Constants.accessKeyId;
            OrgName = Constants.OrgName;
        }
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        Id paaRecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();
        loadForm = true;
        
        clientID = ApexPages.CurrentPage().getParameters().get('id');
        ceID = ApexPages.CurrentPage().getParameters().get('ceId');
        RecordTypeName = ApexPages.CurrentPage().getParameters().get('type');
        if(RecordTypeName == null)
            RecordTypeName = 'Pre Admission Assesment';
        
        if(clientId != null){
            clientChart = [SELECT id, RecordType.name 
                           FROM Client_Chart__c WHERE id = :clientId limit 1];
            //checkRenderAllergies();
            if(ceID == null)
            {
                ce = new Clinical_Evaluation__c(RecordTypeId=paaRecordTypeId,Client_Chart__c =clientId);
                ce.PAA_Date__c = System.today();
                ce.Status__c = 'In Progress';
            }
            else if(ceID != null && RecordTypeName == 'Pre Admission Assesment')
            {
                 try{
                    ce = [Select Id,Client_Chart__c ,due_date_time__c,Status__c, PAA_Opportunity__c,PAA_Age__c,PAA_Age_of_First_Use_Drug_1__c, PAA_Age_of_First_Use_Drug_2__c, PAA_Age_of_First_Use_Drug_3__c,
                            PAA_Aggressive_Behavior__c, PAA_Allergic_Reaction__c, Allergies__c, PAA_Ambulation__c, PAA_Any_Pending_Charges__c, PAA_Body_Mass_Index_BMI__c,
                            PAA_Client_Aware_of_No_Return_Flight__c, PAA_Client_Name__c, PAA_Current_Employer__c, PAA_Currently_Pregnant__c, PAA_Current_Medications__c,
                            PAA_Current_Suicidal_Ideations__c, PAA_Current_Use_Details_Drug_1__c, PAA_Current_Use_Details_Drug_2__c, PAA_Current_Use_Details_Drug_3__c,
                            PAA_Dangerous_Behavior_while_Using__c, PAA_Date_of_Last_Use_Drug_1__c, PAA_Date_of_Last_Use_Drug_2__c, PAA_Date_of_Last_Use_Drug_3__c,
                            PAA_Days_Committed_to_Treatment__c, PAA_Detox_Needed__c, PAA_DOC_Notes__c, PAA_Drug_of_Choice_1__c, PAA_Drug_of_Choice_2__c, PAA_Drug_of_Choice_3__c,
                            PAA_Employment_Status__c, PAA_Family_Contact_Email__c, PAA_Family_Contact_Name__c, PAA_Family_Contact_Phone__c, PAA_Family_Contact_Relationship__c,
                            PAA_Family_History_Notes__c, PAA_Family_History_of_Mental_Health__c, PAA_Family_History_of_Suicide__c, PAA_FMLA_Needed__c, PAA_Frequency_of_Use_Drug_1__c,
                            PAA_Frequency_of_Use_Drug_2__c, PAA_Frequency_of_Use_Drug_3__c, PAA_Height__c, PAA_History_of_Arson__c, PAA_History_of_Seizures__c, PAA_History_of_Violence__c,
                            PAA_Legal_Contact_Info__c, PAA_Legal_Contact_Required__c, PAA_Legal_history_Notes__c, PAA_Length_of_Employment__c, PAA_Lives_with_Name_Age__c,
                            PAA_Longest_Sobriety__c, PAA_Medical_Conditions__c, PAA_Medical_History_Notes__c, PAA_Method_of_Use_Drug_1__c, PAA_Method_of_Use_Drug_2__c,PAA_Method_of_Use_Drug_3__c,
                            PAA_Negative_Consequences_of_Using__c, PAA_On_Probation_Parole__c, PAA_Other_Employment_Info__c, PAA_Other_Housing_Issues__c, PAA_Other_Issues__c,
                            PAA_Other_Medical_Issues__c, PAA_Past_Suicidal_Ideations__c, PAA_Precipitating_Event__c, PAA_Prescribed_but_not_Taken_Medication__c, PAA_Previous_ACAs__c,
                            PAA_Previous_Suicide_Attempts__c, PAA_Previous_Treatment_Episodes__c, PAA_Previous_Treatment_Notes__c, PAA_Psychiatric_Co_occurring_Issues__c, PAA_Psychiatric_Diagnosis__c,
                            PAA_Psych_Notes__c, PAA_Reason_Why_Not_Taking__c, PAA_Recent_Hospitalization_Surgery__c, PAA_Self_Diagnosed__c, PAA_Self_Injurious_Mutilating_Behavior__c,
                            PAA_Sex__c, PAA_Sexual_Offenses__c, PAA_Suicide_Notes__c, PAA_Supporting_Withdrawal_Notes__c, PAA_Supportive_Environment__c, PAA_Trauma__c,
                            PAA_Trauma_Notes__c, PAA_Triggers__c, PAA_Under_Care_of_Dr_for_Pain_Management__c, PAA_Upcoming_Court_Dates__c, PAA_Weight__c, Why_Treatment_Now__c, 
                            PAA_Willing_to_Discontinue_all_Pain_Meds__c, PAA_Withdrawal_Symptoms__c, Client_Chart__r.Treatment_Center__r.Name, Client_Chart__r.Name,
                            Family_Contact_Name_2__c,Family_Contact_Name_3__c, Family_Contact_Relationship_2__c, Family_Contact_Relationship_3__c, Family_Contact_Email_2__c, Family_Contact_Email_3__c,
                            Family_Contact_Phone_2__c, Family_Contact_Phone_3__c, SignedBy__c FROM Clinical_Evaluation__c where id =:ceID];
                            
                    
                    if((ce.Status__c == 'Review Pending' || ce.Status__c == 'Closed') || (ce.Status__c == 'In Progress' &&  ce.SignedBy__c == 'Client'))
                        ce3Record = [select id,Clinical_Evaluation__c, Client_Closed_Date__c, Client_Image_Url_Closed__c, Client_Signed_User_Closed__c, Intern_Closed_Date__c,
                                    Intern_Signature_URL__c, Intern_Signed_User__c, Staff_Closed_Date__c, Staff_Signature_URL_Closed__c, Staff_Signed_User_Closed__c,
                                    SignedBy__c from Clinical_Evaluation_3__c where Clinical_Evaluation__c =: CEID order by CreatedDate DESC Limit 1];
                    
                    //system.debug('#ce3Record='+ce3Record);
                    
                    if (ce.Status__c == 'Open' || ce.Status__c == 'In Progress') {

                    ce.Status__c = 'In Progress';
                    ce3Record.SignedBy__c = ce3Record.SignedBy__c!=null ? ce3Record.SignedBy__c : 'None';
                    }
                
                }
                catch(Exception e){
                    Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'The Id passed in URL is invalid.');
                    ApexPages.addMessage(errMsg);
                    loadForm = false;
                }
            }
            
            userObj = [Select id, name, title,Has_Overwrite_Access__c, User_Role__c from user where id =: userinfo.getUserID()];
            //setCheckBoxes();
            //checkRender2();
            
            contact = new Contact();
        }
        else{
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Client Chart ID(cid) parameter missing in URL.');
            ApexPages.addMessage(errMsg);
            loadForm = false;
        }
        
    }
    
    public pageReference Edit()
    {
        PageReference pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
        pr.getParameters().put('ID',ClientID);
        pr.getParameters().put('ceId',ceID);
        pr.getParameters().put('type',RecordTypeName);
        pr.getParameters().put('rt',clientChart.RecordType.Name);
        pr.getParameters().put('readOnly','false');
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        
        return pr;
    }
    public PageReference Save(){
        upsert ce;
        Pagereference pr;
        if(ceID == null)
        {
            pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
            pr.getParameters().put('ID',ClientID);
            pr.getParameters().put('ceId',ce.Id);
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
    public Pagereference submit(){
        System.debug('submit button method');
        upsert ce;
        return new Pagereference('/apex/CE_PAA_ReadOnly?id='+ ce.Id);
    }
    
    public PageReference Cancel()
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
    
    public PageReference Back()
    {
        return new Pagereference('/apex/ClinicalEvaluationHomePage?id='+ clientId);
    }
    
    public static Boolean ValueIsNull(Object val){if(val == null || String.valueOf(val).length() == 0){return true;}return false;} 
    
    /*public void checkRenderAllergies(){
        
        if(!ValueIsNull(clientChart.Allergen1__c) || !ValueIsNull(clientChart.Allergy_Type1__c) || 
           !ValueIsNull(clientChart.Reaction1__c) || !ValueIsNull(clientChart.Reaction_type1__c) || 
          !ValueIsNull(clientChart.Onset1__c ) || !ValueIsNull(clientChart.Treatment1__c) || 
          !ValueIsNull(clientChart.Status1__c)|| !ValueIsNull(clientChart.Allergy_Source1__c)){
            allergy1 = True;
          }else{allergy1 = False;}
        if(!ValueIsNull(clientChart.Allergen2__c) || !ValueIsNull(clientChart.Allergy_Type2__c) || 
           !ValueIsNull(clientChart.Reaction2__c) || !ValueIsNull(clientChart.Reaction_type2__c) || 
          !ValueIsNull(clientChart.Onset2__c) || !ValueIsNull(clientChart.Treatment2__c) || 
          !ValueIsNull(clientChart.Status2__c) || !ValueIsNull(clientChart.Allergy_Source2__c) ){
            allergy2 = True;
        }else{allergy2 = False;}
        if(!ValueIsNull(clientChart.Allergen3__c) || !ValueIsNull(clientChart.Allergy_Type3__c) || 
           !ValueIsNull(clientChart.Reaction3__c) || !ValueIsNull(clientChart.Reaction_type3__c) || 
          !ValueIsNull(clientChart.Onset3__c) || !ValueIsNull(clientChart.Treatment3__c) || 
          !ValueIsNull(clientChart.Status3__c) || !ValueIsNull(clientChart.Allergy_Source3__c) ){
            allergy3 = True;
        }else{allergy3 = False;}
        if(!ValueIsNull(clientChart.Allergen4__c) || !ValueIsNull(clientChart.Allergy_Type4__c) || 
           !ValueIsNull(clientChart.Reaction4__c) || !ValueIsNull(clientChart.Reaction_type4__c) || 
          !ValueIsNull(clientChart.Onset4__c) || !ValueIsNull(clientChart.Treatment4__c) || 
          !ValueIsNull(clientChart.Status4__c) || !ValueIsNull(clientChart.Allergy_Source4__c) ){
            allergy4 = True;
        }else{allergy4 = False;}
        if(!ValueIsNull(clientChart.Allergen5__c) || !ValueIsNull(clientChart.Allergy_Type5__c) || 
           !ValueIsNull(clientChart.Reaction5__c) || !ValueIsNull(clientChart.Reaction_type5__c) || 
          !ValueIsNull(clientChart.Onset5__c) || !ValueIsNull(clientChart.Treatment5__c) || 
          !ValueIsNull(clientChart.Status5__c) || !ValueIsNull(clientChart.Allergy_Source5__c) ){
            allergy5 = True;
        }else{allergy5 = False;}
        if(!ValueIsNull(clientChart.Allergen6__c) || !ValueIsNull(clientChart.Allergy_Type6__c) || 
           !ValueIsNull(clientChart.Reaction6__c) || !ValueIsNull(clientChart.Reaction_type6__c) || 
          !ValueIsNull(clientChart.Onset6__c) || !ValueIsNull(clientChart.Treatment6__c) || 
          !ValueIsNull(clientChart.Status6__c) || !ValueIsNull(clientChart.Allergy_Source6__c) ){
            allergy6 = True;
        }else{allergy6 = False;}
    }
    
    public void addAllergy(){
        checkRenderAllergies();
        if(Allergy1 == false){
            allergy1 = True;
        }
        else if(Allergy2 == false){
            Allergy2 = True;
        }
        else if(Allergy3 == false){
            allergy3 = True;
        }
        else if(Allergy4 == false){
            allergy4 = True;
        }
        else if(Allergy5 == false){
            allergy5 = True;
        }
        else if(Allergy6 == false){
            allergy6 = True;
        }
    }
    
    public void removeAllergy(){
        checkRenderAllergies();
        if(Allergy6 == True){
            allergy6 = false;
            clientChart.Allergen6__c= '';
            clientChart.Allergy_Type6__c= '';
            clientChart.Reaction6__c= '';
            clientChart.Reaction_Type6__c= '';
            clientChart.Onset6__c= '';
            clientChart.Treatment6__c= '';
            clientChart.Status6__c='';
            clientChart.Allergy_Source6__c= '';
        }
        else if(Allergy5 == True){
            allergy5 = false;
            clientChart.Allergen5__c= '';
            clientChart.Allergy_Type5__c= '';
            clientChart.Reaction5__c= '';
            clientChart.Reaction_Type5__c= '';
            clientChart.Onset5__c= '';
            clientChart.Treatment5__c= '';
            clientChart.Status5__c='';
            clientChart.Allergy_Source5__c= '';
        }
        else if(Allergy4 == True){
            allergy4 = false;
            clientChart.Allergen4__c= '';
            clientChart.Allergy_Type4__c= '';
            clientChart.Reaction4__c= '';
            clientChart.Reaction_Type4__c= '';
            clientChart.Onset4__c= '';
            clientChart.Treatment4__c= '';
            clientChart.Status4__c='';
            clientChart.Allergy_Source4__c= '';
        }
        else if(Allergy3 == True){
            allergy3 = false;
            clientChart.Allergen3__c= '';
            clientChart.Allergy_Type3__c= '';
            clientChart.Reaction3__c= '';
            clientChart.Reaction_Type3__c= '';
            clientChart.Onset3__c= '';
            clientChart.Treatment3__c= '';
            clientChart.Status3__c='';
            clientChart.Allergy_Source3__c= '';
        }
        else if(Allergy2 == True){
            allergy2 = false;
            clientChart.Allergen2__c= '';
            clientChart.Allergy_Type2__c= '';
            clientChart.Reaction2__c= '';
            clientChart.Reaction_Type2__c= '';
            clientChart.Onset2__c= '';
            clientChart.Treatment2__c= '';
            clientChart.Status2__c='';
            clientChart.Allergy_Source2__c= '';
        }
        else if(Allergy1 == True){
            allergy1 = false;
            clientChart.Allergen1__c= '';
            clientChart.Allergy_Type1__c= '';
            clientChart.Reaction1__c= '';
            clientChart.Reaction_Type1__c= '';
            clientChart.Onset1__c= '';
            clientChart.Treatment1__c= '';
            clientChart.Status1__c='';
            clientChart.Allergy_Source1__c= '';
        }
    }
    
    public Boolean PAA_Medical_condition_seizures_tube{get;set;}
    public Boolean PAA_Attempted_suicide{get;set;}
    public Boolean PAA_Physician_for_pain_Management{get;set;}
    public Boolean PAA_Do_you_have_a_recent_history_of_assa{get;set;}
    public Boolean PAA_History_of_arson_or_fire_setting{get;set;}
    public Boolean PAA_involuntary_psychiatric_hold{get;set;}
    public Boolean PAA_Are_you_taking_any_medications{get;set;}
    public Boolean PAA_Recently_hospitalized_recent_surgery{get;set;}
    public Boolean PAA_Do_you_have_any_allergies{get;set;}
    public Boolean PAA_Do_you_have_a_family_history_of_suic{get;set;}
    public Boolean PAA_family_history_of_mental_health_diso{get;set;}
    public Boolean PAA_family_history_of_substance_abuse{get;set;}
    public Boolean PAA_Any_outstanding_legal_issues{get;set;}
    public Boolean PAA_notice_to_you_employer_seeking_subst{get;set;}
    public Boolean PAA_We_need_PHI_consent{get;set;}
    
    public void setCheckBoxes(){
        ce.PAA_Medical_condition_seizuresC__c = TRUE;
        ce.PAA_Attempted_suicideC__c = TRUE;
        ce.PAA_Physician_for_pain_ManagementC__c = TRUE;
        ce.PAA_Do_you_have_a_recent_history_ofC__c = TRUE;
        ce.PAA_History_of_arson_or_fire_settingC__c = TRUE;
        ce.PAA_Involuntary_psychiatric_hold_51_50C__c = TRUE;
        ce.PAA_Are_you_taking_any_medicationsC__c = TRUE;
        ce.PAA_Do_you_have_a_family_history_ofC__c = TRUE;
        ce.PAA_Family_history_of_mental_health_disC__c= true;
        ce.PAA_family_history_of_substance_abuseC__c = True;
        ce.PAA_Any_outstanding_legal_issuesC__c = TRUE;
        ce.PAA_Notice_to_you_employer_seekingC__c = True;
        ce.PAA_We_need_PHI_consentC__c = True;
    }
    
    public void checkRender1(){
        if(ce.PAA_Medical_condition_seizures_tube__c == 'Yes'){
            PAA_Medical_condition_seizures_tube = true;
        }
        else if(ce.PAA_Medical_condition_seizures_tube__c != 'Yes'){
            PAA_Medical_condition_seizures_tube = false;
        }
        if(ce.PAA_Attempted_suicide__c == 'Yes'){
            PAA_Attempted_suicide = true;
        }
        else if(ce.PAA_Attempted_suicide__c != 'Yes'){
            PAA_Attempted_suicide = false;
        }
        if(ce.PAA_Physician_for_pain_Management__c == 'Yes'){
            PAA_Physician_for_pain_Management = true;
        }
        else if(ce.PAA_Physician_for_pain_Management__c != 'Yes'){
            PAA_Physician_for_pain_Management = false;
        }
        if(ce.PAA_Do_you_have_a_recent_history_of_assa__c == 'Yes'){
            PAA_Do_you_have_a_recent_history_of_assa = true;
        }
        else if(ce.PAA_Do_you_have_a_recent_history_of_assa__c != 'Yes'){
            PAA_Do_you_have_a_recent_history_of_assa = false;
        }
        if(ce.PAA_History_of_arson_or_fire_setting__c == 'Yes'){
            PAA_History_of_arson_or_fire_setting = true;
        }
        else if(ce.PAA_History_of_arson_or_fire_setting__c != 'Yes'){
            PAA_History_of_arson_or_fire_setting = false;
        }
        if(ce.PAA_involuntary_psychiatric_hold__c == 'Yes'){
            PAA_involuntary_psychiatric_hold = true;
        }
        else if(ce.PAA_involuntary_psychiatric_hold__c != 'Yes'){
            PAA_involuntary_psychiatric_hold = false;
        }
        
        
    }
    public void checkRender2(){
        if(ce.PAA_Medical_condition_seizuresC__c == TRUE){
            PAA_Medical_condition_seizures_tube = FALSE;
        }
        else if(ce.PAA_Medical_condition_seizuresC__c != TRUE){
            PAA_Medical_condition_seizures_tube = true;
        }
        if(ce.PAA_Attempted_suicideC__c == TRUE){
            PAA_Attempted_suicide = FALSE;
        }
        else if(ce.PAA_Attempted_suicideC__c != TRUE){
            PAA_Attempted_suicide = true;
        }
        
        if(ce.PAA_Physician_for_pain_ManagementC__c == TRUE){
            PAA_Physician_for_pain_Management = FALSE;
        }
        else if(ce.PAA_Physician_for_pain_ManagementC__c != TRUE){
            PAA_Physician_for_pain_Management = true;
        }
        
        if(ce.PAA_Do_you_have_a_recent_history_ofC__c == TRUE){
            PAA_Do_you_have_a_recent_history_of_assa = FALSE;
        }
        else if(ce.PAA_Do_you_have_a_recent_history_ofC__c != TRUE){
            PAA_Do_you_have_a_recent_history_of_assa = true;
        }
        if(ce.PAA_History_of_arson_or_fire_settingC__c == TRUE){
            PAA_History_of_arson_or_fire_setting = FALSE;
        }
        else if(ce.PAA_History_of_arson_or_fire_settingC__c != TRUE){
            PAA_History_of_arson_or_fire_setting = true;
        }
        if(ce.PAA_Involuntary_psychiatric_hold_51_50C__c == TRUE){
            PAA_involuntary_psychiatric_hold = FALSE;
        }
        else if(ce.PAA_Involuntary_psychiatric_hold_51_50C__c != TRUE){
            PAA_involuntary_psychiatric_hold = true;
        }
    }
    public void checkRendermh(){
        if(ce.PAA_Are_you_taking_any_medications__c == 'Yes'){
            PAA_Are_you_taking_any_medications = true;
        }
        else if(ce.PAA_Are_you_taking_any_medications__c != 'Yes'){
            PAA_Are_you_taking_any_medications = false;
        }
        if(ce.PAA_Recently_hospitalized_recent_surgery__c == 'Yes'){
            PAA_Recently_hospitalized_recent_surgery = true;
        }
        else if(ce.PAA_Recently_hospitalized_recent_surgery__c != 'Yes'){
            PAA_Recently_hospitalized_recent_surgery = false;
        }
        if(ce.PAA_Do_you_have_any_allergies__c == 'Yes'){
            PAA_Do_you_have_any_allergies = true;
        }
        else if(ce.PAA_Do_you_have_any_allergies__c != 'Yes'){
            PAA_Do_you_have_any_allergies = false;
        }
    }
    public void checkRendermh2(){
        if(ce.PAA_Are_you_taking_any_medicationsC__c == TRUE){
            PAA_Are_you_taking_any_medications = FALSE;
        }
        else if(ce.PAA_Are_you_taking_any_medicationsC__c != TRUE){
            PAA_Are_you_taking_any_medications = true;
        }
        if(ce.PAA_Recently_hospitalized_recent_surgerC__c == TRUE){
            PAA_Recently_hospitalized_recent_surgery = FALSE;
        }
        else if(ce.PAA_Recently_hospitalized_recent_surgerC__c != TRUE){
            PAA_Recently_hospitalized_recent_surgery = true;
        }
        if(ce.PAA_Do_you_have_any_allergies__c == 'Yes'){
            PAA_Do_you_have_any_allergies = true;
        }
        else if(ce.PAA_Do_you_have_any_allergies__c != 'Yes'){
            PAA_Do_you_have_any_allergies = false;
        }
    }
    public void checkRendercsp(){
    }
    public void checkRendercsp1(){
    }
    public void checkRenderth(){
    }
    public void checkRenderth1(){
    }
    public void checkRenderth2(){
    }
    public void checkRenderfpah(){
        if(ce.PAA_Do_you_have_a_family_history_of_suic__c == 'Yes'){
            PAA_Do_you_have_a_family_history_of_suic = true;
        }
        else if(ce.PAA_Do_you_have_a_family_history_of_suic__c != 'Yes'){
            PAA_Do_you_have_a_family_history_of_suic = false;
        }
        if(ce.PAA_family_history_of_mental_health_diso__c == 'Yes'){
            PAA_family_history_of_mental_health_diso = true;
        }
        else if(ce.PAA_family_history_of_mental_health_diso__c != 'Yes'){
            PAA_family_history_of_mental_health_diso = false;
        }
        if(ce.PAA_family_history_of_substance_abuse__c == 'Yes'){
            PAA_family_history_of_substance_abuse = true;
        }
        else if(ce.PAA_family_history_of_substance_abuse__c != 'Yes'){
            PAA_family_history_of_substance_abuse = false;
        }
    }
    public void checkRenderfpah2(){
        if(ce.PAA_Do_you_have_a_family_history_ofC__c == TRUE){
            PAA_Do_you_have_a_family_history_of_suic = FALSE;
        }
        else if(ce.PAA_Do_you_have_a_family_history_ofC__c != TRUE){
            PAA_Do_you_have_a_family_history_of_suic = true;
        }
        if(ce.PAA_Family_history_of_mental_health_disC__c == TRUE){
            PAA_family_history_of_mental_health_diso = FALSE;
        }
        else if(ce.PAA_Family_history_of_mental_health_disC__c != TRUE){
            PAA_family_history_of_mental_health_diso = true;
        }
        if(ce.PAA_family_history_of_substance_abuseC__c == TRUE){
            PAA_family_history_of_substance_abuse = FALSE;
        }
        else if(ce.PAA_family_history_of_substance_abuseC__c != TRUE){
            PAA_family_history_of_substance_abuse = true;
        }
    }
    public void checkRenderlp(){
        if(ce.PAA_Any_outstanding_legal_issues__c == 'Yes'){
            PAA_Any_outstanding_legal_issues = true;
        }
        else if(ce.PAA_Any_outstanding_legal_issues__c != 'Yes'){
            PAA_Any_outstanding_legal_issues = false;
        }
        if(ce.PAA_notice_to_you_employer_seeking_subst__c == 'Yes'){
            PAA_notice_to_you_employer_seeking_subst = true;
        }
        else if(ce.PAA_notice_to_you_employer_seeking_subst__c != 'Yes'){
            PAA_notice_to_you_employer_seeking_subst = false;
        }
        if(ce.PAA_We_need_PHI_consent__c == 'Yes'){
            PAA_We_need_PHI_consent = true;
        }
        else if(ce.PAA_We_need_PHI_consent__c != 'Yes'){
            PAA_We_need_PHI_consent = false;
        }
    }
    public void checkRenderlp2(){
        if(ce.PAA_Any_outstanding_legal_issuesC__c == TRUE){
            PAA_Any_outstanding_legal_issues = FALSE;
        }
        else if(ce.PAA_Any_outstanding_legal_issuesC__c != TRUE){
            PAA_Any_outstanding_legal_issues = true;
        }
        if(ce.PAA_Notice_to_you_employer_seekingC__c == TRUE){
            PAA_notice_to_you_employer_seeking_subst = FALSE;
        }
        else if(ce.PAA_Notice_to_you_employer_seekingC__c != TRUE){
            PAA_notice_to_you_employer_seeking_subst = true;
        }
        if(ce.PAA_We_need_PHI_consentC__c == TRUE){
            PAA_We_need_PHI_consent = FALSE;
        }
        else if(ce.PAA_We_need_PHI_consentC__c != TRUE){
            PAA_We_need_PHI_consent = true;
        }
    }
    */
    public boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false; 
        loadForm = true;
    }     
    public void showPopup() {        
        displayPopup = true; 
        loadForm = false;
    }
    
    public PageReference CloseSignatureForm() {
    
        callJs = false;
        ce3Record.Clinical_Evaluation__c = ceID;
        if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == NULL) {

            ce3Record.Staff_Signature_URL_Closed__c = AWSURL + ImageUrlAddress;
            ce3Record.Staff_Signed_User_Closed__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            ce3Record.Staff_Closed_Date__c = DateTime.Now();
            ce3Record.SignedBy__c = 'Staff';
        } /*else if (SelectedSignedOption == 'Patient') {

            ce3Record.Client_Image_Url_Closed__c = AWSURL + ImageUrlAddress;
            ce3Record.Client_Signed_User_Closed__c = '(Patient) ' + ce.Client_Chart__r.Name;
            ce3Record.Client_Closed_Date__c = DateTime.Now();
            ce3Record.SignedBy__c = 'Client';
            ce.SignedBy__c = 'Client';
        }*/ else if (userObj.User_Role__c != NULL) {

            ce3Record.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
            ce3Record.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
            ce3Record.Intern_Closed_Date__c = DateTime.Now();
            ce3Record.SignedBy__c = 'Client';
            ce.Status__c = 'Review Pending';
        }

        if ((ce3Record.Staff_Signed_User_Closed__c != null || String.isNotBlank(ce3Record.Staff_Signed_User_Closed__c ))){// && (ce3Record.Client_Signed_User_Closed__c != null || String.isNotBlank(ce3Record.Client_Signed_User_Closed__c ))) {
            ce.Status__c = 'Closed';
            ce3Record.SignedBy__c = 'All'; // signing is complete
              

        }
        
        if(ce.Status__c != 'Closed'){
         callJS = true;
        }
         
       update ce;
       upsert ce3Record;
       return null;
 

    }
}