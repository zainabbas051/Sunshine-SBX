//Test Class : BedBoardConfig_Test
public class BedBoardConfig {
    
    public UtlizationReviewOrder__c selectedReservation {get; set;}
    public UtlizationReviewOrder__c futureReservation {get; set;}
    public UtlizationReviewOrder__c NewReservation {get; set;}
    
    
    public map<string,list<Bed_Board_Configuration__c>> mapOfHouseAndRooms {get; set;}
    public map<string,list<Bed_Board_Configuration__c>> mapOfRoomsAndBeds {get; set;}
    public map<string, UtlizationReviewOrder__c> mapOfActiveRes {get; set;}
    public map<string, UtlizationReviewOrder__c> mapOfFutureRes {get; set;}
    public map<string, UtlizationReviewOrder__c> mapOfActiveResOfClient {get; set;}
    public map<string, UtlizationReviewOrder__c> mapOfFutureResOfClient {get; set;}
    public map<string, string> mapClientNameID {get; set;}
    public map<string, Client_Chart__c> mapOfClients {get; set;}
    public map<string,list<Bed_Board_Configuration__c>> mapOfHouseAndBeds {get; set;}
    
    
    public list<Bed_Board_Configuration__c> listOfHouses {get; set;}
    public list<BBCWrapper> BBCList {get;set;}
    public list<UtlizationReviewOrder__c> lstFutureReservations {get;set;}
    public list<UtlizationReviewOrder__c> lstHistoryBedReservations {get;set;}
    public list<UtlizationReviewOrder__c> lstUnassignedClients {get;set;}
    
    public list<SelectOption> listOfClients {get; set;}
    
    public set<string> setUnAsgnClients {get; set;}
    
    public string RecordTypeName {get;set;}
    public string SelectedClient {get;set;}
    public string CurrentHouse {get;set;}
    public string CurrentBed {get; set;}
    public string CurrentBedNum {get; set;}
    public string CurrentRoomNum {get; set;}
    public string CurrentHouseName {get; set;}
    public string CurrentClientId {get; set;}
    public string CurrentClientName {get; set;}
    public string FutureResId {get;set;}
    public string ActFutureResId {get;set;}
    public string ClientIdToRedirect {get;set;}
    
    public boolean isEditRes {get; set;}
    public boolean isEditFutRes {get; set;}
    public boolean isAddNewRes {get; set;}
    public boolean isNewResEdit {get; set;}
    public boolean showHistory {get; set;}
    public boolean isGenderEnabled {get; set;}
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('BedBoardRecord');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    public BedBoardConfig()
    {
        RecordTypeName = ApexPages.CurrentPage().getParameters().get('rt');
        SelectedClient = '';
        CurrentHouse = '';
        CurrentBed = '';
        CurrentBedNum = '';
        CurrentRoomNum = '';
        CurrentHouseName = '';
        CurrentClientId = '';
        CurrentClientName = '';
        FutureResId = '';
        ActFutureResId = '';
        ClientIdToRedirect = '';
        
        selectedReservation = new UtlizationReviewOrder__c();
        futureReservation = new UtlizationReviewOrder__c();
        NewReservation = new UtlizationReviewOrder__c();
        isEditRes = false;
        isEditFutRes = false;
        isAddNewRes = false;
        isNewResEdit = false;
        showHistory = false;
        mapOfHouseAndRooms = new map<string,list<Bed_Board_Configuration__c>>();
        mapOfRoomsAndBeds = new map<string,list<Bed_Board_Configuration__c>>();
        mapOfActiveRes = new map<string, UtlizationReviewOrder__c>();
        mapOfFutureRes = new map<string, UtlizationReviewOrder__c>();
        mapOfActiveResOfClient = new map<string, UtlizationReviewOrder__c>();
        mapOfFutureResOfClient = new map<string, UtlizationReviewOrder__c>();
        mapClientNameID = new map<string, string>();
        mapOfClients = new map<string, Client_Chart__c>();
        mapOfHouseAndBeds = new map<string,list<Bed_Board_Configuration__c>>();
        
        listOfHouses = new list<Bed_Board_Configuration__c>();
        lstFutureReservations = new list<UtlizationReviewOrder__c>();
        lstHistoryBedReservations = new list<UtlizationReviewOrder__c>();
        listOfClients = new list<SelectOption>();
        lstUnassignedClients = new list<UtlizationReviewOrder__c>();
        
        setUnAsgnClients = new set<string>();
        
        loadData();
        
        BBCList = new List<BBCWrapper>();
        
        fillWrapperList();
        
        getClientsOnRecType();
        
        Sunshine_Center_Id__c sunshineCS = Sunshine_Center_Id__c.getValues(RecordTypeName);
        isGenderEnabled = sunshineCS != null && sunshineCS.IsGenderSpecific__c;
        
        System.debug('BBCList:: '+ JSON.serialize(BBCList) );
    }
    
