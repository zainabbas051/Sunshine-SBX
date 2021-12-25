@isTest
public class HCPDashboardControllerTest {
    static Medicine__c medi;
    static string frequency;
    static string freqQAM;
    static string freqQPM;
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
        
        Schema.DescribeFieldResult fieldResult = Order__c.Frequency__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            if(f.getLabel().startswith('TID'))
                frequency = f.getLabel();
            if(f.getLabel().startswith('QAM'))
                freqQAM = f.getLabel();
            if(f.getLabel().startswith('QPM'))
                freqQPM = f.getLabel();
        }
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
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         
         Order__c order = new Order__c();
         order.Client_Chart__c = cl.id;
         order.Status__c = 'Under Review';
         order.Order_Type__c = 'Manual';
         order.Start_Date__c = Datetime.now();
         order.Duration__c = 1;
         order.End_Date__c = Datetime.now().addDays(1);
         order.Order_By__c= UserInfo.getUserId();  
         order.Frequency__c = frequency ;
         order.Medicine__c = medi.id;
         insert order;
         
         Order__c order2 = new Order__c();
         order2.Client_Chart__c = cl.id;
         order2.Status__c = 'Active';
         order2.Order_Type__c = 'Manual';
         order2.Start_Date__c = Datetime.now();
         order2.Duration__c = 1;
         order2.End_Date__c = Datetime.now().addDays(1);
         order2.Order_By__c= UserInfo.getUserId();  
         order2.Frequency__c = frequency ;
         order2.Medicine__c = medi.id;
         insert order2;
         
         Order__c order3 = new Order__c();
         order3.Client_Chart__c = cl.id;
         order3.Status__c = 'Pending Pharmacy';
         order3.Order_Type__c = 'Manual';
         order3.Start_Date__c = Datetime.now();
         order3.Duration__c = 1;
         order3.End_Date__c = Datetime.now().addDays(1);
         order3.Order_By__c= UserInfo.getUserId();  
         order3.Frequency__c = frequency ;
         order3.Medicine__c = medi.id;
         insert order3;
         
         Test.setCurrentPageReference(Page.HCPDashboard);

         system.currentPageReference().getParameters().put('rt','Monarch Shores');
         
         HCPDashboardController hcp = new HCPDashboardController();
         List<SelectOption> selectOptionList = hcp.getCancelledViaList();
         
         hcp.pendingOrders[0].check = True;
         hcp.signWithSignature();
         hcp.showDiscontinueDetailsPickerPopup();
         
         hcp.activeOrders[0].check = True;
         hcp.discontinueOrders();
         
         PageReference pr1 = hcp.ShowOrderDetails();
         
         system.CurrentPageReference().getParameters().put('orderId',order2.id);
         
         PageReference pr2 = hcp.ViewOrder();
         
         test.stoptest();
    }
   
}