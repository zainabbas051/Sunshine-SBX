//Test Class : IncidentReportTest
public class IncidentDetailCtrl{

    public string RecordType {
        get;
        set;
    }

    public Boolean IsEdit {
        get;
        set;
    }

    public string ID {

        get;
        set;
    }

    public Incident_Report__c incident{

        get;
        set;
    }
    
    public User UserObj {
        
        get;
        set;
    }
    
    //hidden field
    public string SelectedSignedOption {
        get;
        set;
    }
    public string ImageUrlAddress {
        get;
        set;
    }
    
      //AWS
    public string accessKeyId {
        get;
        set;
    }
    public string secretAccessKey {
        get;
        set;
    }
    public string OrgName {
        get;
        set;
    }
    
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('IncidentReport');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    final string AWSURL;
    
    public boolean claim{get;set;}
    
    public boolean supervisor{get;set;}
    
    public boolean supervisorFields{get;set;}
    
    public list<SelectOption> listClientNames{get;set;}
    
    public list<string> clientNames{get;set;}
    
    public list<SelectOption> listStaffNames{get;set;}
    
    public list<string> staffNames{get;set;}
    
    public Map<String,id> allUserNameIdMap {get;set;} 
    public Sunshine_Center_Id__c scid{get;set;}
    
    public IncidentDetailCtrl() {
        
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        ID irId = ApexPages.CurrentPage().getParameters().get('IR');
        
        String RecType = ApexPages.CurrentPage().getParameters().get('rt');
        scid = Sunshine_Center_Id__c.getValues(RecType);
        
        UserObj = [Select Name ,title, User_Role__c,Supervisor__c, ManagerId from User where ID =: UserInfo.getUserID() limit 1];
        
        supervisor = UserObj.Supervisor__c ;
        
        incident = [Select Name ,RecordType.Name,id, Date_Time__c ,Name_s_of_Individuals_Involved__c ,
         Describe_the_event_in_detail__c, Status__c,
           SignedBy__c, 
       Type_of_Accident__c, Check_all_persons_involved__c ,Report_writer_Involved__c, Report_writer_observer__c, Regular_job_duties__c,
       Personal_Protective_Equipment_used__c, If_not_used_why__c, Actions_Taken_by_staff_members__c, Location_of_Incident__c ,
       Incident_Reported_By__c, Incident_Reported_By_Position__c, Incident_Reported_Date__c,
       Supervisor_Notified_Date_Time__c, Name_Of_Supervisor__c, Incident_Reviewed_By__c, Incident_Review_Claimed_Date_Time__c,
       Supervisor_Notified__c, Corrective_Action_Taken_Follow_Up__c, Director_Comments__c, Medical_Services_Workers_Compensation_rq__c,
       Compliance_Department_Representative__c, Supervisor_Image_URL__c , Supervisor_Signed_User__c , Supervisor_Closed_Date__c ,
            Staff_Closed_Date__c, Staff_Image_Url__c,  Staff_Signed_User__c,Compliance_Signed_User__c,Incident_Report_Closed_Time__c ,
            Compliance_Image_URL__c, Name_of_Staff_s_Involved__c, House__c, House__r.House_Name__c   from Incident_Report__c where ID =: irId limit 1
        ];
        
        claim = false;
        RecordType = incident.RecordType.Name;
        //ID = incident.Client_Chart__c;
        IsEdit = (ApexPages.CurrentPage().getParameters().get('edit') != null) ? true : false;
        
        if(incident.Status__c != 'Open'){
            supervisorFields = True;
        }else{
            supervisorFields = False;    
        }
        if(incident.Status__c == 'Under Supervisor Review' && incident.Incident_Reviewed_By__c ==null && supervisor){
            claim = true;
        }
        if(incident.Status__c == 'Under Supervisor Review' && !supervisor && !claim)
            IsEdit = false;
            
        if(incident.Status__c == 'Under Compliance Review' && UserInfo.getUserId()!=incident.Compliance_Department_Representative__c )
            IsEdit = false;
        
        getClientsName();    

    }
    
