/*
    author: Huma Zafar
*/
public class meds_RefillCountController{
    
    id clientChartId;
    string rtparam;
    
    //list of refill counts
    public list<RefillCount> lstRefillCount {get; set;}    
    
    
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
     //public id orderIdView{get;set;}
    final string AWSURL; 
    private User userObj;   
    
    public string SunShineCenterName {get; set;}
    public string ClientName {get; set;}
    
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
    
    public meds_RefillCountController(){
        
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
                
        loadRefillCountAndDetails();
    }
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
    
    private void loadRefillCountAndDetails() {
        
        lstRefillCount = new list<RefillCount>();
        
        list<UtlizationReviewOrder__c> lst = [select id, Start_Date_Time__c, House__c ,Type__c, Client_Chart__c , Status__c, Name ,
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
        if (lstRefillCount.size() == 0)
            addmore();

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
    }

    public void AddMore() {
        
        for(RefillCount RC : lstRefillCount){
            if(RC.UOR.Status__c == 'Open'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create a new Open Refill Count Row, until all previous Refill Count Rows are in Closed status'));
                return;
            }
        }

        list<wrapperTaperLine> lstTLITemp = new list<wrapperTaperLine>();
        //lstTLITemp.add(new wrapperTaperLine(new Taper_Line_Item__c(),lstTLITemp.size(),true));

        RefillCount r = new RefillCount(new UtlizationReviewOrder__c (Client_Chart__c = clientChartId,Status__c='Open',Type__c = 'Control Substance Count'),
                                        lstRefillCount.size(), true, lstTLITemp);

        lstRefillCount.add(r);
    }

    public void Edit() {
        string objIndex = system.CurrentPageReference().getParameters().get('IndexNumber');
        RefillCount  obj = lstRefillCount.get(integer.valueof(objIndex));
        obj.IsEdit = true;
    }

    public void SaveRefillCount() {

        string objIndex = system.CurrentPageReference().getParameters().get('IndexNumber');
        RefillCount  obj = lstRefillCount.get(integer.valueof(objIndex));

        obj.IsEdit = false;
        upsert obj.UOR;
        
        //loadRefillCountAndDetails();
    }

    public void RemoveRefillCountFromList() {

        string objIndex = system.CurrentPageReference().getParameters().get('IndexNumber');
        string recId = system.CurrentPageReference().getParameters().get('recId');
        if(recId !=null && recId !='')
        delete[Select ID from UtlizationReviewOrder__c where ID = : recId ];
        lstRefillCount.remove(integer.valueof(objIndex));

        loadRefillCountAndDetails();
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

    public void EditLI() {

        string UORID = system.CurrentPageReference().getParameters().get('UORID');
        string index = system.CurrentPageReference().getParameters().get('liIndex');

        wrapperTaperLine wTL = lstRefillCount.get(integer.valueof(UORID)).lstTLI.get(integer.valueof(index));
        wTL.isEdit = true;
    }

    public void SaveLI() {

        string UORID = system.CurrentPageReference().getParameters().get('UORID');
        string index = system.CurrentPageReference().getParameters().get('liIndex');
        system.debug(UORID );
        system.debug(index);
        wrapperTaperLine wTL = lstRefillCount.get(integer.valueof(UORID)).lstTLI.get(integer.valueof(index));
        
        wTL.isEdit = false;
        system.debug(lstRefillCount.get(integer.valueof(UORID)).UOR.id);
        wTL.TLI.UtlizationReviewOrder__c = lstRefillCount.get(integer.valueof(UORID)).UOR.id;
        wTL.TLI.ClientChart__c= clientChartId;
        try{
            upsert wTL.TLI;
            system.debug('item saved');
            loadRefillCountAndDetails();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
        
    }

    public void RemoveLI() {

        string UORID = system.CurrentPageReference().getParameters().get('UORID');
        string index = system.CurrentPageReference().getParameters().get('liIndex');

        wrapperTaperLine wTL = lstRefillCount.get(integer.valueof(UORID)).lstTLI.get(integer.valueof(index));
        delete wTL.TLI;

        lstRefillCount.get(integer.valueof(UORID)).lstTLI.remove(integer.valueof(index));
        loadRefillCountAndDetails();
    }

    public void AddLI() {
        string UORID = system.CurrentPageReference().getParameters().get('index');
        system.debug(UORID);
        list<wrapperTaperLine> lstTLITemp = new list<wrapperTaperLine>();
        integer indexVal = lstRefillCount.get(integer.valueof(UORID)).lstTLI.size();
        lstRefillCount.get(integer.valueof(UORID)).lstTLI.add(new wrapperTaperLine(new Taper_Line_Item__c(), indexVal , true));

    }
    
  public PageReference CloseUOR() {

        id recId = system.CurrentPageReference().getParameters().get('recId');
        //update AssementForm with the user signature
        UtlizationReviewOrder__c  ord = [Select Staff_Signed_URL__c,Staff_Signed_User__c,Staff_Signed_Date__c,
                                        Type__c, Staff_Signed_Date_2__c, Staff_Signed_URL_2__c, Staff_Signed_User_2__c
                                        from UtlizationReviewOrder__c WHERE Id =: recId limit 1];
        //ord.id = recId;
        
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
    
    public PageReference backToMeds(){
        PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId + '&rt=' + rtparam );
        meds.setRedirect(true);
        return meds;
    }
}