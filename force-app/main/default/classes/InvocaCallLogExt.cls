//test class : InvocaCallLogExtTest
public class InvocaCallLogExt {
    
    public string url {get;set;}
    
    public InvocaCallLogExt(ApexPages.StandardController ex){
        
        url = ex.cancel().getUrl();
    }

}