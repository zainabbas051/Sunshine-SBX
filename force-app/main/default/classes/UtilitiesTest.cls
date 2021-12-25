@isTest()
private class UtilitiesTest {

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
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
    
    public Static testmethod void smsAndEmailTest(){
        Profile adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
        user user1 = [SELECT id,email,MobilePhone FROM user where isActive=:True and ProfileId =: adminProfile.Id LIMIT 1];
        Map<String,String> map2= New Map<String,String>();
        Map<String,Map<String,String>> map3 = New Map<String,Map<String,String>>();
        Map<String,String> map1= New Map<String,String>();
        Map<id,List<String>> map4 = new map<Id,List<String>>();
        List<String> stringList = new List<String>();
        stringList.add('test');
        map1.put(user1.id,'subject1');
        map2.put('subject','body');
        map3.put(user1.id,map2);
        map4.put(user1.id,stringList);
        test.startTest();
        
        Utilities.sendSMS(map1);
        Utilities.sendEmail(map3);
        Utilities.sendSMS2(map4);
        
        Utilities.sendJSONEmail('testString');
        createSampleData();
        List<Utilities.InvokableParams> ips= new List<Utilities.InvokableParams>();
        
        Utilities.InvokableParams ip= new Utilities.InvokableParams();
        ip.OppID=oms.ID;
        ip.SMSBody='test123';
        ip.OppName=oms.Name;
        ip.OppPhoneNumber=oms.Incoming_Number__c;
        ips.add(ip);
        Utilities.sendSMSDrip(ips);
        test.stopTest();
    
    }
    Public static Account a;
    Public static Account SunshineCenter;
    Public static Opportunity oms;
     public Static void createSampleData(){
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        SunshineCenter = new Account();
        SunshineCenter.Name = 'Chapters Capistrano';
        SunshineCenter.Type = 'Internal Center';
        insert SunshineCenter;
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Sunshine_Center__c = SunshineCenter.id;
        oms.KIPU_MRN__c = 'CC2019-10';
        oms.Incoming_Number__c='12345688999';
        insert oms;
        
          
        
     } 
    
}