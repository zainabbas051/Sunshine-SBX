@IsTest
private class BedBoardConfig_Test {
    public Static testmethod void BedBoardConfig_Test()
    {
        Test.startTest();
        PrepareData();
        PrepareData1();
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
         tv.Name = 'BedBoardRecord';
         tv.Button_Access_Type__c = 'Admin';
         insert tv;
        
        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Monarch Shores';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.Admit_Date_Time__c = dateTime.Now();
        ClientID.Bed__c = '';
        ClientID.Room__c = '';
        ClientID.Building__c = '';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert ClientID;
        
        //UtlizationReviewOrder__c uro = new UtlizationReviewOrder__c();
        
        //Id recordTypeId = 
        //Sunshine Center
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
        
        DateTime now = Datetime.now();
        
        UtlizationReviewOrder__c uro = new UtlizationReviewOrder__c();
        uro.Client_Chart__c = ClientId.Id;
        uro.Bed__c = bed.Id;
        uro.Status__c = 'Active';
        uro.Start_Date_Time__c = Datetime.now();
        uro.End_Date_Time__c = now.addDays(1);
        insert uro;
        
        UtlizationReviewOrder__c uro1 = new UtlizationReviewOrder__c();
        uro1.Client_Chart__c = ClientId.Id;
        uro1.Bed__c = bed.Id;
        uro1.Status__c = 'Active';
        uro1.Start_Date_Time__c = now.addDays(-3);
        uro1.End_Date_Time__c = now.addDays(-2);
        insert uro1;
        
        UtlizationReviewOrder__c uro2 = new UtlizationReviewOrder__c();
        uro2.Client_Chart__c = ClientId.Id;
        uro2.Bed__c = bed.Id;
        uro2.Status__c = 'Future Reservation';
        uro2.Start_Date_Time__c = now;
        uro2.End_Date_Time__c = now.addDays(1);
        insert uro2;
        
        
        
        UtlizationReviewOrder__c newReservation = new UtlizationReviewOrder__c();
        newReservation.Client_Chart__c = ClientId.Id;
        newReservation.Bed__c = bed.Id;
        newReservation.Status__c = 'Active';
        newReservation.Start_Date_Time__c = now.addDays(1).addHours(2);
        newReservation.End_Date_Time__c = now.addDays(2).addHours(2);
        insert newReservation;
        
        system.runAs(userAdmin){
            ApexPages.currentPage().getParameters().put('rt', 'Willowsprings Recovery');
            
            BedBoardConfig bbc= new BedBoardConfig();
            BedBoardConfig.BBCWrapper wrapper = new BedBoardConfig.BBCWrapper();
            
            bbc.SelectedClient = ClientID.Id;
            bbc.NewReservation = newReservation;
            //bbc.selectedReservation = uro;
            bbc.CurrentBed = uro2.Bed__c;
            bbc.futureReservation = uro2;
            
            
            //bbc.getUnassignedClients();
            bbc.getBedReservations();
            bbc.getHistoricReservations();
            bbc.hideHistory();
            bbc.getClientReservations();
            
            bbc.saveNewFutureRes();
            bbc.cancelFutureRes();
            bbc.cancelActiveRes();
            bbc.cancelNewRes();
            
            bbc.validateClientRes(newReservation);
            
            bbc.editCurrentRes();
            bbc.editFutureRes();
            bbc.addNewRes();
            bbc.redirectToFaceSheet();
            
            //Map<String, Client_Chart__c> myMap = new Map<String, Client_Chart__c>([Select Bed__c, Room__c, Building__c From Client_Chart__c where id=:ClientId.Id]);
            //bbc.mapOfClients.put(ClientId.Id,ClientId);
            
            Client_Chart__c clientToUpd = new Client_Chart__c();
            clientToUpd.Id = ClientId.Id;
            bbc.mapOfClients.put(clientToUpd.Id,clientToUpd);
            
            //bbc.mapOfClients = myMap;
            system.debug('#mapOfClients='+bbc.mapOfClients);
            bbc.futureReservation = [select id, bed__r.Bed_Number__c,bed__r.Room__r.Room_Number__c,
            							 bed__r.Room__r.House__r.House_Name__c,Status__c, Start_Date_Time__c, End_Date_Time__c, Client_Chart__c from UtlizationReviewOrder__c where id=:uro2.id];
            system.debug('#bbc.futureReservation='+bbc.futureReservation);
            bbc.lstFutureReservations.add(uro2);
            
            bbc.ActFutureResId = bbc.futureReservation.Id;
            bbc.activateFutureRes();
            bbc.closeActiveRes();
            
            
            bbc.updateActiveBedReservation();
            bbc.updateActiveClientReservation();
            
            
            
            bbc.updateFutureBedReservation();
            bbc.updateFutureClientReservation();
        
            
            wrapper.ActiveClient  = '';
            wrapper.ActiveClientId = null;
            wrapper.ActiveStartDT = DateTime.now();
            wrapper.ActiveEndDT = DateTime.now();
            
            wrapper.FutureClient = '';
            wrapper.FutureClientId = null;
            wrapper.FutureStartDT = DateTime.now();
            wrapper.FutureEndDT = DateTime.now();
            Boolean Flag = bbc.buttonAccessType;
            
            bbc.CurrentBed = uro1.Bed__c;
            bbc.selectedReservation = uro1;
            
            bbc.activateFutureRes();
            bbc.closeActiveRes();
            
        }
    }
    
