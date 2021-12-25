@isTest
public class medicinesPDFControllerTest {
    static Medicine__c medi;
    static{
        awsBucket__c aws = new awsBucket__c();
        aws.accessKeyId__c =  'AKIAIKHBOKKMOFRNX5XQ';
        aws.secretAccessKey__c = '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';
        aws.Bucket__c = 'freepu';
        aws.Name = 'FREEPU';
        insert aws;
        
        FrequencyMapping__c FreqMapping = new FrequencyMapping__c();
        FreqMapping.Name = 'TID';
        FreqMapping.Count__c = 3;
        FreqMapping.Interval__c = 2;
        FreqMapping.Missed__c =2;
        FreqMapping.Time__c = '6,12,18';
        FreqMapping.Hide_Button__c = 10;
        insert FreqMapping;
        
        FrequencyMapping__c FreqMapping2 = new FrequencyMapping__c();
        FreqMapping2.Name = 'Q8 Hours';
        FreqMapping2.Count__c = 3;
        FreqMapping2.Interval__c = 2;
        FreqMapping2.Missed__c =2;
        FreqMapping2.Time__c = '6,12,18';
        FreqMapping2.Hide_Button__c = 10;
        insert FreqMapping2;
        
        medi = new Medicine__c();
         medi.Name= 'test';
         insert medi;
        
        Sunshine_Center_Id__c sc = new Sunshine_Center_Id__c();
        sc.Name ='Monarch Shores';
        SC.Health_Care_Practitioner_Role_ID__c = [select id from UserRole where name like '%Health care%'].id;
        insert sc;
    }
    //test method for medshomepagecontroller
    static testMethod void MedsHomePageController(){
    
         test.startTest();
                  
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Contact c = new Contact();
         c.AccountId = a.id;
         c.FirstName = 'Pharmacy';
         c.LastName = 'Contact';
         c.Email = 'chugh.naveen@gmail.com';
         insert c;
         
         Taper__c prn = new Taper__c();
         prn.name = 'test';
         prn.Active__c = true;
         prn.Number_of_Days__c = 3;
         prn.Protocol__c = 'Detox Protocol';
         prn.dosage_type__c = 'Open Ended';
         insert prn;
         
         Taper_Line_Item__c tliprn = new Taper_Line_Item__c();
         tliprn.taper__c = prn.id;
         tliprn.medicine__c = medi.id;
         tliprn.Route__c = 'PO - By Mouth';
         tliprn.Strength__c = '10mg';
         tliprn.Frequency__c = 'Q8 Hours : Every 8 Hours';
         tliprn.Duration_in_Days__c =1;
         insert tliprn;
         
         Taper_Line_Item__c tliprn2 = new Taper_Line_Item__c();
         tliprn2.taper__c = prn.id;
         tliprn2.medicine__c = medi.id;
         tliprn2.Route__c = 'PO - By Mouth';
         tliprn2.Strength__c = '10mg';
         tliprn2.Frequency__c = 'TID : three times a day at 6AM, 12PM, and 9PM (to be taken at minimum 6 hour intervals)';
         tliprn2.Duration_in_Days__c =2;
         insert tliprn2;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         Test.setCurrentPageReference(Page.MedsHomePage);

         System.currentPageReference().getParameters().put('id', cl.id);
         system.currentPageReference().getParameters().put('rt','Monarch Shores;Chapters Capistrano;Willowsprings Recovery');
         
         
         
         Order__c order = new Order__c();
         order.Client_Chart__c = cl.id;
         order.Status__c = 'Active';
         order.Order_Type__c = 'Standard - Taper';
         order.Start_Date__c = Datetime.now();
         order.Duration__c = 1;
         order.End_Date__c = Datetime.now().addDays(1);
         order.Order_By__c= UserInfo.getUserId();  
         order.Frequency__c = 'TID : three times a day at 6AM, 12PM, and 9PM (to be taken at minimum 6 hour intervals)';
         order.Medicine__c = medi.id;
         order.Taper__c = prn.id;
         insert order;
         
         Order_Line_Item__c abc = new Order_Line_Item__c ();
         abc.Order__c = order.id;
         abc.medicine__c = medi.id;
         abc.Route__c = 'PO - By Mouth';
         abc.Dose__c = '10mg';
         abc.Frequency__c = 'Q8 Hours : Every 8 Hours';
         abc.Day__c =1;
         insert abc;
         
         Order_Line_Item__c abc2 = new Order_Line_Item__c ();
         abc2.Order__c = order.id;
         abc2.medicine__c = medi.id;
         abc2.Route__c = 'PO - By Mouth';
         abc2.Dose__c = '10mg';
         abc2.Frequency__c = 'TID : three times a day at 6AM, 12PM, and 9PM (to be taken at minimum 6 hour intervals)';
         abc2.Day__c =2;
         insert abc2;
         
         
         ApexPages.CurrentPage().getParameters().Put('orderId',order.id);
         
         medicinesPDFController med_pdf = new medicinesPDFController();      
         
         Order__c order_man = new Order__c();
         order_man.Client_Chart__c = cl.id;
         order_man.Status__c = 'Active';
         order_man.Order_Type__c = 'Manual';
         order_man.Start_Date__c = Datetime.now();
         order_man.Duration__c = 1;
         order_man.End_Date__c = Datetime.now().addDays(1);
         order_man.Order_By__c= UserInfo.getUserId();  
         order_man.Frequency__c = 'TID : three times a day at 6AM, 12PM, and 9PM (to be taken at minimum 6 hour intervals)';
         order_man.Medicine__c = medi.id;
         insert order_man;
         
         ApexPages.CurrentPage().getParameters().Put('orderId',order_man.id);
         
         medicinesPDFController med_pdf_man = new medicinesPDFController();    
         
         test.stoptest();
    }
    
}