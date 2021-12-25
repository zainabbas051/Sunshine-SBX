/*
    controller -class for WellnessCheck vf page
    author huma
    
*/
public class WellnessCheckCtrl{
    
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
    
    public string clientChartId{get;set;}
    
    public boolean showAdd{get;set;}
    public boolean isRequired {get;set;}
    
      //AWS
    public string accessKeyId { get;set;}
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
    
    public string ciwaId {
        get;
        set;
    }
    
    public WellnessCheckCtrl(){
       clientChartId=ApexPages.currentPage().getParameters().get('id');
        
        //AWS
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
    }
    
    public void buildData(){
        lstWrapperRA = new list<wrapperRA>();
         
        listRA = [SELECT Id, Name,Observation_Location__c , Note__c, Awake_or_Asleep__c,
                  Time_Due__c, CreatedDate, Owner.Name,LastModifiedDate, Related_To__c, Related_To__r.Name 
                  ,Status__c
                  FROM Recurring_Assessment__c
                  WHERE RecordType.DeveloperName = 'Wellness_Check' and Client_Chart__c=:clientChartId order by createddate asc];
        
        setNewAssessmentsIds = new Set<Id>();
        
        for(Recurring_Assessment__c ra: listRA){
             lstWrapperRA.add(new wrapperRA(ra,False));
            if(ra.Status__c== 'Open')
                setNewAssessmentsIds.add(ra.Id);
        }
        
        List<Recurring_Assessment__c> listCiwaConfig = [SELECT Id, Wellness_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Client_Chart__c=:clientChartId and Wellness_Check_Required__c= TRUE];
        
        
        System.debug('cc:: ' + clientChartId);
        if(listCiwaConfig.size() > 0)
            showAdd = False;
        else
            showAdd= True;
    }
    
    public PageReference Add(){        
         
      Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='Wellness-'+Crypto.getRandomInteger(),
                RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                get('Wellness Check').getRecordTypeId(),
                Client_Chart__c=clientChartId,
                Status__c='Open',
                Time_Due__c = DateTime.now());
       try{     
            insert raNew;
        
        PageReference pr = new PageReference('/apex/WellnessCheck?id='+clientChartId);
        return pr;
           }
        catch(exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getmessage());
            ApexPages.addMessage(myMsg);
            return null;
        }     
    }
    
    
    Public PageReference Save(){
        
        List<Recurring_Assessment__c> listRAToUpdate = new List<Recurring_Assessment__c>();
        
        for(wrapperRA wRa:  lstWrapperRA){
            if(setNewAssessmentsIds.contains(wRa.ra.Id)){
                //if(wRA.ra.Observation_Location__c != null){
                    wRA.ra.Status__c='Closed';
                    listRAToUpdate.add(wRA.ra);
                //}
            }
        }
        update listRAToUpdate;
        if(listRAToUpdate.size()>0){
        List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, Wellness_Recurring_Time__c  FROM Recurring_Assessment__c WHERE 
                                                      Wellness_Check_Required__c= TRUE  and Client_Chart__c =: clientChartId];
        
        if(listConfigRA.size() > 0){
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='Wellness-' + Crypto.getRandomInteger(),
                                                                        Time_Due__c = Datetime.now().addMinutes(Integer.valueOf(listConfigRA[0].Wellness_Recurring_Time__c.replace('Q','').replace(' Hours',''))),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('Wellness Check').getRecordTypeId(),
                                                                        Client_Chart__c=clientChartId,
                                                                        Status__c='Open');
            
            insert raNew;
        }
        }
        PageReference pr = new PageReference('/apex/WellnessCheck?id='+clientChartId);
        return pr;
    }
    
    public PageReference UpdateFileupload(){
        
        System.debug('Ciwa ID:: ' + ciwaId);
        
        User userObj = [select id,name, title from user where id=:UserInfo.getUserID()];
        
        //update AssementForm with the user signature 
        Recurring_Assessment__c ciwara = new Recurring_Assessment__c(Id=ciwaId);
        
        
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
        PageReference pg = new PageReference ('/apex/WellnessPDF?id='+clientChartId);
        pg.setRedirect(false);
        return pg;
                //return null;
    }
    
    
}