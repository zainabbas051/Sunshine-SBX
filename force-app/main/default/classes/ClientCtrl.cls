//Test Class : ClientCtrl_Test
public class ClientCtrl{
    
    public string SearchParam{
      get;
      set;
    }
    public integer totalRecords{
      get;
      set;
    }
    
    public integer totalDetox{
      get;
      set;
    }
    public integer totalResidential{
      get;
      set;
    }
    public integer totalPHP{
      get;
      set;
    }
    
    public List <client_chart__c> lstClientCharts {
      get;
      set;
    } 
    public string recordTypeName {get; set;}
    
    public date ArrStDt {get; set;}
    public date ArrEndDt {get; set;}
    public date DisStDt {get; set;}
    public date DisEndStDt {get; set;}
    
    public boolean PreAddStatus {get; set;}
    public boolean AddmitStatus {get; set;}
    public boolean ArrTodayStatus {get; set;}
    public boolean ArrTommStatus {get; set;}
    public boolean DisTodayStatus {get; set;}
    public boolean DisTommStatus {get; set;}
    public boolean ResdntlPrg   {get; set;}
    public boolean DetoxPrg {get; set;}
    public boolean IOPPrg {get; set;}
    public boolean PHPPrg {get; set;}
    public boolean OPPrg {get; set;}
    public boolean ResdntlURLoc {get; set;}
    public boolean DetoxURLoc {get; set;}
    public boolean IOPURLoc {get; set;}
    public boolean PHPURLoc {get; set;}
    public boolean OPURLoc {get; set;}
    public boolean BlueTrack {get; set;}
    public boolean GreenTrack {get; set;}
    public boolean OrangeTrack {get; set;}
    public boolean PurpleTrack {get; set;}
    
    public string MsgString {get; set;}
    public string PrgString {get; set;}
    public string URLocString {get; set;}
    public string TrackString {get; set;}
    
    public boolean isHouseBasedSelection {get;set;}
    public boolean isTrackSelection {get;set;}
    public string SelectedHouseId {get;set;}
    public string SelectedHouseName {get;set;}
    public List<HouseFilterWrapper> houseFilters {get;set;}
    public List<string> recordtypeNames {get;set;}
    
    public list<RecordType> LstRecTypes;
    
    public ClientCtrl(){
       
        recordTypeName = ApexPages.currentPage().getParameters().get('rt');
        MsgString = 'Clients';
        PrgString = '';
        URLocString = '';
        TrackString = '';
        SelectedHouseId = '';
        SelectedHouseName = '';
        LstRecTypes = new list<RecordType>();
        getAllRecordTypes();
        setAllBooleansFalse();
        setDatesNull();
        getAllClients();
        setFilterSection();
    }
    //Danish Farooq
    //11-Sept-2017
    public void getAllClients() {
        if(recordTypeName=='' || recordTypeName == null){
            list<RecordType> lst = [select id,Name from RecordType where sobjecttype = 'Client_Chart__c'];
            recordTypeName ='';
            for(RecordType RT: lst){
                recordTypeName += RT.Name+';';
                
            }
            if(recordTypeName.endswith(';'))
                recordTypeName = recordTypeName.substring(0,recordTypeName.length()-1);
        }
        recordtypeNames = recordTypeName.split(';');
      lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, U_R_Location__c ,Client_Status__c , Building__c,
                          Room__c, Bed__c, Client_Image_URL2__c from Client_Chart__c where RecordType.Name in: recordtypeNames and Client_Status__c =: 'Admitted' ORDER BY Name ASC limit 200];
      totalRecords = lstClientCharts.size();
      MsgString = 'Clients';  
   
