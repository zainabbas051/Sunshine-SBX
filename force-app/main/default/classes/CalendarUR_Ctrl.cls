/*
test class : CalendarCtrlTest
*/
public class CalendarUR_Ctrl {
        
    
    public Boolean includeMyEvents {get;set;}

    public list<calEvent> events {get;set;}
    
    
      
         public string selectHouse {get;set;}
      
      public List<selectoption> houseLst {get;set;} 
      
      public string clientSelection {get;set;}
      
       
    Set<ID> setOfHouseClientChart;
     

    

    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly

    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
    User currentUser ;
    DateTime SDateTime;
    DateTime EDateTime;
     string RecordTypeName;

    

    //constructor

    public CalendarUR_Ctrl() {

        //Default showing my events to on
        
        currentUser = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId() limit 1]; 
          system.debug('#####' + events);
        includeMyEvents = true;
         RecordTypeName = ApexPages.currentPage().getParameters().get('rt');
            houseLst = new List<SelectOption>();
          houseLst.add(new SelectOption('','--None--'));
        for(Bed_Board_Configuration__c iBed : [Select id ,name,Sunshine_Center__r.Name from Bed_Board_Configuration__c where Sunshine_Center__r.Name=: RecordTypeName
                                                AND House_Name__c != '']){
            
                houseLst.add(new SelectOption(iBed.ID,iBed.Name));
        }
     
      
    }
    
    //Action method
    public PageReference pageLoad() {

      
        
      LoadCalendar();
        GetUtilizationReview();
      
      
        return null;

    }
    
     public void LoadCalendar(){
         
           RecordTypeName = ApexPages.currentPage().getParameters().get('rt');
        events = new list<calEvent>();
        currentUser = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId()]; 
        setOfHouseClientChart = new Set<ID>();
         if(clientSelection == 'ClientsHouse' && selectHouse != ''){
            
             Set<ID> setOfRoom = new Set<ID>();
         
             SYSTEM.DEBUG('&&&&' +selectHouse);
         
            for(Bed_Board_Configuration__c bd : [Select ID from Bed_Board_Configuration__c Where House__c =: selectHouse]){
                
                setOfRoom.add(bd.ID);
            }
        
            SYSTEM.DEBUG('####' + setOfRoom);
            if(setOfRoom.isEmpty())
              return ;
              
            
            Set<ID> setOfBed = new Set<ID>();
            
            for(Bed_Board_Configuration__c iRoom :[Select ID from Bed_Board_Configuration__c Where Room__c IN : setOfRoom]){
                
                setOfBed.add(iRoom.ID);
            }
       
           SYSTEM.DEBUG('####' + setOfBed);
            
            if(setOfBed.isEmpty())
                 return;
            
         
            
            for(UtlizationReviewOrder__c util :[Select id,Client_Chart__c,Bed__c from UtlizationReviewOrder__c
                                                where Bed__c IN :setOfBed AND (Status__c =: 'Active' OR Status__c =: 'Future Reservation')]){
                                                    
            
                      setOfHouseClientChart.add(util.Client_Chart__c);                                  
            }
            
                 
        }
        else if(clientSelection == 'ShowAllClients'){
            selectHouse = '';
             
         
            for(Client_Chart__c iCl : [Select Id from Client_Chart__c where RecordType.Name =: RecordTypeName]){
                setOfHouseClientChart.add(iCl.ID);                                  
            
            }
            
        }
       
        
        
      
    }
    
    
    
    
    void GetUtilizationReview(){
          
          Id CRRecordTypeId = Constants.ConcurrentReviewRecordTypeId;
          
          
          for(Utilization_Review__c ur : [Select ID,RecordType.Name, Status__c,Next_Review_Date__c, Client_Chart__c, Client_Chart__r.Name,Client_chart__r.UR_Representation__r.Name, CreatedDate from Utilization_Review__c where Client_Chart__c IN: setOfHouseClientChart AND RecordTypeId =: CRRecordTypeId
                                          ]){
              if(ur.Next_Review_Date__c != null){
                  
                  SDateTime = dateTime.NewInstance(ur.Next_Review_Date__c.year(),ur.Next_Review_Date__c.month(),ur.Next_Review_Date__c.day(),9,0,0);
                  EDateTime = dateTime.NewInstance(ur.Next_Review_Date__c.year(),ur.Next_Review_Date__c.month(),ur.Next_Review_Date__c.day(),9,20,0);
                
                  
                  CalEvent cl = new CalEvent();
                  cl.title = ur.RecordType.Name+'-'+ur.Client_Chart__r.Name;
                  cl.AllDay = false;
                  cl.startString = string.valueOf(SDateTime);
                  cl.endString = string.valueOf(EDateTime);
                  cl.Url = '/apex/UtilizationReviewHomePage?ID='+ur.Client_Chart__c+'&rt='+EncodingUtil.urlEncode(RecordTypeName, 'UTF-8');
                  cl.Description = ur.Client_chart__r.UR_Representation__r.Name;
                 if(ur.Status__c == 'Complete'){
                      cl.className = 'event-green';
                  }else{
                      cl.className = 'event-red';
                  }
                
                  events.add(cl);
              }
          }  
          
          
    }
        
    

    //Class to hold calendar event data

    public class calEvent{

        public String title {get;set;}

        public Boolean allDay {get;set;}

        public String startString {get;private set;}

        public String endString {get;private set;}

        public String url {get;set;}

        public String className {get;set;}
        
        public String Description {get;set;}
        
      
    }


}