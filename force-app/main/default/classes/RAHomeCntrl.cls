//Test Class : RAHomeCntrlTest
public class RAHomeCntrl {
    
    Public Recurring_Assessment__c ra{get;set;}
    //Public Boolean raMain{get;set;}
    Public Boolean flagCIWA{get;set;}
    public Map<string,List<FieldHistory>> mapOfHistory {get;set;}
    public List<string> lstOfFields {get;set;}
    
    Public Id clientChartId{get;set;}
    
   
    
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('RecurringAssessments');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
     public void RecurringAssessments(){
         
        
         clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        
        List<Recurring_Assessment__c> listConfigRA = [SELECT Id,Name, CIWA_Assessment_Required__c, CIWA_Assessment_Recurring_Time__c ,
                                                     COWS_Assessment_Required__c, COWS_Assessment_Recurring_Time__c ,Blood_Glucose_Assessment_Recurring_Time__c,
                                                     Blood_Glucose_Assessment_Required__c, BMI_Assessment_Recurring_Time__c, BMI_Assessment_Required__c,
                                                     Detox_Required__c, Detox_Recurring_Time__c,Wellness_Check_Required__c, Wellness_Recurring_Time__c,
                                                     Vital_SIgns_Required__c , Vital_SIgns_Recurring_Time__c FROM Recurring_Assessment__c
                                                      WHERE Name='Config' and Client_Chart__c=:clientChartId];
        if(listConfigRA.size() == 0)
            ra = new Recurring_Assessment__c();
        else
            ra = listConfigRA[0];
        
        //variables
        //raMain = true;
        flagCIWA = false;
        //get history logs
        GetHistory();
    }
    
    public PageReference upateConfig(){
        
        try{
            if(ra.id==null ){
                ra.Name='Config';
                ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
                ra.Client_Chart__c = clientChartId;
            }
            system.debug('name null');
            upsert ra;
            
            GetHistory();
            return null;
            
        }
        catch(exception  e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getmessage() +e.getLinenUmber());
            ApexPages.addMessage(myMsg);
            return null;
            
        }
        
    }
    
    void GetHistory(){
      
          
         string type = 'Recurring_Assessment__c';
         Map<string,Schema.SObjectType> schemaMap = schema.getGlobalDescribe();
         Schema.SObjectType recurringSchema = schemaMap.get(type);
         Map<String, Schema.SObjectField> fieldMap = recurringSchema.getDescribe().fields.getMap();
         lstOfFields = new List<string>();
           mapOfHistory = new Map<string,List<FieldHistory>>();
         lstOfFields.add('Vital');
           mapOfHistory.put('Vital',new List<FieldHistory>{ } );
         lstOfFields.add('CIWA');
           mapOfHistory.put('CIWA',new List<FieldHistory>{ } );
         lstOfFields.add('COWS');
           mapOfHistory.put('COWS',new List<FieldHistory>{ } );
         lstOfFields.add('Glucose');
           mapOfHistory.put('Glucose',new List<FieldHistory>{ } );
         lstOfFields.add('BMI');
           mapOfHistory.put('BMI',new List<FieldHistory>{ } );
         lstOfFields.add('Detox');
           mapOfHistory.put('Detox',new List<FieldHistory>{ } );
         lstOfFields.add('Wellness');
           mapOfHistory.put('Wellness',new List<FieldHistory>{ } );
        for(Recurring_Assessment__History raH: [SELECT ParentId, OldValue, NewValue, Field, CreatedBy.Name,CreatedById, CreatedDate FROM Recurring_Assessment__History
                                                WHERE ParentId =: ra.ID order by CreatedDate]){
                                           
           for(string value : lstOfFields){
               
               if(rah.Field.contains(value)){
                   
                    if(mapOfHistory.ContainsKey(value))
                    
                        mapOfHistory.get(value).add(new FieldHistory(rah,fieldMap.get(rah.Field).getDescribe().getLabel()));
               
               }
             
                 
                
           }
        }
    }
    
    public class FieldHistory{
        
        public Recurring_Assessment__History ra {get;set;}
        public string LabelName {get;set;}
        
         public FieldHistory(Recurring_Assessment__History aRa, string aLabel){
             ra = aRa;
             LabelName = aLabel;
         }
    }
    

}