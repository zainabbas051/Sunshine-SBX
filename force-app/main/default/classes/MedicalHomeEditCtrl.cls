/*
test class : MedicalHomeEditCtrlTest
*/
public class MedicalHomeEditCtrl {
    public string mdRecordId {get;set;}
    public string rtId;
    public string VsRtId;
    public List<Recurring_Assessment__c> VSLst;
    public string editValue{get;set;}
    public boolean edit {get;set;}
    public Recurring_Assessment__c VSIns {get;set;}
    public Medical__C DrugScreenDetox {get;set;}
    public string RecordTypeName         {get;set;}
    public string rtype {get; set;}
    
    public string  ProviderConsultation;
    public string  MedicalLabAttachmentRtId;
    public string  AdmitOrderRtId;
    public string  OustidereferalnoteRtId;
    public string  DrugScreenRtId;
    public string  UrinePregnacyTestRtId;
    public string CCId                         {get;set;}
    
    public boolean ShowMedicalConsultForm      {get;set;}
    public boolean ShowMedicalDetoxForm        {get;set;}
    public boolean ShowMedicalLabAttachmentForm{get;set;}
    public boolean showAdmitOrderForm          {get;set;}
    public boolean ShowOustidereferalnoteform  {get;set;}
    public boolean ShowDrugScreenForm          {get;set;}
    public Boolean ShowUrinePregnacyTestForm   {get;set;}
    public Medical__c medical                  {get;set;}
    public string ImageUrlAddress              {get;set;}
    public string SelectedSignedOption         {get;set;}
    public string selectedOption               {get;set;}
    //AWS
    public string accessKeyId                 {get;set;}
    public string secretAccessKey             {get;set;}
    public string OrgName                     {get;set;}
    public client_chart__c ClientIns           {get;set;}
    final string AWSURL;
    public List<string> AttachmentFileName {get;set;}
    public List<UtlizationReviewOrder__c> ListOfOrder{
        get;
        set;
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
    
    
    public User UserObj{
        
        get{
            
            return [Select ID, UserName,Acess_Type__c, Has_Overwrite_Access__c FROM User where ID =: UserInfo.getUserId()];
        }
        set;
    }
    
    public MedicalHomeEditCtrl(){
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        CCId = apexPages.currentPage().getParameters().get('ID');
        ClientIns = [select id,height__C,weight__c from Client_chart__C where id=:CCId];
        selectedOption = 'None';
        
        rtype = apexPages.currentPage().getParameters().get('rt')!=null ? apexPages.currentPage().getParameters().get('rt'):'';
        mdRecordId= apexPages.currentPage().getParameters().get('mcid');
        rtId = apexPages.currentPage().getParameters().get('rtId');
        editValue = apexPages.currentPage().getParameters().get('editValue');
        edit=false;
        VsRtId =Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
        ProviderConsultation = Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Provider Consultation').getRecordTypeId();
        MedicalLabAttachmentRtId= Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Lab Attachment').getRecordTypeId();
        AdmitOrderRtId= Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Admit Order').getRecordTypeId();
        OustidereferalnoteRtId= Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Oustide referal note').getRecordTypeId();
        DrugScreenRtId= Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('BAC and Drug Screen').getRecordTypeId();
        UrinePregnacyTestRtId= Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Urine Pregnancy Test').getRecordTypeId();
        ShowMedicalDetoxForm = false;
        
        
       if(rtId==MedicalLabAttachmentRtId)
            ShowMedicalLabAttachmentForm = true;
        else if(rtId==AdmitOrderRtId)
            showAdmitOrderForm= true;
        else if(rtId==OustidereferalnoteRtId)
            ShowOustidereferalnoteform = true;
        else if(rtId==DrugScreenRtId)
            ShowDrugScreenForm = true;
        else if(rtId==UrinePregnacyTestRtId)
            ShowUrinePregnacyTestForm = true;
            
         
         medical = [SELECT id,DS_All_Negative__c,DS_AMP__c,DS_BAR__c,DS_BZO__c,DS_COC__c,DS_MDMA__c,DS_MET__c,DS_MTD__c,DS_OPI__c,recordType.DeveloperName,
                      DS_OXY__c,DS_PCP__c,DS_Suboxone__c,DS_TCA__c,DS_Temperature__c,
                      UPT_Description__c,UPT_None_Description__c,Ds_THC__c,ORN_Date__c,ORN_Client_referred_detail__c,ORN_Referral_Contact_Information__c,
                      ORN_Referred_Service_Provider_detail__c,ORN_Return_to_Program__c,ORN_Return_to_Program_Explained__c,ORN_Return_to_Program_Explaination__c,
                      ORN_Emergency_Contact_Notified__c,ORN_Information_disclosed__c,ORN_Information_Disclose_Detail__c,ORN_Ultimate_Outcome__c,
                                 Attachment1_Id_URl__c, Attachment2_Id_URl__c,
                                 Attachment3_Id_URl__c, Attachment4_Id_URl__c, Attachment5_Id_URl__c, Attachment6_Id_URl__c, 
                                 Attachment7_Id_URl__c, Attachment8_Id_URl__c, Attachment9_Id_URl__c, Attachment10_Id_URl__c,
                                 MDF_WS_Agitation__c,In_take_of_food_water__c,Station__c ,MDF_Follow_up_with_PCP__c,MDF_Reviewed_With_Client__c,
                                 MDF_WS_Anxiety__c,MDF_Appearance__c,MDF_Tone_Atrophy__c,MDF_Affect_Blunted__c,MDF_Bowel__c,MDF_WS_Chills__c,
                                 MDF_Tone_Cogwheeling__c,MDF_Concentration__c,MDF_Affect_Congurent__c,MDF_Affect_Constricted__c,
                                 MDF_Recom_Continue_current_protocol__c,MDF_Cravings__c,MDF_Current_Detox_Protocol__c, MDF_WS_Diaphoresis__c,
                                 MDF_WS_diarrhea__c,MDF_Strength_Diffusely_Weak__c,MDF_WS_Diuresis__c,MDF_Eye_Contact__c,MDF_Tone_Flaccid__c,
                                 MDF_Affect_Flat__c,MDF_WS_Flushing__c,MDF_Speech_Garbled__c,MDF_WS_GI_disturbance_nausea__c,MDF_WS_Hallucinations__c,
                                 MDF_Gait_Hemiplegic__c,MDF_Homicidal__c,MDF_Homicidal_Ideation_Present__c,MDF_Speech_incoherent__c,MDF_Affect_Incongurent__c,
                                 MDF_WS_Increased_Perspiration__c,MDF_Insight__c,MDF_WS_Irritability__c,MDF_Judgement__c,MDF_Affect_Labile__c,
                                 MDF_Lab_Results__c,MDF_Language__c,MDF_Medication_Compliance__c,MDF_Medication_Side_Effects__c,MDF_Mood__c,
                                 MDF_WS_Muscle_Twitching__c,MDF_Musculoskeltal__c, MDF_Speech_Mute__c,MDF_Lab_Results_None__c,MDF_CIWA__c,
                                 MDF_COWS__c,MDF_Cows_None__c,MDF_CIWA_None__c,MDF_WS_None__c,MDF_Medication_Side_Effects_None__c,
                                 MDF_Speech_Normal__c,MDF_Strength_Normal__c,MDF_Tone_Normal__c,MDF_Gait_Normal__c, MDF_Precautions_Other__c,
                                 MDF_Precautions_None__c,MDF_Precaution_Seizure__c,MDF_Precaution_Detox_Vital_Signs__c,MDF_Precaution_Fall__c,
                                 MDF_Gait_Parkinsonian__c,MDF_Suicidality_Plan__c,MDF_Plan__c,MDF_Precautions__c,MDF_Speech_Pressured__c,
                                 MDF_PRNs_in_the_last_24_hours__c,MDF_Problems__c,MDF_WS_Pupillary_Constriction__c,MDF_WS_Dysphoria__c,
                                 MDF_WS_Headache__c,MDF_WS_Hypersomnia__c,MDF_WS_Insomnia__c,MDF_WS_Muscle_Cramping__c,MDF_WS_Paranoia__c,
                                 MDF_WS_Perceptual_Disturbances__c,MDF_WS_Difficulty_Concentrating__c,MDF_WS_Pupillary_dilation__c,
                                 MDF_Speech_Rapid__c,MDF_Recommendations__c,MDF_WS_Restlessness__c,MDF_Tone_Rigid__c,MDF_Speech_Scant__c,
                                 MDF_Recom_See_Order_for_Changes__c,MDF_Gait_Shuffling__c,MDF_Sleep__c,MDF_Speech_Slow__c,MDF_Speech_Slurred__c,
                                 MDF_Tone_Spastic__c,MDF_Gait_Staggering__c,MDF_MC_compliant__c,MDF_MC_irregular__c,MDF_MC_refused__c,MDF_Speech_Stutter__c,
                                 MDF_Suicidality__c,MDF_Thought_Process__c,MDF_WS_Tremors__c,MDF_Gait_Unsteady__c,MDF_WS_Vomiting__c,MDF_Strength_Weakness__c,
                                 MDF_WS_Details__c,MDF_Gait_Wide_based__c,MDF_WS_Yawning__c,MC_Evaluation_Date__c,MC_Chief_Complaint__c,
                                 MC_Labs_tests__c ,MC_Assessment__c ,MC_Plan__c ,Vital_Sign__c,MC_Clinical_Exam__c ,
                                 MDF_Medical_Compliance_Detail__c,MDF_Intake_normal__c,MDF_Intake_diminished__c,MDF_intake_increased__c,MDf_Intake_needs_coaxing__c,
                                 MDF_Bowel_regular__c,MDF_bowel_diarrhea__c,MDF_Bowel_constipated__c,MDF_sleep_excessive_sleep__c,
                                 MDF_Sleep_delayed_sleep_onset__c,MDF_sleep_fair__c,MDF_Sleep_early_waking__c,MDF_sleep_good__c,
                                 MDF_Sleep_Hours__c,MDF_sleep_poor__c,MDF_Appearance_Casually_Groomed__c,MDF_Appearance_Disheveled__c,
                                 MDF_Appearance_Well_groomed__c,MDF_Eye_Avoidant__c,MDF_Eye_Good__c,MDF_Eye_Poor__c,MDF_Concentration_Attentive__c,
                                 MDF_Concentration_Inattentive__c, MDF_Concentration_Distracted__c,
                                    MDF_Language_Communicative__c, MDF_Language_Minimally_Communicative__c, MDF_Language_Uncommunicative__c, 
                                    MDF_Language_Cooperative__c, MDF_Language_Hostile__c, MDF_Language_Defensive__c,
                                    MDF_Mood_Elevated__c, MDF_Mood_Euthymic__c, MDF_Mood_Depressed__c,Medical_Closed_Date__c ,
                                    MDF_Thought_Ogical__c, MDF_Thought_Loose__c, MDF_Thought_Tangential__c, 
                                    MDF_Thought_Circumstantial__c, MDF_Thought_Concrete__c, MDF_Thought_Illogical__c,
                                    MDF_Suicidality_Denies__c, MDF_Suicidality_Guarded__c, MDF_Suicidality_Ideation__c, MDF_Suicidality_intent__c,
                                    MDF_Homicidal_Denies__c,MDF_Is_Homicidal_Ideation_present__c,
                                    MDF_Judgement_Good__c, MDF_Judgement_Fair__c, MDF_Judgement_Poor__c,
                                    MDF_Insight_Good__c, MDF_Insight_Fair__c, MDF_Insight_Poor__C,
                                    MDF_Station_Normal__c, MDF_Station_Slouched__c, MDF_Station_Kyphotic__c, MDF_Station_Lordotic__c,
                                    MDF_Prognosis_poor__c, MDF_Prognosis_fair__c, MDF_Prognosis_good__c,
                                    MDF_physical_Limited_detox__c,MDF_physical_Ok__c,MDF_physical_detail__c,
                                    MDF_Recommendation_Details__c,
                                    MDF_Plan_Step_down__c, MDF_Plan_Discharge__c,Closed_Date__c ,
                                    MDF_Plan_detail__c,LA_Notes_Comments__c,
                                    Status__c ,SignedBy__c,Client_Signed_User__c ,Patient_Closed_Date__c ,
                                    Client_Chart__r.Treatment_Center__r.Name,RecordType.Name,Client_Image_Url__c ,
                                    Image_Url__c ,
                                 Client_Chart__c,Client_Chart__r.name,Signed_User__c,
                                 AO_height__c,AO_Weight_in_lbs__c,AO_Admit_to__c,AO_Visual_Check_Parameters__c,
                                 AO_Vital_Sign_Parameters__c,AO_COWS_Parameters__c,AO_CIWA_Parameters__c,AO_No_Standing_Order__c ,
                                 AO_Determine_BAC__c ,AO_Obtain_TB_Skin_Test__c,AO_Obtain_Initial_Urine_Drug_Screening__c,
                                 AO_Obtain_Standard_Blood_DNA_Lab__c,AO_14_Day_Thiamine_Supplement__c ,AO_Multivitamin__c,AO_Folic_Acid_Supplement__c ,
                                 Provider_Consultation_Type__c ,
                                 Visual_Check_Parameters1__c ,Vital_Sign_Parameters__c ,CIWA_Parameters__c, COWS_Parameters__c,
                                 Type_of_Note__c ,Doctors_Note_Date_Time__c, LA_Title__c,
                                 Due_Date_Time__c,Impression__c,
                                Hair_Color__c,Eye_Color__c,Name_of_Physician__c,Date_of_Last_Visit__c,Reason__c,
                                Signs_and_Symptoms_of_Withdrawal__c,History_of_Physical_complications__c,
                                Neurological__c, Hx_of_ECT_When__c,How_many_times__c,Muscular_Skeletal__c,Gastro_intestinal__c,
                                Bowel__c,Urinary__c,Cardio_Respiratory__c,Any_Medical_Condition__c,Endocrine__c,Skin__c,Dental__c,Nose_Throat__c,M_F_Reproductive__c,
                                All_Patients__c,Surgical_History__c,Speech__c,Vision__c,Hearing__c,Sleep__c,Ave_hours_sleep__c,Self_Care_Hygiene__c,Do_you_currently_have_any_physical_pain__c,
                                If_Yes_Pain_Score__c,Within_the_past_two_weeks__c,list_medications_and_treatments_NA__c,If_yes_list_medications_and_treatments__c,
                                Have_you_had_any_significant_reoccurrin__c,s_UNABLE_TO_VERBALIZE_SIGNS_SYMPTOMS__c,DOES_DEMONSTRATE_SIGNS_OF_PAIN__c,
                                Do_you_currently_have_any_suicidal_ideat__c,Within_the_past_two_weeks_Suc__c,If_yes_list_medications_Sucide_NA__c,
                                If_yes_list_medications_Sucide__c,Have_you_had_any_significant_sucide__c,
                                UNABLE_TO_VERBALIZE_suc__c,DOES_DEMONSTRATE_SIGNS_OF_Suc__c,Signs_and_Symptoms_Other__c,Previous_Treatment_Image__c,
                                HIV_Date_of_last_test__c,Mood_and_Behavior__c,
                                Glucose_Reading__c,Type_of_Check__c,
                                Intervention__c,Glucose_Note__c,Weight_Loss_or_Gain__c,Cravings__c,Anxiety__c,Depression__c, Nursing_Notes__c,
                                Urinary_Comments__c,Bowel_Comments__c,Gastro_intestinal_Notes__c,Muscular_Skeletal_Notes__c,Medication_Given_for_Sleep__c,
                                Menstrual_Cycle__c,Client_Chart__r.gender__c,Other_findings_treatment__c,FemalSexual_Assault_Rape_Hx__c
                                ,Females_Only__c,Drug_Screen_Performed__c,BAC_Level__c,BAC_Performed__c
                                 
                               FROM Medical__c 
                               WHERE Id =:mdRecordId limit 1];
        
        
                                                  
        RecordTypeName = medical.RecordType.Name;
        
        if(RecordTypeName == 'Lab Attachment' || RecordTypeName == 'Doctors Note' ||RecordTypeName == 'Evaluation Addendum'||RecordTypeName == 'Medical Attachment'){
            
            AttachmentFileName = new List<string>();
            CreateAttachmentFileName();
        }
         string web=(String)ApexPages.currentPage().getHeaders().get('Referer');
         system.debug('web++++'+web);
    
    }
    
     public pageReference AddAttachment(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_MedicalAttachments?id='+mdRecordId);
        return pr;
    } 
    
    public void SelectChange(){
        
    }
    
    public void editRecord() {
        edit= True;
    }
    
    public void SaveRecord() {
        
        edit = False;
        update medical ;
        
    }
    
    public PageReference BacktoMedicalHome() {
        PageReference secondPage = Page.MedicalHomePage;
        secondPage.getParameters().put('id',CCId);
        secondPage.getParameters().put('rt',ApexPages.CurrentPage().getParameters().get('rt'));
        
        secondPage.setRedirect(true);
        
        return secondPage; 
    }
    
    public void changeStatus() {

        //if status is open
        if (Medical.status__c == 'Open') {

            Medical.status__c = 'In Progress';
            Medical.SignedBy__c = 'None';
            
            if(Medical.recordType.DeveloperName == 'Admit_Order' || Medical.recordType.DeveloperName == 'Drug_Screen'|| Medical.recordType.DeveloperName == 'Lab_Attachment'||Medical.recordType.DeveloperName =='Evaluation_Addendum'||Medical.recordType.DeveloperName =='Medical_Attachment')
                 Medical.SignedBy__c = 'Client';
            update Medical;
        }
         if (Medical.status__c == 'In Progress' && (Medical.recordType.DeveloperName == 'Lab_Attachment'||Medical.recordType.DeveloperName =='Evaluation_Addendum'||Medical.recordType.DeveloperName =='Medical_Attachment')) {
            Medical.SignedBy__c = 'Client';
            update Medical;
        }
        
         if(Medical.Status__c == 'Closed'){
            
              
              ListOfOrder = loadOrders();
               
            }
            else
            {
                UpdateMedicationList();
               
            }
           
        string mdId=apexPages.currentPage().getParameters().get('mcid');
        string clientID=apexPages.currentPage().getParameters().get('ID');

        if(rtId == ProviderConsultation){
            
            CreateUtilizationReview(mdId , clientID, medical.status__c);
            CreateDrugScreen(mdId , clientID, medical.status__c);
        }
    
    }
    
    
    
      List<UtlizationReviewOrder__c> LoadOrders(){
        
          return [Select ID,Order__r.Order_Type__c,Order__r.Taper__r.Name,Order__r.Medicine__r.Name,
          Order__r.Frequency__c FROM UtlizationReviewOrder__c where Medical__c =: medical.id];
    }
    
   
    
    void UpdateMedicationList(){
    
        string clientID=apexPages.currentPage().getParameters().get('ID');
        delete loadOrders();
        ListOfOrder = new List<UtlizationReviewOrder__c>();
        for(Order__c od : [Select ID,Order_Type__c,Taper__r.Name,Medicine__r.Name,
          Frequency__c from Order__c where Client_Chart__c=:clientID AND (Status__c = 'Active' OR Status__c = 'Under Review') AND Order_Type__c <> 'Action'])
        {
            ListOfOrder.add( new UtlizationReviewOrder__c(Medical__c = medical.id , Order__c = od.ID , Order__r= od));
        }
        insert ListOfOrder;
        
        system.debug('test##' + ListOfOrder);
        
    }

    
    
     void CreateUtilizationReview(string aMedID , string aClientID ,string aMedStatus){
         
         if(aMedStatus != 'Closed'){
            recurring_assessment__c NewVSIns = new recurring_assessment__c();
            UtlizationReviewOrder__c JuncIns = new UtlizationReviewOrder__c();
            UtlizationReviewOrder__c NewJuncIns = new UtlizationReviewOrder__c();
            for(Recurring_Assessment__c ra : [SELECT Id,BP_Systolic__c, BP_Diastolic__c, Temperature__c, Pulse__c,Respirations__c, X02_Saturation__c,
                                               Time_Due__c, LastModifiedDate, Owner.Name, CreatedDate, Related_To__c  FROM Recurring_Assessment__c WHERE 
                                               RecordType.DeveloperName='Vital_Signs' and Client_Chart__c=:aClientID
                                               and Status__c='Closed' order by LastModifiedDate desc limit 1]){
                NewVSIns = ra;
            }
            for(UtlizationReviewOrder__c uro : [Select ID,Medical__c,Vital_Sign__c FROM UtlizationReviewOrder__c where Medical__c=:aMedID and Vital_Sign__c!=null ]){
                JuncIns = uro;
            }
            if(NewVSIns.id != null){//Checking to see if a Latest Closed Vital Sign Exists
                if(JuncIns.id != null){//Checking to See is an old Junction Object Record for the Medical Record exists
                    if(NewVSIns.id!=JuncIns.Vital_Sign__c){//If an Existing Junction Object Record for the Medical Record exists and the Vital Sign linked to it is not the same Latest Closed Vital Sign
                        delete JuncIns;//Deleting Old Junction Object
                        NewJuncIns = new UtlizationReviewOrder__c(Medical__c = aMedID,Vital_Sign__c = NewVSIns.id );//Creating New Junction Object
                        insert NewJuncIns ;    
                    }
                }else{//In case no Junction Object Existed, a.k.a the form was being opened for the first time
                    NewJuncIns = new UtlizationReviewOrder__c(Medical__c = aMedID,Vital_Sign__c = NewVSIns.id );//Create New Junction Object
                    insert NewJuncIns ;     
                }
            }
            system.debug('Test Values'+newJuncIns +'testttttt'+NewVSIns);
            VSIns = NewVsIns;
        
     }
      if(aMedStatus == 'Closed'){
        UtlizationReviewOrder__c JuncIns= [Select ID,Medical__c,Vital_Sign__c FROM UtlizationReviewOrder__c where Medical__c=:aMedID and Vital_Sign__c!=null ];
        VsIns= [SELECT Id,BP_Systolic__c, BP_Diastolic__c, Temperature__c, Pulse__c,Respirations__c, X02_Saturation__c,
                           Time_Due__c, LastModifiedDate, Owner.Name, CreatedDate, Related_To__c  FROM Recurring_Assessment__c WHERE id=:JuncIns.Vital_Sign__c ];
                                               
    
        }
     
     }
     
     void CreateDrugScreen( string aMedID,string aClientID,string aMedStatus){
         
          if(aMedStatus != 'Closed'){
             Medical__c DrugScreenIns = new Medical__c(); 
 
             List<Medical__c> LsDrugScreen =[SELECT Id,Medical_Closed_Date__c,Attachment10_Id_URl__c,Attachment1_Id_URl__c,Attachment2_Id_URl__c,
                                    Attachment3_Id_URl__c,Attachment4_Id_URl__c,Attachment5_Id_URl__c,Attachment6_Id_URl__c,
                                    Attachment7_Id_URl__c,Attachment8_Id_URl__c,Attachment9_Id_URl__c  
                                    FROM Medical__c WHERE RecordType.DeveloperName='Drug_Screen' and Client_Chart__c=:aClientID
                                    and Status__c='Closed'  order by Medical_Closed_Date__c desc limit 1];
                                    
            if (LsDrugScreen.size() > 0){
                DrugScreenIns  = LsDrugScreen.get(0);
            }
            
            List<UtlizationReviewOrder__c> JuncInsDrug= [Select ID,Medical__c,drugscreen__C FROM UtlizationReviewOrder__c where Medical__c=:aMedID and drugscreen__C!=null limit 1 ];
            if(!JuncInsDrug.isEmpty()){
                UtlizationReviewOrder__c NewJuncInsDrug ;
                if(DrugScreenIns.id!=JuncInsDrug[0].drugscreen__C ) {
                    delete JuncInsDrug;
                    NewJuncInsDrug = new UtlizationReviewOrder__c(Medical__c=aMedID,drugscreen__C= DrugScreenIns.id );
                    insert NewJuncInsDrug ;
                }
            }
            
            DrugScreenDetox = DrugScreenIns;
        
    }
    
    if(aMedStatus == 'Closed'){
        UtlizationReviewOrder__c JuncInsDrug= new UtlizationReviewOrder__c();
        for(UtlizationReviewOrder__c uro : [Select ID,Medical__c,drugscreen__C FROM UtlizationReviewOrder__c where Medical__c=:aMedID and drugscreen__C!=null ]){
            JuncInsDrug= uro;
        }
        if(JuncInsDrug.id!= null){
            for(medical__c med : [SELECT Id,Medical_Closed_Date__c,Attachment10_Id_URl__c,Attachment1_Id_URl__c,Attachment2_Id_URl__c,
                                        Attachment3_Id_URl__c,Attachment4_Id_URl__c,Attachment5_Id_URl__c,Attachment6_Id_URl__c,
                                        Attachment7_Id_URl__c,Attachment8_Id_URl__c,Attachment9_Id_URl__c from medical__c where id=:JuncInsDrug.drugscreen__C]){
                DrugScreenDetox= med;
            }
        }                                       
    
        }   
     }
    
     public PageReference CloseMedicals() {

        //update intake Form with the user signature    

        User u = [Select Name, title from User where ID =: UserInfo.getUserID() limit 1];

        if (SelectedSignedOption == 'Staff') {

            Medical.Image_Url__c = AWSURL + ImageUrlAddress;
            Medical.Signed_User__c = 'Staff present: ' + u.Name + ',' + u.Title;
            Medical.Closed_Date__c = DateTime.Now();
            Medical.SignedBy__c = 'Staff';
        } else if (SelectedSignedOption == 'Patient') {

            Medical.Client_Image_Url__c = AWSURL + ImageUrlAddress;
            Medical.Client_Signed_User__c = '(Patient) ' + Medical.Client_Chart__r.Name;
            Medical.Patient_Closed_Date__c = DateTime.Now();
            Medical.SignedBy__c = 'Client';
        }

        if ((Medical.Signed_User__c != null || String.isNotBlank(Medical.Signed_User__c))&& (Medical.recordType.DeveloperName == 'Drug_Screen'|| Medical.recordType.DeveloperName =='Admit_Order'
                || Medical.recordType.DeveloperName =='Lab_Attachment'||Medical.recordType.DeveloperName =='Evaluation_Addendum'
                || Medical.recordType.DeveloperName =='Medical_Attachment' || Medical.recordType.DeveloperName =='Psychiatric_Progress_Notes'
                || Medical.recordType.DeveloperName == 'Oustide_referal_note' || Medical.recordType.DeveloperName == 'Doctors_Note'))
        {
            Medical.Status__c = 'Closed';
            Medical.SignedBy__c = 'All';
            Medical.Medical_Closed_Date__c =DateTime.Now();
        }

        //Medical.Signed_User__c = '(Patient);

        else if ((Medical.Signed_User__c != null || String.isNotBlank(Medical.Signed_User__c)) && (Medical.Client_Signed_User__c != null || String.isNotBlank(Medical.Client_Signed_User__c))) {
            Medical.Status__c = 'Closed';
            Medical.SignedBy__c = 'All';
            Medical.Medical_Closed_Date__c =DateTime.Now();

        }

        update Medical;

       /* PageReference pr = new PageReference('/apex/MedicalHomeEditPage');
        pr.getParameters().put('ID', CCId);
        pr.getParameters().put('rtId', rtId);
        pr.getParameters().put('mcid', mdRecordId);
        pr.getParameters().put('editValue', '0');
        pr.getParameters().put('rt',rtype);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;*/
        return null;

    }
    
    void CreateAttachmentFileName(){
        
         if(Medical.Attachment1_Id_URl__c!= null){
             
            
            AttachmentFileName .add(SubString(Medical.Attachment1_Id_URl__c)); 
        }
        
        if(Medical.Attachment2_Id_URl__c!= null){
            AttachmentFileName .add(SubString(Medical.Attachment2_Id_URl__c)); 
        
        }
        
        
        if(Medical.Attachment3_Id_URl__c!= null){
             AttachmentFileName .add(SubString(Medical.Attachment3_Id_URl__c)); 
        }
        
        if(Medical.Attachment4_Id_URl__c!= null){
             AttachmentFileName .add(SubString(Medical.Attachment4_Id_URl__c)); 
        }
        
        if(Medical.Attachment5_Id_URl__c!= null){
              AttachmentFileName .add(SubString(Medical.Attachment5_Id_URl__c)); 
        }
        
        if(Medical.Attachment6_Id_URl__c!= null){
            AttachmentFileName .add(SubString(Medical.Attachment6_Id_URl__c));  
        }
        
        if(Medical.Attachment7_Id_URl__c!= null){
              AttachmentFileName .add(SubString(Medical.Attachment7_Id_URl__c)); 
        }
        
        if(Medical.Attachment8_Id_URl__c!= null){
              AttachmentFileName .add(SubString(Medical.Attachment8_Id_URl__c)); 
        }
        
        if(Medical.Attachment9_Id_URl__c!= null){
             AttachmentFileName .add(SubString(Medical.Attachment9_Id_URl__c)); 
        }
        
        if(Medical.Attachment10_Id_URl__c!= null){
            AttachmentFileName .add(SubString(Medical.Attachment10_Id_URl__c)); 
        }
    }
    
    string SubString(String aUrl){
        
         integer lastIndexOf =aUrl.lastIndexOf('/');
          
          string subResult = aUrl.substring(lastIndexOf +1);
          subResult = subResult.replace('%',' ');
          return subResult;
    }
 

}