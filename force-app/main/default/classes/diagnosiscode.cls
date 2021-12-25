//Test Class : DiagnosisCode_Test
public class diagnosiscode {
    
    public string ClientID {get; set;}
    public string CEID {get; set;}
    public string StrexistingCodes {get; set;}
    public string RecordtypeName {get; set;}
    
    public Client_Chart__c clientRecord {get; set;}
    public Clinical_Evaluation__c ceRecord {get; set;} 
    public Clinical_Evaluation_3__c ce3Record{get; set;}
    public Clinical_Evaluation_3__c ce3RecordExt{get; set;}
    
    public boolean isEdit{get; set;}
    //public boolean isReadOnly {get;set;}
    public boolean callJS{get; set;}
    
    //AWS
    public string accessKeyId {get; set;}
    public string secretAccessKey {get; set;}
    public string OrgName {get; set;}
    final string AWSURL;
    
     //hidden field
    public string SelectedSignedOption {get; set;}
    public string ImageUrlAddress {get; set;}
    
    public list<string> Codes {get; set;}
    public list<string> listExistingCode {get; set;}
    public list<SelectOption> listAllCodes {get; set;}
    private set<string> setExistingCode;
    
    public User userObj {get; set;}
    
    public string buttonText {get;set;}
    public list<Order__c> listOfMeds {get; set;}
    
