//Test Class : DiagnosisCode_Test
public class PsychEvaluation2 {
    
    public Client_Chart__c clientRecord {get; set;}
    public Clinical_Evaluation_3__c ceRecord {get; set;}
    public Recurring_Assessment__c latestVitals {get; set;}
    public UtlizationReviewOrder__c vitalJunction {get; set;}
    public list<Order__c> listOfMeds {get; set;}
    //public Sunshine_Center_Id__c scID {get; set;}
    
    public string ClientID {get; set;}
    public string CEID {get; set;}
    public string StrexistingCodes {get; set;}
    public string RecordtypeName {get; set;}
    
    
    public boolean isEdit {get; set;}
    public boolean callJS{get; set;}
    
    public list<string> Codes {get; set;}
    public list<SelectOption> listAllCodes {get; set;}
    
    
    //AWS
    public string accessKeyId {get; set;}
    public string secretAccessKey {get; set;}
    public string OrgName {get; set;}
    final string AWSURL;
    
     //hidden field
    public string SelectedSignedOption {get; set;}
    public string ImageUrlAddress {get; set;}
    
    public User userObj {get; set;}
    
    public PsychEvaluation2()
    {
        ClientID = ApexPages.CurrentPage().getParameters().get('ID');
        CEID = ApexPages.CurrentPage().getParameters().get('ceId');
        isEdit = ApexPages.CurrentPage().getParameters().get('mode')!= null? true: false;
        Id PERecordTypeId = Schema.SObjectType.Clinical_Evaluation_3__c.getRecordTypeInfosByName().get('Phsych Evaluation').getRecordTypeId();
        //scID = Sunshine_Center_Id__c.getInstance(ApexPages.CurrentPage().getParameters().get('rt'))!=null ? Sunshine_Center_Id__c.getInstance(ApexPages.CurrentPage().getParameters().get('rt')) : new Sunshine_Center_Id__c();
        
        callJS = false;
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        Codes = new list<string>();
        RecordTypeName = 'Phsych Evaluation';
        
        if(ClientID != null)
        {
            
            ceRecord = new Clinical_Evaluation_3__c();
            clientRecord = [select id, Diagnosis_Code__c, RecordType.Name from Client_Chart__c where id =: ClientID];
            
            if(CEID == null)
            {
                ceRecord = new Clinical_Evaluation_3__c();
                ceRecord.Client_Chart__c = ClientID;
                ceRecord.RecordtypeId = PERecordTypeId;
                ceRecord.HP_Status__c = 'In Progress';
            }
            else if(CEID != null && RecordTypeName == 'Phsych Evaluation')
            {
                ceRecord = [select due_date_time__c, HP_Evaluation_Date__c ,ASSESS_OF_MENTAL_MOOD_Sad__c ,HP_Ability_to_participate_fair__c ,
                                    HP_Ability_to_participate_good__c ,PE_Source_of_Information__c ,PE_Weight__c ,PE_Appetite__c ,PE_Sleep__c ,
                                    PE_Energy__c ,PE_Relevant_Laboratory__c ,Client_have_any_future_education_goal_NO__c ,
                                    HP_Illness_Text__c,HP_Current_NonPsych_1_Dosage__c, Client_have_any_future_education_goal__c,
                                    HP_Current_NonPsych_1_Freq__c ,HP_Current_NonPsych_1_Indicat__c ,HP_Current_NonPsych_1_Med__c ,
                                    HP_Current_NonPsych_2_Dosage__c ,HP_Current_NonPsych_2_Freq__c ,HP_Current_NonPsych_2_Indicat__c ,
                                    HP_Current_NonPsych_2_Med__c ,HP_Current_NonPsych_3_Dosage__c ,HP_Current_NonPsych_3_Freq__c ,
                                    HP_Current_NonPsych_3_Indicat__c ,HP_Current_NonPsych_3_Med__c ,Attempt_to_discontinue_cut_back_on_subs__c ,
                                    Client_Family_History_Medical_Condition__c ,Client_Environment_to_conductive_NO__c ,Client_Environment_to_conductive_Txt__c ,
                                    HP_Family_Medical_His_UnRemark__c ,HP_Family_Medical_His__c ,PE_Clinical_Global_Impressions__c ,
                                    Assessment_of_Mental_Status_Check__c ,PE_Appearance__c ,PE_Speech__c ,PE_Mood__c ,PE_Attitude__c ,
                                    PE_Affect__c ,PE_Thought_Content__c ,PE_Thought_Process__c ,PE_Behavior__c ,PE_Motor__c ,PE_Hallucinations__c ,
                                    PE_Orientation__c ,PE_Memory__c ,PE_Attention_Span__c ,PE_Reality_Testing__c ,PE_Insight_and_Judgment__c ,
                                    HP_Diagnosis_Code__c ,HP_Ability_of_gaze_sideways__c ,ASSESS_OF_MENTAL_BEHAVIOR_Cooperative__c ,
                                    ASSESS_OF_MENTAL_BEHAVIOR_Uncooperative__c ,ASSESS_OF_MENTAL_INSIGHT_Fair__c ,ASSESS_OF_MENTAL_INSIGHT_Good__c ,
                                    ASSESS_OF_MENTAL_INSIGHT_Immature__c ,ASSESS_OF_MENTAL_INSIGHT_Mature__c ,ASSESS_OF_MENTAL_INSIGHT_Poor__c ,
                                    HP_Review_of_Sys_ENT_None__c ,HP_Review_of_Sys_ENT_Yes__c ,PE_Recommended_Therapies__c ,PE_Recommended_Therapies_Other__c ,
                                    PE_Laboratory_Testing_Ordered__c ,PE_Laboratory_Testing_Ordered_Other__c ,PE_Imaging__c ,PE_Imaging_CTScan_Desc__c ,
                                    PE_Imaging_MRI_Desc__c ,PE_Imaging_Special_Proc_Rec_Desc__c ,PE_Imaging_XRay_Desc__c ,PE_Next_Evaluation__c ,
                                    PE_Disability_Status__c ,ASSESS_OF_MENTAL_MOOD_Depressed__c,  HP_Status__c,Client_Closed_Date__c, 
                                    Client_Image_Url_Closed__c, Client_Signed_User_Closed__c, Intern_Closed_Date__c, Intern_Signature_URL__c, Intern_Signed_User__c,
                                    Staff_Signed_User__c , Staff_Closed_Date__c, Staff_Signature_URL_Closed__c, Staff_Signed_User_Closed__c, SignedBy__c,
                                    HP_Medication_List_Update_Time__c,PE_Evaluation_DateTime__c,
                                    Client_Chart__c, Client_Chart__r.Treatment_Center__r.Name, Client_Chart__r.Name from Clinical_Evaluation_3__c where id=:CEID];
            }
            
            if (ceRecord.HP_Status__c == null || ceRecord.HP_Status__c == 'Open' || ceRecord.HP_Status__c == 'In Progress') {

                    ceRecord.HP_Status__c = 'In Progress';
                    ceRecord.SignedBy__c = 'None';
            }
            
            
            userObj = [Select id, name, title, User_Role__c, UserRole.Name from user where id =: userinfo.getUserID()];
            
            checkExistingCode();
            fillAllCodes();
        }
        
        else
        {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Client Chart ID(cid) parameter missing in URL.');
            ApexPages.addMessage(errMsg);
        }
    }
    
    
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('Medical');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    private void checkExistingCode()
    {
        if(ceRecord != null && ceRecord.HP_Diagnosis_Code__c != null && ceRecord.HP_Status__c == 'Closed')
        {
            for(string exstCode: ceRecord.HP_Diagnosis_Code__c.split(';'))
            {
                Codes.add(exstCode);    
            }
        }
        else if(clientRecord != null && clientRecord.Diagnosis_Code__c != null)
        {
            ceRecord.HP_Diagnosis_Code__c = clientRecord.Diagnosis_Code__c;
            for(string exstCode: clientRecord.Diagnosis_Code__c.split(';'))
            {
                Codes.add(exstCode);    
            }
        }
    }
    
