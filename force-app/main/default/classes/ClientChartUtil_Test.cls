@IsTest
private class ClientChartUtil_Test {

    private static Client_Chart__c ClientID;

    public static testmethod void ClientChartUtil_Test() {
        Test.startTest();
        PrepareData_ClientChartUtil();
        Test.stopTest();
    }
    public static testmethod void ClientChartUtil_Test_BPSA() {
        Test.startTest();
      
        PrepareData_ClientChartUtil_BPSA_Test4();
        PrepareData_ClientChartUtil_BPSA_Test5();
        PrepareData_ClientChartUtil_BPSA_Test6();
        Test.stopTest();
    }
    
      public static testmethod void ClientChartUtil_Test_BPSA1() {
        Test.startTest();
        PrepareData_ClientChartUtil_BPSA_Test1();
        PrepareData_ClientChartUtil_BPSA_Test2();
        PrepareData_ClientChartUtil_BPSA_Test3();
    
        Test.stopTest();
    }
    public static testmethod void ClientChartUtil_Test_BPSA_Other() {
        Test.startTest();
        PrepareData_ClientChartUtil_BPSA_Test_Other();
        Test.stopTest();
    }

    public static testmethod void ClientChartUtil_Test_updateDueDate() {
        Test.startTest();
        ClientChartUtil ccu = PrepareData_ClientChartUtil();
        ccu.updateDueDate(ClientID);
        Test.stopTest();
    }

    public static ClientChartUtil PrepareData_ClientChartUtil() {

        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;

        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;

        ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Pre Admission';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        ClientID.Admit_Date_Time__c = DateTime.now();
        ClientID.Gender__c = 'Female';
        Insert ClientID;

        //Id OppRecTypeId = [Select Id,Name,DeveloperName from RecordType where SObjectType = 'Opportunity' and Name = 'Monarch Shores' limit 1].Id;


        Opportunity opp = new Opportunity();
        opp.Is_Client_Chart_Created__c = false;
        opp.Name = 'Opp 1';
        opp.StageName = 'Admit Scheduled';
        opp.Family_Contact_Name__c = 'Test';
        opp.Family_Contact_Email__c = 'test@test.com';
        opp.Family_Contact_Phone__c = '1234567890';
        opp.Family_Contact_Relationship__c = 'Parent';
        opp.CloseDate = System.today();
        opp.Sunshine_Center__c = acc.id;
        insert opp;

        Clinical_Evaluation__c ceOpp = new Clinical_Evaluation__c();
        ceOpp.Client_Chart__c = ClientID.Id;
        ceOpp.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();

        ceOpp.PAA_Drug_of_Choice_1__c = 'Alcohol';
        ceOpp.PAA_Current_Use_Details_Drug_1__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_1__c = 15;
        ceOpp.PAA_Frequency_of_Use_Drug_1__c = 'Daily';
        ceOpp.PAA_Method_of_Use_Drug_1__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_1__c = System.today();

        ceOpp.PAA_Drug_of_Choice_2__c = 'Heroin';
        ceOpp.PAA_Current_Use_Details_Drug_2__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_2__c = 22;
        ceOpp.PAA_Frequency_of_Use_Drug_2__c = 'Weekly';
        ceOpp.PAA_Method_of_Use_Drug_2__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_2__c = System.today();

        ceOpp.PAA_Drug_of_Choice_3__c = 'Percocet';
        ceOpp.PAA_Current_Use_Details_Drug_3__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_3__c = 20;
        ceOpp.PAA_Frequency_of_Use_Drug_3__c = 'test';
        ceOpp.PAA_Method_of_Use_Drug_3__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_3__c = System.today();
        insert ceOpp;
        //opp.RecordTypeId = OppRecTypeId;//Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();



        ClientChartUtil ccu = new ClientChartUtil();

        ccu.createClientChart(opp);

        List<Contact> contacts = new List<Contact>();
        ccu.createPHIAuthorizations(contacts);

        ccu.createUrinePregnancy(ClientID);

        ccu.createContact(ClientID);
        ccu.createPreAddAssess(ClientID);

        ClientID.Client_Status__c = 'Admitted';
        update ClientID;

        ccu.updatePAA(ClientID);
        ccu.createFFE(ClientID, ceOpp);
        ccu.createPsychEval(ClientID, ceOpp);
        ccu.createBioPsychSocial(ClientID, ceOpp);
        ccu.createHistNPhys(ClientID, ceOpp);
        ccu.createDetoxTrtPlan(ClientID);
        ccu.createMasterTrtPlan(ClientID);
        ccu.createDischargePlan(ClientID);
        ccu.createIntakeAllRecords(ClientID);
        ccu.createAdmitOrder(ClientID);
        ccu.createDrugScreen(ClientID);
        //ccu.createUrinePregnancy(ClientID);
        return ccu;
    }