    public static void PrepareData1(){
        
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
         tv.Name = 'BedBoardRecord';
         tv.Button_Access_Type__c = 'Admin';
         insert tv;
        
        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Monarch Shores';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.Admit_Date_Time__c = dateTime.Now();
        ClientID.Discharge_Date_Time__c = datetime.now().addDays(1);
        ClientID.Bed__c = '';
        ClientID.Room__c = '';
        ClientID.Building__c = '';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert ClientID;
        
        //UtlizationReviewOrder__c uro = new UtlizationReviewOrder__c();
        
        //Id recordTypeId = 
        //Sunshine Center
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
        
        DateTime now = Datetime.now();
        
        UtlizationReviewOrder__c uro = new UtlizationReviewOrder__c();
        uro.Client_Chart__c = ClientId.Id;
        uro.Bed__c = bed.Id;
        uro.Status__c = 'Active';
        uro.Start_Date_Time__c = Datetime.now();
        uro.End_Date_Time__c = now.addDays(2);
        insert uro;
        
        UtlizationReviewOrder__c uro1 = new UtlizationReviewOrder__c();
        uro1.Client_Chart__c = ClientId.Id;
        uro1.Bed__c = bed.Id;
        uro1.Status__c = 'Active';
        uro1.Start_Date_Time__c = now.addDays(-3);
        uro1.End_Date_Time__c = now.addDays(-2);
        insert uro1;
        
        UtlizationReviewOrder__c uro2 = new UtlizationReviewOrder__c();
        uro2.Client_Chart__c = ClientId.Id;
        uro2.Bed__c = bed.Id;
        uro2.Status__c = 'Future Reservation';
        uro2.Start_Date_Time__c = now;
        uro2.End_Date_Time__c = now.addDays(5);
        insert uro2;
        
        
        
        UtlizationReviewOrder__c newReservation = new UtlizationReviewOrder__c();
        newReservation.Client_Chart__c = ClientId.Id;
        newReservation.Bed__c = bed.Id;
        newReservation.Status__c = 'Active';
        newReservation.Start_Date_Time__c = now.addDays(1).addHours(2);
        newReservation.End_Date_Time__c = now.addDays(2).addHours(2);
        insert newReservation;
        
        system.runAs(userAdmin){
            ApexPages.currentPage().getParameters().put('rt', 'Willowsprings Recovery');
            
            BedBoardConfig bbc= new BedBoardConfig();
            BedBoardConfig.BBCWrapper wrapper = new BedBoardConfig.BBCWrapper();
            
            bbc.SelectedClient = ClientID.Id;
            bbc.NewReservation = newReservation;
            //bbc.selectedReservation = uro;
            bbc.CurrentBed = uro2.Bed__c;
            bbc.futureReservation = uro2;
            
            
            //bbc.getUnassignedClients();
            bbc.getBedReservations();
            bbc.getHistoricReservations();
            bbc.hideHistory();
            bbc.getClientReservations();
            
            bbc.saveNewFutureRes();
            bbc.cancelFutureRes();
            bbc.cancelActiveRes();
            bbc.cancelNewRes();
            
            bbc.validateClientRes(newReservation);
            
            bbc.editCurrentRes();
            bbc.editFutureRes();
            bbc.addNewRes();
            bbc.redirectToFaceSheet();
            
            bbc.mapOfClients.put(ClientId.Id,ClientId);
            bbc.futureReservation = [select id, bed__r.Bed_Number__c,bed__r.Room__r.Room_Number__c,
            							 bed__r.Room__r.House__r.House_Name__c,Status__c, Start_Date_Time__c, End_Date_Time__c, Client_Chart__c from UtlizationReviewOrder__c where id=:uro2.id];
            system.debug('#bbc.futureReservation='+bbc.futureReservation);
            bbc.lstFutureReservations.add(uro2);
            
            bbc.FutureResId = bbc.futureReservation.Id;
            //bbc.activateFutureRes();
            bbc.closeActiveRes();
            
            
            bbc.updateActiveBedReservation();
            bbc.updateActiveClientReservation();
            
            //bbc.futureReservation = uro2;
            
            bbc.updateFutureBedReservation();
            bbc.updateFutureClientReservation();
        	bbc.deleteFutureRes();
            
            wrapper.ActiveClient  = '';
            wrapper.ActiveClientId = null;
            wrapper.ActiveStartDT = DateTime.now();
            wrapper.ActiveEndDT = DateTime.now();
            
            wrapper.FutureClient = '';
            wrapper.FutureClientId = null;
            wrapper.FutureStartDT = DateTime.now();
            wrapper.FutureEndDT = DateTime.now();
            Boolean Flag = bbc.buttonAccessType;
            
            bbc.CurrentBed = uro1.Bed__c;
            bbc.selectedReservation = uro1;
            
            //bbc.activateFutureRes();
            bbc.closeActiveRes();
            
        }
    }
    
    
}