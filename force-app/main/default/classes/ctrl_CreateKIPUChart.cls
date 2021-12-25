public class ctrl_CreateKIPUChart{
    
    id oppid; 
 
    public ctrl_CreateKIPUChart(){
        oppid =  ApexPages.CurrentPage().getParameters().get('id');
       
    }
    
    
    public PageReference CreatePatient(){
        
        KIPU_Services.CreatePatient(oppid);
        PageReference pr = new PageReference('/'+oppid);
        pr.setRedirect(true);
        return pr;
    }
}