    public static void PrepareData_ClientChartUtil_BPSA_Test1() {

        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;

        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;

        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        ClientID.Admit_Date_Time__c = DateTime.now();
        ClientID.Gender__c = 'Female';
        Insert ClientID;

        //Id OppRecTypeId = [Select Id,Name,DeveloperName from RecordType where SObjectType = 'Opportunity' and Name = 'Monarch Shores' limit 1].Id;

        Opportunity opp = new Opportunity();
        opp.Is_Client_Chart_Created__c = false;
        opp.Name = 'Opp 1';
        opp.StageName = 'Admit Scheduled';
        opp.Family_Contact_Name__c = 'Test';
        opp.Family_Contact_Email__c = 'test@test.com';
        opp.Family_Contact_Phone__c = '1234567890';
        opp.Family_Contact_Relationship__c = 'Parent';
        opp.CloseDate = System.today();
        opp.Sunshine_Center__c = acc.id;
        insert opp;

        Clinical_Evaluation__c ceOpp = new Clinical_Evaluation__c();
        ceOpp.Client_Chart__c = ClientID.Id;
        ceOpp.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();

        ceOpp.PAA_Drug_of_Choice_1__c = 'Vicodin';
        ceOpp.PAA_Current_Use_Details_Drug_1__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_1__c = 15;
        ceOpp.PAA_Frequency_of_Use_Drug_1__c = 'Daily';
        ceOpp.PAA_Method_of_Use_Drug_1__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_1__c = System.today();

        ceOpp.PAA_Drug_of_Choice_2__c = 'Methadone';
        ceOpp.PAA_Current_Use_Details_Drug_2__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_2__c = 22;
        ceOpp.PAA_Frequency_of_Use_Drug_2__c = 'Weekly';
        ceOpp.PAA_Method_of_Use_Drug_2__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_2__c = System.today();

        ceOpp.PAA_Drug_of_Choice_3__c = 'Dilaudid';
        ceOpp.PAA_Current_Use_Details_Drug_3__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_3__c = 20;
        ceOpp.PAA_Frequency_of_Use_Drug_3__c = 'test';
        ceOpp.PAA_Method_of_Use_Drug_3__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_3__c = System.today();

        //opp.RecordTypeId = OppRecTypeId;//Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert ceOpp;


        ClientChartUtil ccu = new ClientChartUtil();

        ccu.createClientChart(opp);

        List<Contact> contacts = new List<Contact>();
        ccu.createPHIAuthorizations(contacts);

        ccu.createPreAddAssess(ClientID);
        ccu.createBioPsychSocial(ClientID, ceOpp);

    }

