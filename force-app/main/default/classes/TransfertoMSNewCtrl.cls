//Test Class : TransfertoMSNewCtrl 
public without sharing class  TransfertoMSNewCtrl {
    opportunity oppIns;
    opportunity MSOpp;
    public string oppID;
    public TransfertoMSNewCtrl(){
     oppID = ApexPages.currentPage().getParameters().get('id');
     oppIns = [select id,name,ownerid from opportunity where id =:oppID limit 1];
     //MSOpp = createMonarchShoresOpportunity(oppIns.id,'005U0000004lxkn');

    }
    
    public TransfertoMSNewCtrl(Id opportunityId, Boolean createMSOpp){
        oppID = opportunityId;
        oppIns = [select id,name,ownerid from opportunity where id =:oppID limit 1];
        if(createMSOpp == True)
            createMonarchShoresOpportunity();
    }
    
    public pagereference createMonarchShoresOpportunity(){
        Opportunity erpOpp = new Opportunity();
        Opportunity msOpp = new Opportunity();
        String msOppOwnerId;
        Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Monarch Shores').getRecordTypeId();
        if(oppID !=Null){
            
            String queryString = '';
            for(Opportunity_Transfer_Fields__c otf : Opportunity_Transfer_Fields__c.getall().values()){
                if(queryString == '')
                    queryString = 'Select '+otf.Name;
                else
                    queryString = queryString+', '+otf.Name;
            }
            system.debug('Interim queryString :::'+queryString);
            if(queryString.length()>7){
                queryString = queryString+', Insurance_Verification_Created_Date_Time__c, (Select Id, OpportunityId, ContactId, Role, IsPrimary  From OpportunityContactRoles) From Opportunity where Id =\'' +oppID+ '\' limit 1';
            
                system.debug('Final queryString :::'+queryString);
                erpOpp = Database.query(queryString);
            }
                    
            if(erpOpp != Null){
                msOpp = erpOpp.clone(false, true);
                msOpp.Referred_by__c = erpOpp.Closing_Agent__c;
                msOpp.Opening_Agent__c = userInfo.getUserId();
                msOpp.RecordTypeId = recTypeId;
                msOpp.StageName = 'Working';
                msOpp.Assignment_of_Benefits__c = erpOpp.Assignment_of_Benefits__c;
                msOpp.Usual_and_Customary__c = erpOpp.Usual_and_Customary__c;
                msOpp.LeadSource = 'Elite Rehab Placement';
                msOpp.Insurance_Verification_Created_Date_Time__c = erpOpp.Insurance_Verification_Created_Date_Time__c;
                msOpp.Insurance_Verified_By__c = erpOpp.Insurance_Verified_By__c;
                msOpp.Insurance_Verified_Time_Stamp__c = erpOpp.Insurance_Verified_Time_Stamp__c;
                msOpp.Last_Activity_Date__c = DateTime.now();
                String feedBody = 'This Opportunity Has Been Transferred to Monarch Shores';
                
                /*msOppOwnerId = getOpportunityOwner();
                
                if(msOppOwnerId  == null){//Seeing if no user is found for assignment from AC Schedule, the opp is assigned to Tahnil from where it can be accepted latter
                    msOpp.Closing_Agent__c = System.Label.Tahil_User_Id;//Making sure the selected user from the intermediate VF page is made the closing agent
                    msOpp.OwnerId = System.Label.Tahil_User_Id;
                }else{//If a user is found for assignment from AC Schedule, the opportunity is assigned to that user.
                    msOpp.Closing_Agent__c = msOppOwnerId;
                    msOpp.OwnerId = msOppOwnerId;
                }
                */
                
                FeedItem fi = new FeedItem();
                fi.Body = feedBody;
                fi.Type = 'AdvancedTextPost';
                fi.ParentId = erpOpp.id;                                
                
                try{
                    erpOpp.Last_Activity_Date__c =DateTime.now();
                    update erpOpp;
                    insert msOpp;
                    insert fi;
                    
                    //associate contact role
                    if(erpOpp.OpportunityContactRoles.size()>0){
                        
                        list<OpportunityContactRole> lstCreateOCR = new list<OpportunityContactRole>();
                        
                        for(OpportunityContactRole OCR : erpOpp.OpportunityContactRoles){
                            OpportunityContactRole newOCR = new OpportunityContactRole();
                            newOCR.OpportunityId = msOpp.id;
                            newOCR.ContactId = OCR.ContactId;
                            newOCR.Role = OCR.Role;
                            newOCR.IsPrimary = OCR.IsPrimary;
                            lstCreateOCR.add(newOCR);
                        }
                        if(lstCreateOCR.size()>0)
                            insert lstCreateOCR;
                    }
                    
                }catch(exception e){
                    system.debug('exception :::'+e.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage())); 
                }
            }
            
        }
        //sendSMS(msOpp.OwnerId,oppIns.name, msOppOwnerId);
        string returnURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppID ;
    return new PageReference(returnURL); 
   
   }
   
    public void sendSMS (string idval,string oppname, string msOppOwner){
         
         system.debug('idval'+ idval);
         user userIns=[SELECT name,mobilephone from user where id=:idval];
         
         //The Following SMS has become redundant, since it was sending an SMS on Lead Conversion to the user who converted the lead, informing him that the new Opp was assigned to him
         /*
         smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
         smsObj.smagicinteract__PhoneNumber__c = userIns.MobilePhone;//Phone Number to which text is sent
         smsObj.smagicinteract__SMSText__c = Oppname+', '+label.MS_Opportunity_Owner_Text;
         //smsObj.smagicinteract__senderId__c = 'smsMagic';
         smsObj.smagicinteract__senderId__c = '13173155065';
         smsObj.smagicinteract__Name__c = userIns.Name;
 
         if(!Test.isRunningTest()){
             smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
             insert smsObj;

         }
         */
        
        //list for sending VOB sms
         list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();   
         
                 
        //list for sending MS Closures sms    
        list<smagicinteract__smsMagic__c> lstSendSMSMS = new list<smagicinteract__smsMagic__c>();   

    
        
        //getting VOB queue Memeber details
        List<Group> QueueId = [select Id from Group where Name = 'VOB Queue' and Type = 'Queue'];
        
        List<GroupMember > QueueMemIDs  = [Select UserOrGroupId From GroupMember where GroupId =:QueueId ] ;
        set<id> UserIds=new set<id>();
        if(QueueMemIDs.size()>0){
            for(GroupMember GMIns: QueueMemIDs){
                UserIds.add(GMIns.UserOrGroupId );
            }
        } 
        list<user> VOBQueueMembers = [select id,name,MobilePhone from user where IsActive=true and id in :UserIds];
        
        //Sending SMS to VOBS    
        for(user VOBQueueMembersIns: VOBQueueMembers ){
        smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
            smsObjNew.smagicinteract__PhoneNumber__c = VOBQueueMembersIns.MobilePhone;//Phone Number to which text is sent
            smsObjNew.smagicinteract__SMSText__c = 'Please Initiate VOB for New MS Opportunity - '+Oppname;
            //smsObjNew.smagicinteract__senderId__c = 'smsMagic';
            smsObjNew.smagicinteract__senderId__c = '13173155065';
            smsObjNew.smagicinteract__Name__c = VOBQueueMembersIns.Name;
            
            smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            lstSendSMS.add(smsObjNew);
                        
        }
        if(lstSendSMS.size()>0){
            if(!Test.isRunningTest())
                insert lstSendSMS;
        }
        
        if(msOppOwner == null){//This means no user was found for auto assignment, thus the opp would go to Tahnil, and any AC can claim opp from there
            //getting MS Closures Queue Memeber details
            List<Group> MSQueueId = [select Id from Group where Name = 'MS Closures Queue' and Type = 'Queue'];
            List<GroupMember > MSQueueMemIDs  = [Select UserOrGroupId From GroupMember where GroupId =:MSQueueId ] ;
            set<id> MSUserIds = new set<id>();
            for(GroupMember MSGMIns: MSQueueMemIDs  ){
                MSUserIds.add(MSGMIns.UserOrGroupId );
            }
            
            list<user> MSClosureQueueMembers = [select id,name,MobilePhone from user where IsActive=true and id in :MSUserIds];
                
            // Sending SMS to  MS closures   
            for(user MSClosureQueueMembersIns: MSClosureQueueMembers ){
            smagicinteract__smsMagic__c smsObjNewMS = new smagicinteract__smsMagic__c();
                smsObjNewMS.smagicinteract__PhoneNumber__c = MSClosureQueueMembersIns.MobilePhone;//Phone Number to which text is sent
                smsObjNewMS.smagicinteract__SMSText__c = '"'+Oppname+'" has been assigned to the "'+userIns.name+'" queue, please claim it at the earliest!';
                
               //smsObjNewMS.smagicinteract__senderId__c = 'smsMagic';
                smsObjNewMS.smagicinteract__senderId__c = '13173155065';
                smsObjNewMS.smagicinteract__Name__c = MSClosureQueueMembersIns.Name;
                
                smsObjNewMS.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                lstSendSMSMS.add(smsObjNewMS);
                            
            }
        }else{//Sending SMS to Tahnil and Lynelle in case we found a user for Assignment from AC Schedule board.
            for(user u:  [select id,name,MobilePhone from user where id =:System.Label.Tahil_User_Id OR id=:system.label.Lynelle_Smith_Id]){
                smagicinteract__smsMagic__c smsObjNewMS = new smagicinteract__smsMagic__c();
                smsObjNewMS.smagicinteract__PhoneNumber__c = u.MobilePhone;//Phone Number to which text is sent
                smsObjNewMS.smagicinteract__SMSText__c = '"'+Oppname+'" has been assigned to "'+userIns.Name+'"';
                //smsObjNewMS.smagicinteract__senderId__c = 'smsMagic';
                smsObjNewMS.smagicinteract__senderId__c = '13173155065';
                smsObjNewMS.smagicinteract__Name__c = u.Name;
                smsObjNewMS.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                lstSendSMSMS.add(smsObjNewMS);
                            
            }
        }
        
        if(lstSendSMSMS.size()>0){
            if(!Test.isRunningTest())
                insert lstSendSMSMS;
        }
        
   }
   
   public String getOpportunityOwner(){
       
       String dayOfWeek=datetime.Now().format('EEEE');
       
       String returnOwnerId='';
       Integer hour = dateTime.now().hour();
       Integer minute = dateTime.Now().minute();
       system.debug('dayOfWeek:::'+dayOfWeek);
       List<MS_Admision_Coordinator_Schedule__c> availableForAssignmentList = new List<MS_Admision_Coordinator_Schedule__c>();
       List<MS_Admision_Coordinator_Schedule__c> allMSACSList = new List<MS_Admision_Coordinator_Schedule__c>();
       for(MS_Admision_Coordinator_Schedule__c mac : [select id, User__c, Last_Opportunity_Assigned__c,  Monday_OFF__c, Monday_Start_Time__c, Monday_End_Time__c, 
                                                       Tuesday_OFF__c, Tuesday_Start_Time__c, Tuesday_End_Time__c, Wednesday_OFF__c, Wednesday_Start_Time__c, 
                                                       Wednesday_End_Time__c, Thursday_OFF__c, Thursday_Start_Time__c, Thursday_End_Time__c, Friday_OFF__c, 
                                                       Friday_Start_Time__c, Friday_End_Time__c, Saturday_OFF__c, Saturday_Start_Time__c, Saturday_End_Time__c,
                                                       Sunday_OFF__c, Sunday_Start_Time__c, Sunday_End_Time__c, Available_for_Off_Hours_Assignment__c, Off_Hours_Last_Assigned__c
                                                       from MS_Admision_Coordinator_Schedule__c]){
           
           allMSACSList.add(mac);
           if((boolean)mac.get(dayOfWeek+'_OFF__c') == False){//checking to see if the current MAC row is available for assignment today or not
               String startTimeString = (String)mac.get(dayOfWeek+'_Start_Time__c'); 
               String[] startTime = startTimeString.split(':');//Splitting the Start Time of day into Hour and Minutes - startTime[0] is hour and startTime[1] is minute
               
               String endTimeString = (String)mac.get(dayOfWeek+'_End_Time__c');
               String[] endTime = endTimeString.split(':');//Splitting the End Time of day into Hour and Minutes - endTime[0] is hour and endTime[1] is minute  
               
               Boolean startTimeMatch=False;
               Boolean endTimeMatch = False;
               
               if(hour >= integer.valueOf(startTime[0]) && hour <= integer.valueOf(endTime[0])){//Checking to see that the hour now is within Start Hour and End Hour
                   if(hour == integer.valueOf(startTime[0])){//If the hour is same as the start hour, then we make sure minute is greater than start minute. 
                       if(minute >= integer.valueOf(startTime[1])){
                           startTimeMatch = True;
                       }
                   }else{
                       startTimeMatch = True;
                   }
                   if(hour == integer.valueOf(endTime[0])){//If the hour is same as the end hour, then we make sure minute is less than end minute.
                       if(minute <= integer.valueOf(endTime[1])){
                           endTimeMatch  = True;
                       }
                   }else{
                       endTimeMatch = True;
                   }
               }
               
               if(startTimeMatch && endTimeMatch)
               {
                   availableForAssignmentList.add(mac);//we figure out if any user is available for assignment
               }
               
           }
          
       }
       
       system.debug('availableForAssignmentList ::'+availableForAssignmentList);
       
       if(availableForAssignmentList.size()==0)
           if(allMSACSList.size()>0){
               availableForAssignmentList = offHoursOwnerAssignment(allMSACSList);
               if(availableForAssignmentList.size()==0){
                   return null;//No AC is available for Assignment even in off hours
               }else if(availableForAssignmentList.size()==1){
                   return availableForAssignmentList[0].User__c;
               }else{
                   integer indexOfLastAssigned = 0;//This gives us the index of the last assigned user
                   integer indexOfNextAssignment = 0;//this gives us the index of the user we are supposed to assign next
                   integer i=0;
                   for(MS_Admision_Coordinator_Schedule__c mac2 : availableForAssignmentList){
                       if(mac2.Off_Hours_Last_Assigned__c == True){
                           indexOfLastAssigned = i;  
                       }
                       i++;
                   }
                   if(indexOfLastAssigned == availableForAssignmentList.size()-1){//if the index of the last assigned used is the last record in the list, we go to 0 
                       indexOfNextAssignment = 0;
                   }else{
                       indexOfNextAssignment = indexOfLastAssigned+1;
                   }
                   
                   availableForAssignmentList[indexOfNextAssignment].Off_Hours_Last_Assigned__c = True;
                   availableForAssignmentList[indexOfLastAssigned].Off_Hours_Last_Assigned__c = False;
                   
                   String returnValue = availableForAssignmentList[indexOfNextAssignment].User__c;
                   try{
                       update availableForAssignmentList;//we update the MAC records, to use in the next assignment
                   }Catch (exception e){
                       system.debug('exception :::'+e.getMessage());
                   }
                   
                   return returnValue;//returning the id of the user to be assigned.    
               }
           }else{
               return null;//if we found no user active at current time in schedule, we return null so that opportunity can be assigned to Tahnil
           }
       else if(availableForAssignmentList.size()==1)
           return availableForAssignmentList[0].User__c;//if we found one suitable user we assign the opportunity to that user
       else if(availableForAssignmentList.size()>1){//if we found more that one suitable user for assignment, we will assign on the basis of round robin assignment, as described below    
           integer indexOfLastAssigned = 0;//This gives us the index of the last assigned user
           integer indexOfNextAssignment = 0;//this gives us the index of the user we are supposed to assign next
           integer i=0;
           for(MS_Admision_Coordinator_Schedule__c mac2 : availableForAssignmentList){
               if(mac2.Last_Opportunity_Assigned__c == True){
                   indexOfLastAssigned = i;  
               }
               i++;
           }
           if(indexOfLastAssigned == availableForAssignmentList.size()-1){//if the index of the last assigned used is the last record in the list, we go to 0 
               indexOfNextAssignment = 0;
           }else{
               indexOfNextAssignment = indexOfLastAssigned+1;
           }
           
           availableForAssignmentList[indexOfNextAssignment].Last_Opportunity_Assigned__c = True;
           availableForAssignmentList[indexOfLastAssigned].Last_Opportunity_Assigned__c = False;
           
           String returnValue = availableForAssignmentList[indexOfNextAssignment].User__c;
           try{
               update availableForAssignmentList;//we update the MAC records, to use in the next assignment
           }Catch (exception e){
               system.debug('exception :::'+e.getMessage());
           }
           
           return returnValue;//returning the id of the user to be assigned.
       }
       return null;
   }
   
   
   public static String getPremiumLeadOwner(){
       
       List<MS_Admision_Coordinator_Schedule__c> lstmac = [select id, User__c, User__r.Name, Last_Opportunity_Assigned__c,  Monday_OFF__c, Monday_Start_Time__c, Monday_End_Time__c, 
                                                       Tuesday_OFF__c, Tuesday_Start_Time__c, Tuesday_End_Time__c, Wednesday_OFF__c, Wednesday_Start_Time__c, 
                                                       Wednesday_End_Time__c, Thursday_OFF__c, Thursday_Start_Time__c, Thursday_End_Time__c, Friday_OFF__c, 
                                                       Friday_Start_Time__c, Friday_End_Time__c, Saturday_OFF__c, Saturday_Start_Time__c, Saturday_End_Time__c,
                                                       Sunday_OFF__c, Sunday_Start_Time__c, Sunday_End_Time__c, Available_for_Off_Hours_Assignment__c, Off_Hours_Last_Assigned__c
                                                       from MS_Admision_Coordinator_Schedule__c where User__r.Premium_Leads_Enabled_User__c = true];
       return getLeadOwner(lstmac);
   }
   
     public static String getNormalLeadOwner(){
       
       List<MS_Admision_Coordinator_Schedule__c> lstmac = [select id, User__c, User__r.Name, Last_Opportunity_Assigned__c,  Monday_OFF__c, Monday_Start_Time__c, Monday_End_Time__c, 
                                                       Tuesday_OFF__c, Tuesday_Start_Time__c, Tuesday_End_Time__c, Wednesday_OFF__c, Wednesday_Start_Time__c, 
                                                       Wednesday_End_Time__c, Thursday_OFF__c, Thursday_Start_Time__c, Thursday_End_Time__c, Friday_OFF__c, 
                                                       Friday_Start_Time__c, Friday_End_Time__c, Saturday_OFF__c, Saturday_Start_Time__c, Saturday_End_Time__c,
                                                       Sunday_OFF__c, Sunday_Start_Time__c, Sunday_End_Time__c, Available_for_Off_Hours_Assignment__c, Off_Hours_Last_Assigned__c
                                                       from MS_Admision_Coordinator_Schedule__c];
       return getLeadOwner(lstmac);
   }
   
    static String getLeadOwner(List<MS_Admision_Coordinator_Schedule__c> lstmac){
       
       String dayOfWeek=datetime.Now().format('EEEE');
       
       String returnOwnerId='';
       Integer hour = dateTime.now().hour();
       Integer minute = dateTime.Now().minute();
       system.debug('dayOfWeek:::'+dayOfWeek);
       List<MS_Admision_Coordinator_Schedule__c> availableForAssignmentList = new List<MS_Admision_Coordinator_Schedule__c>();
       List<MS_Admision_Coordinator_Schedule__c> allMSACSList = new List<MS_Admision_Coordinator_Schedule__c>();
       for(MS_Admision_Coordinator_Schedule__c mac : lstmac){
           
           allMSACSList.add(mac);
           if((boolean)mac.get(dayOfWeek+'_OFF__c') == False){//checking to see if the current MAC row is available for assignment today or not
               String startTimeString = (String)mac.get(dayOfWeek+'_Start_Time__c'); 
               String[] startTime = startTimeString.split(':');//Splitting the Start Time of day into Hour and Minutes - startTime[0] is hour and startTime[1] is minute
               
               String endTimeString = (String)mac.get(dayOfWeek+'_End_Time__c');
               String[] endTime = endTimeString.split(':');//Splitting the End Time of day into Hour and Minutes - endTime[0] is hour and endTime[1] is minute  
               
               Boolean startTimeMatch=False;
               Boolean endTimeMatch = False;
               
               if(hour >= integer.valueOf(startTime[0]) && hour <= integer.valueOf(endTime[0])){//Checking to see that the hour now is within Start Hour and End Hour
                   if(hour == integer.valueOf(startTime[0])){//If the hour is same as the start hour, then we make sure minute is greater than start minute. 
                       if(minute >= integer.valueOf(startTime[1])){
                           startTimeMatch = True;
                       }
                   }else{
                       startTimeMatch = True;
                   }
                   if(hour == integer.valueOf(endTime[0])){//If the hour is same as the end hour, then we make sure minute is less than end minute.
                       if(minute <= integer.valueOf(endTime[1])){
                           endTimeMatch  = True;
                       }
                   }else{
                       endTimeMatch = True;
                   }
               }
               
               if(startTimeMatch && endTimeMatch)
               {
                   availableForAssignmentList.add(mac);//we figure out if any user is available for assignment
               }
               
           }
          
       }
       
       system.debug('availableForAssignmentList ::'+availableForAssignmentList);
       
       if(availableForAssignmentList.size()==0)
           if(allMSACSList.size()>0){
               availableForAssignmentList = offHoursOwnerAssignment(allMSACSList);
               if(availableForAssignmentList.size()==0){
                   return null;//No AC is available for Assignment even in off hours
               }else if(availableForAssignmentList.size()==1){
                   return availableForAssignmentList[0].User__c;
               }else{
                   integer indexOfLastAssigned = 0;//This gives us the index of the last assigned user
                   integer indexOfNextAssignment = 0;//this gives us the index of the user we are supposed to assign next
                   integer i=0;
                   for(MS_Admision_Coordinator_Schedule__c mac2 : availableForAssignmentList){
                       if(mac2.Off_Hours_Last_Assigned__c == True){
                           indexOfLastAssigned = i;  
                       }
                       i++;
                   }
                   if(indexOfLastAssigned == availableForAssignmentList.size()-1){//if the index of the last assigned used is the last record in the list, we go to 0 
                       indexOfNextAssignment = 0;
                   }else{
                       indexOfNextAssignment = indexOfLastAssigned+1;
                   }
                   
                   availableForAssignmentList[indexOfNextAssignment].Off_Hours_Last_Assigned__c = True;
                   availableForAssignmentList[indexOfLastAssigned].Off_Hours_Last_Assigned__c = False;
                   
                   String returnValue = availableForAssignmentList[indexOfNextAssignment].User__c+';'+availableForAssignmentList[indexOfNextAssignment].User__r.Name;
                   try{
                       update availableForAssignmentList;//we update the MAC records, to use in the next assignment
                   }Catch (exception e){
                       system.debug('exception :::'+e.getMessage());
                   }
                   
                   return returnValue;//returning the id of the user to be assigned.    
               }
           }else{
               return null;//if we found no user active at current time in schedule, we return null so that opportunity can be assigned to Tahnil
           }
       else if(availableForAssignmentList.size()==1)
           return availableForAssignmentList[0].User__c;//if we found one suitable user we assign the opportunity to that user
       else if(availableForAssignmentList.size()>1){//if we found more that one suitable user for assignment, we will assign on the basis of round robin assignment, as described below    
           integer indexOfLastAssigned = 0;//This gives us the index of the last assigned user
           integer indexOfNextAssignment = 0;//this gives us the index of the user we are supposed to assign next
           integer i=0;
           for(MS_Admision_Coordinator_Schedule__c mac2 : availableForAssignmentList){
               if(mac2.Last_Opportunity_Assigned__c == True){
                   indexOfLastAssigned = i;  
               }
               i++;
           }
           if(indexOfLastAssigned == availableForAssignmentList.size()-1){//if the index of the last assigned used is the last record in the list, we go to 0 
               indexOfNextAssignment = 0;
           }else{
               indexOfNextAssignment = indexOfLastAssigned+1;
           }
           
           availableForAssignmentList[indexOfNextAssignment].Last_Opportunity_Assigned__c = True;
           availableForAssignmentList[indexOfLastAssigned].Last_Opportunity_Assigned__c = False;
           
           String returnValue = availableForAssignmentList[indexOfNextAssignment].User__c+';'+availableForAssignmentList[indexOfNextAssignment].User__r.Name;
           try{
               update availableForAssignmentList;//we update the MAC records, to use in the next assignment
           }Catch (exception e){
               system.debug('exception :::'+e.getMessage());
           }
           
           return returnValue;//returning the id of the user to be assigned.
       }
       return null;
   }
   
   public boolean vobRequestStatus(String insuranceProvider, Boolean cashClient){
       if(insuranceProvider != '' && insuranceProvider != null){
           if(cashClient == True){
               return False;
           }else{
               if(insuranceProvider.containsIgnoreCase('United') || insuranceProvider.containsIgnoreCase('uhc') || insuranceProvider.containsIgnoreCase('United Healthcare')){
                   return False;
               }
               else{
                   return True;
               }
           }
       }
       return False;
   }
   
   public static List<MS_Admision_Coordinator_Schedule__c> offHoursOwnerAssignment(List<MS_Admision_Coordinator_Schedule__c> msacsList){
       if(msacsList.size()>0){
           List<MS_Admision_Coordinator_Schedule__c> returnList = new List<MS_Admision_Coordinator_Schedule__c>();
           for(MS_Admision_Coordinator_Schedule__c msac : msacsList){
               if(msac.Available_for_Off_Hours_Assignment__c == True){
                   returnList.add(msac);
               }
           }
           return returnList;
       }
       
       return null;
   }
   
   public ID initiateVOBRequest(String oppId, String InsuranceInfoId){
       try{
           
           
           VOB_Request__c vr = new VOB_Request__c();
           vr.Opportunity__c = oppId;
           //vr.Insurance_Information__c = InsuranceInfoId;
           //vr.Insurance_Verification__c = iv.id;
           vr.VOB_Request_Status__c = 'Open';
           insert vr;
          
          
           Insurance_Verification__c iv = new Insurance_Verification__c();
           iv.Opportunity__c = oppId;
           iv.Related_Insurance_Information__c = InsuranceInfoId;
           iv.VOB_Request__c = vr.id;
           insert iv;
           
           return vr.id;
       }catch(exception e){
           return null;
       }
       return null;
   }
   
   public id createInsuranceInfo(String OppId, String subscriberName, String insuranceProviders, String insurancePolicy, String groupNumber, String insuranceProviderPhoneNumber,
                                 String subscriberDOB, String ssnLast4, String address, String address2, String city, String state, String zipCode, String country, 
                                 String employer){
       
       Insurance_Information__c ii = new Insurance_Information__c();
       ii.Opportunity__c = oppId;
       ii.Subscriber_Name__c = subscriberName;
       ii.Insurance_Providers__c = insuranceProviders;
       ii.Insurance_Policy__c = insurancePolicy;
       ii.Group_Number__c = groupNumber;
       ii.Insurance_Provider_Phone_Number__c = insuranceProviderPhoneNumber;
       ii.Subscriber_DOB__c = subscriberDOB;
       ii.SSN_Last_4__c = ssnLast4;
       ii.Address__c = address;
       ii.Address_2__c = address2;
       ii.City__c = city;
       ii.State__c = state;
       ii.Zip_Code__c = zipCode;
       ii.Country__c = country;
       ii.Employer__c = employer;
       insert ii;
       
       return ii.id;
       
   }
   
   public opportunity initiateVOBTempOpportunity(id oppId){
       opportunity tempOpp = new Opportunity(id = oppId);
       tempOpp.VOB_Status__c = 'Open';
       tempOpp.Insurance_Verified_By__c = null;
       tempOpp.VOB_Agent__c = null;
       tempOpp.Insurance_Verified_Time_Stamp__c = null;
       tempOpp.VOB_Completed__c = null;
       
       return tempOpp;
   }
}