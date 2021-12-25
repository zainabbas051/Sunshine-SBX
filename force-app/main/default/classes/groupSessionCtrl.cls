/*
Test class : groupSessionCtrlTest
*/
public class groupSessionCtrl{
    
    public List<Group_Therapy_Session__c> lstGroupSessnOpen { get; set;}
    public List<Group_Therapy_Session__c> lstGroupSessnComplt { get;set;}
    public List<Group_Therapy_Session__c> lstGroupSessnPast { get;set;}
    public List<Group_Therapy_Session__c> lstGroupSessnPending { get;set;}
    public ID statusRecordID {get;set;}
    Date TodayDate; 
    public ID UserID { get;set;}
    public string todayDateFormat { get ;set;}
   
    
    public groupSessionCtrl(){
      
   
      TodayDate  = date.today();
      UserID = UserInfo.getUserId();
      todayDateFormat   = DateTime.newInstance(TodayDate.year(),TodayDate.month(),TodayDate.day()).format('MMMM dd,YYYY');
      GetCurrentData();
      GetPastData();
     
     // todayDateFormat = Date.Today().format('YYYY-MM-DD');
    }
    
    void GetCurrentData(){
        
        
        string recordTypeName = apexpages.currentpage().getparameters().get('rt');
        lstGroupSessnOpen = new List<Group_Therapy_Session__c>();
        lstGroupSessnComplt = new List<Group_Therapy_Session__c>();
        lstGroupSessnPending = new List<Group_Therapy_Session__c>();
        for(Group_Therapy_Session__c grp: [Select ID, Name,OwnerID,Owner.Name,Programme_Name__c,Manager_ID__c ,Rehab_Facility__c,End_Time__c,
                                            Status__c,Start_Time__c,Date__c,Facility_Schedule__c,Group_Leader__c, House__c, House__r.Name
                                            from Group_Therapy_Session__c where Date__c =: TodayDate AND Rehab_Facility__r.Name =: recordTypeName  ]){
                                                
            
            if(grp.Status__c == 'Open')
                lstGroupSessnOpen.add(grp);
            
            if(grp.Status__c == 'Completed' || grp.Status__c == 'In-Progress')
                lstGroupSessnComplt.add(grp);
                
             if(grp.Status__c == 'Pending Review')
                lstGroupSessnPending.add(grp);
        }
    }
    
    
    void GetPastData(){
        
        lstGroupSessnPast = new List<Group_Therapy_Session__c>();
       
        for(Group_Therapy_Session__c grp: [Select ID, Name,OwnerID,Owner.Name,Programme_Name__c,Rehab_Facility__c,End_Time__c,
                                            Status__c,Start_Time__c,Date__c,Facility_Schedule__c,Group_Leader__c, House__c, House__r.Name
                                            from Group_Therapy_Session__c where Date__c <: TodayDate  ]){
                                                
                lstGroupSessnPast.add(grp);
        }
    }
    
    public PageReference ChangeStatus(){
        
        system.debug('test@@@' + statusRecordID);
        Group_Therapy_Session__c grp =  [Select ID,Status__c, House__c, Client_Track__c, Start_Time__c, End_Time__c, Date__c from Group_Therapy_Session__c where ID =: statusRecordID limit 1];
        system.debug('test@@@' + grp);
        grp.Status__c = 'In-Progress';
        update grp;
        
        list < Group_Therapy_Session__c > lstCreateGroupTherapySessions = new list < Group_Therapy_Session__c > ();
        lstCreateGroupTherapySessions.add(grp);
        if(grp.Client_Track__c != null){
            List < Client_Chart__c > lstClientChrt = [Select ID, Track_Post_Detox__c from Client_Chart__c where Track_Post_Detox__c =: grp.Client_Track__c];
            if (!lstClientChrt.isEmpty())
                groupTheraphyBatch_Handler.CreateClientByClientTrack(lstClientChrt, lstCreateGroupTherapySessions);
        }
        if(grp.House__c != null){
            List < UtlizationReviewOrder__c > lstUtilizationReview = [Select Client_Chart__c,
            Bed__c, Bed__r.Room__r.House__c, Bed__r.House_Name__c from UtlizationReviewOrder__c
            where Bed__r.Room__r.House__c =: grp.House__c AND Status__c =: 'Active'
            		AND Client_Chart__r.Client_Status__c = 'Admitted']; // Adding a filter requested by Naveen to get only Admitted Clients - Zain
        
            system.debug('$$$$$$' + lstUtilizationReview);

            if (!lstUtilizationReview.isEmpty())
                groupTheraphyBatch_Handler.CreateClientByHouse(lstUtilizationReview, lstCreateGroupTherapySessions);
        }
        
        PageReference pr = new PageReference('/apex/SessionGroupDetail');
        pr.getParameters().put('Id',statusRecordID);
        pr.getParameters().put('rt',apexpages.currentpage().getparameters().get('rt'));
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;
       // GetCurrentData();
       
    }
    
    
    
    public void ChangeOwner(){
        
        Group_Therapy_Session__c grp =  [Select ID,OwnerID from Group_Therapy_Session__c where ID =: statusRecordID limit 1];
        grp.OwnerID = UserID;
        grp.Group_Claimed_Date_Time__c = DateTime.Now();
        update grp;
        GetCurrentData();
        
        
    }
}