    public static void PrepareData_ClientChartUtil_BPSA_Test2() {

        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;

        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;

        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        ClientID.Admit_Date_Time__c = DateTime.now();
        ClientID.Gender__c = 'Female';
        Insert ClientID;

        //Id OppRecTypeId = [Select Id,Name,DeveloperName from RecordType where SObjectType = 'Opportunity' and Name = 'Monarch Shores' limit 1].Id;

        Opportunity opp = new Opportunity();
        opp.Is_Client_Chart_Created__c = false;
        opp.Name = 'Opp 1';
        opp.StageName = 'Admit Scheduled';
        opp.Family_Contact_Name__c = 'Test';
        opp.Family_Contact_Email__c = 'test@test.com';
        opp.Family_Contact_Phone__c = '1234567890';
        opp.Family_Contact_Relationship__c = 'Parent';
        opp.CloseDate = System.today();
        opp.Sunshine_Center__c = acc.id;
        insert opp;

        Clinical_Evaluation__c ceOpp = new Clinical_Evaluation__c();
        ceOpp.Client_Chart__c = ClientID.Id;
        ceOpp.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();

        ceOpp.PAA_Drug_of_Choice_1__c = 'Marijuana';
        ceOpp.PAA_Current_Use_Details_Drug_1__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_1__c = 15;
        ceOpp.PAA_Frequency_of_Use_Drug_1__c = 'Daily';
        ceOpp.PAA_Method_of_Use_Drug_1__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_1__c = System.today();

        ceOpp.PAA_Drug_of_Choice_2__c = 'LSD';
        ceOpp.PAA_Current_Use_Details_Drug_2__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_2__c = 22;
        ceOpp.PAA_Frequency_of_Use_Drug_2__c = 'Weekly';
        ceOpp.PAA_Method_of_Use_Drug_2__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_2__c = System.today();

        ceOpp.PAA_Drug_of_Choice_3__c = 'PCP';
        ceOpp.PAA_Current_Use_Details_Drug_3__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_3__c = 20;
        ceOpp.PAA_Frequency_of_Use_Drug_3__c = 'test';
        ceOpp.PAA_Method_of_Use_Drug_3__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_3__c = System.today();

        insert ceOpp;

        ClientChartUtil ccu = new ClientChartUtil();

        ccu.createClientChart(opp);

        List<Contact> contacts = new List<Contact>();
        ccu.createPHIAuthorizations(contacts);

        ccu.createPreAddAssess(ClientID);
        ccu.createBioPsychSocial(ClientID, ceOpp);

    }

    public static void PrepareData_ClientChartUtil_BPSA_Test3() {

        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;

        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;

        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        ClientID.Admit_Date_Time__c = DateTime.now();
        ClientID.Gender__c = 'Female';
        Insert ClientID;

        //Id OppRecTypeId = [Select Id,Name,DeveloperName from RecordType where SObjectType = 'Opportunity' and Name = 'Monarch Shores' limit 1].Id;

        Opportunity opp = new Opportunity();
        opp.Is_Client_Chart_Created__c = false;
        opp.Name = 'Opp 1';
        opp.StageName = 'Admit Scheduled';
        opp.Family_Contact_Name__c = 'Test';
        opp.Family_Contact_Email__c = 'test@test.com';
        opp.Family_Contact_Phone__c = '1234567890';
        opp.Family_Contact_Relationship__c = 'Parent';
        opp.CloseDate = System.today();
        opp.Sunshine_Center__c = acc.id;
        insert opp;


        Clinical_Evaluation__c ceOpp = new Clinical_Evaluation__c();
        ceOpp.Client_Chart__c = ClientID.Id;
        ceOpp.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();

        ceOpp.PAA_Drug_of_Choice_1__c = 'Ecstacy';
        ceOpp.PAA_Current_Use_Details_Drug_1__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_1__c = 15;
        ceOpp.PAA_Frequency_of_Use_Drug_1__c = 'Daily';
        ceOpp.PAA_Method_of_Use_Drug_1__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_1__c = System.today();

        ceOpp.PAA_Drug_of_Choice_2__c = 'Cocaine';
        ceOpp.PAA_Current_Use_Details_Drug_2__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_2__c = 22;
        ceOpp.PAA_Frequency_of_Use_Drug_2__c = 'Weekly';
        ceOpp.PAA_Method_of_Use_Drug_2__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_2__c = System.today();

        ceOpp.PAA_Drug_of_Choice_3__c = 'Crack Cocaine';
        ceOpp.PAA_Current_Use_Details_Drug_3__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_3__c = 20;
        ceOpp.PAA_Frequency_of_Use_Drug_3__c = 'test';
        ceOpp.PAA_Method_of_Use_Drug_3__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_3__c = System.today();

        insert ceOpp;
        //opp.RecordTypeId = OppRecTypeId;//Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();


        ClientChartUtil ccu = new ClientChartUtil();

        ccu.createClientChart(opp);

        List<Contact> contacts = new List<Contact>();
        ccu.createPHIAuthorizations(contacts);

        ccu.createPreAddAssess(ClientID);

        ccu.createBioPsychSocial(ClientID, ceOpp);

    }
    
