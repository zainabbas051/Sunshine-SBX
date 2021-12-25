//Test Class : ClinicalEvaluationDetailPage_Test
public class ClinicalEvaluationDetailPage 
{
    public boolean isEdit {get; set;}
    
    public string ClientID {get; set;}
    public string CEID {get; set;}
    public string RecordTypeName {get; set;}
    
        
    public Clinical_Evaluation__c ceRecord {get; set;}
    
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ClinicalEvaluation');
        
        if( visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    
    
    public ClinicalEvaluationDetailPage()
    {
        ClientID = ApexPages.CurrentPage().getParameters().get('ID');
        CEID = ApexPages.CurrentPage().getParameters().get('ceId');
        isEdit = (ApexPages.CurrentPage().getParameters().get('readOnly') != null)? true : false;
        RecordTypeName = ApexPages.CurrentPage().getParameters().get('type');
        
        if(ClientID == null)
        {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Client Chart ID(cid) parameter missing in URL.');
            ApexPages.addMessage(errMsg);
        }
    }
    
    
    
    public PageReference BackToHome()
    {
        PageReference pr = new PageReference('/apex/ClinicalEvaluationHomePage');
        pr.getParameters().put('ID',ClientID);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;
    }
    
}