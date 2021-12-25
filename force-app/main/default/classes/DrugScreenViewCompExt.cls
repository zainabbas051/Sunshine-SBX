// Test class: DrugScreenViewCompExtTest

public class DrugScreenViewCompExt {

    public Medical__c medical {get;set;}
    public string clientId {get;set;}
    public string mcid {get;set;}
    public string rtype {get; set;}
    string rtID {get;set;}
    
    public DrugScreenViewCompExt(){
        medical = new Medical__c();
        clientId = ApexPages.CurrentPage().getParameters().get('id');
        mcid= ApexPages.CurrentPage().getParameters().get('mcid');
        rtID = ApexPages.CurrentPage().getParameters().get('rtID');
        rtype = apexPages.currentPage().getParameters().get('rt')!=null ? apexPages.currentPage().getParameters().get('rt'):'';
    }
    
    public pageReference AddAttachment(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_MedicalAttachments?id='+mcid+'&rtID='+rtID+'&rt='+rtype);
        return pr;
    } 
    
   
    
}