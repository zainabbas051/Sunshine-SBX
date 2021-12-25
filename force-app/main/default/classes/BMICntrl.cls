public class BMICntrl {
    
    public List<Recurring_Assessment__c> listRA{get;set;}
    public Integer listRASize{
        get{
            if(!listRA.isEmpty())
                return listRA.size()-1;  
            return null;  
        }set;
    }
     public list<wrapperRA> lstWrapperRA{get;set;}
    
    public list<wrapperRA> lstSelectedRA{get;set;}
    
    Public String vitalSignID{get;set;}
    Public string recordId{get;set;}
    
    Public Set<Id> setNewAssessmentsIds;
    
    public string clientChartId{
        get;set;
    }
    
    public boolean showAdd{get;set;}
    public boolean isRequired {get;set;}
    
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
    
    public string ImageUrlAddress {
        get;
        set;
    }
    
    public string bmiId {
        get;
        set;
    }
    
    public BMICntrl(){
       clientChartId=ApexPages.currentPage().getParameters().get('id');
        
        //AWS
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
    }
    
    public void buildData(){
         lstWrapperRA = new list<wrapperRA>();
        listRA = [SELECT Id, Name, Height__c, Weight__c, Gender__c,Time_Due__c, CreatedDate, Owner.Name,LastModifiedDate, Related_To__c, Related_To__r.Name ,Status__c, Body_Mass_Index__c
                  FROM Recurring_Assessment__c
                  WHERE RecordType.DeveloperName = 'BMI' and Client_Chart__c=:clientChartId order by createddate asc];
        
        setNewAssessmentsIds = new Set<Id>();
        
        for(Recurring_Assessment__c ra: listRA){
            lstWrapperRA.add(new wrapperRA(ra,False));
            if(ra.Status__c == 'Open')   
                setNewAssessmentsIds.add(ra.Id);
        }
        
        List<Recurring_Assessment__c> listBMIConfig = [SELECT Id, BMI_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Client_Chart__c=:clientChartId and BMI_Assessment_Required__c = TRUE];
        
        
        
        if(listBMIConfig.size() > 0)
            showAdd = false;
        else
            showAdd= true;
    }
    
    public PageReference Add(){
        
        /*
        List<Recurring_Assessment__c> listConfigRA = [SELECT Id, CIWA_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      CIWA_Assessment_Required__c = TRUE];
        if(listConfigRA.size() == 0){
            //SA: previously commented
            Recurring_Assessment__c raVS = [SELECT Id, Time_Due__c, LastModifiedDate, Owner.Name FROM Recurring_Assessment__c WHERE RecordType.DeveloperName='CIWA_Alcohol_Withdrawal_Assessment_Flowsheet' order by
                                            LastModifiedDate desc limit 1];
            if(raVS != null){
                Recurring_Assessment__c raNew = new Recurring_Assessment__c(
                    Time_Due__c = raVS.Time_Due__c.addHours(2),
                    RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                    get('CIWA').getRecordTypeId());
                
                insert raNew;
            }
            else{
               
            }// SA: end
            
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='CIWA-'+Crypto.getRandomInteger(),
                RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                get('CIWA').getRecordTypeId());
            
            insert raNew;
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot add Assessment at this time.');
            ApexPages.addMessage(myMsg);
            
            return null;
        }
        
        */
         
      Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='BMI-'+Crypto.getRandomInteger(),
                RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                get('BMI').getRecordTypeId(),
                Client_Chart__c=clientChartId,
                Status__c='Open',
                Time_Due__c = DateTime.now());
        try{    
            insert raNew;
        
        PageReference pr = new PageReference('/apex/BMIVfp?id='+clientChartId);
        return pr;  
        }
        catch(exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getmessage());
            ApexPages.addMessage(myMsg);
            return null;
        }      
        
    }
    
    public PageReference AddVitalSigns(){
        
        Recurring_Assessment__c ra = new Recurring_Assessment__c(Id=recordID);
        ra.Related_To__c = vitalSignID;
        
        update ra;
        
        PageReference pr = new PageReference('/apex/BMIVfp?id='+clientChartId);
        pr.setRedirect(true);
        return pr;
    }
    
    Public PageReference Save(){
        
        List<Recurring_Assessment__c> listRAToUpdate = new List<Recurring_Assessment__c>();
        
        for(wrapperRA wRa:  lstWrapperRA){
            if(setNewAssessmentsIds.contains(wRA.ra.Id)){
                if(wRA.ra.Height__c != null && wRA.ra.Weight__c !=null && wRA.ra.Gender__c != null){
                    wRA.ra.Status__c='Closed';
                    listRAToUpdate.add(wRa.ra);
                }
            }
        }
        update listRAToUpdate;
        
        List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, BMI_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      BMI_Assessment_Required__c = TRUE  and Client_Chart__c =: clientChartId];
        
        if(listConfigRA.size() > 0){
            list<string> rtime = listConfigRA[0].BMI_Assessment_Recurring_Time__c.split(' ');
            integer Hours = 0;
            if(listConfigRA[0].BMI_Assessment_Recurring_Time__c.contains('Days'))
                Hours = 24 * integer.valueof(rtime[1]);
            else
                Hours = integer.valueof(rtime[0]);
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='BMI-' + Crypto.getRandomInteger(),
                                                                        Time_Due__c = Datetime.now().addHours(Hours ),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('BMI').getRecordTypeId(),
                                                                        Client_Chart__c=clientChartId,
                                                                        Status__c='Open');
            
            insert raNew;
        }
        PageReference pr = new PageReference('/apex/BMIVfp?id='+clientChartId);
        
        return pr;
    }
    
    public PageReference UpdateFileupload(){
        

        
        User userObj = [select id,name, title from user where id=:UserInfo.getUserID()];
        
        //update AssementForm with the user signature 
        Recurring_Assessment__c ciwara = new Recurring_Assessment__c(Id=bmiId);
        
        
        ciwara.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
        ciwara.Doctor_Signed_User__c = 'Doctor present: ' + userObj.Name + ',' + userObj.Title;
        ciwara.Doctor_Signed_Date__c = DateTime.Now();
        //ord.Signed_By__c = 'All';                    
        
           
        update ciwara;
        
        return null;
        
    }
    
     public PageReference generatePDF(){
        system.debug('inside genpdf');
        lstSelectedRA = new list<wrapperRA>();
        
        system.debug(lstWrapperRA.size());
        
        for(wrapperRA wRA : lstWrapperRA){
            system.debug(wRA.selected);
            if(wRA.selected ){
                lstSelectedRA.add(wRA);
            }
        }
        system.debug(lstSelectedRA.size());
        PageReference pg = new PageReference ('/apex/BMIPDF?id='+clientChartId);
        pg.setRedirect(false);
        return pg;
                //return null;
    }
    
}