/*
Test class : groupConfigCtrlTest
*/
public class groupConfigDetailCtrl{
    
    public Group_Session_Configuration__c GrpSession { get;set;}
    
    public groupConfigDetailCtrl(){
        
        String GroupSessionId = ApexPages.currentPage().getParameters().get('ID');
        GrpSession  = new Group_Session_Configuration__c ();
        if(GroupSessionId  != null){
            GrpSession = [Select ID,Day_of_Week__c,End_Time__c,
                          Facility_Name__c,Group_Name__c,Facility_Name__r.Name,
                          Start_Time__c,Client_Track__c, House__c, Assigned_Group_Owner__c from Group_Session_Configuration__c
                          where ID =:GroupSessionId limit 1 ];
        }
    }
    
    public PageReference save(){
        
        
        upsert GrpSession;
        PageReference pageRef = new PageReference('/apex/GroupConfiguration');
        pageRef.getParameters().put('rt',ApexPages.currentPage().getParameters().get('rt'));
        return pageRef ;

        
    }
}