    public void claim(){
        incident.Incident_Reviewed_By__c = UserInfo.getUserId();
        incident.Incident_Review_Claimed_Date_Time__c = datetime.now();
        update incident;
        claim = false;
    }
    private void getClientsName(){
        string recordtype = ApexPages.CurrentPage().getParameters().get('rt');
        system.debug(recordtype );
        list<string> lstRecordTypes = recordtype.split(';');
        
        //Getting Data for Name of Clients Involved
        clientNames = new list<string>();
        if(incident.Name_s_of_Individuals_Involved__c!=null)
            clientNames = incident.Name_s_of_Individuals_Involved__c.split(';');
        
        listClientNames = new list<SelectOption>();
        
        /*
        //All Clients that has active reservation of Incident Report House
        for(UtlizationReviewOrder__c activeRes: [select id, Client_Chart__c, Client_Chart__r.name,Bed__c from UtlizationReviewOrder__c
                                                        where Bed__r.Room__r.House__c =: incident.House__c AND
                                                        Client_Chart__r.Client_Status__c = 'Admitted' AND 
                                                        Start_Date_Time__c <= TODAY AND End_Date_Time__c >= TODAY])
        {
            listClientNames.add(new SelectOption(activeRes.Client_Chart__r.name, activeRes.Client_Chart__r.name));
        }
        */
        
        list<Client_Chart__c> lstCC = [select id,Name from Client_Chart__c where RecordType.Name in: lstRecordTypes AND Client_Status__c = 'Admitted']; 
        for(Client_Chart__c  c: lstCC ){
            listClientNames.add(new SelectOption(c.Name,c.Name));
        }
        
        //Getting Values for Name of Staff Involved Field
        staffNames = new list<string>();
        if(incident.Name_of_Staff_s_Involved__c != null)
            staffNames = incident.Name_of_Staff_s_Involved__c.split(';');
        
        listStaffNames = new List<SelectOption>();
        allUserNameIdMap = new Map<String,Id>();
        String query = 'select id, Name from User where isactive = true AND Facility__c includes (';
        system.debug('first query :::'+query);
        String testString ='';
        
        for(String rType : lstRecordTypes){
            testString =testString+',\''+rType+'\'';
        }
        system.debug('first testString :::'+testString);
        testString = testString.removeStart(',');
        
        query = query+testString+')';
        system.debug('second query :::'+query);
        
        for(user u : Database.query(query)){
            listStaffNames.add(new SelectOption(u.Name,u.Name));
            allUserNameIdMap.put(u.Name,u.id);
        }
        system.debug('allUserNameIdMap 1 :::'+allUserNameIdMap);
        //return listClientNames ;
    }
    
    public PageReference CloseIncidentForm(){
        
        //update AssementForm with the user signature    
         if (SelectedSignedOption == 'Staff') {
                
                Map<String,String> smsMap = new Map<String,String>();
                smsMap.put(userObj.ManagerId,'A new Incident Report has been Submitted By : '+userObj.Name+' on : '+dateTime.now());
                Utilities.sendSMS(smsMap);
                incident.Staff_Image_URL__c = AWSURL + ImageUrlAddress;
                incident.Staff_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
                incident.Staff_Closed_Date__c = DateTime.Now();
                incident.SignedBy__c = 'Staff_IR';
                incident.Status__c = 'Under Supervisor Review';
                incident.Date_Received_By_Supervisor__c = datetime.now();
                claim = true;
            }
            else if (SelectedSignedOption == 'Supervisor') {

                incident.Supervisor_Image_URL__c = AWSURL + ImageUrlAddress;
                incident.Supervisor_Signed_User__c = 'Supervisor present: ' + userObj.Name + ',' + userObj.Title;
                incident.Supervisor_Closed_Date__c = DateTime.Now();
                incident.SignedBy__c = 'Supervisor';
                
                incident.Status__c = 'Under Compliance Review';
                incident.Compliance_Department_Representative__c = label.Compliance_Department_Representative;
                incident.Review_Completed_Date_Time__c = datetime.now();
            }
            else if (SelectedSignedOption == 'Compliance') {

                incident.Compliance_Image_URL__c= AWSURL + ImageUrlAddress;
                incident.Compliance_Signed_User__c = 'Compliance department representative present: ' + userObj.Name + ',' + userObj.Title;
                incident.Incident_Report_Closed_Time__c = DateTime.Now();
                incident.SignedBy__c = 'All';
                incident.Status__c = 'Closed';
            }
        update incident;
        return null;
    }
    

