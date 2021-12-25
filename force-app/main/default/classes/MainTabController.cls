/*
testclass : MainTabControllerTest
*/
public class MainTabController {
        
    public string AvailableTabs { get;set;}
    
    public MainTabController(){
        
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        
        AvailableTabs = 'none';
        
        if(!string.isNotBlank(u.Acess_Type__c)) return;
        AvailableTabs = '';
        
        Map<String,TabViews__c> allTabs = TabViews__c.getAll();
        
        for(string key : allTabs.keySet()){
            
            TabViews__c tabValue = allTabs.get(key);
            
            for(string access : u.Acess_Type__c.split(';')){
                
                if(tabValue.Tabs_Access_Type__c.contains(access) && tabValue.Is_Main_Tab__c)
                    AvailableTabs += key;
            }
            
        }

      /*  for(string acess : u.Acess_Type__c.split(';')){ 
            TabViews__c tabView = TabViews__c.getValues(acess);
            AvailableTabs += tabView.Main_Tabs_Available__c;
            
            
            
        }*/
            
       
        
        
        
    }

}