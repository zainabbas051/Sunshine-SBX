public class DMLRecord_Qeuable implements Queueable {
    
    List<sObject> lstObjectDml;
    string dmlMode;
    public DMLRecord_Qeuable(List<sObject> lstObject, string mode){
     
        lstObjectDml = lstObject;
        dmlMode = mode;
        
    
    }
    public void execute(QueueableContext context) {
    
       switch on dmlMode {
            when 'Update' {      
               update lstObjectDml;
            }   
           
        }       
    }
}