    public void loadData()
    {
        set<string> setOfHouseIds = new set<string>();
        
        for(UtlizationReviewOrder__c uri : [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,Client_Chart__r.U_R_Location__c,
                                                Start_Date_Time__c, End_Date_Time__c, Status__c, Client_Chart__r.Discharge_Date_Time__c, Client_Chart__r.Admit_Date_Time__c,
                                                Client_Chart__r.Client_Status__c from UtlizationReviewOrder__c 
                                                where Bed__c != null AND Client_Chart__c != NULL])
        {
            if(uri.status__c == 'Active')
            {
                mapOfActiveRes.put(uri.Bed__c, uri);
                mapOfActiveResOfClient.put(uri.Client_Chart__c, uri);
            }
                
            
            else if(uri.status__c == 'Future Reservation')
            {
                mapOfFutureRes.put(uri.Bed__c, uri);
                mapOfFutureResOfClient.put(uri.Client_Chart__c, uri);
            }
        }
        
        
        for(Bed_Board_Configuration__c beds: [select id,Bed_Number__c, Room__c, Room__r.Room_Number__c, 
                                                Room__r.House__c, Room__r.House__r.House_Name__c from Bed_Board_Configuration__c 
                                                where Room__c != null AND Room__r.House__r.Sunshine_Center__r.Name =: RecordTypeName])
        {
            if(mapOfRoomsAndBeds.containsKey(beds.Room__c))
            {
                list<Bed_Board_Configuration__c> listBeds = new list<Bed_Board_Configuration__c>();
                listBeds = mapOfRoomsAndBeds.get(beds.Room__c);
                listBeds.add(beds);
                mapOfRoomsAndBeds.put(beds.Room__c, listBeds);
            }
            else
            {
                list<Bed_Board_Configuration__c> listBeds = new list<Bed_Board_Configuration__c>();
                listBeds.add(beds);
                mapOfRoomsAndBeds.put(beds.Room__c, listBeds);
            }
            
            setOfHouseIds.add(beds.Room__r.House__c);
            
            if(!mapOfActiveRes.containskey(beds.id))
            {
                UtlizationReviewOrder__c uri = new UtlizationReviewOrder__c();
                mapOfActiveRes.put(beds.id, uri);
            }
            if(!mapOfFutureRes.containskey(beds.id))
            {
                UtlizationReviewOrder__c uri = new UtlizationReviewOrder__c();
                mapOfFutureRes.put(beds.id, uri);
            }
            
            if(mapOfHouseAndBeds.containsKey(beds.Room__r.House__c))
            {
                list<Bed_Board_Configuration__c> listBeds = new list<Bed_Board_Configuration__c>();
                listBeds = mapOfHouseAndBeds.get(beds.Room__r.House__c);
                listBeds.add(beds);
                mapOfHouseAndBeds.put(beds.Room__r.House__c, listBeds);
            }
            else
            {
                list<Bed_Board_Configuration__c> listBeds = new list<Bed_Board_Configuration__c>();
                listBeds.add(beds);
                mapOfHouseAndBeds.put(beds.Room__r.House__c, listBeds);
            }
        }
        
        for(Bed_Board_Configuration__c rooms : [select id, Room_Number__c,Gender__c ,House__c from  Bed_Board_Configuration__c
                                                    where House__c in: setOfHouseIds order by Room_Number__c ASC])
        {
            if(mapOfHouseAndRooms.containsKey(rooms.House__c))
            {
                list<Bed_Board_Configuration__c> listRooms = new list<Bed_Board_Configuration__c>();
                listRooms = mapOfHouseAndRooms.get(rooms.House__c);
                listRooms.add(rooms);
                mapOfHouseAndRooms.put(rooms.House__c, listRooms);
            }
            else
            {
                list<Bed_Board_Configuration__c> listRooms = new list<Bed_Board_Configuration__c>();
                listRooms.add(rooms);
                mapOfHouseAndRooms.put(rooms.House__c, listRooms);
            }       
        }
        
        for(Bed_Board_Configuration__c houses : [select id, House_Name__c , Sunshine_Center__c from Bed_Board_Configuration__c
                                                    where id in : setOfHouseIds])
        {
            listOfHouses.add(houses);
        }
        
    }
    
