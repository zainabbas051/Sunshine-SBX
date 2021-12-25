@IsTest
private class ClientCtrl_Test {
    public static testmethod void ClientCtrl_Test(){
        Test.startTest();
        PrepareData();
        Test.stopTest();
    }
    
    public static testmethod void ClientCtrl_Test_NORT(){
        Test.startTest();
        PrepareDataWithoutRT();
        Test.stopTest();
    }
    public static void PrepareData(){
        Datetime now = DateTime.now();
        
        Account a = new Account();
         a.Name = 'Chapters Capistrano';
         a.Type = 'Internal Center';
         insert a;
        
        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.name = a.Name;
        scid.Account_id__c = a.id;
        scid.House_Based_Selection__c = True;
        scid.Requires_Admit_Order__c = False;
        insert scid;
        
        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Willowsprings Recovery';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Pre Admission';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        ClientID.Admit_Date_Time__c = now;
        Insert ClientID;
        
        Client_Chart__c tomorrowClient = new Client_Chart__c();
        tomorrowClient.Name = 'Willowsprings Recovery';
        tomorrowClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        tomorrowClient.Client_Status__c = 'Pre Admission';
        tomorrowClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        tomorrowClient.Admit_Date_Time__c = now.addDays(1);
        Insert tomorrowClient;
        
        Client_Chart__c YesterdayClient = new Client_Chart__c();
        YesterdayClient.Name = 'Willowsprings Recovery';
        YesterdayClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        YesterdayClient.Client_Status__c = 'Pre Admission';
        YesterdayClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        YesterdayClient.Admit_Date_Time__c = now.addDays(1);
        Insert YesterdayClient;
        
        Client_Chart__c AdmittedClient = new Client_Chart__c();
        AdmittedClient.Name = 'Test Client';
        AdmittedClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        AdmittedClient.Client_Status__c = 'Admitted';
        AdmittedClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        AdmittedClient.Admit_Date_Time__c = now;
        Insert AdmittedClient;  
        
        Client_Chart__c DisTodayClient = new Client_Chart__c();
        DisTodayClient.Name = 'Test Client';
        DisTodayClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        DisTodayClient.Client_Status__c = 'Admitted';
        DisTodayClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        DisTodayClient.Discharge_Date_Time__c = now;
        DisTodayClient.Admit_Date_Time__c = now.addDays(-1);
        Insert DisTodayClient;  
        
        Client_Chart__c DisTomClient = new Client_Chart__c();
        DisTomClient.Name = 'Test Client';
        DisTomClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        DisTomClient.Client_Status__c = 'Admitted';
        DisTomClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        DisTomClient.Discharge_Date_Time__c = now.addDays(1);
        DisTomClient.Admit_Date_Time__c = now.addDays(-1);
        Insert DisTomClient;  
        
        
        Client_Chart__c ResidentialClient = new Client_Chart__c();
        ResidentialClient.Name = 'Test Client';
        ResidentialClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ResidentialClient.Program__c = 'Residential';
        ResidentialClient.U_R_Location__c = 'Residential';
        ResidentialClient.Track_Post_Detox__c = 'Blue Track';
        ResidentialClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        Insert ResidentialClient;  
        
        Client_Chart__c DetoxClient = new Client_Chart__c();
        DetoxClient.Name = 'Test Client';
        DetoxClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        DetoxClient.Program__c = 'Detox';
        DetoxClient.Track_Post_Detox__c = 'Green Track';
        DetoxClient.U_R_Location__c = 'Detox';
        
        DetoxClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        Insert DetoxClient; 
        
        Client_Chart__c PHPClient = new Client_Chart__c();
        PHPClient.Name = 'Test Client';
        PHPClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        PHPClient.Program__c = 'PHP';
        PHPClient.U_R_Location__c = 'PHP';
        PHPClient.Track_Post_Detox__c = 'Orange Track';
        PHPClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        Insert PHPClient; 
        
        Client_Chart__c IOPClient = new Client_Chart__c();
        IOPClient.Name = 'Test Client';
        IOPClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        IOPClient.Program__c = 'IOP';
        IOPClient.U_R_Location__c = 'IOP';
        IOPClient.Track_Post_Detox__c = 'Purple Track';
        IOPClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        Insert IOPClient; 
        
        Client_Chart__c OPClient = new Client_Chart__c();
        OPClient.Name = 'Test Client';
        OPClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        OPClient.Program__c = 'OP';
        OPClient.U_R_Location__c = 'OP';
        OPClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        Insert OPClient; 
        
        Client_Chart__c AllClient = new Client_Chart__c();
        AllClient.Name = 'Test Client';
        AllClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        AllClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Chapters Capistrano').getRecordTypeId();
        Insert AllClient; 
        
        
        
        
        Bed_Board_Configuration__c bbc_house = new Bed_Board_Configuration__c();
        bbc_house.House_Name__c = 'La Cuesta';
        bbc_house.Sunshine_Center__c = a.id;
        insert bbc_house;
        
        Bed_Board_Configuration__c bbc_room = new Bed_Board_Configuration__c();
        bbc_room.Room_Number__c = '1';
        bbc_room.House__c = bbc_house.id;
        bbc_room.Sunshine_Center__c = a.id;
        insert bbc_room;
        //Discharge_Date_Time__c
            
        ApexPages.currentPage().getParameters().put('rt', 'Chapters Capistrano');
        
        ClientCtrl cc = new ClientCtrl();
        Date thisday = System.today();
        
        cc.ArrStDt = thisday.addDays(-1);
        cc.ArrEndDt = thisday.addDays(+1);
        cc.DisStDt = thisday.addDays(-1);
        cc.DisEndStDt = thisday.addDays(+1);
        
        cc.getClientPreAddmission();
        cc.getClientAdmitted();
        cc.getClientArrivingToday();
        cc.getClientArrivingTomorrow();   
        cc.getClientDischargingToday();  
        cc.getClientDischargingTomorrow();  
        cc.getClientOnArrivDateRng();
        cc.getClientOnDisDateRng();
        cc.getClientOnPrograms();
        
        cc.PrgString = 'Residential';
        cc.URLocString = 'Residential';
        cc.TrackString = 'Blue Track';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.PrgString = 'Detox';
        cc.URLocString = 'Detox';
        cc.TrackString = 'Green Track';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.PrgString = 'PHP';
        cc.URLocString = 'PHP';
        cc.TrackString = 'Orange Track';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.PrgString = 'IOP';
        cc.URLocString = 'IOP';
        cc.TrackString = 'Purple Track';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.PrgString = 'OP';
        cc.URLocString = 'OP';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        
        
        cc.PrgString = 'All';
        cc.URLocString = 'All';
        cc.TrackString = 'All';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.setAllBooleansFalse();
        
        cc.SearchParam = 'Willowsprings';
        cc.getSearchResults();
        
        cc.getClientForHouse();
        cc.getClientNotAdmitted();
        
    }
    