      public static void PrepareData_ClientChartUtil_BPSA_Test4() {

        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;

        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;

        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        ClientID.Admit_Date_Time__c = DateTime.now();
        ClientID.Gender__c = 'Female';
        Insert ClientID;

        //Id OppRecTypeId = [Select Id,Name,DeveloperName from RecordType where SObjectType = 'Opportunity' and Name = 'Monarch Shores' limit 1].Id;

        Opportunity opp = new Opportunity();
        opp.Is_Client_Chart_Created__c = false;
        opp.Name = 'Opp 1';
        opp.StageName = 'Admit Scheduled';
        opp.Family_Contact_Name__c = 'Test';
        opp.Family_Contact_Email__c = 'test@test.com';
        opp.Family_Contact_Phone__c = '1234567890';
        opp.Family_Contact_Relationship__c = 'Parent';
        opp.CloseDate = System.today();
        opp.Sunshine_Center__c = acc.id;
        insert opp;


        Clinical_Evaluation__c ceOpp = new Clinical_Evaluation__c();
        ceOpp.Client_Chart__c = ClientID.Id;
        ceOpp.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();

        ceOpp.PAA_Drug_of_Choice_1__c = 'Speed';
        ceOpp.PAA_Current_Use_Details_Drug_1__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_1__c = 15;
        ceOpp.PAA_Frequency_of_Use_Drug_1__c = 'Daily';
        ceOpp.PAA_Method_of_Use_Drug_1__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_1__c = System.today();

        ceOpp.PAA_Drug_of_Choice_2__c = 'Amphetamines';
        ceOpp.PAA_Current_Use_Details_Drug_2__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_2__c = 22;
        ceOpp.PAA_Frequency_of_Use_Drug_2__c = 'Weekly';
        ceOpp.PAA_Method_of_Use_Drug_2__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_2__c = System.today();

        ceOpp.PAA_Drug_of_Choice_3__c = 'Methamphetamine';
        ceOpp.PAA_Current_Use_Details_Drug_3__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_3__c = 20;
        ceOpp.PAA_Frequency_of_Use_Drug_3__c = 'test';
        ceOpp.PAA_Method_of_Use_Drug_3__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_3__c = System.today();

        insert ceOpp;
        //opp.RecordTypeId = OppRecTypeId;//Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();


        ClientChartUtil ccu = new ClientChartUtil();

        ccu.createClientChart(opp);

        List<Contact> contacts = new List<Contact>();
        ccu.createPHIAuthorizations(contacts);

        ccu.createPreAddAssess(ClientID);

        ccu.createBioPsychSocial(ClientID, ceOpp);

    }
    