    public pageReference submit() {
        
        list<UtlizationReviewOrder__c> lst = [select id from UtlizationReviewOrder__c where Incident_Report__c =: incident.id];
        delete lst;
        list<UtlizationReviewOrder__c> lstCreateUR = new list<UtlizationReviewOrder__c>();
            
        system.debug(clientNames );
        if(clientNames.size()>0){
        
            list<Client_Chart__c> lstcc = [select id,Name from Client_Chart__c where Name in: clientNames ];//updatedclientnames];
            
            map<string,id> mapClientNameId = new map<string,id>();
            
            for(Client_Chart__c cc: lstcc){
                mapClientNameId.put(cc.Name,cc.Id);
            }
            
            UtlizationReviewOrder__c UR;
            
            string strpersons = '';
            system.debug(incident.id);
            for(string s : clientNames ){
                strpersons += s +';';
                UR = new UtlizationReviewOrder__c();
                system.debug(mapClientNameId.get(s));
                
                UR.Client_Chart__c = mapClientNameId.get(s);
                UR.Incident_Report__c = incident.id;
                system.debug(UR);
                lstCreateUR.add(UR);
            }
            system.debug(lstCreateUR);
            incident.Name_s_of_Individuals_Involved__c = strpersons ;
        }
        if(clientNames.size()==0 && incident.Name_s_of_Individuals_Involved__c != null)
            incident.Name_s_of_Individuals_Involved__c  = null;
        
        system.debug('staffNames :::'+staffNames);
        if(staffNames.size()>0){
            map<string,id> mapStaffNamesId = new map<string,id>();
            system.debug('allUserNameIdMap 2 :::'+allUserNameIdMap);
            for(String u: staffNames){
                if(allUserNameIdMap.containsKey(u)){
                    mapStaffNamesId.put(u,allUserNameIdMap.get(u));
                }
            }
            
            if(mapStaffNamesId.keyset().size()>0){
                UtlizationReviewOrder__c UR;
            
                string strpersons = '';
                system.debug(incident.id);
                for(string s : staffNames ){
                    strpersons += s +';';
                    UR = new UtlizationReviewOrder__c();
                    system.debug(mapStaffNamesId.get(s));
                    
                    UR.User__c = mapStaffNamesId.get(s);
                    UR.Incident_Report__c = incident.id;
                    system.debug(UR);
                    lstCreateUR.add(UR);
                }
                system.debug(lstCreateUR);
                incident.Name_of_Staff_s_Involved__c = strpersons ;
            }
            
            
        }
        if(staffNames.size()==0 && incident.Name_of_Staff_s_Involved__c != '')
            incident.Name_of_Staff_s_Involved__c  = '';
        
        upsert incident;
        
        if(lstCreateUR.size()>0)
            insert lstCreateUR;
         PageReference pr = new PageReference('/apex/IncidentReportDetailPage');        
         pr.getParameters().put('IR',incident.ID);
         pr.getParameters().put('rt',ApexPages.CurrentPage().getParameters().get('rt'));
         pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
         return pr;
    }  

}