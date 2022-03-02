//TEST CLASS : sendSMStoLeadQueueMembersTest
//Author : Naveen Chugh on 6/18/2014
//Action : This trigger sends out a Text message to the queue members when ever a new lead is assigned to a particular queue
//UPDATE : Updated this trigger on 07/11/2015 to Send Intake QUEUE texts to a common number, Tom and Chad's phone number only, instead of sending it to all Queue Members.
trigger sendSMSToLeadQueueMembers on Lead (after update){
    Public Boolean textRequired = False;//Flag to see if a TEXT is needed to be sent
    Public Boolean testClassCheckbox = False;//Flag to make sure Test Class works
     
    list<Id> leadId = new list<Id>();
    list<lead> leadUpd = new list<Lead>();
    
    system.debug('isFirstRun is:'+TriggerContextUtility.isFirstRun());
    Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
    Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    Id recTypeId = rtMapByName.get('Elite Rehab Placement').getRecordTypeId(); 
    Id recTypeIdMS = rtMapByName.get('Monarch Shores').getRecordTypeId();
       
       Map<String, string> queueNameIdMap = new Map<String, string>();
            
        list<Group> queueIdName = new list<Group>([Select Id, Name from Group where type=: 'Queue' AND Name !=: 'MS Closures Queue' AND Name !=: 'MS Intake Queue' AND Name !=: 'MS Unqualified Queue']);
                
        for(Group g : queueIdName){//Getting a list of all the queues and creating a map of there name and id's
            system.debug('Queue Id is:'+g.id);
            system.debug('Queue Name is:'+g.Name);
            queueNameIdMap.put(g.id,g.Name);            
        }   
                
        for(Lead ld : Trigger.New){
            if(ld.recordTypeId == recTypeId || ld.recordTypeId == recTypeIdMS){
                if(ld.isConverted==False){
                    if(queueNameIdMap.keyset().contains(ld.OwnerId) && 
                    (ld.Text_Sent_Queues__c==null || !ld.Text_Sent_Queues__c.contains(ld.OwnerId))){
                        leadId.add(ld.Id);
                        textRequired = True;
                    }
                }
            }
        }
        
        if(textRequired == True){
            
            if(TriggerContextUtility.isFirstRun() == True){  
             
            List<smagicinteract__smsMagic__c> smsObjects = new List<smagicinteract__smsMagic__c>();
            String tplText = null;
            Map<String, set<ID>> queueUserIdMap = new Map<String, set<ID>>();                        
            
            //Getting a list of all the members of all the queue found in the above query
            list<GroupMember> groupMember = new list<GroupMember>([Select UserOrGroupId, GroupId,Group.Name From GroupMember 
            where GroupId IN: queueNameIdMap.keyset()]);            
            
            //Going through all the members of the above found queue's and choosing the users out of them and assigning the users to the
            //    corresponding list according to queue name
            set<id> setQueueMemberUserIds = new set<id>();
           
            for(GroupMember grpMem : groupMember){
                String a = '005';
                String gId = grpMem.UserOrGroupId;//making sure the record is a user and not a group
                Integer result = gId.indexOf(a, 0);
                if(result == 0){
                    if(queueUserIdMap.containsKey(grpMem.GroupId)){
                        set<id> setUsers = queueUserIdMap.get(grpMem.GroupId);
                        setUsers.add(grpMem.UserOrGroupId);
                        setQueueMemberUserIds.add(grpMem.UserOrGroupId);
                    }
                    else{
                        queueUserIdMap.put(grpMem.GroupId,new set<id>{grpMem.UserOrGroupId});
                        setQueueMemberUserIds.add(grpMem.UserOrGroupId);
                    }
                }                            
            }
            system.debug('queueUserIdMap size is:'+queueUserIdMap.size());
            
            map<string,set<User>> mapQueueUsers = new map<string,set<User>>(); 
                       
            if(queueUserIdMap.size()>0){
               //Getting a list of all the users in the above Map
               Set<User> users = new Set<User>([ select Id, MobilePhone, Name from User where Id IN: setQueueMemberUserIds]);
               
               system.debug('User size is:'+users.size());
               //Assign out user records into corresponding list according to the queue they belong to.
               for(User u : users){
                   for(string queueId: queueUserIdMap.keyset()){
                       set<id> setUsersIds = queueUserIdMap.get(queueId);
                       if(setUsersIds.contains(u.id)){
                           if(mapQueueUsers.containsKey(queueId)){
                               set<user> setU = mapQueueUsers.get(queueId);
                               setU.add(u);
                           }
                           else{
                               mapQueueUsers.put(queueId,new set<user>{u});
                           }
                       }
                   }                   
               }                
            }
            
            //Getting a list of all the leads to which texts need to be sent
            for(Lead l : [select id, OwnerId, Text_Sent_Queues__c, Name, Test_Class_Checkbox__c from Lead where Id IN: leadId]){
                
                if(queueNameIdMap.keyset().contains(l.OwnerId) && 
                !NoSMSQueues__c.getall().keyset().contains(queueNameIdMap.get(l.OwnerId)) && 
                (l.Text_Sent_Queues__c==null || !l.Text_Sent_Queues__c.contains(l.OwnerId))){
                    if(queueNameIdMap.get(l.OwnerId).containsIgnoreCase('intake')){
                        set<string> setPhones = new set<string>();
                        setPhones.add('+12486021423');//Adding the number of Common Intake Mobile Phone Number
                        //setPhones.add(label.Chad_Daugherty_Phone);//Adding Chad Daugherty Phone Number from Custom Label
                        setPhones.add(label.Tom_Kearns_Phone);//Adding Tom Kearns Phone Number from Custom Label
                        for(string p : setPhones){
                            tplText = 'New Lead in '+queueNameIdMap.get(l.OwnerId)+' : '+ l.Name;//body of the text
                            smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
                            smsObj.smagicinteract__PhoneNumber__c = p;//Phone Number to which text is sent
                            smsObj.smagicinteract__SMSText__c = tplText;
                            //smsObj.smagicinteract__senderId__c = 'smsMagic';
                            smsObj.smagicinteract__senderId__c = '13173155065';
                            smsObj.smagicinteract__Name__c = 'Tom Kearns';
                            
                            smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                            smsObjects.add(smsObj);
                        }
                        l.Text_Sent_Queues__c = l.Text_Sent_Queues__c +';'+l.OwnerId;
                        leadUpd.add(l);
                        continue;
                    }
                    for(user u : mapQueueUsers.get(l.OwnerId)){
                        tplText = 'New Lead in '+queueNameIdMap.get(l.OwnerId)+' : '+ l.Name;//body of the text
                        smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
                        smsObj.smagicinteract__PhoneNumber__c = u.MobilePhone;//Phone Number to which text is sent
                        smsObj.smagicinteract__SMSText__c = tplText;
                        //smsObj.smagicinteract__senderId__c = 'smsMagic';
                        smsObj.smagicinteract__senderId__c = '13173155065';
                        smsObj.smagicinteract__Name__c = u.Name;
                        
                        smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                        smsObjects.add(smsObj);
                    }
                    
                    l.Text_Sent_Queues__c = l.Text_Sent_Queues__c +';'+l.OwnerId;
                    leadUpd.add(l);
                }
                testClassCheckbox = l.Test_Class_Checkbox__c;//Used as a dummy boolean flag for Test Class to avoid WEB SERVICE CALL
            }                        
            if(testClassCheckbox == False){//Used as a dummy boolean flag for Test Class to avoid WEB SERVICE CALL  
                if(!Test.isRunningTest()){
                    try{
                        insert smsObjects;//a list of all Texts that need to be sent
                    }Catch(exception e){
                        system.debug('exception e :::'+e.getMessage());
                        Map<String,String> subjectBodyMap = new Map<String,String>();
                        Map<String,Map<String,String>> emailMap = new Map<String,Map<String,String>>();
                        subjectBodyMap.put('Error Occured While Sending SMS In sendSMSToLeadQueueMembers',e.getMessage());
                        emailMap.put(label.Naveen_User_Id, subjectBodyMap);
                        Utilities.sendEmail(emailMap);
                    }
                }
            }            
        }
        if(leadUpd.size()>0){
            try{
                update leadUpd;//Updating the leads with text sent flags
            }catch(exception e){
                system.debug('exception e ::::'+e.getMessage());
                Map<String,String> subjectBodyMap = new Map<String,String>();
                Map<String,Map<String,String>> emailMap = new Map<String,Map<String,String>>();
                subjectBodyMap.put('Error Occured While Updating Lead Owner in sendSMSToLeadQueueMembers',e.getMessage());
                emailMap.put(label.Naveen_User_Id, subjectBodyMap);
                Utilities.sendEmail(emailMap);
            }
            
        }
        
        TriggerContextUtility.setFirstRunFalse();
    }
} // trigger code ends