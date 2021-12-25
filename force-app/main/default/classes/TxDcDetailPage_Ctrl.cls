//Test Class : TxDcDetailPage_CtrlTest
public class TxDcDetailPage_Ctrl{

    public string RecordType{
        
        get;
        set;
    }
    
     public string ID{
        
        get;
        set;
    }
    
    Tx_and_D_C_Plans__c td;
    
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('TxDCPlans');
        
        if( visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    public TxDcDetailPage_Ctrl(){
    
           ID txPlanID = ApexPages.CurrentPage().getParameters().get('TXDX');
           
            td = [Select RecordType.Name,Client_Chart__c from Tx_and_D_C_Plans__c where ID =: txPlanID limit 1];
           RecordType = td.RecordType.Name;
           ID = td.Client_Chart__c ;
    }
    
   
    
  

}