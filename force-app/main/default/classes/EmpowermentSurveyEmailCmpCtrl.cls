public with sharing class EmpowermentSurveyEmailCmpCtrl {
 public Id epstId {get; set;}
 public Empowerment_Packet_Survey__c eps{get; set;}
 public string meetingsInterestedIn {get; set;}
 public string religiousService {get;set;}
 public List<string> ListofMeetings;
 public List<string> ListofWorshipPlaces;
 public List<wrapperClass> lstOfWrapper {get
 {
      List<wrapperClass> lstOfWrapperTemp = new List<wrapperClass>();
      eps=[SELECT id,Related_Opportunity__c,Related_Opportunity__r.Name,Support_Meetings_Interested_In__c,Email_Body_End__c,Google_MAP_API_Result__c 
                from Empowerment_Packet_Survey__c WHERE 
                id=:epstId ];
                
                 system.debug('$$$' + eps.Google_MAP_API_Result__c);
           meetingsInterestedIn= eps.Support_Meetings_Interested_In__c.replace( ';' , ',' );
           ListofMeetings=eps.Google_MAP_API_Result__c.split('\n');
            system.debug('$$$' + ListofMeetings);
           for(integer index = 0; index < ListofMeetings.size(); index+=4){
              string name = ListofMeetings[index].split(':')[1];
              string address = ListofMeetings[index+1].split(':')[1];
              string url = ListofMeetings[index+2].replace('Link :','');
              lstOfWrapperTemp .add(new wrapperClass(name,address,url));
              }
              return lstOfWrapperTemp ;
 
 }set;}
 public List<wrapperClass> lstOfWorshipWrapper {get
 {
      List<wrapperClass> lstOfWorshipWrapperTemp = new List<wrapperClass>();
      eps=[SELECT id,Related_Opportunity__c,Related_Opportunity__r.Name,What_Kind_of_Religious_Services__c,Interested_in_Attending_Religious_Servi__c,Email_Body_End__c,Google_Map_API_result_for_Worship__c 
                from Empowerment_Packet_Survey__c WHERE 
                id=:epstId ];
                
                 system.debug('$$$' + eps.Google_Map_API_result_for_Worship__c);
           //religiousService= eps.Interested_in_Attending_Religious_Servi__c;
           ListofWorshipPlaces=eps.Google_Map_API_result_for_Worship__c.split('\n');
            
        if(eps.What_Kind_of_Religious_Services__c=='Islamic'){
        religiousService = 'Mosque ';
        }
        
        else if(eps.What_Kind_of_Religious_Services__c=='Jewish'){
        religiousService = 'Synagogues ';
        }
        
        else 
        {
            religiousService = eps.What_Kind_of_Religious_Services__c + ' Church';
        }
            system.debug('$$$' + ListofWorshipPlaces);
            
            if(ListofWorshipPlaces.size() == 1){
                 lstOfWorshipWrapperTemp.add(new wrapperClass(ListofWorshipPlaces[0],'','',''));
                 return lstOfWorshipWrapperTemp;
            }
           for(integer index = 0; index < ListofWorshipPlaces.size(); index+=5){
              
              string name = ListofWorshipPlaces[index].split(':')[1];
              string address = ListofWorshipPlaces[index+1].split(':')[1];
              string contact = ListofWorshipPlaces[index+2].replace('Contact :','');
              string url = ListofWorshipPlaces[index+3].replace('URL :','');
              lstOfWorshipWrapperTemp.add(new wrapperClass(name,address,url,contact));
              }
              return lstOfWorshipWrapperTemp ;
 
 }set;}
 public string formattedMeetingList;
    public EmpowermentSurveyEmailCmpCtrl() {
      
      
    }
    
    public class wrapperClass{
        
        public string name {get;set;}
        public string address  {get;set;}
        public string url  {get;set;}
        public string contact {get;set;}
        public wrapperClass(string name,string address,string url){
            this.name = name;
            this.address = address;
            this.url = url;
        }
         public wrapperClass(string name,string address,string url,string contact){
            this.name = name;
            this.address = address;
            this.url = url;
            this.contact=contact;
        }
    }
    }