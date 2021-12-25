/*
    controller class for clinicalnotes_acupunturemassage vf component. its a record type of 
    Clinical Notes object.
    @author: Huma Zafar
    test : ClinicalNotesDetailCtrlTest
*/
public with sharing class clinicalnotes_acupunturemassage {
    
    public Clinical_Note__c cNote{get;set;}
    public Client_Chart__c cc{get;set;}
     id noteId;
    public boolean EditPage{get;set;}
    public string rtype {get; set;}
    public User u {
        
        get {
            
            return [Select ID, UserName,Acess_Type__c, Has_Overwrite_Access__c FROM User where ID =: UserInfo.getUserId()];
        }
        
        set;
    }
    
    
     public boolean buttonAccessType{
        
        get {
     
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ClinicalNotes');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    public clinicalnotes_acupunturemassage(){
        
      noteId = ApexPages.CurrentPage().getParameters().get('clNID');
         EditPage =    (ApexPages.CurrentPage().getParameters().get('edit') != null)? true : false;
        rtype = ApexPages.CurrentPage().getParameters().get('rt') != null? ApexPages.CurrentPage().getParameters().get('rt'):'';
        cc = [select id, Treatment_Center__c, Name, SSN__c from Client_Chart__c 
            where id=: ApexPages.CurrentPage().getParameters().get('ID')];
            
                          
            cNote = [select id, Evaluation_Date__c, Acupuncture__c, Massage_Therapy__c, Headaches_tension__c,Start_Date_Time__c,End_Date_Time__c,
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
            Group_Description__c, Absent_Reason__c, Attendence__c
             from Clinical_Note__c where id=: noteId];
            
         
        
    }
 
     public Pagereference submit(){
        upsert cNote;
         PageReference pr = new PageReference('/apex/ClinicalNotesDetail');
            pr.getParameters().put('ID',cc.ID);
            pr.getParameters().put('clNID',noteId);
            pr.getParameters().put('rt',rtype);
            pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
            return pr;
    }
}