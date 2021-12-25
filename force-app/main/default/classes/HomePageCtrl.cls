/*
    author: Huma Zafar
    controller for HomePage VF
    Test Class : HomePageTest
*/
public class HomePageCtrl{
    
    public boolean redirect{get;set;}
    public string facilityAccess{get;set;}
    
    public HomePageCtrl(){
        
        User u = [Select ID, Facility__c FROM User where ID =: UserInfo.getUserId()];
        if(u.Facility__c != null){
            facilityAccess = u.Facility__c;
            if(u.Facility__c.Contains(';')){
                redirect = false;
            }else{
                redirect = true;
            }    
        }else{
            facilityAccess = '';
            redirect = false;
        }
        
        
    }
    
    public PageReference redirectPage(){
        if(redirect){
            User u = [select id,Facility__c from User where id=:UserInfo.getUserId()];
            
            PageReference pg = new PageReference('/apex/Client?rt='+u.Facility__c);
            pg.setRedirect(true);
            return pg;
        }
        return null;
    }
    
    public PageReference showClients(){
        
        string recordtypeName = system.CurrentPageReference().getParameters().get('rtName');
        
        PageReference pg = new PageReference('/apex/Client?rt='+recordtypeName );
        pg.setRedirect(true);
        return pg;
    }
}