      public static void PrepareData_ClientChartUtil_BPSA_Test5() {

        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;

        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;

        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        ClientID.Admit_Date_Time__c = DateTime.now();
        ClientID.Gender__c = 'Female';
        Insert ClientID;

        //Id OppRecTypeId = [Select Id,Name,DeveloperName from RecordType where SObjectType = 'Opportunity' and Name = 'Monarch Shores' limit 1].Id;

        Opportunity opp = new Opportunity();
        opp.Is_Client_Chart_Created__c = false;
        opp.Name = 'Opp 1';
        opp.StageName = 'Admit Scheduled';
        opp.Family_Contact_Name__c = 'Test';
        opp.Family_Contact_Email__c = 'test@test.com';
        opp.Family_Contact_Phone__c = '1234567890';
        opp.Family_Contact_Relationship__c = 'Parent';
        opp.CloseDate = System.today();
        opp.Sunshine_Center__c = acc.id;
        insert opp;


        Clinical_Evaluation__c ceOpp = new Clinical_Evaluation__c();
        ceOpp.Client_Chart__c = ClientID.Id;
        ceOpp.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();

        ceOpp.PAA_Drug_of_Choice_1__c = 'Barbiturates';
        ceOpp.PAA_Current_Use_Details_Drug_1__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_1__c = 15;
        ceOpp.PAA_Frequency_of_Use_Drug_1__c = 'Daily';
        ceOpp.PAA_Method_of_Use_Drug_1__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_1__c = System.today();

        ceOpp.PAA_Drug_of_Choice_2__c = 'Quaaludes';
        ceOpp.PAA_Current_Use_Details_Drug_2__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_2__c = 22;
        ceOpp.PAA_Frequency_of_Use_Drug_2__c = 'Weekly';
        ceOpp.PAA_Method_of_Use_Drug_2__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_2__c = System.today();

        ceOpp.PAA_Drug_of_Choice_3__c = 'Valium';
        ceOpp.PAA_Current_Use_Details_Drug_3__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_3__c = 20;
        ceOpp.PAA_Frequency_of_Use_Drug_3__c = 'test';
        ceOpp.PAA_Method_of_Use_Drug_3__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_3__c = System.today();

        insert ceOpp;
        //opp.RecordTypeId = OppRecTypeId;//Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();


        ClientChartUtil ccu = new ClientChartUtil();

        ccu.createClientChart(opp);

        List<Contact> contacts = new List<Contact>();
        ccu.createPHIAuthorizations(contacts);

        ccu.createPreAddAssess(ClientID);

        ccu.createBioPsychSocial(ClientID, ceOpp);

    }
    
      public static void PrepareData_ClientChartUtil_BPSA_Test6() {

        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;

        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;

        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        ClientID.Admit_Date_Time__c = DateTime.now();
        ClientID.Gender__c = 'Female';
        Insert ClientID;

        //Id OppRecTypeId = [Select Id,Name,DeveloperName from RecordType where SObjectType = 'Opportunity' and Name = 'Monarch Shores' limit 1].Id;

        Opportunity opp = new Opportunity();
        opp.Is_Client_Chart_Created__c = false;
        opp.Name = 'Opp 1';
        opp.StageName = 'Admit Scheduled';
        opp.Family_Contact_Name__c = 'Test';
        opp.Family_Contact_Email__c = 'test@test.com';
        opp.Family_Contact_Phone__c = '1234567890';
        opp.Family_Contact_Relationship__c = 'Parent';
        opp.CloseDate = System.today();
        opp.Sunshine_Center__c = acc.id;
        insert opp;


        Clinical_Evaluation__c ceOpp = new Clinical_Evaluation__c();
        ceOpp.Client_Chart__c = ClientID.Id;
        ceOpp.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();

        ceOpp.PAA_Drug_of_Choice_1__c = 'Xanax';
        ceOpp.PAA_Current_Use_Details_Drug_1__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_1__c = 15;
        ceOpp.PAA_Frequency_of_Use_Drug_1__c = 'Daily';
        ceOpp.PAA_Method_of_Use_Drug_1__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_1__c = System.today();

        ceOpp.PAA_Drug_of_Choice_2__c = 'Quaaludes';
        ceOpp.PAA_Current_Use_Details_Drug_2__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_2__c = 22;
        ceOpp.PAA_Frequency_of_Use_Drug_2__c = 'Weekly';
        ceOpp.PAA_Method_of_Use_Drug_2__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_2__c = System.today();

        ceOpp.PAA_Drug_of_Choice_3__c = 'Valium';
        ceOpp.PAA_Current_Use_Details_Drug_3__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_3__c = 20;
        ceOpp.PAA_Frequency_of_Use_Drug_3__c = 'test';
        ceOpp.PAA_Method_of_Use_Drug_3__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_3__c = System.today();

        insert ceOpp;
        //opp.RecordTypeId = OppRecTypeId;//Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();


        ClientChartUtil ccu = new ClientChartUtil();

        ccu.createClientChart(opp);

        List<Contact> contacts = new List<Contact>();
        ccu.createPHIAuthorizations(contacts);

        ccu.createPreAddAssess(ClientID);

        ccu.createBioPsychSocial(ClientID, ceOpp);

    }

