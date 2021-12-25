//Test Class : utilizationreviewControllerTest
public with sharing class utilizationreviewController {
    
    public string rtype {get; set;} 
    public string rtID {get; set;}

   public List<UtlizationReviewOrder__c > ListOfOrder {
       get{
           if(ListOfOrder != null){
               return ListOfOrder;
           }else{
               ListOfOrder = new List<UtlizationReviewOrder__c>();
               return ListOfOrder;
           }
       }
       set;
   }
    
    //hidden field
    public string SelectedSignedOption {
        get;
        set;
    }
    public string ImageUrlAddress {
        get;
        set;
    }
    public User userObj{
        
        get;
        set;
    
    }
    
    public UtlizationReviewOrder__c VitalAss{
        get;
        set;
    }
    
      public String RecordType{
        
        get;
        set;
    
    }
    
    //AWS
    public string accessKeyId {
        get;
        set;
    }
    public string secretAccessKey {
        get;
        set;
    }
    public string OrgName {
        get;
        set;
    }
    final string AWSURL;
    
    string UtilizationID;
    
    public ID ClientChartID{get;set;}


    public boolean EditPage{get;set;}
    
    public Client_Chart__c cl {get; set;}
    public Utilization_Review__c UtilizationReview {get; set;}
    public List<String> LstFileName = new List<String>();
    public List<string> AttachmentFileName {get;set;}

    
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('UtilizationReview');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    public PageReference submit(){
        
        upsert UtilizationReview;
        //update VitalAss;
        PageReference pr = new PageReference('/apex/utlization_review');
        pr.getParameters().put('ID',ClientChartID );
        pr.getParameters().put('UtilId',UtilizationReview.ID);
        pr.getParameters().put('rt',rtype);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;
    }
    
    public void QuickSubmit(){
        
        upsert UtilizationReview;
        
    }
    
      public PageReference ActiveUtilizationReview() {
      
            if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == NULL) {

                UtilizationReview.Staff_Image_Url__c= AWSURL + ImageUrlAddress;
                UtilizationReview.Staff_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
                UtilizationReview.Staff_Closed_Date__c = DateTime.Now();
                UtilizationReview.SignedBy__c = 'Staff';
            
            } else if (userObj.User_Role__c != NULL) {

                UtilizationReview.Intern_Image_Url__c= AWSURL + ImageUrlAddress;
                UtilizationReview.Intern_Signed_User__c= userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
                UtilizationReview.Intern_Closed_Date__c= DateTime.Now();
                UtilizationReview.SignedBy__c = 'Client';
                UtilizationReview.Status__c = 'Review Pending';
            }

            if (UtilizationReview.Staff_Signed_User__c != null || String.isNotBlank(UtilizationReview.Staff_Signed_User__c )) {
                UtilizationReview.Status__c = 'Complete';
                UtilizationReview.SignedBy__c = 'All'; // signing is complete
              

            }
           
           if(!test.isRunningTest()){ 
               update VitalAss;
               update UtilizationReview;
           }
           return null;
    }
    
    public utilizationreviewController(){
    
        rtype = apexPages.currentPage().getParameters().get('rt')!=null ? apexPages.currentPage().getParameters().get('rt'):'';
         userObj = [Select id, name, title, User_Role__c from user where id =: userinfo.getUserID()];
         EditPage = (ApexPages.CurrentPage().getParameters().get('readOnly') != null)? true: false;
         UtilizationID = ApexPages.CurrentPage().getParameters().get('UtilId');
         ClientChartID = ApexPages.CurrentPage().getParameters().get('ID');
         cl = new Client_Chart__c();
        
          accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
         cl = [Select Admit_Date_Time__c,Discharge_Date_Time__c ,Primary_Therapist__c,Primary_Therapist__r.Name,
                            Primary_Therapist__r.Street, Primary_Therapist__r.State, 
                            Primary_Therapist__r.City, Primary_Therapist__r.PostalCode
                            from Client_Chart__c where ID =: ClientChartID];
         if(UtilizationID == null){
             //Client_Chart__c cl = [Select Admit_Date_Time__c,Discharge_Date_Time__c ,Primary_Therapist__r.Name from Client_Chart__c where ID =: ClientChartID];
             UtilizationReview  = new Utilization_Review__c ();
             UtilizationReview.Client_Chart__c =ClientChartID ;
             UtilizationReview.Status__c= 'Open';
             UtilizationReview.SignedBy__c = 'Client';
             UtilizationReview.Patient_Admission_Date__c = cl.Admit_Date_Time__c;
             UtilizationReview.Patient_Estimated_Discharge_Date__c = cl.Discharge_Date_Time__c;
             UtilizationReview.Primary_Therapist__c = cl.Primary_Therapist__c;
             //UtilizationReview.Name_of_person_completing_form__c = userObj.Name;
             return;
         
         }
         UtilizationReview = [ SELECT Affect_Angry__c,Affect_Anxious__c,Affect_Appropriate__c,Affect_Blunted__c,Name_of_person_completing_form__c,
         Affect_Broad__c,Affect_Congruent__c,Affect_Constricted__c,Affect_Despairing__c,Affect_Euphoric__c,
         Affect_Expansive__c,Affect_Flat__c,Affect_Inappropriate_explain__c,Affect_Incongruent__c,Affect_Intensity__c,
         Affect_Labile__c,Affect_Modulated__c,Affect_Other_explain__c,Affect_Restricted__c,Affect_Sad__c,Affect_Suspicious__c,
         Affect_Tearful__c,Affect__c,Agitation__c,Anxiousness__c,Any_Other_Notes_Description__c,Any_other_notes__c,Appearance_Appropriate__c,
         Appearance_Bizarre__c,Appearance_Disheveled__c,Appearance_Healthy__c,Appearance_Interested__c,Appearance_Unkempt__c,Appearance_Well_Groomed__c,
         Appearance__c,Appetite_disturbance__c,Attitude_Angry__c,Attitude_Anxious__c,Attitude_Apathetic__c,Attitude_Attentive__c,
         Attitude_Cooperative__c,Attitude_Defensive__c,Attitude_Depressed__c,Attitude_Gait__c,Attitude_Guarded__c,Attitude_Hostile__c,
         Attitude_Other_describe__c,Attitude_Paranoid__c,Attitude_Posture__c,Attitude__c,Authorization_date__c,Authorization_number__c,
         Behavior_Physical_Agitated__c,Behavior_Physical_Combative__c,Behavior_Physical_Cooperative__c,Behavior_Physical_Hyperactive__c,
         Behavior_Physical_Lethargic__c,Behavior_Physical_Pacing__c,Behavior_Physical_Restless__c,Behavior_Physical_Withdrawn__c,
         Behavior_Physical__c,Behavior_Psychological__c,Blackouts__c,Bouts_of_crying__c,BP_Abnormal_involuntary_movements__c,
         BP_Agitated__c,BP_Apathetic__c,BP_Appropriate__c,BP_diastolic__c,BP_Hyperactive__c,BP_Relaxed__c,BP_Rigid__c,BP_systolic__c,
         BP_Tense__c,Change_in_ability_to_function__c,City__c,Client_Chart__c,Comments__c,Contact_information_for_diagnosing__c,
         Cramping__c,CreatedById,CreatedDate,Current_Level_of_Care__c,Current_seizures__c,Current_Symptoms_behaviors_and_problems__c,
         Date_Current_Level_Began__c,Decreased_energy__c,Delirium_tremens__c,Depressed_mood__c,Diagnosing_physician_Contact_Info__c,
         diagnosing_physician_or_psychiatrist__c,Difficulty_making_decisions__c,Dissociation__c,Elevated_mood__c,End_date__c,
         Exaggerated_startle_response__c,Eye_Contact_Good__c,Eye_Contact_Intermittent__c,Eye_Contact_None__c,Eye_Contact__c,
         Family_Involvement__c,Frequency__c,Gait__c,Hallucinations__c,Hopelessness__c,Hyperactivity__c,Id,Impaired_memory_concentration__c,
         Impulse_Control_and_Mental_Health_Issues__c,Impulsivity__c,Initial_Level_of_Care__c,Insurance_Company_Picklist__c, Insurance_Company__c,
         Irritability__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,Last_coverage_date__c,Level_of_care__c,
         Loss_of_interest_in_activities__c,Mania__c,Medical_Issues_Affecting_Recovery__c,Mood_Angry__c,Mood_Anxious__c,
         Mood_Depressed__c,Mood_Dysphoric__c,Mood_Elated__c,Mood_Euphoric__c,Mood_Expansive__c,Mood_Fearful__c,Mood_Hypomanic__c,
         Mood_Irritable__c,Mood_lability__c,Mood_Manic__c,Mood_Normal__c,Mood__c,Most_Recent_Family_Session__c,Most_Recent_Medical_Appointment__c,
         Most_Recent_Meeting_with_Psychiatrist__c,Motivation_Level__c,Name,Name_of_diagnosing_physician__c,
         Name__c,Nausea__c,Next_review_date__c,Next_Scheduled_Family_Session__c,Next_Scheduled_Medical_Appointment__c,Night_sweats__c,
         No_withdrawal_symptoms__c,Number_of_days__c,O2_Saturation__c,Obsessions_Compulsions__c,Oppositionality__c,Other_Affect__c,
         Other_Attitude__c,Other_Notes__c,Pain__c,Panic_attacks__c,Paranoia__c,Past_DTs__c,Past_seizures__c,Patient_Admission_Date__c,
         Patient_Estimated_Discharge_Date__c,Phone__c,Physical_emotional_sexual_abuse__c,Physician_City__c,
         Physician_State__c,Physician_Zip_Code__c,Please_Rate_the_severity_of_risk__c,Poor_hygiene__c,Posture__c,
         Primary_Therapist_Address_Street__c,Psychomotor_Activity_Accelerated__c,Psychomotor_Activity_Normal__c,
         Psychomotor_Activity_Slow__c,Psychomotor_Activity__c,PTSD__c,Pulse__c,Reckless_activity__c,RecordTypeId,Recovery_Environment_at_Home__c,
         Relapse_Risk__c,Respirations__c,risk_for_Dimension_2__c,risk_for_Dimension_3__c,risk_for_Dimension_4__c,risk_for_Dimension_5__c,
         risk_for_Dimension_6__c,Seizures__c,Self_harm_behavior__c,Self_injurious_Tx__c,severity_of_risk_for_Dimension_1__c,
         severity_of_risk_for_Dimension_2__c,severity_of_risk_for_Dimension_3__c,severity_of_risk_for_Dimension_4__c,severity_of_risk_for_Dimension_5__c,
         severity_of_risk_for_Dimension_6__c,SG_Impaired_memory_concentration__c,SignedBy__c,Sleep_disturbance__c,Somatic_complaints__c,
         Speech_Abnormal_rhythm__c,Speech_Accelerated__c,Speech_Articulation_disorder__c,Speech_Coherent__c,Speech_Goal_directed__c,
         Speech_Hesitant__c,Speech_Incoherent__c,Speech_Loud__c,Speech_Monotonous__c,Speech_Mute__c,Speech_Neologisms__c,
         Speech_Non_spontaneous__c,Speech_Normal__c,Speech_Pressured__c,Speech_Rapid__c,Speech_Short_answers__c,Speech_Slow__c,Speech_Slurred__c,
         Speech_Spontaneous__c,Speech_Unresponsive__c,Speech__c,Start_date__c,State__c,Status__c,Sweating__c,Symptoms_General_Agitation__c,
         Symptoms_General_Anxiousness__c,Symptoms_General_Appetite_Disturbance__c,Symptoms_General_Cramping__c,Symptoms_General_Decreased_energy__c,
         Symptoms_General_Delusions__c,Symptoms_General_Depressed_mood__c,Symptoms_General_Hallucinations__c,Symptoms_General_Hopelessness__c,
         Symptoms_General_Hyperactivity__c,Symptoms_General_Irritability__c,Symptoms_General_Mania__c,Symptoms_General_Mood_lability__c,
         Symptoms_General_Nausea__c,Symptoms_General_Night_Sweats__c,Symptoms_General_None__c,Symptoms_General_Panic_Attacks__c,
         Symptoms_General_Paranoia__c,Symptoms_General_Sleep_Disturbance__c,Symptoms_General_Sweating__c,Symptoms_General_Tremors__c,
         Symptoms_General_Vomiting__c,SystemModstamp,Temperature__c,Thought_Content_Auditory__c,Thought_Content_Command__c,
         Thought_Content_Delusions__c,Thought_Content_Explain__c,Thought_Content_Hallucinations__c,Thought_Content_Homicidality__c,
         Thought_Content_Olfactory__c,Thought_Content_Other__c,Thought_Content_Paranoid__c,Thought_Content_Suicidality__c,
         Thought_Content_Tactile__c,Thought_Content_Visual__c,Thought_Process_Circumstantial__c,Thought_Process_Disorganized__c,
         Thought_Process_Flight_of_ideas__c,Thought_Process_Fragmented__c,Thought_Process_Goal_directed__c,Thought_Process_Linear__c,
         Thought_Process_Logical__c,Thought_Process_Loose_associations__c,Thought_Process_Neologism__c,Thought_Process_Normal__c,
         Thought_Process_Rambling__c,Thought_Process_Rapid_thoughts__c,Thought_Process_Tangential__c,Thought_Process__c,
         Though_Content_Grandiose__c,Though_Content_Obsessive_thinking__c,Treatment_Goals__c,Treatment_Plan__c,Tremors__c,Value__c,
         Vomiting__c,What_is_the_discharge_plan_to_date__c,Worthlessness__c,X12_Step_Involvement__c,Zip_Code__c,RecordType.Name,
         Client_Chart__r.Treatment_Center__r.Name,Client_Chart__r.Name,Intern_Image_Url__c,Intern_Signed_User__c,Intern_Closed_Date__c ,Staff_Image_Url__c ,Staff_Signed_User__c ,Staff_Closed_Date__c ,
         Client_Chart__r.Primary_Therapist__r.Name, Client_Chart__r.Primary_Therapist__r.Street,Client_Chart__r.Primary_Therapist__r.State,
         Client_Chart__r.Primary_Therapist__r.City,Client_Chart__r.Primary_Therapist__r.PostalCode,Physician_Address_Street__c, Patient_Admit_Datetime_ff__c,
         Patient_Estimated_Discharge_Datetime_ff__c, Current_Date_Time__c, Physician__c, Primary_Therapist__c, Attachment1_Id_URl__c, Attachment2_Id_URl__c,
         Attachment3_Id_URl__c, Attachment4_Id_URl__c, Attachment5_Id_URl__c, Attachment6_Id_URl__c, 
         Attachment7_Id_URl__c, Attachment8_Id_URl__c, Attachment9_Id_URl__c, Attachment10_Id_URl__c
          FROM Utilization_Review__c
         where ID =: UtilizationID ];
        rtID=UtilizationReview.RecordTypeId;
         UtilizationReview.Primary_Therapist__c = cl.Primary_Therapist__c;
         UtilizationReview.Primary_Therapist_Address_Street__c = cl.Primary_Therapist__r.Street;
         UtilizationReview.City__c = cl.Primary_Therapist__r.City;
         UtilizationReview.State__c = cl.Primary_Therapist__r.State;
         UtilizationReview.State__c = cl.Primary_Therapist__r.State;
         UtilizationReview.Zip_Code__c = cl.Primary_Therapist__r.PostalCode;
         if(UtilizationReview.Status__c == 'Open') {
             UtilizationReview.SignedBy__c = 'Client';
         }
         
         RecordType = UtilizationReview.RecordType.Name;
         //COmmented As Part of Discussion of Jared, to remove Current Medication List on Utilization Review Forms.
        //We will be Updating this Logic in Phase 2, by auto populating the Latest Related Med Orders, and Providing Order View Popup on each of them.
    
         //GetUtlizationOrder();
         if(RecordType == 'Utilization Review' ){
            
            AttachmentFileName = new List<string>();
            CreateAttachmentFileName();
        }
   
    }
    
    public void loadRelatedVitals(){
        System.debug('Entry Point A');
        if(UtilizationReview.Status__c != 'Complete' ){
            UpdateVitals();
        }
        else{
            GetVitals();
        }
    }
    
    //COmmented As Part of Discussion of Jared, to remove Current Medication List on Utilization Review Forms.
    //We will be Updating this Logic in Phase 2, by auto populating the Latest Related Med Orders, and Providing Order View Popup on each of them.
    /*
    public void GetUtlizationOrder(){
        if(!ListOfOrder.isEmpty()){
            ListOfOrder.clear();
        }
        for(UtlizationReviewOrder__c uro : [Select ID,Order__r.Order_Type__c,Order__r.Taper__r.Name, CreatedDate FROM UtlizationReviewOrder__c where Utilization_Review__c =: UtilizationID AND Order__c != null]){
            ListOfOrder.add(uro);
        }
        if(ListOfOrder.size()>0)
            UtilizationReview.Current_Date_Time__c = ListOfOrder[0].CreatedDate;
    }
    */
    
    public void GetVitals(){
        for(UtlizationReviewOrder__c uro : [Select ID,Vital_Sign__r.BP_Systolic__c,Vital_Sign__r.BP_Diastolic__c,Vital_Sign__r.Temperature__c, Vital_Sign__r.Pulse__c, Vital_Sign__r.Respirations__c, Vital_Sign__r.X02_Saturation__c from UtlizationReviewOrder__c where
                                            Utilization_Review__c =: UtilizationID AND Vital_Sign__c != null order by createdDate desc limit 1]){
            VitalAss = uro;
        }
    }
    
    public void UpdateVitals(){
        
        Recurring_Assessment__c tempRA = new Recurring_Assessment__c();
                    
        for(Recurring_Assessment__c ra : [Select ID,BP_Systolic__c,BP_Diastolic__c,Temperature__c,Pulse__c,Respirations__c,X02_Saturation__c from Recurring_Assessment__c where
                                        RecordType.Name = 'Vital Signs' AND Client_Chart__c =: ClientChartID  AND Status__c =: 'Closed' order by createdDate DESC LIMIT 1]){
            tempRA = ra;                                
        }
       
        system.debug('&&&ra' + tempRA);
        
        GetVitals();
        if(VitalAss == null){
            if(tempRA.id != null){
                VitalAss =  new UtlizationReviewOrder__c(Utilization_Review__c = UtilizationID , Vital_Sign__c = tempRA.ID, Vital_Sign__r = tempRA);
                if(!test.isRunningTest())
                insert VitalAss;    
            }
        }else{
            delete VitalAss;
            VitalAss =  new UtlizationReviewOrder__c(Utilization_Review__c = UtilizationID , Vital_Sign__c = tempRA.ID, Vital_Sign__r = tempRA);
            if(!test.isRunningTest())
            insert VitalAss;
        }
        system.debug('&&&ra' + VitalAss);
    }

    
    //COmmented As Part of Discussion of Jared, to remove Current Medication List on Utilization Review Forms.
    //We will be Updating this Logic in Phase 2, by auto populating the Latest Related Med Orders, and Providing Order View Popup on each of them.
    /*public void UpdateMedicationList(){
        if(!ListOfOrder.isEmpty()){
            delete ListOfOrder;
        }
        List<UtlizationReviewOrder__c> lstNewOrder = new List<UtlizationReviewOrder__c>();
        for(Order__c od : [Select ID from Order__c where Status__c = 'Active' AND Client_Chart__c =: ClientChartID ])
        {
            lstNewOrder.add( new UtlizationReviewOrder__c(Utilization_Review__c = UtilizationID , Order__c = od.ID));
        }
        
        if(!lstNewOrder.isEmpty()){
            insert lstNewOrder;
            GetUtlizationOrder();
            //UtilizationReview.Current_Date_Time__c = DateTime.Now();
        }
    }*/
    
    
    
        void CreateAttachmentFileName(){
        
         if(UtilizationReview.Attachment1_Id_URl__c!= null){
             
            
            AttachmentFileName .add(SubString(UtilizationReview.Attachment1_Id_URl__c)); 
        }
        
        if(UtilizationReview.Attachment2_Id_URl__c!= null){
            AttachmentFileName .add(SubString(UtilizationReview.Attachment2_Id_URl__c)); 
        
        }
        
        
        if(UtilizationReview.Attachment3_Id_URl__c!= null){
             AttachmentFileName .add(SubString(UtilizationReview.Attachment3_Id_URl__c)); 
        }
        
        if(UtilizationReview.Attachment4_Id_URl__c!= null){
             AttachmentFileName .add(SubString(UtilizationReview.Attachment4_Id_URl__c)); 
        }
        
        if(UtilizationReview.Attachment5_Id_URl__c!= null){
              AttachmentFileName .add(SubString(UtilizationReview.Attachment5_Id_URl__c)); 
        }
        
        if(UtilizationReview.Attachment6_Id_URl__c!= null){
            AttachmentFileName .add(SubString(UtilizationReview.Attachment6_Id_URl__c));  
        }
        
        if(UtilizationReview.Attachment7_Id_URl__c!= null){
              AttachmentFileName .add(SubString(UtilizationReview.Attachment7_Id_URl__c)); 
        }
        
        if(UtilizationReview.Attachment8_Id_URl__c!= null){
              AttachmentFileName .add(SubString(UtilizationReview.Attachment8_Id_URl__c)); 
        }
        
        if(UtilizationReview.Attachment9_Id_URl__c!= null){
             AttachmentFileName .add(SubString(UtilizationReview.Attachment9_Id_URl__c)); 
        }
        
        if(UtilizationReview.Attachment10_Id_URl__c!= null){
            AttachmentFileName .add(SubString(UtilizationReview.Attachment10_Id_URl__c)); 
        }
    }
    
    
        string SubString(String aUrl){
        
         integer lastIndexOf =aUrl.lastIndexOf('/');
          
          string subResult = aUrl.substring(lastIndexOf +1);
          subResult = subResult.replace('%',' ');
          return subResult;
    }
    
    
    public pageReference AddAttachment(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_UtiliReviewAttachments?id='+ UtilizationReview.ID+'&rtID='+rtID+'&rt='+rtype);
        return pr;
        
        
    }  
    
    
}