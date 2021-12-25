//Test Class : AllBedInfo_Test
public class AllBedInfo
{
    public Bed_Board_Configuration__c newHouse {get; set;}
    
    public list<Bed_Board_Configuration__c> listOfHouseToDisplay {get; set;}
    public Map<Id,list<Bed_Board_Configuration__c>> listOfRoomToDisplay  {get; set;}
    public Map<Id,list<Bed_Board_Configuration__c>> listOfBedToDisplay  {get; set;}
    public list<Bed_Board_Configuration__c> listOfRoom ;
    public string SunshineCenter {get; set;}
    Set<String> SetOfHouseId = new Set<String>();
    Set<String> SetOfRoomId = new Set<String>();
    
    public boolean addHouse {get; set;}
    public boolean isGenderEnabled {get; set;}
    
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
    
    Public AllBedInfo()
    {
        SunshineCenter = ApexPages.CurrentPage().getParameters().get('rt');
        newHouse = new Bed_Board_Configuration__c();
        addHouse = false;
        listOfRoomToDisplay =new Map<Id,list<Bed_Board_Configuration__c>>();
        listOfBedToDisplay =new Map<Id,list<Bed_Board_Configuration__c>>(); 
        GetAllHouses();
        GetAllRooms();
        GetAllBeds();
        
        Sunshine_Center_Id__c sunshineCS = Sunshine_Center_Id__c.getValues(SunshineCenter);
        isGenderEnabled = sunshineCS != null && sunshineCS.IsGenderSpecific__c; 
        
    }
    
    public void addNewHouse()
    {
        addHouse = true;
    }
    
    public void cancelNewHouse()
    {
        addHouse = false;
    }
    
    public void saveNewHouse()
    {
        if(newHouse.House_Name__c == '' || newHouse.Sunshine_Center__c == null )
        {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Please Enter Required Information');
            ApexPages.addMessage(errMsg);
        }
        else
        {
            upsert newHouse;
            addHouse = false;
            GetAllHouses();
            GetAllRooms();
            GetAllBeds();
        }
    }
    
    public void GetAllHouses()
    {
        listOfHouseToDisplay = [select id, Sunshine_Center__c, House_Name__c ,  Room_Number__c ,Gender__c, House__c,room__c, Bed_Number__c, Address__c, House_Phone_Number__c, House_Fax_Number__c, House_Website__c
                                 from Bed_Board_Configuration__c where House_Name__c != null AND Sunshine_Center__r.name =:SunshineCenter];
        for(Bed_Board_Configuration__c House  : listOfHouseToDisplay)
            SetOfHouseId.add(House.id);
    }    
    
    public void GetAllRooms()
    {
        listOfRoom = [select id, Sunshine_Center__c, House_Name__c ,  Room_Number__c ,Gender__c, House__c,room__c, Bed_Number__c,house__r.House_Name__c 
                        from Bed_Board_Configuration__c where House__c != null and Room_Number__c != null];
        for(Bed_Board_Configuration__c rooms : listOfRoom)
        {
            if(listOfRoomToDisplay.containsKey(rooms.House__c ))
            {   
                list<Bed_Board_Configuration__c> lstOfRooms = new list<Bed_Board_Configuration__c>();
                lstOfRooms = listOfRoomToDisplay.get(rooms.House__c );
                lstOfRooms.add(rooms);
                listOfRoomToDisplay.put(rooms.House__c,lstOfRooms);
            }
            else
            {
                list<Bed_Board_Configuration__c> lstOfRooms = new list<Bed_Board_Configuration__c>();
                lstOfRooms.add(rooms);
                listOfRoomToDisplay.put(rooms.House__c,lstOfRooms);
            }
            SetOfRoomId.add(Rooms.id);
        }
    }
    
    Public void GetAllBeds()
    {
        List<Bed_Board_Configuration__c > listOfBed = [select id, Sunshine_Center__c, House_Name__c ,  Room_Number__c ,Gender__c, House__c,room__c, Bed_Number__c,Room__r.Room_Number__c from Bed_Board_Configuration__c where Room__c != null and Bed_Number__c!= null];
        for(Bed_Board_Configuration__c rooms : listOfBed)
        {
            if(listOfBedToDisplay.containsKey(rooms.Room__c))
            {   
                list<Bed_Board_Configuration__c> lstOfRooms = new list<Bed_Board_Configuration__c>();
                lstOfRooms = listOfBedToDisplay.get(rooms.Room__c );
                lstOfRooms.add(rooms);
                listOfBedToDisplay.put(rooms.Room__c,lstOfRooms);
            }
            else
            {
                list<Bed_Board_Configuration__c> lstOfRooms = new list<Bed_Board_Configuration__c>();
                lstOfRooms.add(rooms);
                listOfBedToDisplay.put(rooms.Room__c,lstOfRooms);
            }
        }
        
        
        for(String Houseid : SetOfHouseId)
        {
            if(!listOfRoomToDisplay.containsKey(Houseid))
            {
                listOfRoomToDisplay.put(Houseid,new list<Bed_Board_Configuration__c>());
            }
        }
        
        for(String Roomid : SetOfRoomId)
        {
            if(!listOfBedToDisplay.containsKey(Roomid))
            {
                listOfBedToDisplay.put(Roomid,new list<Bed_Board_Configuration__c>());
            }
        }
    
    }
    
    Public void Edit()
    {}
    
    
}