@isTest
public class TxDCHomePageControllerTest {
    
    public Static Profile adminProfile;
    
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US', Acess_Type__c='Admin');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
    
    static testMethod void TxdcController(){
        
         test.startTest();
          system.runAs(userAdmin){
             TabViews__c tv = new TabViews__c();
             tv.Name = 'TxDCPlans';
             tv.Button_Access_Type__c = 'Admin';
             insert tv;
             Account a = new Account();
             a.Name = 'Monarch Shores';
             a.Type = 'Internal Center';
             insert a;
             
             Client_Chart__c cl = new Client_Chart__c();
             cl.Treatment_Center__c = a.ID;
             cl.Primary_Therapist__c = UserINFO.getUserID();
             cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
             insert cl;
             
             List<Tx_and_D_C_Plans__c> lstTx = new List<Tx_and_D_C_Plans__c>();
             Id detoxID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Detox Treatment Plan').getRecordTypeId();
             Id dishchargeID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Discharge Plan').getRecordTypeId();
             
             Tx_and_D_C_Plans__c tx = new Tx_and_D_C_Plans__c();
             tx.Client_Chart__c = cl.ID;
             tx.RecordTypeID = dishchargeID;
             tx.Status__c = 'Open';
             insert tx;
             
             tx = new Tx_and_D_C_Plans__c();
             tx.Client_Chart__c = cl.ID;
             tx.RecordTypeID = detoxID;
             tx.Status__c = 'Open';
             insert tx;
             
             ApexPages.currentPage().getParameters().put('id',cl.id);
             
             TxDCHomePageController txdc = new TxDCHomePageController();
             Boolean Falg = txdc.buttonAccessType;
             PageReference pr = txdc.createLeavingAgainstRecord();
         }
         test.stopTest();
         
         
         
        
    }
}