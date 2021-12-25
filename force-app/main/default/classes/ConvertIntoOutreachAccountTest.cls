@isTest
public  class ConvertIntoOutreachAccountTest{
    
    static testmethod void ConvertIntoOutreachAccount(){
        
        test.startTest();
        User u = [Select id from User where isActive =: True AND Profile.Name =: 'System Administrator' LIMIT 1];
        system.runAs(u){
            OUTREACH_REQUEST__c outReq = new OUTREACH_REQUEST__c();
            outReq.Prospect_URL__c = 'www.google.com';
            outReq.Category__c = 'State';
            outReq.Contact_Email_Address__c = 'chugh.naveen@gmail.com';
            outReq.Contact_Phone_Number__c = '5863424795';
            outReq.Email_Address_Used_to_Initiate_Contact__c = 'chugh.naveen@gmail.com';
            outReq.Sub_Category__c = 'Michigan';
            outReq.AssignedSEO__c = u.id;
            insert outReq;
            
            ConvertIntoOutreachAccount.ConvertIntoOutreachAccount(outReq.id);
        }
        test.stoptest();
    }
}