    public void fillWrapperList()
    {
        for(Bed_Board_Configuration__c house : listOfHouses)
        {
            Id HouseId = house.Id;
            string HouseName = house.House_Name__c;
            
            system.debug('#House='+house.House_Name__c);
            
            list<Bed_Board_Configuration__c> houserooms = mapOfHouseAndRooms.get(house.Id);
            integer roomsize = 0;
            boolean setRoomSize = true;
            for(Bed_Board_Configuration__c houseroom : houserooms)
            {
                Id RoomId = houseroom.Id;
                string RoomNumber = houseroom.Room_Number__c;
                string RoomGender =  houseroom.Gender__c;
                
                system.debug('#Room='+houseroom.Room_Number__c);
                system.debug('#RoomSize='+houserooms.size());
                
                list<Bed_Board_Configuration__c> roombeds = mapOfRoomsAndBeds.get(houseroom.Id);
                boolean setBedSize = true;
                integer bedsize = 0;
                
                for(Bed_Board_Configuration__c roombed : roombeds)
                {
                    BBCWrapper bbc = new BBCWrapper();
                    roomsize = houserooms.size();
                    bedsize = roombeds.size();
                    //integer totalroomsize = roomsize * bedsize;
                    bbc.HouseId = HouseId;
                    bbc.HouseName = HouseName;
                    bbc.RoomId = RoomId;
                    bbc.RoomNumber  = RoomNumber;
                    bbc.RoomGender = RoomGender;
                    bbc.BedId = roombed.Id;
                    bbc.BedNumber = roombed.Bed_Number__c;
                    bbc.RoomSize = 0;
                    bbc.BedSize = 0;
                    bbc.activeReservation = mapOfActiveRes.get(roombed.Id);
                    bbc.futureReservation = mapOfFutureRes.get(roombed.Id);
                    //integer totalroomsize = roomsize * bedsize;
                    if(setRoomSize == true)
                    {
                        bbc.RoomSize = mapOfHouseAndBeds.get(house.id).size();//roomsize;//totalroomsize;
                        setRoomSize = false;
                    }
                    if(setBedSize == true)
                    {
                        bbc.BedSize = bedsize;
                        setBedSize = false;
                    }
                    BBCList.add(bbc);
                    system.debug('#bbc.RoomSize='+bbc.RoomSize);
                    system.debug('#BedSize='+bbc.BedSize);
                    system.debug('BBCList='+BBCList);
                }
            }
        }
        
        
    }
    
    /*public void getUnassignedClients()
    {
        for(UtlizationReviewOrder__c uri: [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,
                                        Start_Date_Time__c, End_Date_Time__c, Status__c from UtlizationReviewOrder__c 
                                        where Status__c = 'Future Reservation' AND Client_Chart__r.Client_Status__c = 'Admitted'
                                        AND Client_Chart__r.Recordtype.name =: RecordTypeName])
        {
            setUnAsgnClients.add(uri.Client_Chart__r.Name);
        }
    
    
    }*/
    
    public void getBedReservations()
    {
        
        selectedReservation = mapOfActiveRes.get(CurrentBed);
        lstFutureReservations = [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,
                                        Client_Chart__r.Gender__c,Start_Date_Time__c, End_Date_Time__c, Status__c,
                                        Bed__r.Room__r.Gender__c, bed__r.Room__r.Room_Number__c,bed__r.Room__r.House__r.House_Name__c,
                                        Client_Chart__r.Discharge_Date_Time__c, Client_Chart__r.Admit_Date_Time__c,Client_Chart__r.Client_Status__c from UtlizationReviewOrder__c 
                                        where Bed__c =: CurrentBed AND Status__c = 'Future Reservation' AND Client_Chart__c != null];
                                        
    }
    
