//Test Class : CE_FFE_Edit_Read_Test
public class CE_FFE_Edit_Read {

    public PageReference Back() {
        return null;
    }
    
    public Client_Chart__c clientChart {get;set;}
    public Clinical_Evaluation__c ce{get;set;}
    public Clinical_Evaluation_3__c ce3Record{get; set;}
    public Recurring_Assessment__c VitalSign {get; set;}
    public UtlizationReviewOrder__c vitalJunction {get; set;}
    
    public string CEID {get; set;}
    public string ClientID {get; set;}
    public string RecordtypeName {get; set;}
    public string rtype {get; set;}
    
    public Boolean loadForm {get;set;}
    public Boolean isEdit {get; set;}
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
    
    public string BodyChartUrl {get;set;}
    
    public CE_FFE_Edit_Read (){
        ce3Record = new Clinical_Evaluation_3__c();
        ce = new Clinical_Evaluation__c();
        VitalSign = new Recurring_Assessment__c();
        vitalJunction = new UtlizationReviewOrder__c();
        
        callJS = false;
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        BodyChartUrl = '';
        
        Id ffeRecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Face to Face Evaluation').getRecordTypeId();        
        loadForm = true;
        ClientID = ApexPages.currentPage().getParameters().get('id');
        CEID = ApexPages.currentPage().getParameters().get('ceId');
        RecordtypeName = ApexPages.CurrentPage().getParameters().get('type');
        rtype = ApexPages.CurrentPage().getParameters().get('rt') != null? ApexPages.CurrentPage().getParameters().get('rt') : '';
        if(ClientID != null){
            clientChart = [SELECT id, RecordType.name 
                           FROM Client_Chart__c WHERE id = :ClientID limit 1];
            
            if(CEID == null)
            {
                ce = new Clinical_Evaluation__c(RecordTypeId=ffeRecordTypeId);
                ce.Client_Chart__c = ClientID;
                ce.PAA_Date__c = System.today();
                ce.Status__c = 'In Progress';
            }   
            
            else if(CEID != null && RecordtypeName == 'Face to Face Evaluation')
            {
                try{
                    ce = [Select Id, Name, due_date_time__c,RecordTypeId, Client_Chart__c, X02_Saturations__c,
                            FFE_Sexual_Behavior_Acting_Out_Explain__c,FFE_PSA_AA_NA__c,
                            FFE_Access_to_Guns__c,FFE_Additional_comments_notes__c,FFE_Age_s_of_children__c,
                            FFE_Alcohol_drugs_present_in_environment__c,FFE_Alcohol_present_in_environment_Expla__c,
                            FFE_Appetite__c,FFE_BP_diastolic__c,FF_BP_Systolic__c,FFE_Breathalyzer__c,
                            FFE_Client_occupation_where_continued_Ex__c,FFE_Client_occupation_where_continued_us__c,
                            FFE_Client_Recognize_Usage_Excessive__c,FFE_Client_Recognize_Usage_Excessive_Exp__c,
                            FFE_Current_Medication_Amount_1__c,FFE_Current_Medication_Amount_10__c,
                            FFE_Current_Medication_Amount_2__c,FFE_Current_Medication_Amount_3__c,
                            FFE_Current_Medication_Amount_4__c,FFE_Current_Medication_Amount_5__c,
                            FFE_Current_Medication_Amount_6__c,FFE_Current_Medication_Amount_7__c,
                            FFE_Current_Medication_Amount_8__c,FFE_Current_Medication_Amount_9__c,
                            FFE_Current_Suicidal_ideations_Explain__c,FFE_Current_Suicidal_ideations__c,
                            FFE_DoctorVisit_Date1__c,FFE_DoctorVisit_Date2__c,FFE_DoctorVisit_Date3__c,
                            FFE_DoctorVisit_Date4__c,FFE_DoctorVisit_Date5__c,FFE_Medication_Date1__c,
                            FFE_PSA_Detox__c,FFE_Difficulty_falling_asleep__c,FFE_Difficulty_gratification_drug_explai__c,
                            FFE_Difficulty_postponing_gratification__c,FFE_Difficulty_staying_asleep__c,
                            FFF_Does_client_have_cravings_Explain_1__c,FFE_Does_the_client_have_cravings__c,
                            FFE_Does_the_client_live_where_Explain__c,FFE_Does_the_client_live_where_treatment__c,
                            FFE_Does_their_environment_undermine_eff__c,FFE_Does_their_environment_undermine_Exp__c,
                            FFE_Domestic_Violence_explain__c,FFE_Domestic_Violence__c,Drug_Screen__c,
                            FFE_Evaluation_End_Time__c,FFE_Evaluation_Start_Time__c,FFE_Family_history_of_Psychatric__c,
                            FFE_Family_history_of_substance_abuse__c,FFE_Family_Psychiatric_Behavior_explain__c,
                            FFE_LPA_For_how_long__c,FFE_Gambling_Addiction_Does_the_client_h__c,
                            FFE_Gambling_Addiction_Explain__c,FFE_Has_patient_failed_lower_level_of_Ca__c,
                            FFE_Have_you_ever_been_DX_with_MH_issues__c,FFE_MH_Height__c,FFE_PSA_Home_group__c,
                            FFE_If_you_have_DX_with_MH_issues_explai__c,FFE_PMH_Inpatient__c,FFE_PSA_IOP__c,
                            FFE_PMH_IOP__c,FFE_is_client_purging__c,FFE_is_client_purging_How_long_Explain__c,
                            FFE_Legal_Issues__c,FFE_Legal_Issues_explain__c,FFE_Legal_Issues_PO_Involved_ROI_Signed__c,
                            FFE_Lives_With__c,FFE_ls_client_restricting_food__c,FFE_Marital_Status__c,
                            FFE_Medical_History__c,FFE_Medication_Date_10__c,FFE_Medication_Date_2__c,
                            FFE_Medication_Date_3__c,FFE_Medication_Date_4__c,FFE_Medication_Date_5__c,
                            FFE_Medication_Date_6__c,FFE_Medication_Date_7__c,FFE_Medication_Date_8__c,
                            FFE_Medication_Date_9__c,FFE_Medication_Name1__c,FFE_Medication_Name2__c,
                            FFE_Medication_Name3__c,FFE_Medication_Name4__c,FFE_Medication_Name5__c,
                            FFE_Medication_Name6__c,FFE_Medication_Name7__c,FFE_Medication_Name8__c,FFE_MH_Other__c,
                            FFE_Medication_Name9__c,FFE_Medication_Name10__c,FFE_Number_of_Children__c,
                            FFE_PSA_OP__c,FFE_PMH_OP__c,FFE_Other_Trauma__c,FFE_Other_Trauma_explain__c,
                            FFE_Patient_failed_lower_level_of_Care_e__c,FFE_Perpetrator__c,FFE_Perpetrator_explain__c,
                            FFE_PSA_PHP__c,FFE_PMH_PHP__c,FFE_Precipitating_Crisis__c,FFE_Presently_in_recovery_from_an_eating__c,
                            FFE_Prior_IMP_Psychiatric_TX__c,FFE_Prior_IMP_Psychiatric_TX_Explain__c,FFE_Prior_Mental_Health_Dates__c,
                            Prior_Substance_abuse_treatment_with_dat__c,FFE_Prior_Suicide_attempts_Explain__c,
                            FFE_Prior_Suicide_attempts__c,FFE_SPA_Psychiatrist__c,FFE_PMH_Psychiatrist__c,FFE_PMH_Psychologist__c,
                            FFE_Psychotropic_Meds_Explain__c,FFE_Psychotropic_Meds__c,FFE_SPA_Psychologist__c,Pulse__c,
                            FFE_Reason_for_Visit1__c,FFE_Reason_for_Visit2__c,FFE_Reason_for_Visit3__c,Reason_for_Visit4__c,
                            FFE_Reason_for_Visit5__c,FFE_PSA_Rehab_Res__c,FFE_PMH_Rehab_Res__c,FFE_Relationship__c,
                            FFE_Report_Filed_Perpetrator__c,Respirations__c,FFE_MH_Seizures__c,FFE_Self_Mutilating_Behaviour_Explain__c,
                            FFE_Self_Mutilating_Behaviour__c,FFE_Severity_dysfuntional_behaviors__c,
                            FFE_Sexual_Behavior_Relational_issues_Re__c,FFE_Sexual_Behavior_Acting_Out__c,
                            FFE_Sexual_Behavior_Recovry_Explain__c,FFE_Sleep__c,FFE_Sober_Support_System__c,
                            FFE_PSA_Sponsor__c,FFE_Temperature__c,FFE_DoctorVisit_Treatment1__c,FFE_DoctorVisit_Treatment2__c,
                            FFE_DoctorVisit_Treatment3__c,FFE_DoctorVisit_Treatment4__c,FFE_DoctorVisit_Treatment5__c,
                            FFE_Ultimatum_given__c,FFE_Victim_of_Abuse__c,FFE_Victim_of_Abuse_explain__c,
                            FFE_Violence_Homicidal_Ideations__c,FFE_Violence_Homicidal_Ideations_explain__c,
                            FFE_MH_Weight__c,FFE_What_serious_consequences_client_lif__c,FFE_LPA_When__c,
                            FFE_Who_Brought_you_to_treatment__c,FFE_Who_Will_be_involved_in_treatment__c,
                            PAA_Any_outstanding_legal_issues__c,PAA_Explain_if_any_outstanding_legal_iss__c, 
                            FFE_AlcoholDrugH_Age1__c,FFE_AlcoholDrugH_Age2__c,FFE_AlcoholDrugH_Age3__c,FFE_AlcoholDrugH_Age4__c,
                            FFE_AlcoholDrugH_Age5__c,FFE_AlcoholDrugH_Age6__c,FFE_AlcoholDrugH_Amount1__c,FFE_AlcoholDrugH_Amount2__c,
                            FFE_AlcoholDrugH_Amount3__c,FFE_AlcoholDrugH_Amount4__c,FFE_AlcoholDrugH_Amount5__c,FFE_AlcoholDrugH_Amount6__c,
                            FFE_AlcoholDrugH_Rate1__c,FFE_AlcoholDrugH_Rate2__c,FFE_AlcoholDrugH_Rate3__c,FFE_AlcoholDrugH_Rate4__c,
                            FFE_AlcoholDrugH_Rate5__c,FFE_AlcoholDrugH_Rate6__c,FFE_AlcoholDrugH_DateLastUse1__c,FFE_AlcoholDrugH_DateLastUse2__c,
                            FFE_AlcoholDrugH_DateLastUse3__c,FFE_AlcoholDrugH_DateLastUse4__c,FFE_AlcoholDrugH_DateLastUse5__c,
                            FFE_AlcoholDrugH_DateLastUse6__c,FFE_AlcoholDrugH_Name1__c,FFE_AlcoholDrugH_Name2__c,FFE_AlcoholDrugH_Name3__c,
                            FFE_AlcoholDrugH_Name4__c,FFE_AlcoholDrugH_Name5__c,FFE_AlcoholDrugH_Name6__c,FFE_AlcoholDrugH_Route1__c,
                            FFE_AlcoholDrugH_Route2__c,FFE_AlcoholDrugH_Route3__c,FFE_AlcoholDrugH_Route4__c,
                            FFE_AlcoholDrugH_Route5__c,FFE_AlcoholDrugH_Route6__c,PAA_Prior_Substance_abuse_treatmentC__c,
                            PAA_Prior_Mental_Health_DatesC__c,FFE_family_history_of_substance_abuseC__c,Most_Recent_Hospital_Doctor_visitsC__c,
                            Current_Medication__c,Client_Chart__r.Treatment_Center__r.Name, Client_Chart__r.Name, status__c,
                            PAA_We_need_PHI_consent__c,PAA_Previous_Treatment_Notes__c
                            FROM Clinical_Evaluation__c where id =:CEID];
                            
                            
                    if(ce.Status__c == 'Review Pending' || ce.Status__c == 'Closed')
                        ce3Record = [select id,Clinical_Evaluation__c, Client_Closed_Date__c, Client_Image_Url_Closed__c, Client_Signed_User_Closed__c, Intern_Closed_Date__c,
                                    Intern_Signature_URL__c, Intern_Signed_User__c, Staff_Closed_Date__c, Staff_Signature_URL_Closed__c, Staff_Signed_User_Closed__c,
                                    SignedBy__c from Clinical_Evaluation_3__c where Clinical_Evaluation__c =: CEID order by CreatedDate DESC Limit 1];
                
                    if (ce.Status__c == null || ce.Status__c == 'In Progress' || ce.Status__c == 'Open') {
                        
                        ce.Status__c = 'In Progress';
                        ce3Record.SignedBy__c = 'None';
                    }
                    
                    //getLatestVital();
                
                }
                catch(Exception e){
                    Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'The Id passed in URL is invalid.');
                    ApexPages.addMessage(errMsg);
                    loadForm = false;
                }
            }
            
            userObj = [Select id, name, title, User_Role__c,Has_Overwrite_Access__c from user where id =: userinfo.getUserID()];
            
            
            
        }
        else{
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'The Id passed in URL is invalid.');
            ApexPages.addMessage(errMsg);
            loadForm = false;
        }
        AllRenderFunctions();
        
    }
    public void getLatestVital()
    {
        list<UtlizationReviewOrder__c> lstRevOrd = [select id, Vital_Sign__r.BP_Systolic__c,Vital_Sign__r.BP_Diastolic__c,Vital_Sign__r.Temperature__c,
                                                        Vital_Sign__r.Pulse__c,Vital_Sign__r.Respirations__c,Vital_Sign__r.X02_Saturation__c, Clinical_Evaluation_3__c
                                                        from UtlizationReviewOrder__c where Clinical_Evaluation_3__c =: CEID];
            if(lstRevOrd.size()>0)
                vitalJunction = lstRevOrd[0];
        
        
    }
    /*
    public boolean ProcessVitalSign{
        get{
            boolean showVitalSign = false;
            if(ce.Id != null && ce.Status__c != 'Complete')
            {
                if(vitalJunction.id != null)
                    delete vitalJunction;
                
                list<Recurring_Assessment__c> lstRecAss = [select id, Clinical_Evaluation_3__c, createdDate, BP_Systolic__c, BP_Diastolic__c, Temperature__c, Pulse__c, Respirations__c,
                                                           X02_Saturation__c from Recurring_Assessment__c where Client_Chart__c =: ce.Id and Recordtype.name = 'Vital Signs' order by createdDate desc limit 1 ];
                
                
                if(lstRecAss.size()>0)
                {
                    vitalJunction = new UtlizationReviewOrder__c();
                    vitalJunction.Vital_Sign__c = lstRecAss[0].id;
                    vitalJunction.Clinical_Evaluation_3__c = CEId;
                    insert vitalJunction;
                    ceRecord.HP_Vital_Update_Time__c = datetime.now();
                    update ceRecord;                
                }
                system.debug('#vitalJunction='+vitalJunction);
                getLatestVital();
            }
            return showVitalSign;
        }
        
    }*/
    public boolean ProcessVitalSign{
        get{
            boolean showVitalSign = false;
            if(ce.Status__c != 'Closed')
            {
                List<Recurring_Assessment__c> RecAssList = [Select Id, Name, Status__c, X02_Saturation__c, BP_Diastolic__c, BP_Systolic__c,
                                                            Temperature__c, Respirations__c, Pulse__c, LastModifiedDate from Recurring_Assessment__c
                                                            where Status__c = 'Closed' and Client_Chart__c =: ClientID and Recordtype.name = 'Vital Signs' order by LastModifiedDate desc limit 1]; 
                if(RecAssList.size()>0)
                {
                    try
                    {
                        VitalSign = RecAssList[0];
                        List<UtlizationReviewOrder__c> toDelRecord = [Select Id from UtlizationReviewOrder__c where Clinical_Evaluation__c =: ce.Id];
                        if(toDelRecord.size()>0)
                        {
                            Delete toDelRecord[0];
                        }
                        UtlizationReviewOrder__c toCreatedRecord = new UtlizationReviewOrder__c();
                        toCreatedRecord.Vital_Sign__c = VitalSign.Id;
                        toCreatedRecord.Clinical_Evaluation__c = ce.Id;
                        insert toCreatedRecord;
                        
                        System.debug('Vital Sings: ' + toCreatedRecord);
                        
                        showVitalSign = true;
                    }
                    catch(Exception ex)
                    {
                        string ExMessgae = 'Exception occured: '+ ex.getMessage() + ', on line: '+ ex.getLineNumber();
                        System.debug(ExMessgae);
                    }
                }
            }else{
                
                List<UtlizationReviewOrder__c> junctionRecord = [Select Id,Vital_Sign__c from UtlizationReviewOrder__c where Clinical_Evaluation__c =: ce.Id];
                if(junctionRecord.size() > 0)
                {
                     List<Recurring_Assessment__c> RecAssList = [Select Id, Name, Status__c, X02_Saturation__c, BP_Diastolic__c, BP_Systolic__c,
                                                            Temperature__c, Respirations__c, Pulse__c, LastModifiedDate from Recurring_Assessment__c
                                                            where Status__c = 'Closed' and Client_Chart__c =: ClientID and Recordtype.name = 'Vital Signs' and Id =: junctionRecord[0].Vital_Sign__c];
                    if(RecAssList.size() >0)
                    {
                        showVitalSign = true;
                        VitalSign = RecAssList[0];
                    }
                }
            }
            return showVitalSign;    
        }
        
    }
    // Pass the resource name
    public String GetResourceURL(String resourceName){
        
        // Fetching the resource
        List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];
        
        // Checking if the result is returned or not
        if(resourceList.size() == 1){
            
            // Getting namespace
            String namespace = resourceList[0].NamespacePrefix;
            // Resource URL
            return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
        }
        else return '';
    }
    public void AllRenderFunctions()
    {
        checkRender2();
        checkRender22();
        checkRenderfhs2();
        checkRenderDocVisits();
        checkCurrMed();
        checkRenderdxmh();
        checkRenderdimpp();
        checkRenderdfhpb();
        checkRenderdpm();
        checkRenderdsmb();
        checkRenderdcsi();
        checkRenderdpsa();
        checkRenderdvhi();
        checkRenderddve();
        checkRenderdsbao();
        checkRenderdsbri();
    }
    
    public PageReference Edit()
    {
        PageReference pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
        pr.getParameters().put('ID',ClientID);
        pr.getParameters().put('ceId',CEID);
        pr.getParameters().put('type',RecordTypeName);
        pr.getParameters().put('readOnly','false');
        pr.getParameters().put('rt',rtype);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        
        return pr;
        
    }
    
    public PageReference Save()
    {
        if(BodyChartUrl != '')
        {
            //Using this field to save Body Chart Image.
            ce.PAA_Previous_Treatment_Notes__c = AWSURL + BodyChartUrl;
        }
        upsert ce;
        PageReference pr;
        try{
            if(ceID == null)
            {
                pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
                pr.getParameters().put('ID',ClientID);
                pr.getParameters().put('ceId',ce.Id);
                pr.getParameters().put('type',RecordTypeName);
                pr.getParameters().put('rt',rtype);
                pr.setRedirect(true); 
                return pr;
            }
            else if(ceID != null)
            {
                pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
                pr.getParameters().put('ID',ClientID);
                pr.getParameters().put('ceId',ceID);
                pr.getParameters().put('type',RecordTypeName);
                pr.getParameters().put('rt',rtype);
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
    
    public void QuickSave()
    {
        try{
            if(BodyChartUrl != '')
            {
                //Using this field to save Body Chart Image.
                ce.PAA_Previous_Treatment_Notes__c = AWSURL + BodyChartUrl;
            }
            upsert ce;
        }
        catch(exception ex)
        {
            ApexPages.AddMessages(ex);
        }
        
    }
    /*public void submit(){
        upsert ce;
        //loadForm = false;
    }
    */
    public pageReference Cancel()
    {
        PageReference pr;
        if(ceID == null)
        {
            pr = new PageReference('/apex/ClinicalEvaluationHomePage');
            pr.getParameters().put('ID',ClientID);
            pr.getParameters().put('type',RecordTypeName);
            pr.getParameters().put('rt',rtype);
            pr.setRedirect(true); 
            return pr;
        }
        else if(ceID != null)
        {
            pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
            pr.getParameters().put('ID',ClientID);
            pr.getParameters().put('ceId',ceID);
            pr.getParameters().put('type',RecordTypeName);
            pr.getParameters().put('rt',rtype);
            pr.setRedirect(true); 
            return pr;
        }
        return null;
    }
    public Boolean Prior_Substance_abuse_treatment_with_dat{get;set;}
    public Boolean FFE_Have_you_ever_been_DX_with_MH_issues{get;set;}
    public Boolean FFE_Prior_Mental_Health_Dates{get;set;}
    public Boolean PAA_family_history_of_substance_abuse{get;set;}
    public Boolean FFE_Prior_IMP_Psychiatric_TX{get;set;}
    public Boolean FFE_Family_history_of_Psychatric{get;set;}
    public Boolean FFE_Psychotropic_Meds{get;set;}
    public Boolean FFE_Self_Mutilating_Behaviour{get;set;}
    public Boolean FFE_Access_to_Guns{get;set;}
    public Boolean FFE_Current_Suicidal_ideations{get;set;}
    public Boolean FFE_Prior_Suicide_attempts{get;set;}
    public Boolean FFE_Violence_Homicidal_Ideations{get;set;}
    public Boolean FFE_Domestic_Violence{get;set;}
    public Boolean FFE_Perpetrator{get;set;}
    public Boolean FFE_Legal_Issues{get;set;}
    public Boolean FFE_Has_patient_failed_lower_level_of_Ca{get;set;}
    public Boolean FFE_Difficulty_postponing_gratification{get;set;}
    public Boolean FFE_Does_the_client_have_cravings{get;set;}
    public Boolean FFE_Client_Recognize_Usage_Excessive{get;set;}
    public Boolean FFE_Alcohol_drugs_present_in_environment{get;set;}
    public Boolean FFE_Does_the_client_live_where_treatment{get;set;}
    public Boolean FFE_Does_their_environment_undermine_eff{get;set;}
    public Boolean FFE_Client_occupation_where_continued_us{get;set;}
    public Boolean FFE_Sexual_Behavior_Relational_issues_Re{get;set;}
    public Boolean FFE_Sexual_Behavior_Acting_Out{get;set;}
    public Boolean FFE_Gambling_Addiction_Does_the_client_h{get;set;}
    public Boolean Most_Recent_Hospital_Doctor_visitsC {get;set;}
    public Boolean Current_Medication {get;set;}
    
    public void setCheckBoxes(){
        ce.PAA_Prior_Substance_abuse_treatmentC__c = TRUE;
        ce.PAA_Prior_Mental_Health_DatesC__c = True;
        ce.FFE_family_history_of_substance_abuseC__c = True;
        ce.Most_Recent_Hospital_Doctor_visitsC__c = True;
        ce.Current_Medication__c = True;
    }
    
    public void checkRender1(){
        if(ce.Prior_Substance_abuse_treatment_with_dat__c == 'Yes'){
            Prior_Substance_abuse_treatment_with_dat = true;
        }
        else if(ce.Prior_Substance_abuse_treatment_with_dat__c != 'Yes'){
            Prior_Substance_abuse_treatment_with_dat = false;
        }
    }
    public void checkRender2(){
        if(ce.PAA_Prior_Substance_abuse_treatmentC__c == TRUE){
            Prior_Substance_abuse_treatment_with_dat = FALSE;
        }
        else if(ce.PAA_Prior_Substance_abuse_treatmentC__c != TRUE){
            Prior_Substance_abuse_treatment_with_dat = true;
        }
    }
    public void checkRender22(){
        if(ce.PAA_Prior_Mental_Health_DatesC__c == TRUE){
            FFE_Prior_Mental_Health_Dates = FALSE;
        }
        else if(ce.PAA_Prior_Mental_Health_DatesC__c != TRUE){
            FFE_Prior_Mental_Health_Dates = true;
        }
    }
    
    public void checkRenderfhs(){
        if(ce.PAA_family_history_of_substance_abuse__c == 'Yes'){
            PAA_family_history_of_substance_abuse = true;
        }
        else if(ce.PAA_family_history_of_substance_abuse__c != 'Yes'){
            PAA_family_history_of_substance_abuse = false;
        }
    }
    public void checkRenderfhs2(){
        if(ce.FFE_family_history_of_substance_abuseC__c == TRUE){
            PAA_family_history_of_substance_abuse = FALSE;
        }
        else if(ce.FFE_family_history_of_substance_abuseC__c != TRUE){
            PAA_family_history_of_substance_abuse = true;
        }
    }
    public void checkRenderDocVisits(){
        if(ce.Most_Recent_Hospital_Doctor_visitsC__c == TRUE){
            Most_Recent_Hospital_Doctor_visitsC = FALSE;
        }
        else if(ce.Most_Recent_Hospital_Doctor_visitsC__c != TRUE){
            Most_Recent_Hospital_Doctor_visitsC = true;
        }
    }
    
    public void checkCurrMed(){
        if(ce.Current_Medication__c == TRUE){
            Current_Medication = FALSE;
        }
        else if(ce.Current_Medication__c != TRUE){
            Current_Medication = true;
        }
    }

    
    
    public void checkRenderpsmht(){
        if(ce.FFE_Prior_Mental_Health_Dates__c == 'Yes'){
            FFE_Prior_Mental_Health_Dates = true;
        }
        else if(ce.FFE_Prior_Mental_Health_Dates__c != 'Yes'){
            FFE_Prior_Mental_Health_Dates = false;
        }
    }
    public void checkRenderdxmh(){
        if(ce.FFE_Have_you_ever_been_DX_with_MH_issues__c == 'Yes'){
            FFE_Have_you_ever_been_DX_with_MH_issues = true;
        }
        else if(ce.FFE_Have_you_ever_been_DX_with_MH_issues__c != 'Yes'){
            FFE_Have_you_ever_been_DX_with_MH_issues = false;
        }
    }
    public void checkRenderdimpp(){
        if(ce.FFE_Prior_IMP_Psychiatric_TX__c == 'Yes'){
            FFE_Prior_IMP_Psychiatric_TX = true;
        }
        else if(ce.FFE_Prior_IMP_Psychiatric_TX__c != 'Yes'){
            FFE_Prior_IMP_Psychiatric_TX = false;
        }
    }
    public void checkRenderdfhpb(){
        if(ce.FFE_Family_history_of_Psychatric__c == 'Yes'){
            FFE_Family_history_of_Psychatric = true;
        }
        else if(ce.FFE_Family_history_of_Psychatric__c != 'Yes'){
            FFE_Family_history_of_Psychatric = false;
        }
    }
    public void checkRenderdpm(){
        if(ce.FFE_Psychotropic_Meds__c == 'Yes'){
            FFE_Psychotropic_Meds = true;
        }
        else if(ce.FFE_Psychotropic_Meds__c != 'Yes'){
            FFE_Psychotropic_Meds = false;
        }
    }
    public void checkRenderdsmb(){
        if(ce.FFE_Self_Mutilating_Behaviour__c == 'Yes'){
            FFE_Self_Mutilating_Behaviour = true;
        }
        else if(ce.FFE_Self_Mutilating_Behaviour__c != 'Yes'){
            FFE_Self_Mutilating_Behaviour = false;
        }
    }
    public void checkRenderdcsi(){
        if(ce.FFE_Current_Suicidal_ideations__c == 'Yes'){
            FFE_Current_Suicidal_ideations = true;
        }
        else if(ce.FFE_Current_Suicidal_ideations__c != 'Yes'){
            FFE_Current_Suicidal_ideations = false;
        }
    }
    public void checkRenderdpsa(){
        if(ce.FFE_Prior_Suicide_attempts__c == 'Yes'){
            FFE_Prior_Suicide_attempts = true;
        }
        else if(ce.FFE_Prior_Suicide_attempts__c != 'Yes'){
            FFE_Prior_Suicide_attempts = false;
        }
    }
    public void checkRenderdvhi(){
        if(ce.FFE_Violence_Homicidal_Ideations__c == 'Yes'){
            FFE_Violence_Homicidal_Ideations = true;
        }
        else if(ce.FFE_Violence_Homicidal_Ideations__c != 'Yes'){
            FFE_Violence_Homicidal_Ideations = false;
        }
    }
    public void checkRenderddve(){
        if(ce.FFE_Domestic_Violence__c == 'Yes'){
            FFE_Domestic_Violence = true;
        }
        else if(ce.FFE_Domestic_Violence__c != 'Yes'){
            FFE_Domestic_Violence = false;
        }
    }
    public void checkRenderdprep(){
        if(ce.FFE_Perpetrator__c == 'Yes'){
            FFE_Perpetrator = true;
        }
        else if(ce.FFE_Perpetrator__c != 'Yes'){
            FFE_Perpetrator = false;
        }
    }
    public void checkRenderdli(){
        if(ce.FFE_Legal_Issues__c != ''){
            FFE_Legal_Issues = true;
        }
        else if(ce.FFE_Legal_Issues__c == ''){
            FFE_Legal_Issues = false;
        }
    }
    public void checkRenderdpflc(){
        if(ce.FFE_Has_patient_failed_lower_level_of_Ca__c != ''){
            FFE_Has_patient_failed_lower_level_of_Ca = true;
        }
        else if(ce.FFE_Has_patient_failed_lower_level_of_Ca__c == ''){
            FFE_Has_patient_failed_lower_level_of_Ca = false;
        }
    }
    public void checkRenderddpg(){
        if(ce.FFE_Difficulty_postponing_gratification__c != ''){
            FFE_Difficulty_postponing_gratification = true;
        }
        else if(ce.FFE_Difficulty_postponing_gratification__c == ''){
            FFE_Difficulty_postponing_gratification = false;
        }
    }
    public void checkRenderddchc(){
        if(ce.FFE_Does_the_client_have_cravings__c != ''){
            FFE_Does_the_client_have_cravings = true;
        }
        else if(ce.FFE_Does_the_client_have_cravings__c == ''){
            FFE_Does_the_client_have_cravings = false;
        }
    }
    
    public void checkRenderdcrue(){
        if(ce.FFE_Client_Recognize_Usage_Excessive__c != ''){
            FFE_Client_Recognize_Usage_Excessive = true;
        }
        else if(ce.FFE_Client_Recognize_Usage_Excessive__c == ''){
            FFE_Client_Recognize_Usage_Excessive = false;
        }
    }
    public void checkRenderdadpe(){
        if(ce.FFE_Alcohol_drugs_present_in_environment__c != ''){
            FFE_Alcohol_drugs_present_in_environment = true;
        }
        else if(ce.FFE_Alcohol_drugs_present_in_environment__c == ''){
            FFE_Alcohol_drugs_present_in_environment = false;
        }
    }
    public void checkRenderdaclw(){
        if(ce.FFE_Does_the_client_live_where_treatment__c != ''){
            FFE_Does_the_client_live_where_treatment = true;
        }
        else if(ce.FFE_Does_the_client_live_where_treatment__c == ''){
            FFE_Does_the_client_live_where_treatment = false;
        }
    }
    public void checkRenderddtu(){
        if(ce.FFE_Does_their_environment_undermine_eff__c != ''){
            FFE_Does_their_environment_undermine_eff = true;
        }
        else if(ce.FFE_Does_their_environment_undermine_eff__c == ''){
            FFE_Does_their_environment_undermine_eff = false;
        }
    }
    public void checkRenderdcowc(){
        if(ce.FFE_Client_occupation_where_continued_us__c != ''){
            FFE_Client_occupation_where_continued_us = true;
        }
        else if(ce.FFE_Client_occupation_where_continued_us__c == ''){
            FFE_Client_occupation_where_continued_us = false;
        }
    }
    public void checkRenderdsbri(){
        if(ce.FFE_Sexual_Behavior_Relational_issues_Re__c != ''){
            FFE_Sexual_Behavior_Relational_issues_Re = true;
        }
        else if(ce.FFE_Sexual_Behavior_Relational_issues_Re__c == ''){
            FFE_Sexual_Behavior_Relational_issues_Re = false;
        }
    }
    public void checkRenderdsbao(){
        if(ce.FFE_Sexual_Behavior_Acting_Out__c != ''){
            FFE_Sexual_Behavior_Acting_Out = true;
        }
        else if(ce.FFE_Sexual_Behavior_Acting_Out__c == ''){
            FFE_Sexual_Behavior_Acting_Out = false;
        }
    }
    public void checkRenderdgadc(){
        if(ce.FFE_Gambling_Addiction_Does_the_client_h__c != ''){
            FFE_Gambling_Addiction_Does_the_client_h = true;
        }
        else if(ce.FFE_Gambling_Addiction_Does_the_client_h__c == ''){
            FFE_Gambling_Addiction_Does_the_client_h = false;
        }
    }
    
    public PageReference CloseSignatureForm() {
    
        callJs = false;
        ce3Record.Clinical_Evaluation__c = CEID;
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
        } */else if (userObj.User_Role__c != NULL) {

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