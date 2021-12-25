public class MedsCountCmpCtrl{
    
    public list<RefillCount> lstRefillCount {get; set;}   
    Date TodayDate; 
    public string todayDateFormat { get ;set;}
    public boolean showExistingSN{get;set;}
    public DateTime createdDate{get;set;}
    public string createdBy{get;set;}
    public Group_Therapy_Session__c PGSessions{get;set;}
    public Map<string, List<RefillCount>> mapOfMedsCountByweek {get;set;}
    private integer Days;
    public date sdate {get;set;}
    public date edate {get; set;}
    public boolean isCurrentButton { get;set;}
    public boolean isPastButton { get ;set;}
    public boolean isNextButton { get ;set;}
    public date  disChargeDate  { get;set;}
    public date admitDate  { get;set;}
    public List<Date> dateAgainstDays { get;set;}
    public string RecType {get; set;}
    public Sunshine_Center_Id__c scid{get;set;}
    id clientChartId;
    public string SunShineCenterName {get; set;}
    public string ClientName {get; set;}
    string rtparam;
    
    public RefillCount refillCountObj {get;set;}
    public RefillCount OpenRefillCountObj {get;set;}
            //hidden field
    public string SelectedSignedOption {
        get;
        set;
    }
    public string ImageUrlAddress {
        get;
        set;
    }

    //AWS
    public string accessKeyId {
        get;
        set;
    }
    public string secretAccessKey {
        get;
        set;
    }
    public string OrgName {
        get;
        set;
    }
        final string AWSURL; 
         private User userObj; 


    public boolean buttonAccessType {

        get {

            User u = [Select ID, UserName, Acess_Type__c FROM User where ID = : UserInfo.getUserId()];
            if (!string.isNotBlank(u.Acess_Type__c))
                return false;

            TabViews__c visibleTab = TabViews__c.getValues('Meds');

            if ( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;

            return false;
        }
        set;
    }
    
    public MedsCountCmpCtrl(){
        
         TodayDate  = date.today();
         
        todayDateFormat   = DateTime.newInstance(TodayDate.year(),TodayDate.month(),TodayDate.day()).format('MMMM dd,YYYY'); 
        
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        rtparam = ApexPages.CurrentPage().getParameters().get('rt');
        
        Client_Chart__c ClientChartObj = [select id, Name, Treatment_Center__r.Name from Client_Chart__c where id = :clientChartId];

        SunShineCenterName = ClientChartObj.Treatment_Center__r.Name;
        ClientName = ClientChartObj.Name;
        
        userObj = [select id, name, title from user where id = :UserInfo.getUserID()];
        Houses=getHouses();
        Types=getTypes();
        
        
        loadRefillCountAndDetails();
        loadOpenRefillCount();
     //   if(OpenRefillCountObj==null)
       // AddMore();

        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        RecType = ApexPages.CurrentPage().getParameters().get('rt') != null? ApexPages.CurrentPage().getParameters().get('rt'):'';
        scid = Sunshine_Center_Id__c.getValues(rt);

    
        
        mapOfMedsCountByweek = new Map<string,List<RefillCount >>();
        
        dateAgainstDays  = new  List<Date>();
        Days = 0;
        getCurrentWeek();
        
        isCurrentButton = true;//disbale
        isPastButton = false; //enable
        isNextButton  = true; //disable
        
    }
        private void loadRefillCountAndDetails() {
        
        lstRefillCount = new list<RefillCount>();
        
        list<UtlizationReviewOrder__c> lst = [select id,Created_Day_of_Week__c, Start_Date_Time__c, House__c ,Type__c, Client_Chart__c , Status__c, Name ,
                                    Staff_Signed_URL__c, Staff_Signed_User__c ,Staff_Signed_Date__c ,Staff_Signed_User_2__c,
                                    Staff_Signed_URL_2__c,Staff_Signed_Date_2__c,
                                                (select id, Medicine__c, Strength__c,
                                              Amount_to_Use_Per_Dosage_Form__c, Start_Count__c, End_Count__c, Correct__c 
                                              from Taper_Line_Items__r)
                                              from UtlizationReviewOrder__c
                                              where Client_Chart__c = : clientChartId 
                                              AND (Type__c =: 'Control Substance Count' or Type__c =: 'Normal Medicine Count')];


        integer countVar = 0;

        list<wrapperTaperLine> lstTemp ;
        for (UtlizationReviewOrder__c U : lst) {
            //if (u.Taper_Line_Items__r.size() > 0) {


                lstTemp = new list<wrapperTaperLine>();

                for (Taper_Line_Item__c t : u.Taper_Line_Items__r) {
                    lstTemp.add(new wrapperTaperLine(t, lstTemp.size(), false));

                }
                lstRefillCount.add(new RefillCount(u, countVar , false, lstTemp));
                countVar++;
            //}
        }


    }
    
 
      public PageReference backToMeds(){
        PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId + '&rt=' + rtparam );
        meds.setRedirect(true);
        return meds;
    }

    public void getCurrentWeek(){
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        
        Days = 0;
        isCurrentButton = true;//disable
        isNextButton =true; //disable
        Date dt = Date.Today();
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);
    
     lstRefillCount = new list<RefillCount>();
        
         list<UtlizationReviewOrder__c> lst = [select id,Created_Day_of_Week__c, Start_Date_Time__c, House__c ,Type__c, Client_Chart__c , Status__c, Name ,
                                    Staff_Signed_URL__c, Staff_Signed_User__c ,Staff_Signed_Date__c ,Staff_Signed_User_2__c,
                                    Staff_Signed_URL_2__c,Staff_Signed_Date_2__c,
                                                (select id, Medicine__c, Strength__c,
                                              Amount_to_Use_Per_Dosage_Form__c, Start_Count__c, End_Count__c, Correct__c 
                                              from Taper_Line_Items__r)
                                              from UtlizationReviewOrder__c
                                              where Client_Chart__c = : clientChartId 
                                              AND (Type__c =: 'Control Substance Count' or Type__c =: 'Normal Medicine Count')
                                              AND CreatedDate >=: dt.toStartOfWeek() AND CreatedDate <: endDate
                                              order by CreatedDate desc];


        integer countVar = 0;

        list<wrapperTaperLine> lstTemp ;
        for (UtlizationReviewOrder__c U : lst) {
            //if (u.Taper_Line_Items__r.size() > 0) {


                lstTemp = new list<wrapperTaperLine>();

                for (Taper_Line_Item__c t : u.Taper_Line_Items__r) {
                    lstTemp.add(new wrapperTaperLine(t, lstTemp.size(), false));

                }
                lstRefillCount.add(new RefillCount(u, countVar , false, lstTemp));
                countVar++;
            //}
        }
        
        ShowByWeekDay();
        sdate = dt.toStartOfWeek();
        edate = endDate.Date();
        FillDateAgainstDays(sdate,edate);
        isPastButton = false; //enable
        isCurrentButton = true; // disable
            
            
           
    }
    
    public void getPreviousWeek(){
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        
        Days -= 7;
        isNextButton   = false; //enable
      
        Date dt = Date.Today().AddDays(Days);
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);

     
        lstRefillCount = new list<RefillCount>();
        
         list<UtlizationReviewOrder__c> lst = [select id,Created_Day_of_Week__c, Start_Date_Time__c, House__c ,Type__c, Client_Chart__c , Status__c, Name ,
                                    Staff_Signed_URL__c, Staff_Signed_User__c ,Staff_Signed_Date__c ,Staff_Signed_User_2__c,
                                    Staff_Signed_URL_2__c,Staff_Signed_Date_2__c,
                                                (select id, Medicine__c, Strength__c,
                                              Amount_to_Use_Per_Dosage_Form__c, Start_Count__c, End_Count__c, Correct__c 
                                              from Taper_Line_Items__r)
                                              from UtlizationReviewOrder__c
                                              where Client_Chart__c = : clientChartId 
                                              AND (Type__c =: 'Control Substance Count' or Type__c =: 'Normal Medicine Count')
                                              AND CreatedDate>=: dt.toStartOfWeek() AND CreatedDate <: endDate
                                            order by CreatedDate desc];


        integer countVar = 0;

        list<wrapperTaperLine> lstTemp ;
        for (UtlizationReviewOrder__c U : lst) {
            //if (u.Taper_Line_Items__r.size() > 0) {


                lstTemp = new list<wrapperTaperLine>();

                for (Taper_Line_Item__c t : u.Taper_Line_Items__r) {
                    lstTemp.add(new wrapperTaperLine(t, lstTemp.size(), false));

                }
                lstRefillCount.add(new RefillCount(u, countVar , false, lstTemp));
                countVar++;
            //}
        }
        
        ShowByWeekDay();
        sdate = dt.toStartOfWeek();
        edate = endDate.Date();
          FillDateAgainstDays(sdate,edate);
       
        system.debug('test########' + admitDate );
       
       
          isCurrentButton = false; // enable 
         
          isNextButton   = false; // disable
       
          
  
    }
    
    
    public void GetNextWeek(){
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        
        Days += 7;
        Date dt = Date.Today().AddDays(Days);
        Date tempDate = dt.toStartOfWeek().addDays(6);
        DateTime endDate = DateTime.newInstance(tempDate.year(), tempDate.month(), tempDate.day(), 23, 59, 59);

        
        lstRefillCount = new list<RefillCount>();
        
         list<UtlizationReviewOrder__c> lst = [select id,Created_Day_of_Week__c, Start_Date_Time__c, House__c ,Type__c, Client_Chart__c , Status__c, Name ,
                                    Staff_Signed_URL__c, Staff_Signed_User__c ,Staff_Signed_Date__c ,Staff_Signed_User_2__c,
                                    Staff_Signed_URL_2__c,Staff_Signed_Date_2__c,
                                                (select id, Medicine__c, Strength__c,
                                              Amount_to_Use_Per_Dosage_Form__c, Start_Count__c, End_Count__c, Correct__c 
                                              from Taper_Line_Items__r)
                                              from UtlizationReviewOrder__c
                                              where Client_Chart__c = : clientChartId 
                                              AND (Type__c =: 'Control Substance Count' or Type__c =: 'Normal Medicine Count')
                                               and CreatedDate>=: dt.toStartOfWeek() AND CreatedDate <: endDate
                                                order by CreatedDate desc ];


        integer countVar = 0;

        list<wrapperTaperLine> lstTemp ;
        for (UtlizationReviewOrder__c U : lst) {
            //if (u.Taper_Line_Items__r.size() > 0) {


                lstTemp = new list<wrapperTaperLine>();

                for (Taper_Line_Item__c t : u.Taper_Line_Items__r) {
                    lstTemp.add(new wrapperTaperLine(t, lstTemp.size(), false));

                }
                lstRefillCount.add(new RefillCount(u, countVar , false, lstTemp));
                countVar++;
            //}
        }
        
        ShowByWeekDay();
        sdate = dt.toStartOfWeek();
        edate = endDate.Date();
        FillDateAgainstDays(sdate,edate);
       
       
       
      
       if(Days  >= 0 ) {
           
           isNextButton = true; // disable
           isCurrentButton  = true; //disable
       }
       
       
    }
    
    void FillDateAgainstDays(Date sDate, Date eDate){
        
            dateAgainstDays = new List<date>();
            
            
            dateAgainstDays.add(sDate);
           
     
            for(integer i = 1 ; i<= 6 ; i++){
                   dateAgainstDays.add(sDate.addDays(i));
            }
    
    }
    private void ShowByWeekDay(){
         mapOfMedsCountByweek = new Map<string,List<RefillCount >>();
         mapOfMedsCountByweek.put('Sunday' , new List<RefillCount > {});
         mapOfMedsCountByweek.put('Monday' , new List<RefillCount > {});
         mapOfMedsCountByweek.put('Tuesday' , new List<RefillCount > {});
         mapOfMedsCountByweek.put('Wednesday' , new List<RefillCount > {});
         mapOfMedsCountByweek.put('Thursday' , new List<RefillCount > {});
         mapOfMedsCountByweek.put('Friday' , new List<RefillCount > {});
         mapOfMedsCountByweek.put('Saturday' , new List<RefillCount > {});
        
        for(RefillCount cl : lstRefillCount){
           if(cl.UOR.Status__c=='Closed')
            {
            if(mapOfMedsCountByweek.containsKey(cl.UOR.Created_Day_of_Week__c))
                mapOfMedsCountByweek.get(cl.UOR.Created_Day_of_Week__c).add(cl);
            else
                mapOfMedsCountByweek.put(cl.UOR.Created_Day_of_Week__c , new List<RefillCount > { cl });
            }
                
        }
    }
    
     private void loadOpenRefillCount(){
        
        
        
        for(RefillCount cl : lstRefillCount){
            
            if(cl.UOR.Status__c=='Open'){
               OpenRefillCountObj =cl;
               return;
            }
             
         
                
        }
    }

        public void Edit() {
        loadOpenRefillCount();
        OpenRefillCountObj.IsEdit = true;
    }
    
    public void SaveRefillCount() {

      /*  string objIndex = system.CurrentPageReference().getParameters().get('IndexNumber');
        RefillCount  obj = lstRefillCount.get(integer.valueof(objIndex));

        obj.IsEdit = false;
        upsert obj.UOR;*/
       
        
        upsert OpenRefillCountObj.UOR;
        loadRefillCountAndDetails();
        loadOpenRefillCount();
    }

    public void RemoveRefillCountFromList() {

       
        string recId = system.CurrentPageReference().getParameters().get('recId');
        if(recId !=null && recId !='')
        delete[Select ID from UtlizationReviewOrder__c where ID = : recId ];
        OpenRefillCountObj= new RefillCount();

        loadRefillCountAndDetails();
        loadOpenRefillCount();
          if(OpenRefillCountObj==null)
        AddMore();
    }

  
    public void EditLI() {

  
        string index = system.CurrentPageReference().getParameters().get('liIndex');

        wrapperTaperLine wTL = OpenRefillCountObj.lstTLI.get(integer.valueof(index));
        wTL.isEdit = true;
    }

    public void SaveLI() {

      
        string index = system.CurrentPageReference().getParameters().get('liIndex');

        wrapperTaperLine wTL = OpenRefillCountObj.lstTLI.get(integer.valueof(index));
        
        wTL.isEdit = false;
        
        wTL.TLI.UtlizationReviewOrder__c = OpenRefillCountObj.UOR.id;
        wTL.TLI.ClientChart__c= clientChartId;
        
        try{
            upsert wTL.TLI;
            system.debug('item saved');
            loadRefillCountAndDetails();
            loadOpenRefillCount();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
        
    }

    public void RemoveLI() {

      
        string index = system.CurrentPageReference().getParameters().get('liIndex');

        wrapperTaperLine wTL = OpenRefillCountObj.lstTLI.get(integer.valueof(index));
        delete wTL.TLI;

        OpenRefillCountObj.lstTLI.remove(integer.valueof(index));
        loadRefillCountAndDetails();
          loadOpenRefillCount();
    }

    public void AddLI() {
     
    
        list<wrapperTaperLine> lstTLITemp = new list<wrapperTaperLine>();
        integer indexVal = OpenRefillCountObj.lstTLI.size();
        OpenRefillCountObj.lstTLI.add(new wrapperTaperLine(new Taper_Line_Item__c(), indexVal , true));

    }
      public void AddMore() {
          // loadRefillCountAndDetails();
            
  
     
        list<wrapperTaperLine> lstTLITemp = new list<wrapperTaperLine>();
        //lstTLITemp.add(new wrapperTaperLine(new Taper_Line_Item__c(),lstTLITemp.size(),true));

        RefillCount r = new RefillCount(new UtlizationReviewOrder__c (Client_Chart__c = clientChartId,Status__c='Open',Type__c = 'Control Substance Count'),
                                        lstRefillCount.size(), true, lstTLITemp);
                                        
        OpenRefillCountObj  = r ;

       // lstRefillCount.add(r);
    }

    
  public PageReference CloseUOR() {

        id recId = system.CurrentPageReference().getParameters().get('recId');
        //update AssementForm with the user signature
        UtlizationReviewOrder__c  ord = [Select Staff_Signed_URL__c,Staff_Signed_User__c,Staff_Signed_Date__c,
                                        Type__c, Staff_Signed_Date_2__c, Staff_Signed_URL_2__c, Staff_Signed_User_2__c
                                        from UtlizationReviewOrder__c WHERE Id =: recId limit 1];
        //ord.id = recId;
        
          system.debug('^^^^^^^'+ ord);
        //ord.id = recId;
        system.debug('YYYYYYY' +ImageUrlAddress);
        
        if(string.isBlank( ord.Staff_Signed_URL_2__c) && ord.Type__c == 'Control Substance Count' && string.isNotBlank( ord.Staff_Signed_URL__c)  ){
            
            ord.Staff_Signed_URL_2__c = AWSURL + ImageUrlAddress;
            ord.Staff_Signed_User_2__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            ord.Staff_Signed_Date_2__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
            ord.Status__c = 'Closed';
            update ord;
            //return new PageReference('/apex/MedsHomePage?id='+clientChartId );
            return null; 
            
        }
        
       
            
        ord.Staff_Signed_URL__c= AWSURL + ImageUrlAddress;
        ord.Staff_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
        ord.Staff_Signed_Date__c = DateTime.newinstance(DateTime.Now().date(), datetime.now().time());
        
        if(ord.Type__c != 'Control Substance Count'){
            ord.Status__c = 'Closed';
        }
            update ord;
            //return new PageReference('/apex/MedsHomePage?id='+clientChartId );
            return null;  
      
    }
    Public List<SelectOption> Types;
    Public List<SelectOption> Houses;
    
    
        public List<SelectOption> getTypes(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = UtlizationReviewOrder__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            if(f.getLabel()!='Locker' && f.getLabel()!='PDF Package')
                options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
     public  List<SelectOption> getHouses(){
    
        List<SelectOption> options = new List<SelectOption>();
        list<Bed_Board_Configuration__c> lstBB = [select id,Name from Bed_Board_Configuration__c where Sunshine_Center__r.Name =: rtparam];
        
        
        for( Bed_Board_Configuration__c b : lstBB ){
            options.add(new SelectOption(b.id, b.Name));
            
        } 
        return options; 
    }
    

    public class RefillCount {
        public UtlizationReviewOrder__c UOR {get; set;}
        public integer index {get; set;}
        public boolean isEdit {get; set;}
        public list<wrapperTaperLine> lstTLI {get; set;}


        public RefillCount(UtlizationReviewOrder__c u, integer i, boolean e, list<wrapperTaperLine> lstt) {
            UOR = u;
            index = i;
            isEdit = e;
            lstTLI = lstt;
    
        }
        public RefillCount(){}
    }
        public class wrapperTaperLine {
        public Taper_line_Item__c TLI {get; set;}
        public integer index {get; set;}
        public boolean isEdit {get; set;}

        public wrapperTaperLine(Taper_line_Item__c t, integer i, boolean e) {
            TLI = t;
            index = i;
            isEdit = e;
        }
    }
}