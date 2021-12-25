//Test Class : BedBoard_new_edit_Test
public class BedBoard_new_edit {
    
    public Bed_Board_Configuration__c house {get; set;}
    public Bed_Board_Configuration__c room {get; set;}
    public Bed_Board_Configuration__c bed {get; set;}
    
    public list<Bed_Board_Configuration__c> listOfRoomsToDisplay {get; set;}
    public list<Bed_Board_Configuration__c> listOfRooms {get; set;}
    public list<Bed_Board_Configuration__c> listOfBeds {get; set;}
    
    public map<string,string> mapOfRoomIdNumber {get; set;}
    
    public boolean isHouseReadOnly {get; set;}
    public boolean isRoomEdit {get; set;}
    public boolean isBedEdit {get; set;}
    public boolean isGenderEnabled {get; set;}
    
    public string RoomId {get; set;}
    public string RoomNum {get; set;}
    public string EditRoomId {get; set;}
    public string EditRoomNum {get; set;}
    public string DeleteRoomId {get; set;}
    public string EditBedId {get; set;}
    public string DeleteBedId {get; set;}
    
    public string houseId {get; set;}
    
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('BedBoardConfiguration');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    public BedBoard_new_edit()
    {
        house = new Bed_Board_Configuration__c();
        room = new Bed_Board_Configuration__c();
        bed = new Bed_Board_Configuration__c();
        listOfRooms = new list<Bed_Board_Configuration__c>();
        listOfBeds = new list<Bed_Board_Configuration__c>();
        listOfRoomsToDisplay = new list<Bed_Board_Configuration__c>();
        mapOfRoomIdNumber = new map<string,string>();
        isHouseReadOnly = false;
        isRoomEdit = true;
        isBedEdit = true;
        
        houseId = ApexPages.CurrentPage().getParameters().get('ID');
        if(houseId!= null)
        {
            house = [select id, Sunshine_Center__c, Sunshine_Center__r.name, House_Name__c, Address__c, House_Fax_Number__c, House_Phone_Number__c, House_Website__c  from Bed_Board_Configuration__c where id=:houseId];
            isHouseReadOnly = true;
        }
        
        String EditMode = ApexPages.CurrentPage().getParameters().get('edit');
        if(EditMode != null)
            isHouseReadOnly = false;
            
        getAllRooms();
        system.debug('#size='+listOfRoomsToDisplay.size());
        system.debug('#house='+house);
        
        string SunshineCenterName = ApexPages.CurrentPage().getParameters().get('rt');
        Sunshine_Center_Id__c sunshineCS = Sunshine_Center_Id__c.getValues(SunshineCenterName);
        isGenderEnabled = sunshineCS != null && sunshineCS.IsGenderSpecific__c;
    }
    
    public void addRooms()
    {
        Bed_Board_Configuration__c rooms = new Bed_Board_Configuration__c(House__c = house.id);
        listOfRooms.add(rooms);
        
    }
    
    public void addBeds()
    {
        system.debug('#RoomId='+RoomId);
        system.debug('#RoomNum='+RoomNum);
        if(RoomId!=null)
        {
            Bed_Board_Configuration__c room = [select id, Room_Number__c from Bed_Board_Configuration__c where id=:RoomId];
            Bed_Board_Configuration__c beds = new Bed_Board_Configuration__c(Room__c = room.id);
            listOfBeds.add(beds);
            mapOfRoomIdNumber.put(room.id,room.Room_Number__c);
        }
        else
        {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Please select Room to Add Bed');
            ApexPages.addMessage(errMsg);
        }
        
    }
    
    public void getAllRooms()
    {
        listOfRoomsToDisplay = new list<Bed_Board_Configuration__c>();
        if(house.Id != null)
        {
            for(Bed_Board_Configuration__c rooms : [select id, Room_Number__c, Gender__c, House__c, 
                                                    (select id, room__c, Bed_Number__c, room__r.Room_Number__c from Beds__r)
                                                    from Bed_Board_Configuration__c where House__c =: house.id])
            {
                listOfRoomsToDisplay.add(rooms);
            }
        }
        
        
    }
    
    public void editRoom()
    {
        isRoomEdit = false;
        if(EditRoomId!=null)
        {
            for(Bed_Board_Configuration__c rooms: listOfRoomsToDisplay)
            {
                if(rooms.id == EditRoomId)
                {
                    room = rooms;
                }
            }
        }
    }
    public void editBed()
    {
        system.debug('#EditBedId='+EditBedId);
        isBedEdit = false;
        if(EditBedId!=null)
        {
            for(Bed_Board_Configuration__c rooms: listOfRoomsToDisplay)
            {
                for(Bed_Board_Configuration__c beds : rooms.Beds__r)
                {
                    if(beds.id == EditBedId)
                    {
                        bed = beds;
                    }
                }
                
            }
        }
    }
    
    public void SaveEditBed()
    {
        upsert bed;
        isBedEdit = true;
        bed = new Bed_Board_Configuration__c();
    }
    
    public void SaveEditRoom()
    {
        upsert room;
        isRoomEdit = true;
        room = new Bed_Board_Configuration__c();
    }
    
    public void saveHouse()
    {
        upsert house;
        getAllRooms();
        isHouseReadOnly = true;
    }
    
    public void saveRoom()
    {
        upsert listOfRooms;
        listOfRooms.clear();
        getAllRooms();
    }
    
    public void saveBeds()
    {
        upsert listOfBeds;
        listOfBeds.clear();
        getAllRooms();
    }
    
    public void cancelEditRooms()
    {
        room = new Bed_Board_Configuration__c();
        isRoomEdit = true;
    }
    
    public void cancelEditBeds()
    {
        bed = new Bed_Board_Configuration__c();
        isBedEdit = true;
    }
    
    public void cancelRooms()
    {
        listOfRooms.clear();
    }
    
    public void cancelBeds()
    {
        listOfBeds.clear();
    }
    
    public void deleteRoom()
    {
        Bed_Board_Configuration__c roomToDel = new Bed_Board_Configuration__c();
        list<Bed_Board_Configuration__c> lstBedsToDel = new list<Bed_Board_Configuration__c>();
        if(DeleteRoomId!=null)
        {
            for(Bed_Board_Configuration__c rooms: listOfRoomsToDisplay)
            {
                if(rooms.id == DeleteRoomId)
                    roomToDel = rooms;
                
                for(Bed_Board_Configuration__c beds : rooms.Beds__r)
                {
                    if(DeleteRoomId == beds.room__c)
                    {
                        lstBedsToDel.add(beds);
                    }
                }
            }
        }
        
        if(lstBedsToDel.size()>0)
        {   
            delete lstBedsToDel;
            delete roomToDel;
        }
        
        getAllRooms();
    }
    
    public void deleteBed()
    {
        Bed_Board_Configuration__c bedToDel = new Bed_Board_Configuration__c();
        if(DeleteBedId!=null)
        {
            for(Bed_Board_Configuration__c rooms: listOfRoomsToDisplay)
            {
                for(Bed_Board_Configuration__c beds : rooms.Beds__r)
                {
                    if(DeleteBedId == beds.id)
                    {
                        bedToDel = beds;
                    }
                }
            }
        }
        
        if(bedToDel.id!=null)
        {   
            delete bedToDel;
        }
        
        getAllRooms();
        
        
    }
    
    public pageReference backToAllBed()
    {
        pageReference pr = new PageReference('/apex/AllBedInfo');
        pr.getParameters().put('rt',house.Sunshine_Center__r.name);
        pr.setRedirect(true);
        
        return pr; 
    }
}