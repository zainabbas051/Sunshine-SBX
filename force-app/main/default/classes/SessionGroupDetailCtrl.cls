/*
Test class : SessionGroupDetailCtrlTest
*/
public class SessionGroupDetailCtrl{
    
    
    public Group_Therapy_Session__c grp {get ;set;}
    public Group_Client__c newGrpClient { get ;set;}
    public List<Group_Client__c> grpClient {get ;set;}
    String GroupSessionId {get ;set;}
    public boolean IsUpdate {get;set;}
    public ID SessionGroupDetailCtrl {get;set;}
    //delete param
    public ID deleteRecordID {get;set;}
    public integer IndexToDelete { get;set;}
    public ID clientChartID { get;set;}
    
    Date TodayDate; 
    public string todayDateFormat { get ;set;}
    public string ImageUrlAddress { get ;set;}
    public boolean readOnly { get;set;}
    public string IsIntern { get;set;}
    public string UserName { get;set;}
    public List<Client_Chart__c> lstClientList  {get;set;}
    public string selectedOption { get; set;}
    Set<ID> existingGroupClient;
    Map<string,Client_Chart__c> mapOfClientChart;
    //AWS
    public string accessKeyId  {get ;set;}
    public string secretAccessKey {get; set;}
    public string OrgName {get; set;}
    
    
    string RecordType;
    public SessionGroupDetailCtrl(){
        
      readOnly = true;
      //readOnly = (ApexPages.currentPage().getParameters().get('mode') != null) ? true : false;
      accessKeyId  = Constants.accessKeyId;
      OrgName = Constants.OrgName;
      secretAccessKey = Constants.secretAccessKey ;
      GroupSessionId = ApexPages.currentPage().getParameters().get('ID');
      RecordType =  ApexPages.currentPage().getParameters().get('rt');
      TodayDate = Date.Today();
      todayDateFormat   = DateTime.newInstance(TodayDate.year(),TodayDate.month(),TodayDate.day()).format('MMMM dd,YYYY');
      IsUpdate = false;
      newGrpClient  = new Group_Client__c ();
      User u = [Select ID ,User_Role__c,Name,ManagerID from User where ID =: UserInfo.getUserID()];
      IsIntern = u.User_Role__c;
      UserName = u.Name;
      
      GetExistingGroupSession(GroupSessionId );
      GetExitingGroupClient(GroupSessionId );
      ClientList();
       
    }
    
    void GetExistingGroupSession(ID aGrpID){
      
      grp =  [Select ID, Name,OwnerID,Owner.Name,Programme_Name__c,Rehab_Facility__c,Duration__c,SignedBy__c ,ASW_Image_URL__c ,Group_Close_Date_Time__c,
              Status__c,Start_Time__c,End_Time__c,Date__c,Facility_Schedule__c,Group_Leader__c,Comments__c,Description__c,
              Sunshine_Center__r.Name, House__r.Name, House__c,Signed_User__c  from Group_Therapy_Session__c where ID =: aGrpID];
      
      
      if(grp.Status__c != 'Completed')
          grp.SignedBy__c = 'Client';
    
     
   }
   
    
  
   
   void GetExitingGroupClient (ID aGrpID){
       
       existingGroupClient = new Set<ID>();
       grpClient = [Select ID, Attendant__c,Status__c,Reason_For_Not_Attending__c, Client_Chart__c ,Group_Schedule__c , 
                    Client_Chart__r.Name, Client_Chart__r.Medical_Record_Number__c,    
                    
                    Client_Chart__r.Client_Image_URL2__c from Group_Client__c where Group_Schedule__c =: aGrpID order by ID ];
        
        for(Group_Client__c grpCl : grpClient)
            existingGroupClient.add(grpCl.Client_Chart__c);
        
          IsUpdate = true;
          ClientList();
      
   }
   
    void ClientList(){
        
        mapOfClientChart = new Map<string,Client_Chart__c>();
        if(existingGroupClient.isEmpty())
            lstClientList = [Select ID, Name, Medical_Record_Number__c from Client_Chart__c where Client_Chart__C.RecordType.Name =:RecordType AND Client_Status__c =: 'Admitted'];
        else
            lstClientList = [Select ID, Name ,Medical_Record_Number__c from Client_Chart__c  where ID not in : existingGroupClient
            AND Client_Chart__C.RecordType.Name =:RecordType AND Client_Status__c =: 'Admitted'];
        
        
   }
   
   public void EditGroupClient(){
       
       readOnly = False;
    
   }
   
   public void CancelGroupClient(){
       
       readOnly = True;
    
   }
   
   public PageReference SaveGroupClient(){
       
       if(grpClient.size() > 0){
            system.debug('$$$$$Test'+ grpClient);
            update grpClient ;
            // to update description and other fields
            update grp;
      
       }
        
       PageReference pr = new PageReference('/apex/SessionGroupDetail');
        pr.getParameters().put('ID',GroupSessionId);
        pr.getParameters().put('rt',ApexPages.currentPage().getParameters().get('rt'));
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;
    
   }
  
   
   public void DeleteGroupClient(){
       
       Group_Client__c  grpCl = [Select ID from Group_Client__c  where ID =: deleteRecordID];
       delete grpCl;
       
       grpClient.remove(IndexToDelete);
       existingGroupClient.remove(clientChartID);//remove the element so it should available in select list
       ClientList();
    
   }
   