    public void getHistoricReservations()
    {
        if(CurrentBed !='' && !string.isBlank(CurrentBed))
        {
            lstHistoryBedReservations = [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,
                                        Start_Date_Time__c, End_Date_Time__c, Status__c, Client_Chart__r.Client_Status__c from UtlizationReviewOrder__c 
                                        where Bed__c =: CurrentBed AND Status__c = 'Closed' order by LastModifiedDate desc limit 5];
        }
        else if(CurrentClientId !='' && !string.isBlank(CurrentClientId))
        {
            lstHistoryBedReservations = [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,
                                        Start_Date_Time__c, End_Date_Time__c, Status__c, Client_Chart__r.Client_Status__c from UtlizationReviewOrder__c 
                                        where Client_Chart__c =: CurrentClientId AND Status__c = 'Closed' order by LastModifiedDate desc limit 5];
        }
        showHistory = true;
        if(lstHistoryBedReservations.size()<1)
        {
            Apexpages.Message warningMsg = new Apexpages.Message(ApexPages.Severity.WARNING,'No history has been found');
            ApexPages.addMessage(warningMsg);
        }
            
    }
    public void hideHistory()
    {
        showHistory = false;
    }
    
    public void getClientReservations()
    {
        if(CurrentClientName!='' && !string.isBlank(CurrentClientName))
        {
            CurrentClientId = mapClientNameID.get(CurrentClientName);
        }
        
        if(mapOfActiveResOfClient.containsKey(CurrentClientId))
            selectedReservation = mapOfActiveResOfClient.get(CurrentClientId);
        
        lstFutureReservations = [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,BedNumber__c,RoomNumber__c,HouseName__c,
                                        Client_Chart__r.Gender__c,Start_Date_Time__c, End_Date_Time__c, Status__c, 
                                        Bed__r.Room__r.Gender__c, bed__r.Room__r.Room_Number__c,bed__r.Room__r.House__r.House_Name__c,
                                        Client_Chart__r.Discharge_Date_Time__c, Client_Chart__r.Admit_Date_Time__c, Client_Chart__r.Client_Status__c 
                                        from UtlizationReviewOrder__c 
                                        where Client_Chart__c =: CurrentClientId AND Status__c = 'Future Reservation'
                                        AND Bed__c != null];
        
        system.debug('#Act='+selectedReservation);
        system.debug('#fut='+futureReservation);    
    }
    
    public void updateActiveBedReservation()
    {
        list<UtlizationReviewOrder__c> lstOfExsRes = [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,
                                                        Start_Date_Time__c, End_Date_Time__c, Status__c, Client_Chart__r.Discharge_Date_Time__c,
                                                        Client_Chart__r.Admit_Date_Time__c, Client_Chart__r.Client_Status__c from UtlizationReviewOrder__c 
                                                        where Bed__c =: selectedReservation.Bed__c AND Client_Chart__c != NULL 
                                                        AND Id!= :selectedReservation.Id AND Status__c != 'Closed'];
        
        
        if(validateDates(selectedReservation,lstOfExsRes)  && validateClientRes(selectedReservation))
        {
            update selectedReservation;
            isEditRes = false;
            Apexpages.Message successMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Record has been saved successfully');
            ApexPages.addMessage(successMsg);
        }
    }
    
    public void updateFutureBedReservation()
    {
        list<UtlizationReviewOrder__c> lstOfExsRes = [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,
                                                        Start_Date_Time__c, End_Date_Time__c, Status__c,Client_Chart__r.Discharge_Date_Time__c,
                                                        Client_Chart__r.Admit_Date_Time__c, Client_Chart__r.Client_Status__c from UtlizationReviewOrder__c 
                                                        where Bed__c =: futureReservation.Bed__c AND Client_Chart__c != NULL 
                                                        AND Id!= :futureReservation.Id AND Status__c != 'Closed'];
        
        if(validateDates(futureReservation,lstOfExsRes) && validateClientRes(futureReservation))
        {
            update futureReservation;
            isEditFutRes = false;
            Apexpages.Message successMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Record has been saved successfully');
            ApexPages.addMessage(successMsg);
        }
    }
    