    public diagnosiscode() 
    {
        ce3Record = new Clinical_Evaluation_3__c();
        ce3RecordExt = new Clinical_Evaluation_3__c();
        callJS = false;
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        listOfMeds = new list<Order__c>();
        ClientID = ApexPages.CurrentPage().getParameters().get('ID');
        CEID = ApexPages.CurrentPage().getParameters().get('ceId');
        Id PERecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Phsych Evaluation').getRecordTypeId();
        Codes = new list<string>();
        RecordTypeName = ApexPages.CurrentPage().getParameters().get('type');
        
        buttonText = CEID == null ? 'Save' : 'Update' ;
        string isReadOnly = ApexPages.CurrentPage().getParameters().get('readOnly');
        if(isReadOnly != null)
        {
            if(isReadOnly.toLowerCase() == 'true')
            {
                isEdit = false; 
            }
            else if(isReadOnly.toLowerCase() == 'false')
            {
                isEdit = true;
            }
        }
        
        if(ClientID != null)
        {
            ceRecord = new Clinical_Evaluation__c();
            clientRecord = [select id,  Diagnosis_Code__c, RecordType.Name from Client_Chart__c where id =: ClientID];
            if(CEID != null && RecordtypeName =='Phsych Evaluation')
            {
                ceRecord = [select id, Client_Chart__r.Treatment_Center__r.Name, Client_Chart__r.Name, recordtype.name, 
                            status__c, Diagnosis_Code__c, PAA_Date__c, Client_Chart__c ,FFE_Additional_comments_notes__c,
                            X02_Saturations__c, FFE_Appetite__c, FFE_MH_Weight__c, FFE_Sleep__c, FFE_PSA_AA_NA__c,
                            FFE_Alcohol_present_in_environment_Expla__c, Current_Medication__c, PAA_Current_Medications__c,
                            PAA_Psychiatric_Diagnosis__c, PAA_Psychiatric_Co_occurring_Issues__c, FFE_Family_history_of_Psychatric__c,
                            FFE_Family_Psychiatric_Behavior_explain__c, LegalHistory_Client_Crime_History_NO__c, LegalHistory_Client_Crimnal_History_YES__c,
                            FFE_Domestic_Violence__c, FFE_Domestic_Violence_explain__c,FFE_AlcoholDrugH_Name1__c,FFE_AlcoholDrugH_Name2__c 
                            ,FFE_AlcoholDrugH_Name3__c ,FFE_AlcoholDrugH_Name4__c ,FFE_AlcoholDrugH_Name5__c ,FFE_AlcoholDrugH_Name6__c 
                            ,FFE_AlcoholDrugH_Amount1__c, FFE_AlcoholDrugH_Amount2__c, FFE_AlcoholDrugH_Amount3__c, FFE_AlcoholDrugH_Amount4__c
                            ,FFE_AlcoholDrugH_Amount5__c, FFE_AlcoholDrugH_Amount6__c, FFE_AlcoholDrugH_Age1__c
                            ,FFE_AlcoholDrugH_Age2__c, FFE_AlcoholDrugH_Age3__c, FFE_AlcoholDrugH_Age4__c, FFE_AlcoholDrugH_Age5__c
                            ,FFE_AlcoholDrugH_Age6__c, FFE_AlcoholDrugH_Rate1__c, FFE_AlcoholDrugH_Rate2__c, FFE_AlcoholDrugH_Rate3__c
                            ,FFE_AlcoholDrugH_Rate4__c, FFE_AlcoholDrugH_Rate5__c, FFE_AlcoholDrugH_Rate6__c, FFE_AlcoholDrugH_Route1__c
                            ,FFE_AlcoholDrugH_Route2__c,FFE_AlcoholDrugH_Route3__c, FFE_AlcoholDrugH_Route4__c, FFE_AlcoholDrugH_Route5__c
                            ,FFE_AlcoholDrugH_Route6__c, FFE_AlcoholDrugH_DateLastUse1__c, FFE_AlcoholDrugH_DateLastUse2__c
                            ,FFE_AlcoholDrugH_DateLastUse3__c, FFE_AlcoholDrugH_DateLastUse4__c,FFE_AlcoholDrugH_DateLastUse5__c
                            , Employment_History1_Job_Position__c, Employment_History1_Employment_Dates__c, Employment_History1_Salary__c
                            , Employment_History1_Reason_for_Leaving__c, Employment_History2_Job_Position__c, Employment_History2_Employment_Dates__c
                            , Employment_History2_Salary__c, Employment_History2_Reason_for_Leaving__c, Employment_History3_Job_Position__c
                            , Employment_History3_Employment_Dates__c, Employment_History3_Salary__c, Employment_History3_Reason_for_Leaving__c
                            , Employment_History4_Job_Position__c, Employment_History4_Employment_Dates__c, Employment_History4_Salary__c
                            , Employment_History4_Reason_for_Leaving__c,FFE_AlcoholDrugH_DateLastUse6__c,
                            FFE_Victim_of_Abuse_explain__c,PAA_We_need_PHI_consent__c, 
                            PAA_Current_Suicidal_Ideations__c, FFE_Violence_Homicidal_Ideations__c,PAA_Precipitating_Event__c,
                            FFE_Presently_in_recovery_from_an_eating__c, PAA_Willing_to_Discontinue_all_Pain_Meds__c,
                            PAA_Upcoming_Court_Dates__c, FFE_Other_Trauma__c, FFE_Other_Trauma_explain__c,
                            PAA_Any_outstanding_legal_issues__c,PAA_Explain_if_any_outstanding_legal_iss__c,
                            FFE_Difficulty_postponing_gratification__c,FFE_Difficulty_gratification_drug_explai__c,
                            FFE_Severity_dysfuntional_behaviors__c, FFE_is_client_purging_How_long_Explain__c,
                            FFE_Evaluation_Start_Time__c, Due_Date_time__c
                            from Clinical_Evaluation__c where id =: CEID];
                
                ce3RecordExt = [Select Id,Name,PE_Appetite__c,PE_Weight__c,PE_Sleep__c,PE_Energy__c,PE_Addiction_Symptoms__c,  PE_Imaging__c,
                                PE_Imaging_CTScan_Desc__c, PE_Imaging_MRI_Desc__c, PE_Imaging_Special_Proc_Rec_Desc__c, PE_Imaging_XRay_Desc__c, 
                                PE_Laboratory_Testing_Ordered__c, PE_Laboratory_Testing_Ordered_Other__c, PE_Next_Evaluation__c, PE_Past_Medical_History__c, PE_Affect__c, 
                                PE_Appearance__c, PE_Attention_Span__c, PE_Attitude__c, PE_Behavior__c, PE_Hallucinations__c, 
                                PE_Insight_and_Judgment__c, PE_Memory__c, PE_Mood__c, PE_Motor__c, PE_Orientation__c, PE_Reality_Testing__c, 
                                PE_Speech__c, PE_Thought_Content__c, PE_Thought_Process__c, PE_Withdrawal_Symptoms__c, PE_Recommended_Therapies__c, 
                                PE_Recommended_Therapies_Other__c, PE_Relevant_Laboratory__c, PE_Source_of_Information__c,
                                PE_Disability_Status__c, HP_Medication_List_Update_Time__c, Clinical_Evaluation__c, Client_Closed_Date__c, Client_Image_Url_Closed__c, Client_Signed_User_Closed__c, Intern_Closed_Date__c,
                                Intern_Signature_URL__c, Intern_Signed_User__c, Staff_Closed_Date__c, Staff_Signature_URL_Closed__c, Staff_Signed_User_Closed__c,
                                SignedBy__c, Staff_Signed_User__c
                                from Clinical_Evaluation_3__c where Clinical_Evaluation__c=: CEID order by CreatedDate DESC Limit 1];
                
                /*if(ceRecord.Status__c == 'Review Pending' || ceRecord.Status__c == 'Closed')
                    ce3Record = [select id,Clinical_Evaluation__c, Client_Closed_Date__c, Client_Image_Url_Closed__c, Client_Signed_User_Closed__c, Intern_Closed_Date__c,
                                    Intern_Signature_URL__c, Intern_Signed_User__c, Staff_Closed_Date__c, Staff_Signature_URL_Closed__c, Staff_Signed_User_Closed__c,
                                   SignedBy__c from Clinical_Evaluation_3__c where Clinical_Evaluation__c =: CEID order by CreatedDate DESC Limit 1];*/
            }
            else if(CEID == null)
            {
                ceRecord.Client_Chart__c = ClientID;
                ceRecord.RecordTypeID = PERecordTypeId;
                ceRecord.Status__c = 'In Progress';
                ceRecord.Diagnosis_Code__c = clientRecord.Diagnosis_Code__c;
                
            }
            userObj = [Select id, name, title, User_Role__c, userRole.Name from user where id =: userinfo.getUserID()];
            
            if (ceRecord.Status__c == '' || ceRecord.Status__c == 'In Progress' || ceRecord.Status__c == 'Open') {

            ceRecord.Status__c = 'In Progress';
            ce3RecordExt.SignedBy__c = 'None';
            }
            
            checkExistingCode(ceRecord);
            fillAllCodes();
            getAllMeds();
        }
        else
        {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'The Id passed in URL is invalid.');
            ApexPages.addMessage(errMsg);
        }
    }
    public void updateMedications()
    {
        list<Order__c> listToUpdateMeds = new list<Order__c>();
        for(Order__c ord: [select id,Amount_per_Dosage__c,Client_Chart__c, createdDate ,Clinical_Evaluation_3__c,Continue_on_Discharge__c,Discontinue_Date_Time__c,
                                Dosage_Form__c,Dose__c,Duration__c,End_Date__c,Frequency__c,Justification__c,Medicine__c,Medicine__r.Name,Order_By__c,
                                Order_Type__c,PRN__c,Requested_via__c,Route__c,Start_Date__c,Status__c,Taper__c,Taper__r.Name,Taper__r.Protocol__c,
                                Taper__r.Justification_Indication_Target__c,Via_cancelled_by__c,
                                Warnings__c from Order__c where Client_Chart__c =: ClientID])
        {
            if(ord.Status__c == 'Inactive')
            {
                if(ord.Clinical_Evaluation_3__c == CEId)
                {
                    ord.Clinical_Evaluation_3__c = null;
                    listToUpdateMeds.add(ord);
                }
            }   
            
            if(ord.Status__c == 'Active')
            {
                ce3RecordExt.HP_Medication_List_Update_Time__c = datetime.now();
                ord.Clinical_Evaluation_3__c = CEId;
                listToUpdateMeds.add(ord);
            }
        }
        
        try
        {
            update listToUpdateMeds;
            upsert ce3RecordExt;
            getAllMeds();
        }
        catch(exception e)
        {
            ApexPages.AddMessages(e);
        }
    }    
    public void getAllMeds()
    {
        listOfMeds = [select id,Amount_per_Dosage__c,Client_Chart__c, createdDate ,Clinical_Evaluation_3__c,Continue_on_Discharge__c,Discontinue_Date_Time__c,
                                Dosage_Form__c,Dose__c,Duration__c,End_Date__c,Frequency__c,Justification__c,Medicine__c,Medicine__r.Name,Order_By__c,
                                Order_Type__c,PRN__c,Requested_via__c,Route__c,Start_Date__c,Status__c,Taper__c,Taper__r.Name,Taper__r.Protocol__c,
                                Taper__r.Justification_Indication_Target__c,Via_cancelled_by__c,
                                Warnings__c from Order__c where Clinical_Evaluation_3__c =:CEId];
        
        if(listOfMeds.size() == 0)
            listOfMeds = [select id,Amount_per_Dosage__c,Client_Chart__c, createdDate ,Clinical_Evaluation_3__c,Continue_on_Discharge__c,Discontinue_Date_Time__c,
                                Dosage_Form__c,Dose__c,Duration__c,End_Date__c,Frequency__c,Justification__c,Medicine__c,Medicine__r.Name,Order_By__c,
                                Order_Type__c,PRN__c,Requested_via__c,Route__c,Start_Date__c,Status__c,Taper__c,Taper__r.Name,Taper__r.Protocol__c,
                                Taper__r.Justification_Indication_Target__c,Via_cancelled_by__c,
                                Warnings__c from Order__c where Client_Chart__c =: ClientID AND Status__c = 'Active'];
        
        system.debug('#listOfMeds'+listOfMeds);
        
    }
    
    private void checkExistingCode(Clinical_Evaluation__c ce)
    {
        listExistingCode = new list<string>();
        setExistingCode = new set<string>();
        Codes = new List<string>();
        if(ce != null && ce.Diagnosis_Code__c != null && ce.Status__c == 'Closed')
        {
            StrexistingCodes = ce.Diagnosis_Code__c; 
            for(string exstCode: ce.Diagnosis_Code__c.split(';'))
            {
                Codes.add(exstCode);    
            }
        }else if(clientRecord != null && clientRecord.Diagnosis_Code__c != null)
        {
            ce.Diagnosis_Code__c = clientRecord.Diagnosis_Code__c;
            for(string exstCode: clientRecord.Diagnosis_Code__c.split(';'))
            {
                Codes.add(exstCode);    
            }
        }
        system.debug('#Str='+StrexistingCodes);
        system.debug('#Set='+setExistingCode);
    }
    
    public PageReference Edit()
    {
        //PageReference pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
        PageReference pr = new PageReference('/apex/PsychEvaluation');
        pr.getParameters().put('ID',ClientID);
        pr.getParameters().put('ceId',CEID);
        pr.getParameters().put('type',RecordTypeName);
        pr.getParameters().put('readOnly','false');
        pr.getParameters().put('rt',clientRecord.RecordType.Name);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        
        return pr;
        
    }
       
    public PageReference Save()
    {
        string strCode = '';
        for(string newcode: Codes)
            strCode += newcode + ';' ;
        
        ceRecord.Diagnosis_Code__c = strCode;
        clientRecord.Diagnosis_Code__c = strCode;
        PageReference pr;
        try{
            upsert clientRecord;
            upsert ceRecord;
            
            if(ceRecord.Id != null)
            {
                ce3RecordExt.Clinical_Evaluation__c = ceRecord.Id;
                upsert ce3RecordExt;
            }
            
            if(CEID != null)
            {
                //pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
                pr = new PageReference('/apex/PsychEvaluation');
                pr.getParameters().put('ID',ClientID);
                pr.getParameters().put('ceId',CEID);
                pr.getParameters().put('type',RecordTypeName);
                pr.getParameters().put('readOnly','true');
                pr.getParameters().put('rt',clientRecord.RecordType.Name);
                pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
                return pr;
            }
            else if(CEID == null)
            {
                //pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
                pr = new PageReference('/apex/PsychEvaluation');
                pr.getParameters().put('ID',ClientID);
                pr.getParameters().put('ceId',ceRecord.Id);
                pr.getParameters().put('type',RecordTypeName);
                pr.getParameters().put('readOnly','true');
                pr.getParameters().put('rt',clientRecord.RecordType.Name);
                pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
                return pr;
            }
            
        }
        catch(exception e)
        {
            ApexPages.addMessages(e);
            system.debug('#exception='+e.getMessage());
        }
        
        return null;
        
    }
    
    public void QuickSave()
    {
        string strCode = '';
        for(string newcode: Codes)
            strCode += newcode + ';' ;
        
        ceRecord.Diagnosis_Code__c = strCode;
        clientRecord.Diagnosis_Code__c = strCode;
        
        try{
            upsert clientRecord;
            upsert ceRecord;
            
            if(ceRecord.Id != null)
            {
                ce3RecordExt.Clinical_Evaluation__c = ceRecord.Id;
                upsert ce3RecordExt;
            }
        }
        catch(exception e)
        {
            ApexPages.addMessages(e);
            system.debug('#exception='+e.getMessage());
        }
        
        
        
    }
    
    public PageReference BackToCE()
    {
        PageReference pr;
        
        pr = new PageReference('/apex/MedicalHomePage');
        pr.getParameters().put('ID',ClientID);
        pr.getParameters().put('rt',ApexPages.CurrentPage().getParameters().get('rt'));
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;
        
    }
    
    public PageReference Cancel()
    {
        PageReference pr;
        if(CEID != null)
        {
            //pr = new PageReference('/apex/ClinicalEvaluationDetailPage');
            pr = new PageReference('/apex/PsychEvaluation');
            pr.getParameters().put('ID',ClientID);
            pr.getParameters().put('ceId',CEID);
            pr.getParameters().put('type',RecordTypeName);
            pr.getParameters().put('readOnly','true');
            pr.getParameters().put('rt',clientRecord.RecordType.Name);
            pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
            return pr;
        }
        else if(CEID == null)
        {
            pr = new PageReference('/apex/ClinicalEvaluationHomePage');
            //pr = new PageReference('/apex/PsychEvaluation');
            pr.getParameters().put('ID',ClientID);
            pr.getParameters().put('type',RecordTypeName);
            pr.getParameters().put('rt',clientRecord.RecordType.Name);
            //pr.getParameters().put('readOnly','true');
            pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
            return pr;
        }
        return null;
    }
    
    private void fillAllCodes()
    {
        listAllCodes = new list<SelectOption>();
        List<DiagnosisCode__c> myCs = DiagnosisCode__c.getall().values();
        for(DiagnosisCode__c m : myCs){
            SelectOption option = new SelectOption((m.Name+' '+m.Description__c),(m.Name+' '+m.Description__c));
            listAllCodes.add(option);
        }
    }
    
    
    public PageReference CloseSignatureForm() {
    
        callJs = false;
        ce3RecordExt.Clinical_Evaluation__c = CEID;
        if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == NULL) {

            ce3RecordExt.Staff_Signature_URL_Closed__c = AWSURL + ImageUrlAddress;
            ce3RecordExt.Staff_Signed_User_Closed__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            ce3RecordExt.Staff_Closed_Date__c = DateTime.Now();
            ce3RecordExt.Staff_Signed_User__c = userObj.id;
            ce3RecordExt.SignedBy__c = 'Staff';
        } /*else if (SelectedSignedOption == 'Patient') {

            ce3Record.Client_Image_Url_Closed__c = AWSURL + ImageUrlAddress;
            ce3Record.Client_Signed_User_Closed__c = '(Patient) ' + ceRecord.Client_Chart__r.Name;
            ce3Record.Client_Closed_Date__c = DateTime.Now();
            ce3Record.SignedBy__c = 'Client';
        } */else if (userObj.User_Role__c != NULL) {

            ce3RecordExt.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
            ce3RecordExt.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
            ce3RecordExt.Intern_Closed_Date__c = DateTime.Now();
            ce3RecordExt.SignedBy__c = 'Client';
            ceRecord.Status__c = 'Review Pending';
        }

        if ((ce3RecordExt.Staff_Signed_User_Closed__c != null || String.isNotBlank(ce3RecordExt.Staff_Signed_User_Closed__c ))){// && (ce3Record.Client_Signed_User_Closed__c != null || String.isNotBlank(ce3Record.Client_Signed_User_Closed__c ))) {
            ceRecord.Status__c = 'Closed';
            ce3RecordExt.SignedBy__c = 'All'; // signing is complete
              

        }
        
        if(ceRecord.Status__c != 'Closed'){
         callJS = true;
        }
         
       update ceRecord;
       upsert ce3RecordExt;
       return null;
 

    }
}