   public void AddGroupClient(){
       
       List<Group_Client__c> lstGrpClient = new List<Group_Client__c>();
      
        selectedOption = selectedOption.subString(0,selectedOption.length() - 1);
       
       for(string client : selectedOption.split(',')){
           
           system.debug('client$$$4 ' +  client );
           newGrpClient  = new Group_Client__c ();
           newGrpClient.Group_Schedule__c  = GroupSessionId ;
           newGrpClient.Client_Chart__c = client;
           lstGrpClient.add(newGrpClient);
          
       }
       
        //add in the list
       if(!lstGrpClient.isEmpty()) {
            insert lstGrpClient;
           Set<ID> grpClientListID = new Set<ID>();
           
           for(Group_Client__c cr : lstGrpClient){
                grpClientListID.add(cr.ID);
                existingGroupClient.add(cr.Client_Chart__c);
           }
            List<Group_Client__c> newGrpClientList = [Select ID, Attendant__c, Status__c,Reason_For_Not_Attending__c,Client_Chart__c ,Group_Schedule__c , 
                                            Client_Chart__r.Name, Client_Chart__r.Medical_Record_Number__c,    
                                            Client_Chart__r.Client_Image_URL2__c from Group_Client__c where ID in : grpClientListID order by ID ];
       
      
            grpClient.addAll(newGrpClientList);
    
            ClientList();
          
       }
       
      
   }

  public void ClientUpdateEvent(){
   
         if(grpClient.size() > 0){
            system.debug('$$$$$Test'+ grpClient);
            update grpClient ;
            // to update description and other fields
            update grp;
      
        }
    }
    
    
    
    public PageReference CloseClientEvent(){
        
       // string ImageUrl = Apexpages.currentPage().getParameters().get('imageUrl');
        
            system.debug('@@@@@@ImageUrl');
            User u = [Select ID ,Name,Title,User_Role__c, ManagerID from User where ID =: UserInfo.getUserID()];
               
               //Commented out the following code, inorder to allow Interns and Non Credentialled Counsellors to Close there own Groups With Out Going To Under Review Status.
               /*if(u.User_Role__c != NULL){
                  grp.Status__c = 'Review Pending';
                  grp.Manager_ID__c = u.ManagerID ;
                  grp.Pending_Review_Date__c = Date.Today();
                  grp.ASW_Image_URL_Intern__c = 'http://freepu.s3.amazonaws.com/' + ImageUrlAddress ;
                  grp.Signed_User__c = 'Intern present: ' + u.Name + ',' + u.Title;
               }
                else
                {   
                    grp.Group_Close_Date_Time__c= DateTime.Now();
                    grp.Status__c = 'Completed';
                    grp.ASW_Image_URL__c = 'http://freepu.s3.amazonaws.com/' + ImageUrlAddress ;
                    grp.Signed_User__c = 'Staff present: ' + u.Name + ',' + u.Title;
                    List<Group_Client__c> lstGrpClient = [Select ID , Attendant__c, Status__c,Reason_For_Not_Attending__c, Client_Chart__c ,Group_Schedule__c , 
                                                        Client_Chart__r.Name, Client_Chart__r.Medical_Record_Number__c,    
                                                        Client_Chart__r.Client_Image_URL2__c from Group_Client__c where Group_Schedule__c =: grp.ID order by ID ];
                    CreateClientNotes(lstGrpClient, grp );
                    
                }
                */
                
                grp.Group_Close_Date_Time__c= DateTime.Now();
                grp.Status__c = 'Completed';
                grp.ASW_Image_URL__c = 'http://freepu.s3.amazonaws.com/' + ImageUrlAddress ;
                grp.Signed_User__c = 'Staff present: ' + u.Name + ',' + u.Title;
                List<Group_Client__c> lstGrpClient = [Select ID , Attendant__c, Status__c,Reason_For_Not_Attending__c, Client_Chart__c ,Group_Schedule__c , 
                                                        Client_Chart__r.Name, Client_Chart__r.Medical_Record_Number__c,    
                                                        Client_Chart__r.Client_Image_URL2__c from Group_Client__c where Group_Schedule__c =: grp.ID order by ID ];
                CreateClientNotes(lstGrpClient, grp );
                 
                   
                if(grpClient.size() > 0){
                    system.debug('$$$$$Test'+ grpClient);
                    update grpClient ;   
                }
                 
                // to update description and other fields
                grp.Duration__c = getDuration(grp);
                update grp;
                
              PageReference retURL = new PageReference('/apex/GroupSessions');
              retUrl.getParameters().put('rt',ApexPages.currentPage().getParameters().get('rt'));
              retURL.setRedirect(true);
              return retURL;
    
    }
     
