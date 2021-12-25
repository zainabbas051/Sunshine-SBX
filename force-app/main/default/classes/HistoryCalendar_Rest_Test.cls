@istest
public without sharing class HistoryCalendar_Rest_Test {
   


    public static testMethod void  Test1(){
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        insert appdet;
        
        Alumni_App_Sobriety_Checkin__c appSobriety = new Alumni_App_Sobriety_Checkin__c();
        appSobriety.name = 'test';
        appSobriety.Anxiety_Score__c = '1'; 
        appSobriety.Cravings_Score__c = '1';
        appSobriety.Depression_Score__c = '1';
        appSobriety.Feeling_Today__c = 'Fine'; 
        appSobriety.Notes__c =  '1';
        appSobriety.Sobriety_Checkin_Date__c = date.today().addDays(2);
        appSobriety.Alumni_App_Detail__c = appdet.id;
        insert appSobriety;
        System.debug('@appSobriety'+appSobriety);

        date dt = Date.today();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/history_page_calender';
        req.addParameter('id',appdet.id);
        req.addParameter('interval','10');
        req.addParameter('startDate',string.valueOf(dt));
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        HistoryCalendar_Rest.SobrietyCheckIn wrap = new HistoryCalendar_Rest.SobrietyCheckIn(appSobriety);
        HistoryCalendar_Rest.getSobrietyHistroy();

        Test.stopTest();  
    
    }


    public static testMethod void  Test2(){
    
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        insert appdet;
        
        Alumni_App_Sobriety_Checkin__c appSobriety = new Alumni_App_Sobriety_Checkin__c();
        appSobriety.name = 'test';
        appSobriety.Anxiety_Score__c = '1'; 
        appSobriety.Cravings_Score__c = '1';
        appSobriety.Depression_Score__c = '1';
        appSobriety.Feeling_Today__c = 'Fine'; 
        appSobriety.Notes__c =  '1';
        appSobriety.Alumni_App_Detail__c = appdet.id;
        insert appSobriety;
        
        date dt = Date.today();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/history_page_calender';
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
        HistoryCalendar_Rest.getSobrietyHistroy();

        Test.stopTest();  
    
    }

    public static testMethod void  Test3(){
    
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        insert appdet;
        
        Alumni_App_Sobriety_Checkin__c appSobriety = new Alumni_App_Sobriety_Checkin__c();
        appSobriety.name = 'test';
        appSobriety.Anxiety_Score__c = '1'; 
        appSobriety.Cravings_Score__c = '1';
        appSobriety.Depression_Score__c = '1';
        appSobriety.Feeling_Today__c = 'Fine'; 
        appSobriety.Notes__c =  '1';
        appSobriety.Alumni_App_Detail__c = appdet.id;
        insert appSobriety;
        
        date dt = Date.today();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/history_page_calender';
        req.addParameter('id',appdet.id);
        req.addParameter('interval','10');
        req.addParameter('startDate','invaliddate');
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
        HistoryCalendar_Rest.getSobrietyHistroy();

        Test.stopTest();  
    
    }
}