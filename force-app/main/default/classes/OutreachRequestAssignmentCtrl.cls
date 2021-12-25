public class OutreachRequestAssignmentCtrl {
    public String size { get; set; }
    //This is Our collection of the class/wrapper objects WrapperOutReachReqWrapper
    Public List<WrapperOutReachReqWrapper> wrapperlist;
    Public Integer noOfRecords{get; set;}
    // Create a new Map to verify whether the OUTREACH_REQUEST__c is already added in the Map
    Map <id,OUTREACH_REQUEST__c> SelectedOutReachReqMap = new Map <id,OUTREACH_REQUEST__c>();
    public boolean display{get;set;}
    public list<OUTREACH_REQUEST__c> selectedList {get;set;}
    public List<User> UserTemp = new List<User>();
    public string digitalUserIDvalue {get;set;}
    public string CategoryKeyword {get;set;}

    
    // instantiate the StandardSetOutreachReqtroller from a query locator
    public OutreachRequestAssignmentCtrl(){
        getOutReachrequestList();
    }
    
    
    public ApexPages.StandardSetController SetOutreachReq{
        get{
            if(SetOutreachReq == Null){
                SetOutreachReq = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,name,owner.name, Prospect_URL__c, Category__c, Sub_Category__c, OwnerId FROM OUTREACH_REQUEST__c where OwnerId =:Label.Outreach_Queue_ID LIMIT 10000]));
                // sets the number of records in each page set
                SetOutreachReq.setpagesize(50);
                noOfRecords = SetOutreachReq.getResultSize();
            }
            return SetOutreachReq;
        }
        set;
    }
    
      public string searchValue
    {
        get
        {
            if(searchValue == null)
                searchValue = '';
            return searchValue;
        }
        set;
    }
    
    
    
    public pageReference searchKeywords()
    {   
        if(searchValue ==''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter keyword to Search');
            ApexPages.addMessage(myMsg);
 SetOutreachReq = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,name,owner.name, Prospect_URL__c, Category__c, Sub_Category__c, OwnerId FROM OUTREACH_REQUEST__c where OwnerId =:Label.Outreach_Queue_ID LIMIT 10000]));
                // sets the number of records in each page set
                SetOutreachReq.setpagesize(50);
                noOfRecords = SetOutreachReq.getResultSize();
            return null;
            }
        else{
            String finalSearchValue = '%' + searchValue + '%';
            List<OUTREACH_REQUEST__c > outReachList= new List<OUTREACH_REQUEST__c >([SELECT Id,name,owner.name, Prospect_URL__c, Category__c, Sub_Category__c, OwnerId FROM OUTREACH_REQUEST__c where OwnerId =:Label.Outreach_Queue_ID and Category__c like :finalSearchValue limit 100]);
            SetOutreachReq= new ApexPages.StandardSetController(outReachList); 
            SetOutreachReq.setPageSize(50);
            searchValue ='';
            return null;
            }
    }
    
    
    
    
    
    
    //Returns a list of wrapper objects for the sObjects in the current page set
    Public List<WrapperOutReachReqWrapper> getOutReachrequestList(){
        getSelectedOutReachRequest();
        // Initilaize the list to add the selected OUTREACH_REQUEST__c
        wrapperlist = new List <WrapperOutReachReqWrapper>();
        for(OUTREACH_REQUEST__c cc : (List<OUTREACH_REQUEST__c>)SetOutreachReq.getRecords()){
            if( SelectedOutReachReqMap .ContainsKey(cc.id)){
                wrapperlist.add (new WrapperOutReachReqWrapper(cc,true));
            }
            else{
                wrapperlist.add(new WrapperOutReachReqWrapper(cc,false));
            }
        }
        return wrapperlist;
    }


    public void getSelectedOutReachRequest(){
        if(wrapperlist!=null){
            for(WrapperOutReachReqWrapper wr:wrapperlist){
                if(wr.bool == true){
                    SelectedOutReachReqMap.put(wr.outreachIns.id,wr.outreachIns); // Add the selected OUTREACH_REQUEST__c id in to the SelectedOutReachReqMap.
                }
                else{
                    SelectedOutReachReqMap.remove(wr.outreachIns.id); // If you uncheck the OUTREACH_REQUEST__c, remove it from the SelectedOutReachReqMap
                }
            }
        }
    }
    
    
    public pageReference clickMe(){
        system.debug('check select valueee::'+digitalUserIDvalue);
        list<OUTREACH_REQUEST__c > UpdateOutReachLst = new list<OUTREACH_REQUEST__c>();
        
        if(digitalUserIDvalue==null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please select digital marketing user');
            ApexPages.addMessage(myMsg);
            return null;
            
            }
         
        
        else{
            display = true;
            getSelectedOutReachRequest();
            selectedList = SelectedOutReachReqMap.values();
            if(selectedList.size()<=0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please select atleast one record to assign');
                ApexPages.addMessage(myMsg);
                return null;
            
            }
            
            else{
                for(OUTREACH_REQUEST__c outreachInsTemp :selectedList){
                    outreachInsTemp.ownerid=digitalUserIDvalue;  
                    UpdateOutReachLst.add(outreachInsTemp); 
                }
            
            update UpdateOutReachLst; 
            
             PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;
            
            }
        }
                  
    }
    
  
    
    public integer pageNumber{
        get{
            return SetOutreachReq.getPageNumber();
        }
        set;
    }
    
    public List<SelectOption> DigitalMarketingUsers
    {
        get
        {    
            UserTemp = [SELECT Id, Name, IsActive, ProfileId FROM User where IsActive=true and (Profile.Name =: 'Digital Marketing - Outreach Associate' OR Profile.Name =: 'Digital Marketing - SEO' OR Profile.Name =: 'Custom - Digital Marketing User')];
             
            DigitalMarketingUsers= new List<SelectOption>();
            DigitalMarketingUsers.add(new SelectOption('','-Select-'));
             
            for(User UserIns: UserTemp )
            {
                DigitalMarketingUsers.add(new SelectOption(UserIns.id, UserIns.name));
            }
            return DigitalMarketingUsers;
        }
        set;
    }

    
    Public class WrapperOutReachReqWrapper{
        Public OUTREACH_REQUEST__c outreachIns{get;set;}
        Public boolean bool{get;set;}
        
        public WrapperOutReachReqWrapper(OUTREACH_REQUEST__c outreachIns,boolean bool){
            this.outreachIns = outreachIns;
            this.bool = bool;

        }

    }
}