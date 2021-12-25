@IsTest
private class AllBedInfo_Test {
    public Static testmethod void AllBedInfo_Testmethod()
    {
        Test.startTest();
        PrepareData();
        Test.stopTest();
    }
    
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
    
    public static void PrepareData(){
        
        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;
        
        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;
        
        TabViews__c tv = new TabViews__c();
         tv.Name = 'BedBoardConfiguration';
         tv.Button_Access_Type__c = 'Admin';
         insert tv;
        
        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Willowsprings Recovery';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Pre Admission';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert ClientID;
        
        Account sunshine = new Account();
        sunshine.Name = 'Willowsprings Recovery';
        insert sunshine;
        
        Bed_Board_Configuration__c house = new Bed_Board_Configuration__c();
        house.House_Name__c = 'House 1';
        house.Sunshine_Center__c = sunshine.Id;
        insert house;
        
        Bed_Board_Configuration__c room = new Bed_Board_Configuration__c();
        room.House__c = house.Id;
        room.Room_Number__c = 'room 1';
        insert room;
        
        Bed_Board_Configuration__c bed = new Bed_Board_Configuration__c();
        bed.Room__c = room.Id;
        bed.Bed_Number__c = 'bed 1';
        insert bed;
        
        system.runAs(userAdmin){
            ApexPages.currentPage().getParameters().put('rt', 'Willowsprings Recovery');
            
            AllBedInfo abi = new AllBedInfo();
            abi.addNewHouse();
            abi.saveNewHouse();
            abi.Edit();
            Boolean Flag = abi.buttonAccessType;
        }
        
    }
}