    public static void PrepareData_ClientChartUtil_BPSA_Test_Other() {

        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;

        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;

        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        ClientID.Admit_Date_Time__c = DateTime.now();
        ClientID.Gender__c = 'Female';
        Insert ClientID;

        //Id OppRecTypeId = [Select Id,Name,DeveloperName from RecordType where SObjectType = 'Opportunity' and Name = 'Monarch Shores' limit 1].Id;

        Opportunity opp = new Opportunity();
        opp.Is_Client_Chart_Created__c = false;
        opp.Name = 'Opp 1';
        opp.StageName = 'Admit Scheduled';
        opp.Family_Contact_Name__c = 'Test';
        opp.Family_Contact_Email__c = 'test@test.com';
        opp.Family_Contact_Phone__c = '1234567890';
        opp.Family_Contact_Relationship__c = 'Parent';
        opp.CloseDate = System.today();
        opp.Sunshine_Center__c = acc.id;
        insert opp;

        Clinical_Evaluation__c ceOpp = new Clinical_Evaluation__c();
        ceOpp.Client_Chart__c = ClientID.Id;
        ceOpp.RecordTypeId = Schema.SObjectType.Clinical_Evaluation__c.getRecordTypeInfosByName().get('Pre Admission Assesment').getRecordTypeId();

        ceOpp.PAA_Drug_of_Choice_1__c = 'Subutex';
        ceOpp.PAA_Current_Use_Details_Drug_1__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_1__c = 15;
        ceOpp.PAA_Frequency_of_Use_Drug_1__c = 'Daily';
        ceOpp.PAA_Method_of_Use_Drug_1__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_1__c = System.today();

        ceOpp.PAA_Drug_of_Choice_2__c = 'Synthetics';
        ceOpp.PAA_Current_Use_Details_Drug_2__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_2__c = 22;
        ceOpp.PAA_Frequency_of_Use_Drug_2__c = 'Weekly';
        ceOpp.PAA_Method_of_Use_Drug_2__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_2__c = System.today();

        ceOpp.PAA_Drug_of_Choice_3__c = 'Temazepam';
        ceOpp.PAA_Current_Use_Details_Drug_3__c = 'test';
        ceOpp.PAA_Age_of_First_Use_Drug_3__c = 20;
        ceOpp.PAA_Frequency_of_Use_Drug_3__c = 'test';
        ceOpp.PAA_Method_of_Use_Drug_3__c = 'Orally';
        ceOpp.PAA_Date_of_Last_Use_Drug_3__c = System.today();

        insert ceOpp;

        ClientChartUtil ccu = new ClientChartUtil();

        ccu.createClientChart(opp);

        List<Contact> contacts = new List<Contact>();
        ccu.createPHIAuthorizations(contacts);

        ccu.createPreAddAssess(ClientID);

        ccu.createBioPsychSocial(ClientID, ceOpp);

    }
}