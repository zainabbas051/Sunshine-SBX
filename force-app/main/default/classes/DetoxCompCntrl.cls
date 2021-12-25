public class DetoxCompCntrl {
    
    //testvar
    public integer test1;
    public integer test2;
    public integer test3;
    public integer test4;
    public integer test5;
    public integer test6;
    public integer test7;
    public integer test8;
    public integer test9;
    public integer test10;
    public integer test11;
    public integer test12;
    public integer test13;
    public integer test14;
    public integer test15;
    public integer test16;
    public integer test17;
    public integer test18;
    public integer test19;
    public integer test20;
    public integer test21;
    public integer test22;
    public integer test23;
    public integer test24;
    public integer test25;
    public integer test26;
    public integer test27;
    public integer test28;
    public integer test29;
    public integer test30;
    public integer test31;
    public integer test32;
    public integer test33;
    public integer test34;
    public integer test35;
    public integer test36;
    public integer test37;
    public integer test38;
    public integer test39;
    public integer test40;
    public integer test41;
    public integer test42;
    public integer test43;
    public integer test44;
    public integer test45;
    public integer test46;
    public integer test47;
    public integer test48;
    public integer test49;
    public integer test50;
    
    
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
    
    public DetoxCompCntrl (){
       clientChartId=ApexPages.currentPage().getParameters().get('id');
        
        //AWS
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
    }
    
    public void buildData(){
        
         lstWrapperRA = new list<wrapperRA>();
        listRA = [SELECT Id, Name,Vomitting__c, nausea__c, Tremors1__c, Observation_Location__c , Anxiety1__c,Sweating1__c,
                  paleness__C,  Diarhea__c, Cramps_Achesnsomnial__c, Fatigue__c, Restlessness1__c, Note__c,
                  Time_Due__c, CreatedDate, Owner.Name,LastModifiedDate, Related_To__c, Related_To__r.Name 
                  ,Status__c
                  FROM Recurring_Assessment__c
                  WHERE RecordType.DeveloperName = 'Detox_Check' and Client_Chart__c=:clientChartId order by createddate asc];
        
        setNewAssessmentsIds = new Set<Id>();
        
        for(Recurring_Assessment__c ra: listRA){
             lstWrapperRA.add(new wrapperRA(ra,False));
            if(ra.Status__c == 'Open')            
                setNewAssessmentsIds.add(ra.Id);
        }
        
        List<Recurring_Assessment__c> listCiwaConfig = [SELECT Id, Detox_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Client_Chart__c=:clientChartId and Detox_Required__c = TRUE];
        
        
        System.debug('cc:: ' + clientChartId);
        if(listCiwaConfig.size() > 0)
            showAdd = False;
        else
            showAdd= True;
    }
    
    public PageReference Add(){        
         
      Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='Detox-'+Crypto.getRandomInteger(),
                RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                get('Detox Check').getRecordTypeId(),
                Client_Chart__c=clientChartId,
                Status__c='Open',
                Time_Due__c = DateTime.now());
       try{     
            insert raNew;
        
        PageReference pr = new PageReference('/apex/DetoxCheck?id='+clientChartId);
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
            if(setNewAssessmentsIds.contains(wRA.ra.Id)){
                //if(ra.Observation_Location__c != null){
                    wRA.ra.Status__c='Closed';
                    listRAToUpdate.add(wrA.ra);
                //}
            }
        }
        update listRAToUpdate;
        if(listRAToUpdate.size()>0){
        List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, Detox_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Detox_Required__c = TRUE  and Client_Chart__c =: clientChartId];
        
        if(listConfigRA.size() > 0){
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='Detox-' + Crypto.getRandomInteger(),
                                                                        Time_Due__c = Datetime.now().addMinutes(Integer.valueOf(listConfigRA[0].Detox_Recurring_Time__c.replace('Q','').replace(' Hours',''))),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('Detox Check').getRecordTypeId(),
                                                                        Client_Chart__c=clientChartId,
                                                                        Status__c='Open');
            
            insert raNew;
        }
        }
        PageReference pr = new PageReference('/apex/DetoxCheck?id='+clientChartId);
        return pr;
    }
    
    public PageReference UpdateFileupload(){
        
        System.debug('Ciwa ID:: ' + ciwaId);
        
        User userObj = [select id,name, title from user where id=:UserInfo.getUserID()];
        
        //update AssementForm with the user signature 
        Recurring_Assessment__c ciwara = new Recurring_Assessment__c(Id=ciwaId);
        
        
        ciwara.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
        ciwara.Doctor_Signed_User__c = 'Staff Present: ' + userObj.Name + ',' + userObj.Title;
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
        PageReference pg = new PageReference ('/apex/DetoxPDF?id='+clientChartId);
        pg.setRedirect(false);
        return pg;
                //return null;
    }
}