//Test Class : ClinicalNotesDetailAllCtrlTest
public class ClinicalNotesAll_Ctrl {
    
    
   public transient List<Clinical_Note__c> lstClinicalNotes { get;set;}
   public string ClientChartID { get;set;}
   public User u {get;set;}
   public string currentRec {get;set;}
   public string page_y {get;set;}
   public Clinical_Note__c cl {get;set;}
    
    public ClinicalNotesAll_Ctrl(){
        
       
      u = [Select ID ,Has_Overwrite_Access__c from User where ID =: UserInfo.getUserId()];
       page_y = ApexPages.CurrentPage().getParameters().get('page_y');
       currentRec = null;
      
      if(ApexPages.CurrentPage().getParameters().get('CurrentRec') != null){
          
          currentRec = ApexPages.CurrentPage().getParameters().get('CurrentRec');
          FetchEditRecord();
          
      }
    
                
    }
    
    void FetchEditRecord(){
        
       cl = GetClinialNotes();
       //cl.Other_Type_of_Session__c = 'sdasd asd asdas dasd asda sdasd ';
    }
    
    
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(string.isBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ClinicalNotes');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    public void GetRecord(){
        
         ID clID =  ApexPages.CurrentPage().getParameters().get('ID');
         ClientChartID =  ApexPages.CurrentPage().getParameters().get('ID');
        lstClinicalNotes = [ select id, Evaluation_Date__c, Acupuncture__c, Massage_Therapy__c,RecordType.DeveloperName, Headaches_tension__c,Start_Date_Time__c,End_Date_Time__c,
            Thoracic_Outlet_Syndrome__c, Carpal_Tunnel_Syndrome__c, Juvenile_rheumatoid_arthritis__c,
            Osteoarthritis__c, Shoulder_Pain__c, Arthritis_NOS__c, Elbow_Pain__c, Wrist_Pain__c, Hip_Pain__c,
            Knee_Pain__c, Joint_pain_multiple_areas__c, Joint_stiffness__c, Knee_stiffness__c, Displacement_of_thoracic__c,
            Cervicalgia_neck_pain__c, Radiculitis__c, Neck_stiffness__c, Thoracic_pain__c, Lumbar_back_pain__c,
            Thoracic_radiculitis__c, Back_pain_unspecified__c, Frozen_Shoulder__c, Disorder_of_bursae__c,
            Elbow_tendinitis__c, Spasm_of_muscle__c, Cervical_and_thoracic_Myalgia__c, Facitis_NOS__c,
            Leg_Foot_pain__c, Cramp__c, Fatigue__c, Headache_pain__c, Cervical_subluxation__c, Forearm_injury_unspecified__c,
            Wrist_injury__c, Back_strain_sacroiliac_chronic__c, Sprain_Strain_of_other__c, Shoulder_an_upper_arm_blade__c,
            Wrist__c, IIiofemoral__c, Hamstring__c, Ankle_Foot__c, Thoracic__c, Lumbar__c, Lumbosacral__c,
            Sacroiliac__c, Notes__c  ,Status__c,Group_Name__c ,Start_Time__c ,CreatedBy.Name,Date__c ,End_Time__c ,Duration__c, Attendant__c,
            Group_Description__c, Attendence__c,Absent_Reason__c, Aggressive__c, Agitated__c, Alert__c, Angry__c, Anxious__c, 
            Appropriate__c, Assertive__c, Attended__c, Attention_Seeking__c, Blunted__c, Calm__c, Circumstantial__c, 
            Client_Chart__c, Delusions__c, Dissociated__c, Euphoric__c, 
            Flat__c, Flight_of_Ideas__c, GrandioseInstigating__c, Hallucinations__c, High__c, Hostile__c, 
            Inappropriate__c, In_Denial__c, Individual__c, Insightful__c, Isolative__c, Labile__c, Loose_Association__c,
            Other_Behaviors__c, Other_Mood__c,
            Other_Type_of_Session__c, Paranoid__c, Progress_noted__c, Progress_Note_Type__c, Refused__c, Resistive__c, 
            Restless__c, Low__c,Nursing_Progress_Comments__c,Unkempt__c,Motivated__c,Somatic__c,Secretive__c,Manipulative__c,Withdrawn__c,Sad_tearful__c,
            Oriented__c ,Tangential__c ,Disorganized__c,Other__c ,Medium__c,Progress_Noted_PL__c,Client_Image_Url__c,Client_Closed_Date__c,Signature_URL__c,Staff_Signed_User__c,
            Staff_Closed_Date__c,Intern_Signature_URL__c,Intern_Signed_User__c,Intern_Closed_Date__c
             from Clinical_Note__c where Client_Chart__c =: clID order by Start_Date_Time__c ];
    }
    
