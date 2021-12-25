/*
    controller class for txDCHomeComponent.    
    @author: Huma Zafar
    TestClass : TxDCHomePageControllerTest
*/
public with sharing class TxDCHomePageController {
    
    
    public List<Tx_and_D_C_Plans__c> lstTxPlans{get;set;}
    public List<Tx_and_D_C_Plans__c> lstTxDischargePlans{get;set;}
    public boolean IsLeavingAgaintRecord {get;set;}
    
      public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('TxDCPlans');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
      public PageReference createLeavingAgainstRecord(){
        
        String clientChartId = ApexPages.currentPage().getParameters().get('id');
        ID RecordTypeID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Leaving Against Clinical Advice').getRecordTypeId();
        Tx_and_D_C_Plans__c txdcplan = new Tx_and_D_C_Plans__c();
        txdcplan.status__c = 'Open';
        txdcplan.RecordTypeID = RecordTypeID;
        txdcplan.Client_Chart__c = clientChartID;
        txdcplan.SignedBy__c ='None';
       
        insert txdcplan;
        
        PageReference pr = new PageReference('/apex/TxDcDetailPage');
        pr.getParameters().put('id', clientChartID);
        pr.getParameters().put('TXDX', txdcplan.ID);
        pr.getParameters().put('rt', ApexPages.currentPage().getParameters().get('rt'));
        pr.setRedirect(true);
        return pr;
        
    }
    
    public TxDCHomePageController(){
        loadPlans();
    }
    
    void loadPlans(){
        
        IsLeavingAgaintRecord = false;
        lstTxDischargePlans = new list<Tx_and_D_C_Plans__c>();
        lstTxPlans = new list<Tx_and_D_C_Plans__c>();
        String clientChartId = ApexPages.currentPage().getParameters().get('id');
        for(Tx_and_D_C_Plans__c tpPlan : [select id,RecordType.Name, Client_Chart__r.Name, Status__c ,Client_Chart__c, Due_Date_Time__c, Staff_Closed_Date__c, Staff_Signature_URL_Closed__c, Staff_Signature_URL__c, Staff_Active_Date__c, Staff_Signed_User_Closed__c, Staff_Signed_User__c, Intern_Signed_User__c from Tx_and_D_C_Plans__c Where Client_Chart__c =: clientChartId]){
            
            if(tpPlan.Status__c == '' || tpPlan.Status__c == null)    tpPlan.Status__c = 'Open';
            if(tpPlan.RecordType.Name == 'Discharge Plan' || tpPlan.RecordType.Name == 'leaving against clinical advice' || tpPlan.RecordType.Name == 'Personal Items Returned at Discharge'){
                
                if(tpPlan.RecordType.Name == 'leaving against clinical advice')
                    IsLeavingAgaintRecord = true;
                lstTxDischargePlans.add(tpPlan);
                
            }
                
            else
                lstTxPlans.add(tpPlan);
        }
       
    }
    
  
    
}