/*
    controller class for meds_actionorder component
    author Huma Zafar
*/
public class meds_ActionOrderController{
    
    id clientChartId;
    public Order__c order {get; set;}
    
     public id OrderByUserId{get;set;}
    string rtParam;
    
    public meds_ActionOrderController(){
        
        clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        rtParam = ApexPages.CurrentPage().getParameters().get('rt');
        system.debug( clientChartId);
        order = new Order__c();
        
    }
    
    public  List<SelectOption> getUsers(){
         
         set<id> userRoleId = new set<id>();
                 
        list<string> rts = rtParam.split(';');
        for(string sr: rts){
            Sunshine_Center_Id__c SC = Sunshine_Center_Id__c.getValues(sr);
            if(SC!=null)
            userRoleId.add(SC.Health_Care_Practitioner_Role_ID__c);
        }
                
        List<SelectOption> options = new List<SelectOption>();
        
        list<User> lstUsers = [select id,Name from  User where UserRoleId=:userRoleId];
        
        for(User u: lstUsers){
            options.add(new SelectOption(u.id,u.Name));
        }
        return options;
    }
    
     public  List<SelectOption> getFrequencies(){
    
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Order__c.Frequency__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            if(f.getValue()!='3 day (m,w,f)' && f.getValue()!='daily' && f.getValue()!='sessions' && f.getValue()!='weekdays only'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        } 
        return options; 
    }
    
    public PageReference submitFunc(){

      try{
          
        System.debug('submit button method'); 
        order.Client_Chart__c = clientChartId ;   
        order.Order_Type__c = 'Action';
        order.Order_By__c = OrderByUserId;
        insert (order);        
        
        //order = new Order__c();
        PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId+'&rt='+rtparam );
        meds.setRedirect(true);
        return meds;
      }
      catch(exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        return null;
      }
    }
}