    private void fillAllCodes()
    {
        listAllCodes = new list<SelectOption>();
        List<DiagnosisCode__c> myCs = DiagnosisCode__c.getall().values();
        for(DiagnosisCode__c m:myCs){
            listAllCodes.add(new SelectOption((m.Name+' '+m.Description__c),(m.Name+' '+m.Description__c)));
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
                ceRecord.HP_Medication_List_Update_Time__c = datetime.now();
                ord.Clinical_Evaluation_3__c = CEId;
                listToUpdateMeds.add(ord);
            }
        }
        
        try
        {
            update listToUpdateMeds;
            upsert ceRecord;
            getAllMeds();
        }
        catch(exception e)
        {
            ApexPages.AddMessages(e);
        }
    }
    
    public pageReference back()
    {
        pageReference pr = new PageReference('/apex/MedicalHomePage');
        pr.getParameters().put('ID',ClientID);
        pr.getParameters().put('rt',ApexPages.CurrentPage().getParameters().get('rt'));
        pr.setRedirect(true);
        
        return pr;
    }
    
    public pageReference cancel()
    {
        pageReference pr;
        
        if(CEId == null)
        {
            pr = new PageReference('/apex/MedicalHomePage');
            pr.getParameters().put('ID',ClientID);
            //pr.getParameters().put('type',RecordTypeName);
            pr.getParameters().put('rt',clientRecord.RecordType.Name);
            pr.setRedirect(true); 
        }
        else if(CEId != null)
        {
            pr = new PageReference('/apex/PsychEvaluation2');
            pr.getParameters().put('ID',ClientID);
            pr.getParameters().put('ceId',ceRecord.Id);
            //pr.getParameters().put('type',RecordTypeName);
            pr.getParameters().put('rt',clientRecord.RecordType.Name);
            pr.setRedirect(true); 
        }
        
        return pr;
    }
    
    public pageReference edit()
    {
        pageReference pr = new PageReference('/apex/PsychEvaluation2');
        pr.getParameters().put('ID',ClientID);
        pr.getParameters().put('ceId',ceRecord.Id);
        //pr.getParameters().put('type',RecordTypeName);
        pr.getParameters().put('rt',clientRecord.RecordType.Name);
        pr.getParameters().put('mode','edit');
        pr.setRedirect(true); 
        return pr;
    }
    
    public pageReference save()
    {
        pageReference pr;
        string strCode = '';
        for(string newcode: Codes)
            strCode += newcode + ';' ;
        
        //ceRecord.HP_Diagnosis_Code__c = strCode;
        clientRecord.Diagnosis_Code__c = ceRecord.HP_Diagnosis_Code__c;
        ceRecord.Client_Chart__c = ClientID;
        list<order__c> lstOFMedToUpd = new list<Order__c>();
        try
        {
            upsert ceRecord;
            upsert clientRecord;
            if(CEId ==  null)
            {
                for(order__c ord :listOfMeds)
                {
                    
                    ord.Clinical_Evaluation_3__c = ceRecord.id;
                    lstOFMedToUpd.add(ord);
                    
                }
                ceRecord.HP_Medication_List_Update_Time__c = datetime.now();
                update lstOFMedToUpd;
                //update latestVitals;
                upsert ceRecord;
            }
            system.debug('#ceRec='+ceRecord);
            pr = new PageReference('/apex/PsychEvaluation2');
            pr.getParameters().put('ID',ClientID);
            pr.getParameters().put('ceId',ceRecord.Id);
            //pr.getParameters().put('type',RecordTypeName);
            pr.getParameters().put('rt',clientRecord.RecordType.Name);
            pr.setRedirect(true); 
            return pr;
        }
        catch(exception e)
        {
            ApexPages.AddMessages(e);
        }
        return null;
    }
    
    public void quicksave()
    {
        string strCode = '';
        for(string newcode: Codes)
            strCode += newcode + ';' ;
        
        //ceRecord.HP_Diagnosis_Code__c = strCode;
        clientRecord.Diagnosis_Code__c = ceRecord.HP_Diagnosis_Code__c;
        ceRecord.Client_Chart__c = ClientID;
        list<order__c> lstOFMedToUpd = new list<Order__c>();
        try
        {
            upsert ceRecord;
            upsert clientRecord;
            if(CEId ==  null)
            {
                for(order__c ord :listOfMeds)
                {
                    
                    ord.Clinical_Evaluation_3__c = ceRecord.id;
                    lstOFMedToUpd.add(ord);
                    
                }
                ceRecord.HP_Medication_List_Update_Time__c = datetime.now();
                update lstOFMedToUpd;
                //update latestVitals;
                upsert ceRecord;
            }
            system.debug('#ceRec='+ceRecord);
         
        }
        catch(exception e)
        {
            ApexPages.AddMessages(e);
        }
        
    }
    
    public PageReference CloseSignatureForm() {
    
        callJs = false;
        if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == NULL) {

            ceRecord.Staff_Signature_URL_Closed__c = AWSURL + ImageUrlAddress;
            ceRecord.Staff_Signed_User_Closed__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            ceRecord.Staff_Closed_Date__c = DateTime.Now();
            ceRecord.Staff_Signed_User__c = userObj.id;
            ceRecord.SignedBy__c = 'Staff';
        } /*else if (SelectedSignedOption == 'Patient') {

            ceRecord.Client_Image_Url_Closed__c = AWSURL + ImageUrlAddress;
            ceRecord.Client_Signed_User_Closed__c = '(Patient) ' + ceRecord.Client_Chart__r.Name;
            ceRecord.Client_Closed_Date__c = DateTime.Now();
            ceRecord.SignedBy__c = 'Client';
        } */else if (userObj.User_Role__c != NULL) {

            ceRecord.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
            ceRecord.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
            ceRecord.Intern_Closed_Date__c = DateTime.Now();
            ceRecord.SignedBy__c = 'Client';
            ceRecord.HP_Status__c = 'Review Pending';
        }

        if ((ceRecord.Staff_Signed_User_Closed__c != null || String.isNotBlank(ceRecord.Staff_Signed_User_Closed__c ))){ //&& (ceRecord.Client_Signed_User_Closed__c != null || String.isNotBlank(ceRecord.Client_Signed_User_Closed__c ))) {
            ceRecord.HP_Status__c = 'Closed';
            ceRecord.SignedBy__c = 'All'; // signing is complete
              

        }
        
        if(ceRecord.HP_Status__c != 'Closed'){
         callJS = true;
        }
         
       update ceRecord;
       return null;
 

    }

}