    public PageReference Submit(){
        
        /*Clinical_Note__c Cl;
        system.debug('test');
          system.debug('test***' + lstClinicalNotes);
        
        /*Clinical_Note__c CL = GetClinialNotes();
         update CL;*/
     /*    integer i = 0;
        for(Clinical_Note__c iCl : lstClinicalNotes){
            
            if(iCl.ID == currentRec){
                 Cl = lstClinicalNotes.get(i); 
                 break;
                
            }
               
            
            i++;
        }
        
         
        update Cl;*/
       
        update cl;
         
       
        PageReference pr = new PageReference('/apex/ClinicalNotesViewAll');
        pr.getParameters().put('ID',ClientChartID);
        pr.getParameters().put('page_y',page_y);
          
            pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
            return pr;   
               
        
        
    }
        public List<SelectOption> getProgressNoted(){
        
        Schema.sObjectType sobject_type = Clinical_Note__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Progress_Noted_PL__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    
    Clinical_Note__c GetClinialNotes(){
            
            return [select id, Evaluation_Date__c, Acupuncture__c, Massage_Therapy__c,RecordType.DeveloperName, Headaches_tension__c,Start_Date_Time__c,End_Date_Time__c,
            Thoracic_Outlet_Syndrome__c, Carpal_Tunnel_Syndrome__c, Juvenile_rheumatoid_arthritis__c,
            Osteoarthritis__c, Shoulder_Pain__c, Arthritis_NOS__c, Elbow_Pain__c, Wrist_Pain__c, Hip_Pain__c,
            Knee_Pain__c, Joint_pain_multiple_areas__c, Joint_stiffness__c, Knee_stiffness__c, Displacement_of_thoracic__c,
            Cervicalgia_neck_pain__c, Radiculitis__c, Neck_stiffness__c, Thoracic_pain__c, Lumbar_back_pain__c,
            Thoracic_radiculitis__c, Back_pain_unspecified__c, Frozen_Shoulder__c, Disorder_of_bursae__c,
            Elbow_tendinitis__c, Spasm_of_muscle__c, Cervical_and_thoracic_Myalgia__c, Facitis_NOS__c,
            Leg_Foot_pain__c, Cramp__c, Fatigue__c, Headache_pain__c, Cervical_subluxation__c, Forearm_injury_unspecified__c,
            Wrist_injury__c, Back_strain_sacroiliac_chronic__c, Sprain_Strain_of_other__c, Shoulder_an_upper_arm_blade__c,
            Wrist__c, IIiofemoral__c, Hamstring__c, Ankle_Foot__c, Thoracic__c, Lumbar__c, Lumbosacral__c,
            Sacroiliac__c, Notes__c  ,Status__c,Group_Name__c ,Start_Time__c ,CreatedBy.Name,Date__c ,End_Time__c ,Duration__c, Attendant__c,
            Group_Description__c, Attendence__c,Absent_Reason__c, Aggressive__c, Agitated__c, Alert__c, Angry__c, Anxious__c, 
            Appropriate__c, Assertive__c, Attended__c, Attention_Seeking__c, Blunted__c, Calm__c, Circumstantial__c, 
            Client_Chart__c, Delusions__c, Dissociated__c, Euphoric__c, 
            Flat__c, Flight_of_Ideas__c, GrandioseInstigating__c, Hallucinations__c, High__c, Hostile__c, 
            Inappropriate__c, In_Denial__c, Individual__c, Insightful__c, Isolative__c, Labile__c, Loose_Association__c,
            Other_Behaviors__c, Other_Mood__c,
            Other_Type_of_Session__c, Paranoid__c, Progress_noted__c, Progress_Note_Type__c, Refused__c, Resistive__c, 
            Restless__c, Low__c,Nursing_Progress_Comments__c,Unkempt__c,Motivated__c,Somatic__c,Secretive__c,Manipulative__c,Withdrawn__c,Sad_tearful__c,
            Oriented__c ,Tangential__c ,Disorganized__c,Other__c ,Medium__c,Progress_Noted_PL__c,Client_Image_Url__c,Client_Closed_Date__c,Signature_URL__c,Staff_Signed_User__c,
            Staff_Closed_Date__c,Intern_Signature_URL__c,Intern_Signed_User__c,Intern_Closed_Date__c
             from Clinical_Note__c where ID =: currentRec];
        
    }
        
       

}