    public void updateActiveClientReservation()
    {
        list<UtlizationReviewOrder__c> lstOfExsRes = [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,
                                                        Start_Date_Time__c, End_Date_Time__c, Status__c, Client_Chart__r.Discharge_Date_Time__c,
                                                        Client_Chart__r.Admit_Date_Time__c, Client_Chart__r.Client_Status__c from UtlizationReviewOrder__c 
                                                        where Bed__c != NULL AND Client_Chart__c =:selectedReservation.Client_Chart__c 
                                                        AND Id!= :selectedReservation.Id AND Status__c != 'Closed'];
        
        
        if(validateDates(selectedReservation,lstOfExsRes) && validateClientRes(selectedReservation))
        {
            update selectedReservation;
            isEditRes = false;
            Apexpages.Message successMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Record has been saved successfully');
            ApexPages.addMessage(successMsg);
        }
    }
    
    public void updateFutureClientReservation()
    {
        list<UtlizationReviewOrder__c> lstOfExsRes = [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,
                                                        Start_Date_Time__c, End_Date_Time__c, Status__c, Client_Chart__r.Discharge_Date_Time__c,
                                                        Client_Chart__r.Admit_Date_Time__c, Client_Chart__r.Client_Status__c from UtlizationReviewOrder__c 
                                                        where Bed__c != NULL AND Client_Chart__c =:futureReservation.Client_Chart__c 
                                                        AND Id!= :futureReservation.Id AND Status__c != 'Closed'];
        
        if(validateDates(futureReservation,lstOfExsRes) && validateClientRes(futureReservation))
        {
            update futureReservation;
            isEditFutRes = false;
            Apexpages.Message successMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Record has been saved successfully');
            ApexPages.addMessage(successMsg);
        }
    }
    
    public void saveNewFutureRes()
    {
        list<UtlizationReviewOrder__c> lstOfExsRes = [select id, Bed__c, Bed__r.Bed_Number__c, Client_Chart__c, Client_Chart__r.Name,
                                                        Start_Date_Time__c, End_Date_Time__c, Status__c, Client_Chart__r.Discharge_Date_Time__c,
                                                        Client_Chart__r.Admit_Date_Time__c, Client_Chart__r.Client_Status__c from UtlizationReviewOrder__c 
                                                        where Bed__c =: NewReservation.Bed__c AND Client_Chart__c != NULL 
                                                        AND Status__c != 'Closed'];
        
        NewReservation.Client_Chart__c = SelectedClient;
        if(validateDates(NewReservation,lstOfExsRes) && validateClientRes(NewReservation))
        {   upsert NewReservation;
            isNewResEdit = false;
            Apexpages.Message successMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Record has been saved successfully');
            ApexPages.addMessage(successMsg);
        }
    }
    
    public void cancelFutureRes()
    {
        isEditFutRes = false;
    }
    public void cancelActiveRes()
    {
        isEditRes = false;
    }
    
    public void closeActiveRes()
    {
        if(selectedReservation.End_Date_Time__c <= datetime.now())
        {
            Client_Chart__c clientToUpdate = new Client_Chart__c();
            clientToUpdate = mapOfClients.get(selectedReservation.Client_Chart__c);
            
            selectedReservation.Status__c = 'Closed';
            
            clientToUpdate.Bed__c = '';
            clientToUpdate.Room__c = '';
            clientToUpdate.Building__c = '';
            update selectedReservation;
            update clientToUpdate;
            
            Apexpages.Message successMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Record has been saved successfully');
            ApexPages.addMessage(successMsg);
        }
        else
        {
            Apexpages.Message errorMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Reservation can not be closed before End Date Time');
            ApexPages.addMessage(errorMsg);
        }
    }
    
    public void activateFutureRes()
    {
        integer indexToRem = 0;
        UtlizationReviewOrder__c uriToActvt = new UtlizationReviewOrder__c();
        for(UtlizationReviewOrder__c uri :lstFutureReservations)
        {
            if(ActFutureResId == uri.id)
            {
                uriToActvt = uri;
                break;
            }
            indexToRem++;   
        }
        
        if(mapOfActiveResOfClient.containsKey(uriToActvt.Client_Chart__c))
        {
            String frmtStDt = mapOfActiveResOfClient.get(uriToActvt.Client_Chart__c).Start_Date_Time__c.format('MM-dd-yyyy hh:mm a');
            String frmtEnDt = mapOfActiveResOfClient.get(uriToActvt.Client_Chart__c).End_Date_Time__c.format('MM-dd-yyyy hh:mm a');
            
            Apexpages.Message errorMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'There is already a current booking between '+ frmtStDt+' and '+frmtEnDt);
            ApexPages.addMessage(errorMsg);
            return;
        }
        
