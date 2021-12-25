public class VitalSignsCompCntrl {
    
        
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
    
    
    public string clientChartId{get;set;}
    
    public list<wrapperRA> lstWrapperRA{get;set;}
    
    public list<wrapperRA> lstSelectedRA{get;set;}
    
    public List<Recurring_Assessment__c> listRA{get;set;}
    public Integer listRASize{
        get{
            if(!listRA.isEmpty())
                return listRA.size()-1;  
            return null;  
        }set;
    }
    Public Set<Id> setNewAssessmentsIds;
    
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
    
    public string vsId {
        get;
        set;
    }
    
    public VitalSignsCompCntrl(){
        clientChartId=ApexPages.currentPage().getParameters().get('id');
        
         //AWS
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
    }
    
    public void buildData(){
        listRA = [SELECT Id, Name, BP_Systolic__c, BP_Diastolic__c,  Temperature__c, Pulse__c,Respirations__c, X02_Saturation__c,
                   Time_Due__c, LastModifiedDate, Owner.Name, CreatedDate, Related_To__c, Related_To__r.Name,status__c ,
                   Client_Chart__c, Related_To__r.RecordType.Name, Doctor_Signed_User__c, Doctor_Signed_Date__c FROM Recurring_Assessment__c 
                  WHERE RecordType.DeveloperName='Vital_Signs' and Client_Chart__c=:clientChartId order by createddate asc];
        
        setNewAssessmentsIds = new Set<Id>();
        
        lstWrapperRA = new list<wrapperRA>();
        
        for(Recurring_Assessment__c ra: listRA){
            lstWrapperRA.add(new wrapperRA(ra,False));
            if(ra.Status__c == 'Open')
                setNewAssessmentsIds.add(ra.Id);
        }
        
        List<Recurring_Assessment__c> listVSConfig = [SELECT Id, CIWA_Assessment_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Client_Chart__c=:clientChartId and Vital_Signs_Required__c = TRUE];
        
        if(listVSConfig.size() > 0)
            showAdd = False;
        else
            showAdd= True;
    }
    
    public PageReference Add(){
        
        /*
        List<Recurring_Assessment__c> listConfigRA = [SELECT Id, Vital_SIgns_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Vital_SIgns_Required__c = TRUE];
        if(listConfigRA.size() == 0){
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='VS-'+Crypto.getRandomInteger(),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('Vital Signs').getRecordTypeId());
            
            insert raNew;
        }*/
        
         Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='VS-'+Crypto.getRandomInteger(),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('Vital Signs').getRecordTypeId(),
                                                                    Client_Chart__c=clientChartId,
                                                                    Status__c='Open',
                                                                    Time_Due__c = DateTime.now());
         try{   
            insert raNew;
            
        PageReference pr = new PageReference('/apex/VitalSignsVfp?id='+clientChartId);
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
        
            if(setNewAssessmentsIds.contains(wRA.RA.Id)){
                //if(wRA.RA.BP_Systolic__c != null && wRA.RA.BP_Diastolic__c != null && wRA.RA.Temperature__c !=null && 
                //wRA.RA.Pulse__c !=null && wRA.RA.Respirations__c !=null && wRA.RA.X02_Saturation__c !=null){
                    wRA.RA.Status__c='Closed';
                    listRAToUpdate.add(wRA.RA);
                //}
            }
        }
        update listRAToUpdate;
        if(listRAToUpdate.size()>0){
        List<Recurring_Assessment__c> listCOnfigRA = [SELECT Id, Vital_SIgns_Recurring_Time__c FROM Recurring_Assessment__c WHERE 
                                                      Vital_SIgns_Required__c = TRUE AND Client_Chart__c=:clientChartId];
        //updated add hours  to add minutes //HZ
        if(listConfigRA.size() > 0){
            string rtime = listConfigRA[0].Vital_SIgns_Recurring_Time__c.replace('Q','').replace(' Hours','');
            if (rtime == 'BID')
                rtime = '12';
            Recurring_Assessment__c raNew = new Recurring_Assessment__c(Name='VS-' + Crypto.getRandomInteger(),
                                                                        Time_Due__c = Datetime.now().addHours(Integer.valueOf(rtime )),
                                                                        RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().
                                                                        get('Vital Signs').getRecordTypeId(),
                                                                       Client_Chart__c=clientChartId,
                                                                       Status__c='Open');
            
            insert raNew;
        }
        }
        PageReference pr = new PageReference('/apex/VitalSignsVfp?id='+clientChartId);
        return pr;
    }
    
    public PageReference UpdateFileupload(){
        
        User userObj = [select id,name, title from user where id=:UserInfo.getUserID()];
        
        //update AssementForm with the user signature 
        Recurring_Assessment__c vsra = new Recurring_Assessment__c(Id=vsId);
        
        
        vsra.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
        vsra.Doctor_Signed_User__c = 'Staff Present: ' + userObj.Name + ',' + userObj.Title;
        vsra.Doctor_Signed_Date__c = DateTime.Now();
        //ord.Signed_By__c = 'All';                    
        
           
        update vsra;
        
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
        PageReference pg = new PageReference ('/apex/VitalSignsPDF?id='+clientChartId);
        pg.setRedirect(false);
        return pg;
                //return null;
    }
    
    
}