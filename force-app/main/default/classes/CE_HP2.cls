public class CE_HP2 {
    
    public Client_Chart__c clientRecord {get; set;}
    public Clinical_Evaluation_3__c ceRecord {get; set;}
    
    
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
    
    public CE_HP2()
    {
        ClientID = ApexPages.CurrentPage().getParameters().get('ID');
        CEID = ApexPages.CurrentPage().getParameters().get('ceId');
        isEdit = ApexPages.CurrentPage().getParameters().get('mode')!= null? true: false;
        Id PERecordTypeId = Schema.SObjectType.Clinical_Evaluation_3__c.getRecordTypeInfosByName().get('History And Physical').getRecordTypeId();
        
        callJS = false;
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        Codes = new list<string>();
        RecordTypeName = 'History And Physical';
        
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
            else if(CEID != null && RecordTypeName == 'History And Physical')
            {
                ceRecord = [select due_date_time__c, HP_Evaluation_Date__c ,HP_Illness_No__c,HP_Illness_Text__c, Assessment_of_Mental_Status_Orient_None__c 
                            ,Assessment_of_Mental_Status_Text__c,HP_Surgery_No__c ,HP_Surgery_Text__c ,HP_Subs_Use_1_Subs__c ,HP_Subs_Use_1_Amount_Last_use__c 
                            ,HP_Subs_Use_1_Date_Last_use__c ,HP_Subs_Use_1_Length__c ,HP_Subs_Use_1_Amount__c ,HP_Subs_Use_1_Route__c ,HP_Sex_Transmitted_None__c 
                            ,HP_Sex_Transmitted_Yes__c ,HP_Family_Medical_His_UnRemark__c ,HP_Family_Medical_His__c ,HP_Current_NonPsych_None__c 
                            ,HP_Current_NonPsych_1_Med__c ,HP_Current_NonPsych_1_Dosage__c ,HP_Current_NonPsych_1_Route__c ,HP_Current_NonPsych_1_Freq__c 
                            ,HP_Current_NonPsych_1_Indicat__c ,HP_Review_of_Sys_Constit_Negative__c ,HP_Review_of_Sys_Constit_Text__c ,HP_Review_of_Sys_ENT_None__c 
                            ,HP_Review_of_Sys_ENT_Yes__c ,HP_Review_of_Sys_Cardio_Negative__c ,HP_Review_of_Sys_Hema_Text__c ,HP_Review_of_Sys_Resp_Negative__c 
                            ,HP_Review_of_Sys_Resp_Text__c ,HP_Review_of_Sys_GI_Negative__c ,HP_Review_of_Sys_GI_Text__c ,HP_Review_of_Sys_GU_Negative__c 
                            ,HP_Review_of_Sys_GU_Text__c ,HP_Review_of_Sys_Integum_Negative__c ,HP_Review_of_Sys_Integum_Text__c ,HP_Review_of_Sys_Musculo_Value__c 
                            ,HP_Review_of_Sys_Musculo_Text__c ,HP_Review_of_Sys_Endo_Negative__c ,HP_Review_of_Sys_Endo_Text__c ,Cleint_existing_Positive_Supp_Sys_NO__c 
                            ,Cleint_existing_Positive_Supp_Sys_Txt__c ,HP_Review_of_Sys_Neuro_Negative__c ,HP_Review_of_Sys_Neuro_Text__c ,HP_Exam_Head_Normocephalic__c 
                            ,HP_Exam_Head_microcephalic__c ,HP_Exam_Head_masses__c ,HP_Exam_Head_tenderness__c ,HP_Exam_Hair_Neat__c 
                            ,HP_Exam_Hair_clean__c ,HP_Exam_Hair_disheveled__c ,HP_Exam_Hair_dirty__c ,HP_Exam_Eyes_PERRLA__c ,HP_Exam_Eyes_abnormal__c 
                            ,HP_Exam_External_pink_non_inflamed__c ,HP_Exam_External_inflamed__c ,HP_Exam_External_masses__c ,HP_Exam_External_cerumen_exudate__c 
                            ,HP_Exam_Tympanic_pearly_gray_visible__c ,HP_Exam_Tympanic_hyperemic__c ,HP_Exam_Tympanic_opaque__c ,HP_Exam_Tympanic_bulging__c 
                            ,HP_Exam_Tympanic_retracted__c ,HP_Exam_Tympanic_immobile__c ,HP_Exam_Tympanic_perforation__c ,HP_Exam_Tympanic_PE_tubes__c 
                            ,HP_Exam_Sinuses_non_tender__c ,HP_Exam_Sinuses_tender__c ,HP_Exam_Nose_Patent__c ,HP_Exam_Nose_Pink__c ,HP_Exam_Nose_no_discharge__c 
                            ,HP_Exam_Nose_pale__c ,HP_Exam_Nose_dischargeturbinates__c ,HP_Exam_Nose_polyps__c ,HP_Exam_Mouth_Intact__c ,HP_Exam_Teeth_Malalignment__c 
                            ,HP_Exam_Teeth_dental_caries__c ,HP_Exam_Teeth_erosion__c ,HP_Exam_Teeth_abscess__c ,HP_Exam_Pharynx_erythema__c 
                            ,HP_Exam_Pharynx_tonsillar_enlargement__c ,HP_Exam_Pharynx_Text__c ,HP_Exam_Buccal_lesions__c ,HP_Exam_Buccal_plaques__c 
                            ,HP_Exam_Buccal_vesicules__c ,HP_Exam_Buccal_ulceration__c ,ASSESS_OF_MENTAL_INSIGHT_Fair__c ,HP_Exam_LymphNode_lymphadenopathy__c 
                            ,HP_Exam_LymphNode_tenderness__c ,HP_Exam_LymphNode_torticollis__c ,HP_Exam_LymphNode_other__c ,HP_Exam_Thyroid_enlarged__c 
                            ,HP_Exam_Thyroid_nodes__c ,HP_Exam_Thyroid_asymmetry__c ,HP_Exam_Breast_patient_declined__c 
                            ,HP_Exam_Breast_symmetrical__c ,HP_Exam_Breast_asymmetry__c ,HP_Exam_Breast_non_tender__c ,ASSESS_OF_MENTAL_INSIGHT_Good__c 
                            ,HP_Exam_Breast_gynecomastia__c ,HP_Exam_Breast_nipple_discharge__c ,HP_Exam_Breast_Lesions__c ,HP_Exam_Heart_normal_rate_rhythm__c 
                            ,HP_Exam_Heart_other__c ,Client_Engage_in_subs_free_NO__c ,Client_Engage_in_subs_free_Txt__c ,HP_Exam_Lungs_clear_breath_sounds__c 
                            ,HP_Exam_Lungs_diminished_breath__c ,HP_Exam_Lungs_wheezing__c ,HP_Exam_Lungs_rhonchi__c ,HP_Exam_Lungs_prolonged_expiration__c 
                            ,HP_Exam_Lungs_other__c ,HP_Exam_Lungs_crepitus__c ,HP_Exam_Lungs_rales__c ,HP_Exam_Abdomen_Soft__c ,HP_Exam_Abdomen_non_tender__c 
                            ,HP_Exam_Abdomen_no_organomegaly__c ,HP_Exam_Abdomen_other__c ,HP_Exam_Genitalia_patient_declined__c 
                            ,HP_Exam_Genitalia_not_clinically_indicat__c ,HP_Exam_Genitalia_normal_exam__c ,HP_Exam_Genitalia_abnormal__c ,HP_Exam_Genitalia_None__c 
                            ,HP_Exam_Genitalia_Yes__c ,HP_Musculoskeletal_Full_ROM__c ,HP_Musculoskeletal_no_swelling__c ,HP_Musculoskeletal_no_tenderness__c 
                            ,HP_Musculoskeletal_scoliosis__c ,HP_Musculoskeletal_decreased_ROM__c ,HP_Musculoskeletal_decreased_strength__c 
                            ,HP_Musculoskeletal_swelling__c ,HP_Musculoskeletal_tenderness__c ,HP_Musculoskeletal_other__c ,HP_Cranial_nerve_II__c 
                            ,HP_Movement_in_peripheral_field__c ,HP_Cranial_nerve_III_IV_VI__c ,HP_Ability_to_gaze_down__c ,HP_Ability_of_gaze_sideways__c 
                            ,HP_Extraocular_movement_Smooth__c ,HP_Extraocular_movement_wandering__c ,HP_Extraocular_movement_jerky__c 
                            ,HP_Extraocular_movement_nystagmus__c ,HP_Pupillary_reactivity_PERRLA__c ,HP_Pupillary_reactivity_asymmetrical__c 
                            ,HP_Pupillary_reactivity_sluggish__c ,HP_Pupillary_reactivity_dilated__c ,HP_Pupillary_reactivity_pinpoint__c ,HP_Cranial_nerve_V_forhead__c 
                            ,HP_Cranial_nerve_V_Cheeks__c ,HP_Cranial_nerve_V_Chin__c ,HP_Cranial_nerve_V_Raise_eyebrows__c ,HP_Cranial_nerve_V_Frown__c 
                            ,HP_Cranial_nerve_V_Smile__c ,HP_Cranial_nerve_V_Clench_teeth__c ,HP_Cranial_nerve_V_Ability_to_hear__c ,HP_Ability_to_swallow_Intact__c 
                            ,HP_Ability_to_swallow_NotIntact__c ,HP_Ah__c ,HP_Ability_to_shrug_shoulders__c ,HP_Ability_to_turn_head_left_right__c 
                            ,HP_Tongue_position_midline__c ,HP_Tongue_position_other__c ,HP_Tongue_ROM_intact__c ,HP_Tongue_ROM_other__c 
                            ,HP_Sensory_Functions_All_Intact__c ,HP_Sharp_pain_Arm__c ,HP_Sharp_pain_chest__c ,HP_Sharp_pain_abdomen__c ,HP_Sharp_pain_back__c 
                            ,HP_Sharp_pain_leg__c ,HP_Dull_pain_arm__c ,HP_Dull_pain_chest__c ,HP_Dull_pain_abdomen__c ,HP_Dull_pain_back__c 
                            ,HP_Dull_pain_leg__c ,HP_Overall_impression_alert_and_oriented__c ,HP_Overall_impression_recent_and_remote__c 
                            ,HP_Overall_impression_other__c ,HP_Recommended_Interventions__c,HP_Diagnosis_Code__c ,HP2_Imp_Of_General_Health__c ,HP2_Prognosis__c 
                            ,HP_Ability_to_participate_limited__c ,HP_Ability_to_participate_good__c ,HP_Ability_to_participate_fair__c 
                            ,HP_Ability_to_participate_poor__c ,HP_Restrictions_none__c ,Additional_Info_environment__c, HP_Status__c,Client_Closed_Date__c, 
                            Client_Image_Url_Closed__c, Client_Signed_User_Closed__c, Intern_Closed_Date__c, Intern_Signature_URL__c, Intern_Signed_User__c,
                            Staff_Signed_User__c , Staff_Closed_Date__c, Staff_Signature_URL_Closed__c, Staff_Signed_User_Closed__c, SignedBy__c,
                            Client_have_any_future_education_goal_NO__c, Client_have_any_future_education_goal__c,Client_Environment_to_conductive_NO__c,
                            HP_Subs_Use_2_Amount__c ,HP_Subs_Use_2_Amount_Last_use__c ,HP_Subs_Use_2_Date_Last_use__c ,HP_Subs_Use_2_Length__c ,
                            HP_Subs_Use_2_Route__c ,HP_Subs_Use_2_Subs__c ,HP_Subs_Use_3_Amount__c ,HP_Subs_Use_3_Amount_Last_use__c ,HP_Subs_Use_3_Date_Last_use__c ,HP_Subs_Use_3_Length__c ,
                            HP_Subs_Use_3_Route__c ,HP_Subs_Use_3_Subs__c,HP_Current_NonPsych_2_Dosage__c ,HP_Current_NonPsych_2_Freq__c ,HP_Current_NonPsych_2_Indicat__c ,
                            HP_Current_NonPsych_2_Med__c ,HP_Current_NonPsych_2_Route__c ,HP_Current_NonPsych_3_Dosage__c ,HP_Current_NonPsych_3_Freq__c ,
                            HP_Current_NonPsych_3_Indicat__c ,HP_Current_NonPsych_3_Med__c ,HP_Current_NonPsych_3_Route__c ,HP_Current_NonPsych_4_Dosage__c ,
                            HP_Current_NonPsych_4_Freq__c ,HP_Current_NonPsych_4_Indicat__c ,HP_Current_NonPsych_4_Med__c ,HP_Current_NonPsych_4_Route__c ,
                            HP_Current_NonPsych_5_Dosage__c ,HP_Current_NonPsych_5_Freq__c ,HP_Current_NonPsych_5_Indicat__c ,HP_Current_NonPsych_5_Med__c ,
                            HP_Current_NonPsych_5_Route__c,HP_Exam_Head_macrocephalic__c ,HP_Exam_Thyroid_masses__c,HP_History_of_Seizures_text__c ,ASSESS_OF_MENTAL_MOOD_Angry__c,                         
                            Client_Chart__c, Client_Chart__r.Treatment_Center__r.Name, Client_Chart__r.Name from Clinical_Evaluation_3__c where id=:CEID];
            
            
                            
            }
            
            if (ceRecord.HP_Status__c == '' || ceRecord.HP_Status__c == 'Open' || ceRecord.HP_Status__c == 'In Progress') {

                    ceRecord.HP_Status__c = 'In Progress';
                    ceRecord.SignedBy__c = 'None';
            }
            
            
            userObj = [Select id, name, title, User_Role__c,Has_Overwrite_Access__c, UserRole.Name from user where id =: userinfo.getUserID()];
            
            /*getAllMeds();
            getLatestVital();
            */checkExistingCode();
            fillAllCodes();
            //setAllBooleansTrue();
             
        
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
            pr = new PageReference('/apex/CE_HP2');
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
        pageReference pr = new PageReference('/apex/CE_HP2');
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
        list<order__c> lstOFMedToUpd = new list<Order__c>();
        try
        {
            upsert ceRecord;
            upsert clientRecord;
            if(CEId ==  null)
            {
                //update lstOFMedToUpd;
                //update latestVitals;
                upsert ceRecord;
            }
            pr = new PageReference('/apex/CE_HP2');
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
        system.debug('enter in method');
        string strCode = '';
        for(string newcode: Codes)
            strCode += newcode + ';' ;
        
        //ceRecord.HP_Diagnosis_Code__c = strCode;
        clientRecord.Diagnosis_Code__c = ceRecord.HP_Diagnosis_Code__c;
        list<order__c> lstOFMedToUpd = new list<Order__c>();
        try
        {
            upsert ceRecord;
            upsert clientRecord;
            system.debug('no error');
            if(CEId ==  null)
            {
                //update lstOFMedToUpd;
                //update latestVitals;
                upsert ceRecord;
            }
        }
        catch(exception e)
        {
            ApexPages.AddMessages(e);
            system.debug('exc');
        }
        //return null;
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