        if(isGenderEnabled && uriToActvt.Bed__r.Room__r.Gender__c != uriToActvt.Client_Chart__r.Gender__c)
        {
            Apexpages.Message errorMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Gender of Room and Client must be same');
            ApexPages.addMessage(errorMsg);
            return;
        }
        
        /*if(uriToActvt.End_Date_Time__c > uriToActvt.Client_Chart__r.Discharge_Date_Time__c || 
            uriToActvt.Start_Date_Time__c > uriToActvt.Client_Chart__r.Discharge_Date_Time__c)
        {
            String formattedDt = uriToActvt.Client_Chart__r.Discharge_Date_Time__c.format('MM-dd-yyyy hh:mm a');
            
            Apexpages.Message errorMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Start / End Date Time should be before: '+ formattedDt);
            ApexPages.addMessage(errorMsg);
            return;
        }*/
        //if(uriToActvt.Start_Date_Time__c <= datetime.now())
        //{
            uriToActvt.Status__c = 'Active';
            Client_Chart__c clientToUpdate = new Client_Chart__c(id=uriToActvt.Client_Chart__c);
            system.debug('URO BED ::' +uriToActvt.Bed__r.Bed_Number__c);
            clientToUpdate.Bed__c =  uriToActvt.Bed__r.Bed_Number__c;
            clientToUpdate.Room__c =  uriToActvt.Bed__r.Room__r.Room_Number__c;
            clientToUpdate.Building__c =  uriToActvt.Bed__r.Room__r.House__r.House_Name__c;
            update uriToActvt;
            update clientToUpdate;
            lstFutureReservations.remove(indexToRem);
            Apexpages.Message successMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Record has been saved successfully');
            ApexPages.addMessage(successMsg);
        //}
        /*else
        {
            Apexpages.Message errorMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Reservation can not be activated before Start Date Time');
            ApexPages.addMessage(errorMsg);
            return;
        }
        */
        
    }
    
    public boolean validateDates(UtlizationReviewOrder__c newReservation, list<UtlizationReviewOrder__c> lstOldReservation)
    {
        
        for(UtlizationReviewOrder__c existingRes : lstOldReservation)
        {
            string startDtExistStr = string.valueOf(existingRes.Start_Date_Time__c).replaceAll('-','').replaceAll(':','').replace(' ','');
            string endDtExistStr = string.valueOf(existingRes.End_Date_Time__c).replaceAll('-','').replaceAll(':','').replace(' ','');
            string startDtNewStr = string.valueOf(newReservation.Start_Date_Time__c).replaceAll('-','').replaceAll(':','').replace(' ','');
            string endDtNewStr = string.valueOf(newReservation.End_Date_Time__c).replaceAll('-','').replaceAll(':','').replace(' ','');
            
            long startDtExistLong = long.valueOf(startDtExistStr);
            long endDtExistLong = long.valueOf(endDtExistStr);
            long startDtNewLong = long.valueOf(startDtNewStr);
            long endDtNewLong = long.valueOf(endDtNewStr);
            
            long ExsEndDt = existingRes.End_Date_Time__c.getTime();
            long NewStrDt = newReservation.Start_Date_Time__c.getTime();
            long diffInHours = (NewStrDt - ExsEndDt)/(1000 * 60 * 60);
            
            if(startDtNewLong > endDtNewLong)
            {
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'End Date can not be before Start Date');
                ApexPages.addMessage(errMsg);
                system.debug('@@Start Date is Larger:'+startDtNewLong+'edNew:'+endDtNewLong);
                return false;
                break;
            }
            else if(startDtNewLong >= startDtExistLong && startDtNewLong <= endDtExistLong)
            {
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Bed Not Available, Please adjust your Date/Time');
                ApexPages.addMessage(errMsg);
                system.debug('@@Start Date is between:'+startDtNewLong+'stEx:'+startDtExistLong+'sdNew:'+startDtNewLong+'edEx:'+endDtExistLong);
                return false;
                break;
            }
            else if(endDtNewLong >= startDtExistLong && endDtNewLong <= endDtExistLong)
            {
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Bed Not Available, Please adjust your Date/Time');
                ApexPages.addMessage(errMsg);
                system.debug('@@End Date is between:'+endDtNewLong+'stEx:'+startDtExistLong+'edNew:'+endDtNewLong+'edEx:'+endDtExistLong);
                return false;
                break;
            }
            else if(startDtNewLong <= startDtExistLong && endDtNewLong >= endDtExistLong)
            {
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Bed Not Available, Please adjust your Date/Time');
                ApexPages.addMessage(errMsg);
                system.debug('@@existing Date is between:'+startDtNewLong+'stEx:'+startDtExistLong+'edNew:'+endDtNewLong+'edEx:'+endDtExistLong);
                return false;
                break;
            }
            /*else if(diffInHours < 2 && diffInHours>0)
            {
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'There should be a difference of minimum 2 hours between Reservations');
                ApexPages.addMessage(errMsg);
                system.debug('@@Difference is not 2 hours'+diffInHours);
                return false;
                break;
            }
            */
        }
        if((newReservation.End_Date_Time__c > newReservation.Client_Chart__r.Discharge_Date_Time__c || 
            newReservation.End_Date_Time__c < newReservation.Client_Chart__r.Admit_Date_Time__c) && newReservation.Status__c == 'Active')
        {
            String formattedEnDt = newReservation.Client_Chart__r.Discharge_Date_Time__c.format('MM-dd-yyyy hh:mm a');
            String formattedStDt = newReservation.Client_Chart__r.Admit_Date_Time__c.format('MM-dd-yyyy hh:mm a');
            
            Apexpages.Message errorMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'End Date Time should be between: '+ formattedStDt + ' and '+ formattedEnDt);
            ApexPages.addMessage(errorMsg);
            return false;
        }
        if((newReservation.Start_Date_Time__c < newReservation.Client_Chart__r.Admit_Date_Time__c || 
            newReservation.Start_Date_Time__c > newReservation.Client_Chart__r.Discharge_Date_Time__c) && newReservation.Status__c == 'Active')
        {
            String formattedEnDt = newReservation.Client_Chart__r.Discharge_Date_Time__c.format('MM-dd-yyyy hh:mm a');
            String formattedStDt = newReservation.Client_Chart__r.Admit_Date_Time__c.format('MM-dd-yyyy hh:mm a');
            
            Apexpages.Message errorMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Start Date Time should be between: '+ formattedStDt + ' and '+ formattedEnDt);
            ApexPages.addMessage(errorMsg);
            return false;
        }
        return true;
    }
    
    
    public boolean validateClientRes(UtlizationReviewOrder__c newReservation)
    {
        for(UtlizationReviewOrder__c existingRes : [select id, Bed__c, Client_Chart__c, Start_Date_Time__c, End_Date_Time__c,
                                                            Status__c from UtlizationReviewOrder__c where Client_Chart__c =: newReservation.Client_Chart__c
                                                            AND Id!=:newReservation.Id AND Bed__c != NULL AND Status__c != 'Closed'])
        {
            string startDtExistStr = string.valueOf(existingRes.Start_Date_Time__c).replaceAll('-','').replaceAll(':','').replace(' ','');
            string endDtExistStr = string.valueOf(existingRes.End_Date_Time__c).replaceAll('-','').replaceAll(':','').replace(' ','');
            string startDtNewStr = string.valueOf(newReservation.Start_Date_Time__c).replaceAll('-','').replaceAll(':','').replace(' ','');
            string endDtNewStr = string.valueOf(newReservation.End_Date_Time__c).replaceAll('-','').replaceAll(':','').replace(' ','');
            
            long startDtExistLong = long.valueOf(startDtExistStr);
            long endDtExistLong = long.valueOf(endDtExistStr);
            long startDtNewLong = long.valueOf(startDtNewStr);
            long endDtNewLong = long.valueOf(endDtNewStr);
            
            if(startDtNewLong > endDtNewLong)
            {
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'End Date can not be before Start Date');
                ApexPages.addMessage(errMsg);
                return false;
                break;
            }
            
            else if(startDtNewLong >= startDtExistLong && startDtNewLong <= endDtExistLong)
            {
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Client has already booked during this duration');
                ApexPages.addMessage(errMsg);
                return false;
                break;
            }
            else if(endDtNewLong >= startDtExistLong && endDtNewLong <= endDtExistLong)
            {
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Client has already booked during this duration');
                ApexPages.addMessage(errMsg);
                return false;
                break;
            }
            else if(startDtNewLong <= startDtExistLong && endDtNewLong >= endDtExistLong)
            {
                Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Client has already booked during this duration');
                ApexPages.addMessage(errMsg);
                return false;
                break;
            }
            
        }
        return true;
    }
    
    public void editCurrentRes()
    {
        isEditRes = true;
    }
    
    public void editFutureRes()
    {
        futureReservation = new UtlizationReviewOrder__c();
        System.debug('lstFutureReservations: '+lstFutureReservations);
        for(UtlizationReviewOrder__c uri :lstFutureReservations)
        {
            if(FutureResId == uri.id)
            {
                futureReservation = uri;
                isEditFutRes = true;
                break;
            }   
        }
        
    }
    
    public void deleteFutureRes()
    {
        futureReservation = new UtlizationReviewOrder__c();
        System.debug('lstFutureReservations: '+lstFutureReservations);
        for(UtlizationReviewOrder__c uri :lstFutureReservations)
        {
            if(FutureResId == uri.id)
            {
                futureReservation = uri;
                //isEditFutRes = true;
                break;
            }   
        }
        try
        {
            delete futureReservation;
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Reservation has been deleted. Please refresh the screen to see changes.');
            ApexPages.addMessage(errMsg);
        }
        catch(exception ex)
        {
            system.debug('exc='+ex);
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'An error has occured');
            ApexPages.addMessage(errMsg);
        }
        
    }
    
    public void deleteCurrentRes()
    {
        try
        {
            Client_Chart__c clientToUpdate = new Client_Chart__c(id = selectedReservation.Client_Chart__c);
            clientToUpdate.Bed__c = '';
            clientToUpdate.Room__c = '';
            clientToUpdate.Building__c = '';
            update clientToUpdate;
            
            delete selectedReservation;
            
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Reservation has been deleted. Please refresh the screen to see changes.');
            ApexPages.addMessage(errMsg);
        }
        catch(exception ex)
        {
            system.debug('exc='+ex);
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'An error has occured');
            ApexPages.addMessage(errMsg);
        }
        
    }
    
    public void addNewRes()
    {
        isAddNewRes = true;
        isNewResEdit = true;
        NewReservation.Bed__c = CurrentBed;
        NewReservation.Status__c = 'Future Reservation';
        
    }
    
    public void cancelNewRes()
    {
        isAddNewRes = false;
    }
    
    public void getClientsOnRecType()
    {
        listOfClients = new list<SelectOption>();
        
        for(Client_Chart__c client :[select id, name, Building__c, Room__c, Bed__c, Client_Status__c from Client_Chart__c
                                         where RecordType.name =: RecordTypeName AND (Client_Status__c = 'Admitted' OR Client_Status__c ='Pre Admission') Order by Name])
        {
            listOfClients.add(new SelectOption(client.id, client.name));
            mapClientNameID.put(client.name, client.id);
            mapOfClients.put(client.id, client);
            
            if(!mapOfActiveResOfClient.containsKey(client.id) && client.Client_Status__c == 'Admitted')
                setUnAsgnClients.add(client.Name);
        }
        
    }
    
    public pageReference redirectToFaceSheet()
    {
        pageReference pr = new PageReference('/apex/FaceSheetHomePage');
        pr.getParameters().put('ID',ClientIdToRedirect);
        pr.getParameters().put('rt',RecordTypeName);
        pr.setRedirect(true);
        
        return pr;
    }
    
    public class BBCWrapper{
        public Id HouseId {get;set;}
        public string HouseName {get;set;}
        
        public Id RoomId {get;set;}
        public string RoomNumber {get;set;}
        public string RoomGender {get;set;}
        
        public Id BedId {get;set;}
        public string BedNumber {get;set;}
        
        public integer RoomSize {get;set;}
        public integer bedsize {get;set;}
        
        public UtlizationReviewOrder__c activeReservation {get; set;}
        
        public UtlizationReviewOrder__c futureReservation {get; set;}
        
        public string ActiveClient {get;set;}
        public Id ActiveClientId {get;set;}
        public DateTime ActiveStartDT {get;set;}
        public DateTime ActiveEndDT {get;set;}
        
        public string FutureClient {get;set;}
        public Id FutureClientId {get;set;}
        public DateTime FutureStartDT {get;set;}
        public DateTime FutureEndDT {get;set;}
        
    }
    
}