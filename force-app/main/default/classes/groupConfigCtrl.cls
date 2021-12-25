/*
Test class : groupConfigCtrlTest
*/
public class groupConfigCtrl{
    
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ConfigurationTab');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    
    
    List<Group_Session_Configuration__c> lstGroupSession { get;set;}
    public List<Group_Session_Configuration__c> lstGroupSessionWillowRecovery { get;set;}
    public List<Group_Session_Configuration__c> lstGroupSessionMonarchShores { get;set;}
    public List<Group_Session_Configuration__c> lstGroupSessionChaptersCapistrano { get;set;}
    
    public groupConfigCtrl(){
        
        lstGroupSession  = new List<Group_Session_Configuration__c>();
        lstGroupSessionWillowRecovery = new List<Group_Session_Configuration__c>();
        lstGroupSessionMonarchShores = new List<Group_Session_Configuration__c>();
        lstGroupSessionChaptersCapistrano = new List<Group_Session_Configuration__c>();
        
        lstGroupSession  = [Select ID,Day_of_Week__c,End_Time__c,House__c, House__r.Name, House__r.House_Name__c,
                            Facility_Name__c,Facility_Name__r.Name,Group_Name__c,
                            Start_Time__c,Client_Track__c, Assigned_Group_Owner__c, Assigned_Group_Owner__r.Name from Group_Session_Configuration__c];
        
        for(Group_Session_Configuration__c grp : lstGroupSession ){
            
            if(grp.Facility_Name__r.Name == 'Willowsprings Recovery') 
                lstGroupSessionWillowRecovery.add(grp);
            
            else if(grp.Facility_Name__r.Name == 'Monarch Shores') 
                lstGroupSessionMonarchShores.add(grp);
            
            else if(grp.Facility_Name__r.Name == 'Chapters Capistrano') 
                lstGroupSessionChaptersCapistrano.add(grp);
            
            
        }
    }
}