    public static void PrepareDataWithoutRT(){
        Datetime now = DateTime.now();
        
        Account acc = new Account();
         acc.Name = 'Chapters Capistrano';
         acc.Type = 'Internal Center';
         insert acc;
         
        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Chapters Capistrano';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;
        
        Sunshine_Center_Id__c scid2 = new Sunshine_Center_Id__c();
        scid2.Name = 'Monarch Shores';
        scid2.Requires_Admit_Order__c = False;
        scid2.Account_Id__c = acc.id;
        insert scid2;
        
        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Willowsprings Recovery';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Pre Admission';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        ClientID.Admit_Date_Time__c = now;
        Insert ClientID;
        
        Client_Chart__c tomorrowClient = new Client_Chart__c();
        tomorrowClient.Name = 'Willowsprings Recovery';
        tomorrowClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        tomorrowClient.Client_Status__c = 'Pre Admission';
        tomorrowClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        tomorrowClient.Admit_Date_Time__c = now.addDays(1);
        Insert tomorrowClient;
        
        Client_Chart__c YesterdayClient = new Client_Chart__c();
        YesterdayClient.Name = 'Willowsprings Recovery';
        YesterdayClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        YesterdayClient.Client_Status__c = 'Pre Admission';
        YesterdayClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        YesterdayClient.Admit_Date_Time__c = now.addDays(1);
        Insert YesterdayClient;
        
        Client_Chart__c AdmittedClient = new Client_Chart__c();
        AdmittedClient.Name = 'Test Client';
        AdmittedClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        AdmittedClient.Client_Status__c = 'Admitted';
        AdmittedClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        AdmittedClient.Admit_Date_Time__c = now;
        Insert AdmittedClient;  
        
        Client_Chart__c DisTodayClient = new Client_Chart__c();
        DisTodayClient.Name = 'Test Client';
        DisTodayClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        DisTodayClient.Client_Status__c = 'Admitted';
        DisTodayClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        DisTodayClient.Discharge_Date_Time__c = now;
        DisTodayClient.Admit_Date_Time__c = now.addDays(-1);
        Insert DisTodayClient;  
        
        Client_Chart__c DisTomClient = new Client_Chart__c();
        DisTomClient.Name = 'Test Client';
        DisTomClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        DisTomClient.Client_Status__c = 'Admitted';
        DisTomClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        DisTomClient.Discharge_Date_Time__c = now.addDays(1);
        DisTomClient.Admit_Date_Time__c = now.addDays(-1);
        Insert DisTomClient;  
        
        
        Client_Chart__c ResidentialClient = new Client_Chart__c();
        ResidentialClient.Name = 'Test Client';
        ResidentialClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ResidentialClient.Program__c = 'Residential';
        ResidentialClient.U_R_Location__c = 'Residential';
        ResidentialClient.Track_Post_Detox__c = 'Blue Track';
        ResidentialClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert ResidentialClient;  
        
        Client_Chart__c DetoxClient = new Client_Chart__c();
        DetoxClient.Name = 'Test Client';
        DetoxClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        DetoxClient.Program__c = 'Detox';
        DetoxClient.Track_Post_Detox__c = 'Green Track';
        DetoxClient.U_R_Location__c = 'Detox';
        
        DetoxClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert DetoxClient; 
        
        Client_Chart__c PHPClient = new Client_Chart__c();
        PHPClient.Name = 'Test Client';
        PHPClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        PHPClient.Program__c = 'PHP';
        PHPClient.U_R_Location__c = 'PHP';
        PHPClient.Track_Post_Detox__c = 'Orange Track';
        PHPClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert PHPClient; 
        
        Client_Chart__c IOPClient = new Client_Chart__c();
        IOPClient.Name = 'Test Client';
        IOPClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        IOPClient.Program__c = 'IOP';
        IOPClient.U_R_Location__c = 'IOP';
        IOPClient.Track_Post_Detox__c = 'Purple Track';
        IOPClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert IOPClient; 
        
        Client_Chart__c OPClient = new Client_Chart__c();
        OPClient.Name = 'Test Client';
        OPClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        OPClient.Program__c = 'OP';
        OPClient.U_R_Location__c = 'OP';
        OPClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert OPClient; 
        
        Client_Chart__c AllClient = new Client_Chart__c();
        AllClient.Name = 'Test Client';
        AllClient.Diagnosis_Code__c = 'Test1;Test2;Test3';
        AllClient.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert AllClient; 
        
        ApexPages.currentPage().getParameters().put('rt', '');
        
        ClientCtrl cc = new ClientCtrl();
        Date thisday = System.today();
        
        cc.ArrStDt = thisday.addDays(-1);
        cc.ArrEndDt = thisday.addDays(+1);
        cc.DisStDt = thisday.addDays(-1);
        cc.DisEndStDt = thisday.addDays(+1);
        
        cc.getClientPreAddmission();
        cc.getClientAdmitted();
        cc.getClientDischarged();
        cc.getClientArrivingToday();
        cc.getClientArrivingTomorrow();   
        cc.getClientDischargingToday();  
        cc.getClientDischargingTomorrow();  
        cc.getClientOnArrivDateRng();
        cc.getClientOnDisDateRng();
        cc.getClientOnPrograms();
        
        cc.PrgString = 'Residential';
        cc.URLocString = 'Residential';
        cc.TrackString = 'Blue Track';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.PrgString = 'Detox';
        cc.URLocString = 'Detox';
        cc.TrackString = 'Green Track';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.PrgString = 'PHP';
        cc.URLocString = 'PHP';
        cc.TrackString = 'Orange Track';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.PrgString = 'IOP';
        cc.URLocString = 'IOP';
        cc.TrackString = 'Purple Track';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.PrgString = 'OP';
        cc.URLocString = 'OP';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        
        
        cc.PrgString = 'All';
        cc.URLocString = 'All';
        cc.TrackString = 'All';
        cc.getClientOnPrograms();
        cc.getClientOnURLocation();
        cc.getClientOnTrack();
        
        cc.setAllBooleansFalse();
       
        }
     
}