     string getDuration(Group_Therapy_Session__c aGrp){
        
         integer startHour = integer.ValueOf(aGrp.Start_Time__c.split(' ')[0].split(':')[0]); //hour
         integer startMint = integer.ValueOf(aGrp.Start_Time__c.split(' ')[0].split(':')[1]); // minutes
         boolean startAM_PM =  (aGrp.Start_Time__c.split(' ')[1] == 'AM') ? true : false;
         integer endHour = integer.ValueOf(aGrp.End_Time__c.split(' ')[0].split(':')[0]); //hour
         integer endMint = integer.ValueOf(aGrp.End_Time__c.split(' ')[0].split(':')[1]); // minutes
         boolean endAM_PM =  (aGrp.End_Time__c.split(' ')[1] == 'AM') ? true : false;
         
         if(!startAM_PM) startHour += 12; 
         if(!endAM_PM) endHour += 12; 
         
         integer MintDiff = (endMint -  startMint);
         MintDiff = (MintDiff < 0) ? MintDiff *= -1 : MintDiff;
         integer hourDiff =  (endHour - startHour);
         hourDiff = (hourDiff < 0) ? hourDiff + 12 : hourDiff;
         string sHourDiff =  String.valueOf(hourDiff);
         string sMIntDiff = String.valueOf(MintDiff);
         return ((hourDiff  < 10) ? '0' + sHourDiff :sHourDiff)  + ':' + ((MintDiff < 10) ? '0' + sMIntDiff :sMIntDiff) ;
        
        
     }
     void CreateClientNotes(List<Group_Client__c> aLstGrpClient ,  Group_Therapy_Session__c grp){
        
        List<Clinical_Note__c> lstClinicalNotes = new List<Clinical_Note__c>();
        Id devRecordTypeId = Schema.SObjectType.Clinical_Note__c.getRecordTypeInfosByName().get('Group Session Notes').getRecordTypeId();
        User u =  [Select Name ,title,User_Role__c from User where ID =: UserInfo.getUserID() limit 1];
         
         integer startHour = integer.ValueOf(grp.Start_Time__c.split(' ')[0].split(':')[0]); //hour
         integer startMint = integer.ValueOf(grp.Start_Time__c.split(' ')[0].split(':')[1]); // minutes
         
         integer endHour = integer.ValueOf(grp.End_Time__c.split(' ')[0].split(':')[0]); //hour
         integer endMint = integer.ValueOf(grp.End_Time__c.split(' ')[0].split(':')[1]); // minutes
         
         boolean startAM_PM =  (grp.Start_Time__c.split(' ')[1] == 'AM') ? true : false;
         boolean endAM_PM =  (grp.End_Time__c.split(' ')[1] == 'AM') ? true : false;
         
         if(!startAM_PM && startHour != 12) startHour += 12; 
         
         if(startAM_PM && startHour == 12) startHour = 0;
         
         if(!endAM_PM && endHour!=12) endHour += 12; 
         
        for(Group_Client__c iGrpClient : aLstGrpClient){
            
            Clinical_Note__c clientNotes = new Clinical_Note__c();
            clientNotes.Client_Chart__c = iGrpClient.Client_Chart__c;
            clientNotes.Start_Date_Time__c = Datetime.newInstance(grp.Date__c.year(), grp.Date__c.month(), grp.Date__c.Day(),startHour , startMint, 0);
            clientNotes.End_Date_Time__c =  Datetime.newInstance(grp.Date__c.year(), grp.Date__c.month(), grp.Date__c.Day(),endHour , endMint, 0);
            clientNotes.End_Time__c = grp.End_Time__c;
            clientNotes.Start_Time__c = grp.Start_Time__c;
            clientNotes.Start_Time__c = grp.Start_Time__c;
            clientNotes.Group_Description__c = grp.Description__c;
            clientNotes.Topic__c = grp.Comments__c;
            clientNotes.RecordTypeID = devRecordTypeId;
            if(iGrpClient.Status__c == 'Yes'){
                clientNotes.Attendence__c = 'Attended';
                clientNotes.Attendant__c = iGrpClient.Attendant__c;
            }
            else{
                clientNotes.Attendence__c = 'Refused';  
                clientNotes.Absent_Reason__c = iGrpClient.Reason_For_Not_Attending__c;
            }  
            clientNotes.Group_Name__c = grp.Name;
            clientNotes.Signature_URL__c = grp.ASW_Image_URL__c;
            clientNotes.Group_Close_Date__c = grp.Group_Close_Date__c;
            clientNotes.status__c = 'Closed';
            clientNotes.Group_Client__c = iGrpClient.ID;
             clientNotes.Staff_Signed_User__c = 'Staff present: ' + u.Name+',' +u.Title;
             clientNotes.Staff_Closed_Date__c = DateTime.Now();
             clientNotes.SignedBy__c  = 'Staff';
             clientNotes.Duration__c =  getDuration(grp);
            
            lstClinicalNotes.add(clientNotes);
            
        }
        system.debug('test%%%%' +lstClinicalNotes);
        insert lstClinicalNotes ;
        
        
    }
    
    
    
}