      getDetailedRecordCounts();
    }
    
    public void setDatesNull()
    {
        ArrStDt = null;
        ArrEndDt = null;
        DisStDt = null;
        DisEndStDt = null;
    }
    
    public void getClientPreAddmission()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c , Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Pre Admission' ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c , Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Pre Admission' ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Pre Admission';
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    public void getSearchResults()
    {
        if(SearchParam.trim() == '')
        {
            return;
        }
        SearchParam = '%'+SearchParam+'%';
        
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND (Name like: SearchParam or Medical_Record_Number__c like: SearchParam)  ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND (Name like: SearchParam or Medical_Record_Number__c like: SearchParam) ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - searched for '+SearchParam.replaceAll('%', '');
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    public void getClientAdmitted()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Current';
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
     public void getClientNotAdmitted()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Not Admitted' ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Not Admitted' ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Not Admitted';
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    public void getClientDischarged()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Discharged' ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Discharged' ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Pre Admission';
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    
    public void getClientArrivingToday()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Pre Admission'
                                AND Admit_Date_Time__c = TODAY ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Pre Admission'
                                AND Admit_Date_Time__c = TODAY ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Arriving Today';
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    public void getClientArrivingTomorrow()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Pre Admission'
                                AND Admit_Date_Time__c = TOMORROW  ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Pre Admission'
                                AND Admit_Date_Time__c = TOMORROW  ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Arriving Tomorrow';
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    public void getClientDischargingToday()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Admitted'
                                AND Discharge_Date_Time__c = TODAY  ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Admitted'
                                AND Discharge_Date_Time__c = TODAY  ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Discharging Today';
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    public void getClientDischargingTomorrow()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Admitted'
                                AND Discharge_Date_Time__c = TOMORROW  ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Admitted'
                                AND Discharge_Date_Time__c = TOMORROW  ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Discharging Tomorrow';
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    public void getClientOnArrivDateRng()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Pre Admission'
                                AND Admit_Date_Time__c >=: ArrStDt AND  Admit_Date_Time__c <=: ArrEndDt  ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Pre Admission'
                                AND Admit_Date_Time__c >=: ArrStDt AND  Admit_Date_Time__c <=: ArrEndDt  ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Arriving from '+ArrStDt.month()+'/'+ArrStDt.day()+'/'+ArrStDt.year()+' to ' + ArrEndDt.month()+'/'+ArrEndDt.day()+'/'+ArrEndDt.year();
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    public void getClientOnDisDateRng()
    {
        if(recordTypeName=='' || recordTypeName == null)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordTypeId in: LstRecTypes AND Client_Status__c = 'Admitted'
                                AND Discharge_Date_Time__c >=: DisStDt AND  Discharge_Date_Time__c <=: DisEndStDt  ORDER BY Name ASC limit 200];
        }
        else
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                where RecordType.Name =:recordTypeName AND Client_Status__c = 'Admitted'
                                AND Discharge_Date_Time__c >=: DisStDt AND  Discharge_Date_Time__c <=: DisEndStDt  ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - Discharging from '+DisStDt.month()+'/'+DisStDt.day()+'/'+DisStDt.year()+' to ' + DisEndStDt.month()+'/'+DisEndStDt.day()+'/'+DisEndStDt.year();
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();
    }
    
    public void getClientOnPrograms()
    {
        if(PrgString == 'Residential')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'Residential' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'Residential' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - Program Residential';
            totalRecords = lstClientCharts.size();
        }
        else if(PrgString == 'Detox')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'Detox' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'Detox' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - Program Detox';
            totalRecords = lstClientCharts.size();
        }
        else if(PrgString == 'PHP')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'PHP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'PHP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - Program PHP';
            totalRecords = lstClientCharts.size();
        }
        else if(PrgString == 'IOP')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'IOP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'IOP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - Program IOP';
            totalRecords = lstClientCharts.size();
        }
        else if(PrgString == 'OP')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'OP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Program__c = 'OP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - Program OP';
            totalRecords = lstClientCharts.size();
        }
        else if(PrgString == 'All')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND (Program__c = 'Residential' OR
                                    Program__c = 'Detox' OR Program__c = 'OP' OR Program__c = 'PHP'
                                    OR Program__c = 'IOP') AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND (Program__c = 'Residential' OR
                                    Program__c = 'Detox' OR Program__c = 'OP' OR Program__c = 'PHP'
                                    OR Program__c = 'IOP') AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - All Programs';
            totalRecords = lstClientCharts.size();
        }
        getDetailedRecordCounts();
    }
    
    public void getClientOnURLocation()
    {
        if(URLocString == 'Residential')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'Residential' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'Residential' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - UR Location Residential';
            totalRecords = lstClientCharts.size();
        }
        else if(URLocString == 'Detox')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'Detox' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'Detox' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - UR Location Detox';
            totalRecords = lstClientCharts.size();
        }
        else if(URLocString == 'PHP')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'PHP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'PHP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - UR Location PHP';
            totalRecords = lstClientCharts.size();
        }
        else if(URLocString == 'IOP')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'IOP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'IOP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - UR Location IOP';
            totalRecords = lstClientCharts.size();
        }
        else if(URLocString == 'OP')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'OP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND U_R_Location__c = 'OP' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - UR Location OP';
            totalRecords = lstClientCharts.size();
        }
        else if(URLocString == 'All')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND (U_R_Location__c = 'Residential' OR
                                    U_R_Location__c = 'Detox' OR U_R_Location__c = 'OP' OR U_R_Location__c = 'PHP'
                                    OR U_R_Location__c = 'IOP') AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND (U_R_Location__c = 'Residential' OR
                                    U_R_Location__c = 'Detox' OR U_R_Location__c = 'OP' OR U_R_Location__c = 'PHP'
                                    OR U_R_Location__c = 'IOP') AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - All UR Locations';
            totalRecords = lstClientCharts.size();
        }
        
        getDetailedRecordCounts();
    }
    
    public void getClientOnTrack()
    {
        if(TrackString == 'Blue Track')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Track_Post_Detox__c = 'Blue Track' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Track_Post_Detox__c = 'Blue Track' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - Blue Track';
            totalRecords = lstClientCharts.size();
        }
        else if(TrackString == 'Green Track')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Track_Post_Detox__c = 'Green Track' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Track_Post_Detox__c = 'Green Track' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - Green Track';
            totalRecords = lstClientCharts.size();
        }
        else if(TrackString == 'Orange Track')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Track_Post_Detox__c = 'Orange Track' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Track_Post_Detox__c = 'Orange Track' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - Orange Track';
            totalRecords = lstClientCharts.size();
        }
        else if(TrackString == 'Purple Track')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Track_Post_Detox__c = 'Purple Track' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND Track_Post_Detox__c = 'Purple Track' AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - Purple Track';
            totalRecords = lstClientCharts.size();
        }
        else if(TrackString == 'All')
        {
            if(recordTypeName=='' || recordTypeName == null)
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND (Track_Post_Detox__c = 'Blue Track' OR 
                                    Track_Post_Detox__c = 'Green Track' OR Track_Post_Detox__c = 'Orange Track' OR
                                    Track_Post_Detox__c = 'Purple Track') AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            else
            {
                lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                                    Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c 
                                    where RecordTypeId in: LstRecTypes AND (Track_Post_Detox__c = 'Blue Track' OR 
                                    Track_Post_Detox__c = 'Green Track' OR Track_Post_Detox__c = 'Orange Track' OR
                                    Track_Post_Detox__c = 'Purple Track') AND Client_Status__c = 'Admitted' ORDER BY Name ASC limit 200];
            }
            MsgString = 'Clients - All Tracks';
            totalRecords = lstClientCharts.size();
        }
        
        getDetailedRecordCounts();
    }
    
    public void getAllRecordTypes()
    {
        LstRecTypes = [select id,Name from RecordType where sobjecttype = 'Client_Chart__c'];
    }
    
    public void setAllBooleansFalse()
    {
        PreAddStatus = false;
        AddmitStatus = false;
        ArrTodayStatus = false;
        ArrTommStatus = false;
        DisTodayStatus = false;
        DisTommStatus = false;
        ResdntlPrg = false;
        DetoxPrg = false;
        IOPPrg = false;
        PHPPrg = false;
        OPPrg = false;
        ResdntlURLoc = false;
        DetoxURLoc = false;
        IOPURLoc = false;
        PHPURLoc = false;
        OPURLoc = false;
        BlueTrack = false;
        GreenTrack = false;
        OrangeTrack = false;
        PurpleTrack = false;
    }
    
    public void getDetailedRecordCounts(){
        totalDetox = 0;
        totalResidential = 0;
        totalPHP = 0;
        
        for(Client_Chart__c  cc : lstClientCharts)
        {
            string program = cc.Program__c;
            
            if(program == 'Detox')
            {
                totalDetox +=1;
            }
            else if(program == 'Residential')
            {
                totalResidential +=1;
            }
            else if(program == 'PHP')
            {
                totalPHP +=1;
            }
        }
    }
    
    public void getClientForHouse(){
        System.debug('HouseId: '+SelectedHouseId);
        lstClientCharts = new List<Client_Chart__c>();
        List<Id> ClientIds = new List<Id>();
        for(UtlizationReviewOrder__c uro : [Select Id,bed__c,Client_Chart__c, Client_Chart__r.Client_Status__c  from UtlizationReviewOrder__c where Bed__c != null AND Client_Chart__c != NULL 
                                            and Status__c = 'Active' and Client_Chart__r.Client_Status__c = 'Admitted' and  Bed__r.Room__r.House__c =: SelectedHouseId])
        {
            ClientIds.add(uro.Client_Chart__c);
        }
        
        if(ClientIds.size()>0)
        {
            lstClientCharts = [Select ID,Name,Medical_Record_Number__c, Program__c, Client_Status__c, Building__c,
                          Room__c, Bed__c, Client_Image_URL2__c, U_R_Location__c from Client_Chart__c where Id =: ClientIds ORDER BY Name ASC limit 200];
        }
        MsgString = 'Clients - House: '+SelectedHouseName;
        totalRecords = lstClientCharts.size();
        getDetailedRecordCounts();  
    }
    
    public void setFilterSection(){
        Map<id,string> MapHouses = new Map<id,string>();
        houseFilters = new List<HouseFilterWrapper>();
        
        if(recordTypeName !='' || recordTypeName != null){
            list<string> recordtypeNames = recordTypeName.split(';');
            if(recordtypeNames.size() > 0)
            {
                for(Sunshine_Center_Id__c sunshineList : [Select Id,Name, Account_Id__c, House_Based_Selection__c from Sunshine_Center_Id__c where Name=: recordtypeNames])
                {
                    if(sunshineList.House_Based_Selection__c == false)
                    {
                      isTrackSelection = true;  
                    }
                    if(sunshineList.House_Based_Selection__c == true)
                    {
                        isHouseBasedSelection = true;  
                    }
                }
                
                if(isHouseBasedSelection == true)
                {
                    for(Bed_Board_Configuration__c beds: [select id,Bed_Number__c, Room__c, Room__r.Room_Number__c, 
                                                          Room__r.House__c, Room__r.House__r.House_Name__c from Bed_Board_Configuration__c 
                                                          where Room__c != null AND Room__r.House__r.Sunshine_Center__r.Name =: recordtypeNames])
                    {
                        MapHouses.put(beds.Room__r.House__c, beds.Room__r.House__r.House_Name__c);   
                    }
                    integer count = 0;
                    HouseFilterWrapper wrapper = new HouseFilterWrapper();
                    for(string mpId : MapHouses.keySet())            
                    {
                        if(Math.mod(count, 2) == 0)
                        {
                            wrapper = new HouseFilterWrapper();
                            wrapper.House1Id = mpId;
                            wrapper.House1Name = MapHouses.get(mpId);
                            wrapper.House1Exist = true;
                            if(count+1 == MapHouses.size())
                            {
                                houseFilters.add(wrapper);
                            }
                        }
                        else if(Math.mod(count, 2) == 1)
                        {
                            wrapper.House2Id = mpId;
                            wrapper.House2Name = MapHouses.get(mpId);
                            wrapper.House2Exist = true;
                            houseFilters.add(wrapper);
                        }
                        
                        count = count +1;
                    }    
                }
                
            }
        }
    }
    
    public class HouseFilterWrapper{
        public string House1Id {get;set;}
        public string House1Name {get;set;}
        public boolean House1Exist {get;set;}

        public string House2Id {get;set;}
        public string House2Name {get;set;} 
        public boolean House2Exist {get;set;}
    }
}