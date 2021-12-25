@isTest
public  class OutreachRequestAssignmentCtrlTest{
    
    static testmethod void OutreachRequestAssignmentCtrlTest(){
        
        test.startTest();
        User u = [Select id from User where isActive =: True AND Profile.Name =: 'System Administrator' LIMIT 1];
        user urpof=[SELECT Id, Name, IsActive, ProfileId FROM User where IsActive=true and Profile.Name =: 'Digital Marketing - Outreach Associate' LIMIT 1];
        system.runAs(u){
            OUTREACH_REQUEST__c outReq = new OUTREACH_REQUEST__c();
            outReq.Prospect_URL__c = 'www.google.com';
            outReq.Category__c = 'State';
            outReq.Contact_Email_Address__c = 'chugh.naveen@gmail.com';
            outReq.Contact_Phone_Number__c = '5863424795';
            outReq.Email_Address_Used_to_Initiate_Contact__c = 'chugh.naveen@gmail.com';
            outReq.Sub_Category__c = 'Michigan';
            outReq.AssignedSEO__c = u.id;
            outReq.ownerID=Label.Outreach_Queue_ID;
            insert outReq;
            
            OutreachRequestAssignmentCtrl OutReachInsCtrl= new OutreachRequestAssignmentCtrl();
            integer testval;
            OutReachInsCtrl.clickMe();

            testVal=OutReachInsCtrl.pageNumber;
            List<SelectOption> LstMarketinguser=OutReachInsCtrl.DigitalMarketingUsers;
             OutReachInsCtrl.digitalUserIDvalue=urpof.id;
             list<OUTREACH_REQUEST__c> lstIns = new list<OUTREACH_REQUEST__c>( );
             
             OutReachInsCtrl.selectedList =lstIns;
              OutReachInsCtrl.clickMe();
            OutReachInsCtrl.searchKeywords();
            OutReachInsCtrl.searchValue='test';
                        OutReachInsCtrl.searchKeywords();


        }
        test.stoptest();
    }
}