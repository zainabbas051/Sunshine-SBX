public class COWSCompCntrl extends RA_Handler{

    
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
    
    public string clientChartId{get;set;}
    
    public boolean showAdd{get;set;}
    
    
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
    
    public string cowsId {
        get;
        set;
    }
    
    User userObj ;
    
    public COWSCompCntrl(){
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
        createVS = true;
        
        if(ciwaid!='' && ciwaid!=null){
            for(Recurring_Assessment__c ra : listRA ){
                if(ra.id == ciwaid){
                    update ra;
                }
            }
        }
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
        
        listRA = [SELECT Id, Name,Sweating__c, Restlessness__c, Pupil_size__c, Bone_or_joint_aches__c,Runny_nose_or_tearing__c, Client_Chart__c,
                  Tremor_observation_of_outstretched_hands__c, Yawning_Observation_during_assessment__c, Anxiety_or_irritability__c, 
                  Gooseflesh_skin__c, GI_upset__c, COWS_Score_New__c, Doctor_Signed_Date__c, Doctor_Signed_User__c, Note__c,
                  Time_Due__c, CreatedDate, Owner.Name,LastModifiedDate, Related_To__c, Related_To__r.Name,status__c
                  FROM Recurring_Assessment__c WHERE RecordType.DeveloperName = 'COWS' and Client_Chart__c=:clientChartId order by createddate asc];
        
        setNewAssessmentsIds = new Set<Id>();
        
         string coId = ApexPages.currentPage().getParameters().get('coId');
        System.debug('cc:' + coId);
        
        for(Recurring_Assessment__c ra: listRA){
             if( coId !=null && string.valueOf(ra.ID).contains(coId))
            	lstWrapperRA.add(new wrapperRA(ra,True));
            else
                lstWrapperRA.add(new wrapperRA(ra,False));
            
            if(ra.Status__c == 'Open')
                setNewAssessmentsIds.add(ra.Id);
        }
        
         List<Recurring_Assessment__c> listCowsConfig = [SELECT Id, CIWA_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Client_Chart__c=:clientChartId and COWS_Assessment_Required__c = TRUE];
        
        if(listCowsConfig.size() > 0)
            showAdd = False;
        else
            showAdd= True;
        
        //PDF Page
        if(coId != null)
           generatePDF();
    }
    
    public PageReference Add(){
        
         Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='COWS-' + Crypto.getRandomInteger(),
                                                                       RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('COWS').getRecordTypeId(),
                                                                        Client_Chart__c=clientChartId,
                                                                        Status__c = 'Open',
                                                                        Time_Due__c = DateTime.now());
        try{    
            insert raNew;
        
        
        PageReference pr = new PageReference('/apex/COWSVfp?id='+clientChartId);
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
                /*if(ra.Sweating__c != null && ra.Restlessness__c != null && ra.Pupil_size__c != null && ra.Bone_or_joint_aches__c != null &&
                  ra.Runny_nose_or_tearing__c !=null && ra.Tremor_observation_of_outstretched_hands__c != null && ra.Yawning_Observation_during_assessment__c !=null &&
                   ra.Anxiety_or_irritability__c != null && ra.Gooseflesh_skin__c!=null && ra.GI_upset__c!=null){*/
                    wRA.ra.Status__c = 'Closed';
                    listRAToUpdate.add(wRA.ra);
                   //}
            }
        }
        if(listRAToUpdate.size()>0){
            update listRAToUpdate;
        
            CreateOpenCOWS(clientChartId);
        
        }
        PageReference pr = new PageReference('/apex/COWSVfp?id='+clientChartId);
        //PageReference pr = Page.COWSVfp;
        return pr;
    }
    
     public PageReference UpdateFileupload(){
        
        
        //update AssementForm with the user signature 
        Recurring_Assessment__c cowsra = new Recurring_Assessment__c(Id=cowsId);
        
        
        cowsra.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
        cowsra.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
        cowsra.Doctor_Signed_Date__c = DateTime.Now();
        //ord.Signed_By__c = 'All';                    
        
           
        update cowsra;
        
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
        PageReference pg = new PageReference ('/apex/COWSPDF?id='+clientChartId);
        pg.setRedirect(false);
        return pg;
                //return null;
    }
}