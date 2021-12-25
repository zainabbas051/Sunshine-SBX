@isTest
public class Meds_ControllersTest {
    static Medicine__c medi;
    static string frequency;
    static string freqQAM;
    static string freqQPM;
    static {
        TabViews__c  tv = new TabViews__c ();
        tv.Name = 'Meds';
        tv.Button_Access_Type__c  = 'Admin,Clinical Director,Clinical,Ops Sup,Operations,Lab Tech,HCP,Nursing';
        tv.Is_Main_Tab__c = false;
        tv.Tabs_Access_Type__c = 'Admin,Clinical Director,Clinical,Ops Sup,Operations,Lab Tech,HCP,UR,Admissions,Nursing,Test';
        insert tv;
        
        EFax_Setting__c eFaxSetting = new EFax_Setting__c();
        eFaxSetting.Name = 'Freepu';
        eFaxSetting.Account_ID__c = '100005';
        eFaxSetting.User_Name__c = 'abc49';
        eFaxSetting.Password__c = 'xyz123';
        insert eFaxSetting;
        
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
        FreqMapping.Missed__c = 2;
        FreqMapping.Time__c = '6,12,18';
        FreqMapping.Hide_Button__c = 10;
        insert FreqMapping;

        FrequencyMapping__c FreqMapping2 = new FrequencyMapping__c();
        FreqMapping2.Name = 'Q8 Hours';
        FreqMapping2.Count__c = 3;
        FreqMapping2.Interval__c = 2;
        FreqMapping2.Missed__c = 2;
        FreqMapping2.Time__c = '6,12,18';
        FreqMapping2.Hide_Button__c = 10;
        insert FreqMapping2;
        
        FrequencyMapping__c FreqMapping3 = new FrequencyMapping__c();
        FreqMapping3.Name = 'QPM';
        FreqMapping3.Count__c = 1;
        FreqMapping3.Interval__c = 2;
        FreqMapping3.Missed__c = 2;
        FreqMapping3.Time__c = '21';
        FreqMapping3.Hide_Button__c = 10;
        insert FreqMapping3;
        
        medi = new Medicine__c();
        medi.Name = 'test';
        insert medi;

        Sunshine_Center_Id__c sc = new Sunshine_Center_Id__c();
        sc.Name = 'Monarch Shores';
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
    static testMethod void MedsHomePageController() {

        test.startTest();

        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Contact c = new Contact();
        c.AccountId = a.id;
        c.FirstName = 'Pharmacy';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        c.Pharmacy__c = true;
        c.Fax = '123';
        insert c;

        Client_Chart__c cl = new Client_Chart__c();
        cl.Treatment_Center__c = a.ID;
        cl.Primary_Therapist__c = UserINFO.getUserID();
        cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cl;

        Test.setCurrentPageReference(Page.MedsHomePage);

        System.currentPageReference().getParameters().put('id', cl.id);
        system.currentPageReference().getParameters().put('rt', 'Monarch Shores');
        
        string timeStr = '1,2,3,4,5,6,7,8,9,10,12,13,14';
        list<string> lstTimeString = timeStr.split(',');
        string result = OrderUtil.QDailyFM(lstTimeString  , 0, 1,timeStr );
        result = OrderUtil.QDailyFM(lstTimeString  , 0, 4,timeStr );

        Order__c order = new Order__c();
        order.Client_Chart__c = cl.id;
        order.Status__c = 'Active';
        order.Order_Type__c = 'Manual';
        order.Start_Date__c = Datetime.now();
        order.Duration__c = 1;
        order.End_Date__c = Datetime.now().addDays(1);
        order.Order_By__c = UserInfo.getUserId();
        order.Frequency__c = frequency ;
        order.Medicine__c = medi.id;
        insert order;
        
        
        
        OrderUtil.returnManualOrder(order, cl.id);
        OrderUtil.returnManualMARs(order, cl.id);
        Order_Line_Item__c   oli = OrderUtil.returnOLI(order.id,new Taper_Line_Item__c());
        oli.Frequency__c = frequency;
        //todays mars
        Event t = new Event();
        t.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        t.WhatId = order.id;

        t.Medicine__c = order.Medicine__c;
        t.PRN__c = order.PRN__c;
        t.Strength__c = order.Dose__c;
        t.Route_of_Delivery__c = order.Route__c;
        t.Frequency__c = order.Frequency__c;
        t.Status__c = 'Open';
        t.Client_Chart__c = cl.id;
        t.Day__c = 1;

        //creating Q MARs
        t.StartDateTime = order.Start_Date__c;

        t.EndDateTime = order.Start_Date__c;

        insert t;
        
        Event tNew = OrderUtil.getNextEvent(oli,t);
        //yesterdays mars
        Event yesterday = new Event();
        yesterday.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        yesterday.WhatId = order.id;

        yesterday.Medicine__c = order.Medicine__c;
        yesterday.PRN__c = order.PRN__c;
        yesterday.Strength__c = order.Dose__c;
        yesterday.Route_of_Delivery__c = order.Route__c;
        yesterday.Frequency__c = order.Frequency__c;
        yesterday.Status__c = 'Open';
        yesterday.Client_Chart__c = cl.id;
        yesterday.Day__c = 1;

        //creating Q MARs
        yesterday.StartDateTime = order.Start_Date__c.addDays(-1);

        yesterday.EndDateTime = order.Start_Date__c.addDays(-1);

        insert yesterday;

        //insert tommorws mars
        Event tom = new Event();
        tom.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        tom.WhatId = order.id;

        tom.Medicine__c = order.Medicine__c;
        tom.PRN__c = order.PRN__c;
        tom.Strength__c = order.Dose__c;
        tom.Route_of_Delivery__c = order.Route__c;
        tom.Frequency__c = order.Frequency__c;
        tom.Status__c = 'Open';
        tom.Client_Chart__c = cl.id;
        tom.Day__c = 1;

        //creating Q MARs
        tom.StartDateTime = order.Start_Date__c.addDays(1);

        tom.EndDateTime = order.Start_Date__c.addDays(1);

        insert tom;

        MedsHomePageController meds = new MedsHomePageController();
        meds.ShowAllOrders();
        meds.showMultipleMARs();
        meds.showDiscOrders();
        meds.showAllMARS();
        meds.showTomorrowsMARS();
        meds.showYesterdaysMARS();

        System.currentPageReference().getParameters().put('orderId', order.id);
        
        meds.ViewOrder();
        
        Taper__c taper = new Taper__c();
        taper.name = 'test';
        taper.Active__c = true;
        taper.Number_of_Days__c = 3;
        taper.Protocol__c = 'Detox Protocol';
        taper.dosage_type__c = 'Taper';
        insert taper;

        Taper_Line_Item__c tli = new Taper_Line_Item__c();
        tli.taper__c = taper.id;
        tli.medicine__c = medi.id;
        tli.Route__c = 'PO - By Mouth';
        tli.Strength__c = '10mg';
        tli.Frequency__c = frequency ;
        tli.Duration_in_Days__c = 1;
        insert tli;
        
        
        Order__c o = new Order__c();
        o.Order_Type__c = 'Standard - Taper';
        o.Client_Chart__c = cl.id;
        o.Duration__c = 1;
        o.Status__c = 'Active';
        o.Start_Date__c = datetime.now();
        o.Order_By__c = Userinfo.getuserid();
        o.Taper__c = taper.id;
        insert o;
    
        Order_Line_Item__c ooo = new Order_Line_Item__c ();
        ooo.Order__c= o.id;
        ooo.medicine__c = medi.id;
        ooo.Route__c = 'PO - By Mouth';
        ooo.Dose__c = '10mg';
        ooo.Frequency__c = frequency ;
        ooo.Day__c = 1;
        insert ooo;
        
        System.currentPageReference().getParameters().put('orderId', o.id);
        
        meds.EditOrder();
        
        System.currentPageReference().getParameters().put('IndexNumber', '0');
        meds.EditOLI();
        
        System.currentPageReference().getParameters().put('IndexNumber', '0');
        meds.SaveOLI();
        
        System.currentPageReference().getParameters().put('IndexNumber', '0');
        meds.RemoveOLI();
        
        meds.AddOLI();
        
        ooo.Status__c = 'Complete';
        update ooo;
        
        meds.getPharmacies();
        meds.getFrequencies();
        
        meds.sendToPharmacy();
        //meds.pharmacyEmail = 'test@test.com';
        boolean buttonAccess = meds.buttonAccessType;
        Test.setMock(HttpCalloutMock.class, new HTTPMockCallout());
         
        meds.pharmacyEmail = c.id;
        meds.SendToPharmacyStep2();
        meds.updatePharmacyStatus();

        System.currentPageReference().getParameters().put('myParam', tom.id);
        System.currentPageReference().getParameters().put('statusVal', 'Administered');
        meds.UpdateMARs();
        meds.SubmitMars();

        System.currentPageReference().getParameters().put('orderid', order.id);
        meds.CloseOrderForm();
        
        System.currentPageReference().getParameters().put('orderids', tom.id);
        System.currentPageReference().getParameters().put('option', 'Patient');
        
        meds.CloseMultipleMARs();
        
        System.currentPageReference().getParameters().put('orderids', tom.id);
        System.currentPageReference().getParameters().put('option', 'Staff');
        
        meds.CloseMultipleMARs();
        
        System.currentPageReference().getParameters().put('orderid', tom.id);
        meds.SelectedSignedOption  = 'Staff';
        meds.CloseRefusedMARs();

        System.currentPageReference().getParameters().put('orderid', tom.id);
        meds.SelectedSignedOption  = 'Staff';
        meds.CloseMARsForm();

        System.currentPageReference().getParameters().put('orderid', tom.id);
        meds.SelectedSignedOption  = 'Patient';
        meds.CloseMARsForm();
        meds.redirectToRefillCount();
        meds.redirectToMedicationRecord();
        meds.refreshMARs(new list<string> {tom.id});
        test.stoptest();
    }

    //test method for MedsUpdateMARsStatusBatch and scheduler
    static testMethod void MedsUpdateMARsStatusBatch() {

        test.startTest();

        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Client_Chart__c cl = new Client_Chart__c();
        cl.Treatment_Center__c = a.ID;
        cl.Primary_Therapist__c = UserINFO.getUserID();
        cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cl;

        Order__c order = new Order__c();
        order.Client_Chart__c = cl.id;
        order.Status__c = 'Active';
        order.Order_Type__c = 'Manual';
        order.Start_Date__c = Datetime.now();
        order.Duration__c = 1;
        order.End_Date__c = Datetime.now().addDays(1);
        order.Order_By__c = UserInfo.getUserId();
        order.Frequency__c = frequency ;
        order.Medicine__c = medi.id;

        insert order;

        //todays mars
        Event t = new Event();
        t.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        t.WhatId = order.id;

        t.Medicine__c = order.Medicine__c;
        t.PRN__c = order.PRN__c;
        t.Strength__c = order.Dose__c;
        t.Route_of_Delivery__c = order.Route__c;
        t.Frequency__c = order.Frequency__c;
        t.Status__c = 'Open';
        t.Client_Chart__c = cl.id;
        t.Day__c = 1;
        t.Missed_Time__c = Datetime.now().addMinutes(-1);
        //creating Q MARs
        t.StartDateTime = order.Start_Date__c;

        t.EndDateTime = order.Start_Date__c;

        insert t;

        Event tom = new Event();
        tom.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        tom.WhatId = order.id;

        tom.Medicine__c = order.Medicine__c;
        tom.PRN__c = order.PRN__c;
        tom.Strength__c = order.Dose__c;
        tom.Route_of_Delivery__c = order.Route__c;
        tom.Frequency__c = order.Frequency__c;
        tom.Status__c = 'Open';
        tom.Client_Chart__c = cl.id;
        tom.Day__c = 1;
        tom.Pending_Time__c = Datetime.now().addMinutes(-2);
        //creating Q MARs
        tom.StartDateTime = order.Start_Date__c;

        tom.EndDateTime = order.Start_Date__c;

        insert tom;

        MedsUpdateMARsStatusBatch b = new MedsUpdateMARsStatusBatch ();
        database.executebatch(b);
        MedsUpdateMARsStatusSchedule schd = new MedsUpdateMARsStatusSchedule ();
        schd.execute(null);
        test.stoptest();
    }

    //test method for meds_ActionOrderController
    static testMethod void meds_ActionOrderController() {

        test.startTest();

        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Client_Chart__c cl = new Client_Chart__c();
        cl.Treatment_Center__c = a.ID;
        cl.Primary_Therapist__c = UserINFO.getUserID();
        cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cl;

        Test.setCurrentPageReference(Page.MedsHomePage);

        System.currentPageReference().getParameters().put('id', cl.id);
        system.currentPageReference().getParameters().put('rt', 'Monarch Shores');

        meds_ActionOrderController meds = new meds_ActionOrderController();
        meds.submitFunc();
        meds.getUsers();
        meds.getFrequencies();
        test.stoptest();
    }

    //test method for meds_discontinueordercontroller
    static testmethod void meds_discontinueordercontroller() {

        test.startTest();

        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Client_Chart__c cl = new Client_Chart__c();
        cl.Treatment_Center__c = a.ID;
        cl.Primary_Therapist__c = UserINFO.getUserID();
        cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cl;

        Order__c order = new Order__c();
        order.Client_Chart__c = cl.id;
        order.Status__c = 'Active';
        order.Order_Type__c = 'Manual';
        order.Start_Date__c = Datetime.now();
        order.Duration__c = 1;
        order.End_Date__c = Datetime.now().addDays(1);
        order.Order_By__c = UserInfo.getUserId();
        order.Frequency__c = frequency ;
        order.Medicine__c = medi.id;
        order.Remaining_Time__c = '12,15';
        insert order;
        
        Event t = new Event();
        t.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        t.WhatId = order.id;

        t.Medicine__c = medi.id;
        t.PRN__c = false;
        t.Route_of_Delivery__c = 'PO - By Mouth';
        t.Frequency__c = frequency ;
        t.Status__c = 'Open';
        t.Client_Chart__c = cl.id;
        t.Day__c = 1;
        t.Remaining__c = 1;
        t.Remaining_Time__c = '7';
        t.StartDateTime = datetime.now();
        t.EndDateTime = datetime.now();
        t.Hide_Button_Date_Time__c = datetime.now();
        t.Missed_Time__c = datetime.now();
        insert t;

        t.Status__c = 'Administered';
        t.MARs_Administered__c = Datetime.now();
        update t;

        Test.setCurrentPageReference(Page.MedsHomePage);

        System.currentPageReference().getParameters().put('id', cl.id);
        system.currentPageReference().getParameters().put('rt', 'Monarch Shores');

        meds_discontinueordercontroller meds = new meds_discontinueordercontroller();
        meds.getItems();
        meds.lstWrapperActiveOrders[0].selected = true;
        meds.lstWrapperActiveOrders[0].ActiveOrder.Discontinue_Date_Time__c = datetime.now();
        meds.via = 'fax';
        meds.SubmitButton();
        meds.getUsers();
        test.stoptest();
    }

    //test method for meds_manualordercontroller
    static testmethod void meds_manualordercontroller() {

        test.startTest();

        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Client_Chart__c cl = new Client_Chart__c();
        cl.Treatment_Center__c = a.ID;
        cl.Primary_Therapist__c = UserINFO.getUserID();
        cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cl;

        Test.setCurrentPageReference(Page.MedsHomePage);

        System.currentPageReference().getParameters().put('id', cl.id);
        system.currentPageReference().getParameters().put('rt', 'Monarch Shores');

        meds_manualordercontroller meds = new meds_manualordercontroller();
        meds.EditFullPage();

        meds.order.Client_Chart__c = cl.id;
        meds.order.Status__c = 'Active';
        meds.order.Order_Type__c = 'Manual';
        meds.order.Start_Date__c = Datetime.now();
        meds.order.Duration__c = 1;
        meds.order.End_Date__c = Datetime.now().addDays(1);
        meds.order.Order_By__c = UserInfo.getUserId();
        meds.order.Frequency__c = frequency ;
        meds.order.Medicine__c = medi.id;
        meds.submitFunc();
        meds.getUsers();
        meds.getFrequencies();
        list<Event> lstEvents = [select id, Status__c, MARs_Administered__c from Event where Status__c = 'Open'];
        for (Event e : lstEvents) {
            e.Status__c = 'Administered';
            e.MARs_Administered__c = Datetime.now();

        }
        if (lstEvents.size() > 0)
            update lstEvents;

        test.stopTest();
    }

    //test method for meds_standardordercontroller
    static testmethod void meds_standardordercontroller() {

        test.startTest();

        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Client_Chart__c cl = new Client_Chart__c();
        cl.Treatment_Center__c = a.ID;
        cl.Primary_Therapist__c = UserINFO.getUserID();
        cl.Discharge_Date_Time__c = Datetime.now().adddays(30);
        cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cl;

        Taper__c taper = new Taper__c();
        taper.name = 'test';
        taper.Active__c = true;
        taper.Number_of_Days__c = 3;
        taper.Protocol__c = 'Detox Protocol';
        taper.dosage_type__c = 'Taper';
        insert taper;

        Taper_Line_Item__c tli = new Taper_Line_Item__c();
        tli.taper__c = taper.id;
        tli.medicine__c = medi.id;
        tli.Route__c = 'PO - By Mouth';
        tli.Strength__c = '10mg';
        tli.Frequency__c = frequency ;
        tli.Duration_in_Days__c = 1;
        insert tli;


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
        tliprn.Duration_in_Days__c = 1;
        insert tliprn;

        Taper_Line_Item__c tliprn2 = new Taper_Line_Item__c();
        tliprn2.taper__c = prn.id;
        tliprn2.medicine__c = medi.id;
        tliprn2.Route__c = 'PO - By Mouth';
        tliprn2.Strength__c = '10mg';
        tliprn2.Frequency__c = frequency ;
        tliprn2.Duration_in_Days__c = 2;
        insert tliprn2;

        Taper__c othertaper = new Taper__c();
        othertaper.name = 'test';
        othertaper.Active__c = true;
        othertaper.Number_of_Days__c = 3;
        othertaper.Protocol__c = 'Detox Protocol';
        othertaper.dosage_type__c = 'Consistent Dose';
        insert othertaper;

        Taper_Line_Item__c tliothertaper = new Taper_Line_Item__c();
        tliothertaper.taper__c = othertaper.id;
        tliothertaper.medicine__c = medi.id;
        tliothertaper.Route__c = 'PO - By Mouth';
        tliothertaper.Strength__c = '10mg';
        tliothertaper.Frequency__c = frequency ;
        tliothertaper.Duration_in_Days__c = 1;
        insert tliothertaper;

        Test.setCurrentPageReference(Page.MedsHomePage);

        System.currentPageReference().getParameters().put('id', cl.id);
        system.currentPageReference().getParameters().put('rt', 'Monarch Shores');
        
        meds_standardordercontroller meds = new meds_standardordercontroller();
        //meds.
        meds.SubmitAll();
        for(list<meds_standardordercontroller.wrapperTaper> wt1 : meds.mapWrapperTapers.values()){
            for(meds_standardordercontroller.wrapperTaper wt : wt1 ){
                wt.selected = true;
                wt.ord.Start_Date__c = Datetime.now();
                wt.ord.Requested_via__c = 'phone, read back and verified';
                wt.ord.Order_by__c = Userinfo.getUserId();
            }
        }  meds.submitAll();
        meds.submitTaper();

        list<Event> lstEvents = [select id, Status__c, MARs_Administered__c from Event where Status__c = 'Open'];
        system.debug(lstEvents.size());
        for (Event e : lstEvents) {
            e.Status__c = 'Administered';
            e.MARs_Administered__c = Datetime.now();

        }
        if (lstEvents.size() > 0)
            update lstEvents;
        
        for(list<meds_standardordercontroller.wrapperTaper> wt1 : meds.mapWrapperPRNs.values()){
            for(meds_standardordercontroller.wrapperTaper wt : wt1 ){
                wt.selected = true;
                wt.ord.Start_Date__c = Datetime.now();
                wt.ord.Requested_via__c = 'phone, read back and verified';
                wt.ord.Order_by__c = Userinfo.getUserId();
            }
        }
        meds.submitPRN();

        lstEvents = [select id, Status__c, MARs_Administered__c from Event where Status__c = 'Open'];
        system.debug(lstEvents.size());
        for (Event e : lstEvents) {
            e.Status__c = 'Administered';
            e.MARs_Administered__c = Datetime.now();

        }
        if (lstEvents.size() > 0)
            update lstEvents;
       
        meds.getUsers();
        meds.getFrequencies();
        meds.AddOLI();
        
        system.currentPageReference().getParameters().put('IndexNumber', '0');
        meds.RemoveOLI();
        
        lstEvents = [select id, Status__c, MARs_Administered__c from Event where Status__c = 'Open'];
        system.debug(lstEvents.size());
        for (Event e : lstEvents) {
            e.Status__c = 'Administered';
            e.MARs_Administered__c = Datetime.now();

        }
        if (lstEvents.size() > 0)
            update lstEvents;





        test.stoptest();
    }
    static testmethod void CustomMedicineLookupController() {
        test.starttest();
        Test.setCurrentPageReference(Page.CustomMedicineLookup);

        System.currentPageReference().getParameters().put('lksrch', '');

        CustomMedicineLookupController CM = new CustomMedicineLookupController();
        CM.search();
        CM.medicine.Name = 'test2';
        CM.saveMedicine();
        CM.getFormTag();
        CM.getTextBox();


        test.stoptest();
    }

    static testmethod void meds_RefillCountController() {

        test.starttest();

        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Client_Chart__c cl = new Client_Chart__c();
        cl.Treatment_Center__c = a.ID;
        cl.Primary_Therapist__c = UserINFO.getUserID();
        cl.Discharge_Date_Time__c = Datetime.now().adddays(30);
        cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cl;

        Test.setCurrentPageReference(Page.Meds_RefillCount);

        System.currentPageReference().getParameters().put('id', cl.id);
        system.currentPageReference().getParameters().put('rt', 'Monarch Shores');

        MedsCountCmpCtrl meds = new MedsCountCmpCtrl();
        meds.getTypes();
        meds.getHouses();
        meds.AddMore();

        system.currentPageReference().getParameters().put('IndexNumber', '0');
        meds.Edit();

        system.currentPageReference().getParameters().put('IndexNumber', '0');
        meds.SaveRefillCount();

        system.currentPageReference().getParameters().put('IndexNumber', '0');
        meds.RemoveRefillCountFromList();
        meds.AddMore();

        system.currentPageReference().getParameters().put('IndexNumber', '0');
        meds.Edit();

        system.currentPageReference().getParameters().put('IndexNumber', '0');
        meds.SaveRefillCount();
        UtlizationReviewOrder__c  UOR = [select id from UtlizationReviewOrder__c limit 1];

        system.currentPageReference().getParameters().put('recId', UOR.Id);
        meds.CloseUOR();

        system.currentPageReference().getParameters().put('index', '0');
        meds.AddLI();

        system.currentPageReference().getParameters().put('UORID', '0');
        system.currentPageReference().getParameters().put('liIndex', '0');
        meds.EditLI();

        system.currentPageReference().getParameters().put('UORID', '0');
        system.currentPageReference().getParameters().put('liIndex', '0');
        meds.SaveLI();

        system.currentPageReference().getParameters().put('UORID', '0');
        system.currentPageReference().getParameters().put('liIndex', '0');
        meds.RemoveLI();
        meds.backToMeds();
        meds.getCurrentWeek();
        meds.getPreviousWeek();
        meds.GetNextWeek();
        
        test.stoptest();
    }

    static testmethod void TrgMARS() {

        test.starttest();

        Id MARsRTId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Client_Chart__c cl = new Client_Chart__c();
        cl.Treatment_Center__c = a.ID;
        cl.Primary_Therapist__c = UserINFO.getUserID();
        cl.Discharge_Date_Time__c = Datetime.now().addDays(30);
        cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cl;


        Taper__c taper = new Taper__c();
        taper.name = 'test';
        taper.Active__c = true;
        taper.Number_of_Days__c = 3;
        taper.Protocol__c = 'Detox Protocol';
        taper.dosage_type__c = 'Taper';
        insert taper;

        Taper_Line_Item__c tli = new Taper_Line_Item__c();
        tli.taper__c = taper.id;
        tli.medicine__c = medi.id;
        tli.Route__c = 'PO - By Mouth';
        tli.Strength__c = '10mg';
        tli.Frequency__c = frequency ;
        tli.Duration_in_Days__c = 1;
        insert tli;


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
        tliprn.Duration_in_Days__c = 1;
        insert tliprn;

        Taper_Line_Item__c tliprn2 = new Taper_Line_Item__c();
        tliprn2.taper__c = prn.id;
        tliprn2.medicine__c = medi.id;
        tliprn2.Route__c = 'PO - By Mouth';
        tliprn2.Strength__c = '10mg';
        tliprn2.Frequency__c = frequency ;
        tliprn2.Duration_in_Days__c = 2;
        insert tliprn2;

        Taper__c othertaper = new Taper__c();
        othertaper.name = 'test';
        othertaper.Active__c = true;
        othertaper.Number_of_Days__c = 3;
        othertaper.Protocol__c = 'Detox Protocol';
        othertaper.dosage_type__c = 'Consistent Dose';
        insert othertaper;

        Taper_Line_Item__c tliothertaper = new Taper_Line_Item__c();
        tliothertaper.taper__c = othertaper.id;
        tliothertaper.medicine__c = medi.id;
        tliothertaper.Route__c = 'PO - By Mouth';
        tliothertaper.Strength__c = '10mg';
        tliothertaper.Frequency__c = frequency ;
        tliothertaper.Duration_in_Days__c = 1;
        insert tliothertaper;

        Order__c o = new Order__c();
        o.Order_Type__c = 'Standard - Taper';
        o.Client_Chart__c = cl.id;
        o.Duration__c = 1;
        o.Status__c = 'Active';
        o.Start_Date__c = datetime.now();
        o.Order_By__c = Userinfo.getuserid();
        o.Taper__c = taper.id;
        insert o;
    
        Order_Line_Item__c ooo = new Order_Line_Item__c ();
        ooo.Order__c= o.id;
        ooo.medicine__c = medi.id;
        ooo.Route__c = 'PO - By Mouth';
        ooo.Dose__c = '10mg';
        ooo.Frequency__c = frequency ;
        ooo.Day__c = 1;
        insert ooo;

        OrderUtil.returnStandardOrder(o, cl.id, '', UserInfo.getUserId(), '', prn.id);
        OrderUtil.returnStandardMARs(ooo, o, '', cl.id);
        OrderUtil.returnStandardPRNOTHERMARs(ooo, o, '', true, cl.id);

        Event t = new Event();
        t.RecordTypeId = MARsRTId ;
        t.WhatId = o.id;

        t.Medicine__c = medi.id;
        t.PRN__c = false;
        t.Route_of_Delivery__c = 'PO - By Mouth';
        t.Frequency__c = frequency ;
        t.Status__c = 'Open';
        t.Client_Chart__c = cl.id;
        t.Day__c = 1;
        t.Taper_Line_Item__c = tli.id;
        t.Order_Line_Item__c = ooo.id;
        t.Remaining__c = 1;
        t.Remaining_Time__c = '7';
        t.StartDateTime = datetime.now();
        t.EndDateTime = datetime.now();
        t.Hide_Button_Date_Time__c = datetime.now();
        t.Missed_Time__c = datetime.now();
        insert t;

        t.Status__c = 'Administered';
        t.MARs_Administered__c = Datetime.now();
        update t;
        
        ooo.Status__c = 'Complete';
        update ooo;
        
        Event t2 = new Event();
        t2.RecordTypeId = MARsRTId ;
        t2.WhatId = o.id;

        t2.Medicine__c = medi.id;
        t2.PRN__c = false;
        t2.Route_of_Delivery__c = 'PO - By Mouth';
        t2.Frequency__c = 'Q8 Hours : Every 8 Hours';
        t2.Status__c = 'Open';
        t2.Client_Chart__c = cl.id;
        t2.Day__c = 1;
        t2.Taper_Line_Item__c = tli.id;
        t2.Remaining__c = 0;
        t2.Remaining_Time__c = '7';
        t2.StartDateTime = datetime.now();
        t2.EndDateTime = datetime.now();
        t2.Hide_Button_Date_Time__c = datetime.now();
        t2.Missed_Time__c = datetime.now();
        insert t2;

        t2.Status__c = 'Refused';
        t2.MARs_Refused__c = Datetime.now();
        update t2;


        Event QPM = new Event();
        QPM.RecordTypeId = MARsRTId ;
        QPM.WhatId = o.id;

        QPM.Medicine__c = medi.id;
        QPM.PRN__c = false;
        QPM.Route_of_Delivery__c = 'PO - By Mouth';
        QPM.Frequency__c = freqQAM ;
        QPM.Status__c = 'Open';
        QPM.Client_Chart__c = cl.id;
        QPM.Day__c = 1;
        QPM.Taper_Line_Item__c = tli.id;
        QPM.Remaining__c = 0;
        QPM.Remaining_Time__c = '7';
        QPM.StartDateTime = datetime.now().addDays(-2);
        QPM.EndDateTime = datetime.now();
        QPM.Hide_Button_Date_Time__c = datetime.now();
        QPM.Missed_Time__c = datetime.now();
        insert QPM;

        Event QAM = new Event();
        QAM.RecordTypeId = MARsRTId ;
        QAM.WhatId = o.id;

        QAM.Medicine__c = medi.id;
        QAM.PRN__c = false;
        QAM.Route_of_Delivery__c = 'PO - By Mouth';
        QAM.Frequency__c = freqQPM ;
        QAM.Status__c = 'Open';
        QAM.Client_Chart__c = cl.id;
        QAM.Day__c = 1;
        QAM.Taper_Line_Item__c = tli.id;
        QAM.Remaining__c = null;
        QAM.Remaining_Time__c = '7';
        QAM.StartDateTime = datetime.now();
        QAM.EndDateTime = datetime.now();
        QAM.Hide_Button_Date_Time__c = datetime.now();
        QAM.Missed_Time__c = datetime.now();
        insert QAM;

        test.stoptest();
    }

    static testMethod void TestMedicationRecord() {
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
        cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cl;

        Taper_Line_Item__c tli = new Taper_Line_Item__c();
        tli.Medicine__c = medi.Id;
        tli.Instructions__c = 'take 1-2 tablets as needed';
        tli.ExpirationDate__c = date.today();
        tli.Date_Received__c = date.today();
        tli.Date_Started__c = date.today();
        //tli.Prescribing_Physician__c = 'abc';
        //tli.Pharmacy_Name__c = 'abc';
        tli.Signature_Url__c = 'abc';
        tli.Strength__c = 'abc';
        tli.Amount_to_Use_Per_Dosage_Form__c = 'abc';
        tli.Presciption_Number__c = 'abc';
        tli.No_of_Refills__c = 'abc';
        //tli.Prescribing_Physician__c = UserINFO.getUserID();
        //tli.Pharmacy_Name__c = c.Id;
        //tli.Status__c =
        //     tli.Signature_Url__c
        insert tli;


        Test.setCurrentPageReference(Page.MedicationRecordsPage);

        system.currentPageReference().getParameters().put('id', cl.Id);
        system.currentPageReference().getParameters().put('rt', 'Monarch Shores');
        system.currentPageReference().getParameters().put('medicationToDestruct', '0');
        MedicationRecordsController controller = new MedicationRecordsController();
        system.currentPageReference().getParameters().put('medicationRecordType', 'CentrallyStoredRecord');
        controller.AddNewMedication();
        system.currentPageReference().getParameters().put('index', '0');
        controller.SaveTaperItem();
        controller.EditItem();
        controller.SaveTaperItem();
        system.currentPageReference().getParameters().put('signatureUrl', 'test');
        controller.SaveSignature();
         controller.backToMeds();
        controller.CopyToDestructMedication();

        test.stopTest();
    }
}