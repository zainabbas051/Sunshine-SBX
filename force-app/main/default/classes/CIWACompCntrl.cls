public class CIWACompCntrl extends RA_Handler{
    
        
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
   
    
    public boolean createVS{get;set;}
    Public Recurring_Assessment__c vs {get;set;}
    
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
    
    public string ciwaId {
        get;
        set;
    }
    
    User userObj;
    
    public CIWACompCntrl(){
       clientChartId=ApexPages.currentPage().getParameters().get('id');
        
        //AWS
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        createVS = false;
        userObj = [select id,name, title from user where id=:UserInfo.getUserID()];
    }
    
    public void AddVS(){
        string ciwaid = system.CurrentPageReference().getParameters().get('param1');
        system.debug(ciwaid );
        
         
        if(ciwaid!='' && ciwaid!=null){
            for(Recurring_Assessment__c ra : listRA ){
                if(ra.id == ciwaid){
                    update ra;
                }
            }
        }
        createVS = true;
        
        List<Recurring_Assessment__c> listRA = [SELECT Id,BP_Diastolic__c, BP_Systolic__c, Temperature__c, Pulse__c,
                                                Respirations__c, X02_Saturation__c FROM Recurring_Assessment__c 
                                               WHERE Status__c= 'Open' and Recordtype.developerName='Vital_Signs' and CLient_Chart__c=:clientChartId order by Time_Due__c asc];
        if(listRA.size() > 0){
            vs = listRA[0];
            vs.Related_To__c= ciwaid;
        }else
            vs = new Recurring_Assessment__c(Name='VS-'+Crypto.getRandomInteger(),
                                         RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('Vital Signs').getRecordTypeId(),
                                            Related_To__c= ciwaid ,
                                            Client_Chart__c = clientChartId);
    }
    
    public void buildData(){
        
        lstWrapperRA = new list<wrapperRA>();
          
        listRA = [SELECT Id, Name,Nausea_Vomitting__c, Tremors__c, Agitation__c, Anxiety__c,Paroxysmal_Sweats__c, Client_Chart__c, Note__c,
                  Orientation__c, Tactile_Disturbances__c, Auditory_Disturbance__c, Visual_Disturbances__c, Doctor_Signed_Date__c, Doctor_Signed_User__c,  
                  CIWA_Score__c, Headache__c, Time_Due__c, CreatedDate, Owner.Name,LastModifiedDate, Related_To__c, Related_To__r.Name ,Status__c
                  FROM Recurring_Assessment__c
                  WHERE RecordType.DeveloperName = 'CIWA' and Client_Chart__c=:clientChartId order by createddate asc];
        
        setNewAssessmentsIds = new Set<Id>();
        
        string ciId = ApexPages.currentPage().getParameters().get('ciid');
        
        for(Recurring_Assessment__c ra: listRA){
            if( ciId !=null && string.valueOf(ra.ID).contains(ciId))
            	lstWrapperRA.add(new wrapperRA(ra,True));
            else
                lstWrapperRA.add(new wrapperRA(ra,False));
            if(ra.Status__c == 'Open')
                setNewAssessmentsIds.add(ra.Id);
        }
        
        List<Recurring_Assessment__c> listCiwaConfig = [SELECT Id, CIWA_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Client_Chart__c=:clientChartId and CIWA_Assessment_Required__c = TRUE];
        
        
        System.debug('cc:: ' + clientChartId);
        if(listCiwaConfig.size() > 0)
            showAdd = False;
        else
            showAdd= True;
        
         //PDF Page
        if(ciId != null)
           generatePDF();
    }
    
    public PageReference Add(){
                 
      Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='CIWA-'+Crypto.getRandomInteger(),
                RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                get('CIWA').getRecordTypeId(),
                Client_Chart__c=clientChartId,
                Status__c='Open',
                Time_Due__c = DateTime.now());
         try{   
            insert raNew;
        
        PageReference pr = new PageReference('/apex/CIWAVfp?id='+clientChartId);
        return pr;
        
        }
        catch(exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getmessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
    public void SaveVS(){
        createVS = false;
        vs.Status__c = 'Closed';
        vs.Time_Due__c = Datetime.now();
        vs.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
        vs.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
        vs.Doctor_Signed_Date__c = DateTime.Now();
        upsert vs;
        system.debug(vs);  
        system.debug(vs.Related_To__c);
        
         /*list<Recurring_Assessment__c> lstConfigRA =[select id, Vital_SIgns_Required__c,Vital_Signs_Recurring_Time__c, COWS_Assessment_Required__c from 
        Recurring_Assessment__c where Client_Chart__c =: clientChartId and RecordType.Name = 'Configurations'];
        
        
        if(lstConfigRA.size()>0 && lstConfigRA[0].Vital_SIgns_Required__c){
             string rtime = lstConfigRA[0].Vital_Signs_Recurring_Time__c.replace('Q','').replace(' Hours','');
             if (rtime == 'BID') rtime = '12';
             Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='VS-' + Crypto.getRandomInteger(),Time_Due__c = Datetime.now().addHours(Integer.valueOf(rtime)),
                RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId(), Client_Chart__c=clientChartId,Related_To__c =ApexPages.currentPage().getParameters().get('recId'),Status__c='Open');insert raNew;
        }*/
        
        string vitalSignID = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
        //extend method
        CreateOpenVS(clientChartId,vitalSignID);
        
        Recurring_Assessment__c RA = new Recurring_Assessment__c();
        RA.Id = vs.Related_To__c ;
        RA.Related_To__c = vs.id;
        update RA;
        /*
        for(Recurring_Assessment__c RAloop :listRA ){
            if(RAloop.id == RA.id)
                RAloop.Related_To__c = vs.id;
        }*/
        builddata();
    }
    
    
    
    Public PageReference Save(){
        
        List<Recurring_Assessment__c> listRAToUpdate = new List<Recurring_Assessment__c>();
        
        for(wrapperRA wRa:  lstWrapperRA){
            if(setNewAssessmentsIds.contains(wRA.ra.Id)){
                if(wRA.ra.Nausea_Vomitting__c != null && wRA.ra.Tremors__c != null && wRA.ra.Anxiety__c != null 
                && wRA.ra.Agitation__c !=null && wRA.ra.Paroxysmal_Sweats__c !=null &&
                  wRA.ra.Orientation__c != null && wRA.ra.Tactile_Disturbances__c != null && wRA.ra.Auditory_Disturbance__c != null 
                  && wRA.ra.Visual_Disturbances__c !=null && wRA.ra.Headache__c != null){
                    wRA.ra.Status__c='Closed';
                    listRAToUpdate.add(wRA.ra);
                }
            }
        }
        if(listRAToUpdate.size()>0){
        update listRAToUpdate;
        
         CreateOpenCIWA(clientChartId);
        
       /* List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, CIWA_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      CIWA_Assessment_Required__c = TRUE and Client_Chart__c =: clientChartId];
        
        if(listConfigRA.size() > 0){
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='CIWA-' + Crypto.getRandomInteger(),
                                                                        Time_Due__c = Datetime.now().addHours(Integer.valueOf(listConfigRA[0].CIWA_Assessment_Recurring_Time__c.replace('Q','').replace(' Hours',''))),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('CIWA').getRecordTypeId(),
                                                                        Client_Chart__c=clientChartId,
                                                                        Status__c='Open');
            
            insert raNew;
        }*/
        }
        PageReference pr = new PageReference('/apex/CIWAVfp?id='+clientChartId);
        return pr;
    }
    
    public PageReference UpdateFileupload(){
        
        System.debug('Ciwa ID:: ' + ciwaId);
        
      
        
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
        PageReference pg = new PageReference ('/apex/CIWAPDF?id='+clientChartId);
        pg.setRedirect(false);
        return pg;
                //return null;
    }
}