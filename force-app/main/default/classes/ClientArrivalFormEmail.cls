global without sharing class ClientArrivalFormEmail{

    webservice static String ClientArrivalFormEmail(String oppId){
         system.debug('oppId::::'+oppId);
         string result;
         Opportunity opp = new Opportunity();

         if(oppId != null){
             for(Opportunity o : [select id, AccountID, Name,LeadSource, CloseDate, Email__c, Age__c, Allergies__c, Allergic_Reaction__c, Incoming_Number__c, Family_Contact_Name__c, Family_Contact_Relationship__c,
                     Family_Contact_Phone__c, Client_Aware_of_No_Return_Flight__c, Cash_Client__c, Date__c, Arrival_Time__c, Arrival_Date_Time__c, Arriving_Airport__c, Travel_Notes__c,
                     Airport__c, Airline__c, Flight_Number__c, Drug_of_Choice_1__c, Drug_of_Choice_2__c, Drug_of_Choice_3__c, Current_Use_Details_Drug_1__c,
                     Current_Use_Details_Drug_2__c, Current_Use_Details_Drug_3__c, Date_of_Last_Use_Drug_1__c, Date_of_Last_Use_Drug_2__c, Date_of_Last_Use_Drug_3__c,
                     Psychiatric_Co_occurring_Issues__c, Frequency_of_Use_Drug_1__c, Frequency_of_Use_Drug_2__c, Frequency_of_Use_Drug_3__c, Pharmacy_Information_Sent__c,
                     Vape_Needed__c, House__c, Bed__c, Client_Arrival_Form_Email_Sent__c, Client_Arrival_Form_Email_Sent_Date_Time__c, Sunshine_Center__r.Name, Previous_Treatment_Episodes__c,
                     Previous_ACAs__c,Diet__c,FMLA_Needed__c,Medication_Scholarship__c,WS_Medication__c from opportunity where id=: oppId]){
                 opp = o;        
             }
         }
         system.debug('opportunity id ::'+opp.id);
         String emailBody;
         string MobAppUsername = '';
         string MobAppPassword = '';
         if(opp.id != null){

            //Added by Zain Abbas - Update in Relpased Logic in Mobile App
            
            if(opp.AccountId != null){
                Alumni_App_Detail__c appDet = new Alumni_App_Detail__c();
                for(Alumni_App_Detail__c app : [select id, Username__c, Password__c, (select id from App_Detail_Histories__r where Opportunity__c =: opp.id)
                                                         from Alumni_App_Detail__c where Account__c =: opp.accountId Limit 1]){
                    appDet = app;                    
                }
                
                if(appDet != null && appDet.id != null){
                    MobAppUsername = appDet.Username__c;
                    MobAppPassword = appDet.Password__c;

                    if(appDet.App_Detail_Histories__r.size() == 0){
                        App_Detail_History__c appH = new App_Detail_History__c();
                        appH.Opportunity__c = opp.Id;
                        appH.Alumni_App_Detail__c = appDet.id;
                        insert appH;
                    }
                    appDet.Current_Opportunity_Closed_Date__c = opp.CloseDate;
                    update appDet;
                }
                else{
                    if(!String.isBlank(opp.email__c)){
                        try{
                            Alumni_App_Detail__c appDetToCreate = new Alumni_App_Detail__c();
                            appDetToCreate.Username__c = opp.email__c;
                            appDetToCreate.User_Email__c = opp.email__c;
                            appDetToCreate.Password__c = 'Pa$$word';
                            appDetToCreate.Account__c = opp.AccountId;
                            appDetToCreate.Current_Opportunity_Closed_Date__c = opp.CloseDate;
                            insert appDetToCreate;
                            
                            App_Detail_History__c appHisToCreate = new App_Detail_History__c();
                            appHisToCreate.Opportunity__c = opp.Id;
                            appHisToCreate.Alumni_App_Detail__c = appDetToCreate.id;

                            insert appHisToCreate;
                            
                            MobAppUsername = appDetToCreate.Username__c;
                            MobAppPassword = appDetToCreate.Password__c;
                        
                        }catch(exception e){
                            system.debug('the email failed to send : '+e.getMessage());
                            result = 'OOOPS, Some thing went wrong ::::'+e.getMessage(); 
                            return result;   
                        }
                        
                    }
                    
                }
                
            }
             
         ////////// Added by Safia Osman for Case:00227974
         
         if(opp.LeadSource=='Biz Dev'){
         String bizDevEmailSubject = 'Biz-Dev Admit Scheduled For : '+opp.Name;
         String bizDevEmailBody='Biz-Dev Admit Scheduled For : '+opp.Name;
         Messaging.SingleEmailMessage BizDevMessage = new Messaging.SingleEmailMessage();
                    BizDevMessage.toAddresses = System.Label.BizDevAdmitSheduledEmailRecipientID.split(';');
                    BizDevMessage.subject = bizDevEmailSubject;
                    BizDevMessage.plainTextBody = bizDevEmailBody;
                   // message.setWhatId(opp.id);//This field will link the out going email as an Activity on the Opportunity
                    BizDevMessage.setSenderDisplayName(UserInfo.getName());
                    BizDevMessage.setUseSignature(false); 
                    Messaging.SingleEmailMessage[] BizDevMessages =
                            new List<Messaging.SingleEmailMessage> {BizDevMessage};
                                 Messaging.SendEmailResult[] results = Messaging.sendEmail(BizDevMessages);
                      
         }
         
         ////////////////////////
         
         if(opp.Sunshine_Center__r.name=='Willowsprings Recovery' || opp.Sunshine_Center__r.name=='Willow IOP'){
             emailBody= 'CLIENT INFORMATION Client Name : '+opp.Name+'\n Admit Date : '+opp.CloseDate+'\n Client Age : '+opp.Age__c+'\n House & Bed : '+opp.House__c+', '+opp.Bed__c+
                                 '\n Pharmacy : '+opp.Pharmacy_Information_Sent__c+'\n Medication Scholarship: '+opp.Medication_Scholarship__c+'\n WS Medication : '+opp.WS_Medication__c +'\n Vape : '+opp.Vape_Needed__c+'\n Allergies : '+opp.Allergies__c+', '+opp.Allergic_Reaction__c+
                                 '\n Client Cell Phone : '+opp.Incoming_Number__c+'\n Family Contact & Number : '+opp.Family_Contact_Name__c+'/'+opp.Family_Contact_Relationship__c+
                                 '/'+opp.Family_Contact_Phone__c+'\n Cash Client : '+ opp.Cash_Client__c+'\n Previous ACAs : '+opp.Previous_ACAs__c+'\n Previous Treatment Episodes : '+opp.Previous_Treatment_Episodes__c+'\n\n INCOMING FLIGHT INFORMATION \n Arrival Date/Time : '+opp.Arrival_Date_Time__c.format()+'\n Travel Notes : '+opp.Travel_Notes__c+
                                 '\n Departing Airport : '+opp.Airport__c+'\n Arrival Airport : '+opp.Arriving_Airport__c+'\n Airline : '+opp.Airline__c+'\n Flight Number : '+opp.Flight_Number__c+
                                 '\n\nCURRENT SUBSTANCE ABUSE INFORMATION \n Drug of Choice #1 : '+opp.Drug_of_Choice_1__c+'\n Current Use Details Drug #1 : '+opp.Current_Use_Details_Drug_1__c+
                                 '\n Date of Last Use Drug #1 : '+opp.Date_of_Last_Use_Drug_1__c+ '\n Frequency of Use Drug #1 : '+opp.Frequency_of_Use_Drug_1__c+'\n Drug of Choice #2 : '+opp.Drug_of_Choice_2__c+'\n Current Use Details Drug #2 : '+opp.Current_Use_Details_Drug_2__c+
                                 '\n Date of Last Use Drug #2 : '+opp.Date_of_Last_Use_Drug_2__c+'\n Frequency of Use Drug #2 : '+opp.Frequency_of_Use_Drug_2__c+'\n Drug of Choice #3 : '+opp.Drug_of_Choice_3__c+'\n Current Use Details Drug #3 : '+opp.Current_Use_Details_Drug_3__c+
                                 '\n Date of Last Use Drug #3 : '+opp.Date_of_Last_Use_Drug_3__c+'\n Frequency of Use Drug #3 : '+opp.Frequency_of_Use_Drug_3__c+'\n\nMENTAL HEALTH INFORMATION \n Psychiatric/Co-occurring Issues : '+
                                 opp.Psychiatric_Co_occurring_Issues__c +'\n\nDIET INFORMATION \n Diet : '+opp.Diet__c+'\n\nFMLA Needed INFORMATION \n FMLA Needed: '+opp.FMLA_Needed__c;
                                 }
            else{
           emailBody = 'CLIENT INFORMATION Client Name : '+opp.Name+'\n Admit Date : '+opp.CloseDate+'\n Client Age : '+opp.Age__c+'\n House & Bed : '+opp.House__c+', '+opp.Bed__c+
                                 '\n Pharmacy : '+opp.Pharmacy_Information_Sent__c+'\n Medication Scholarship: '+opp.Medication_Scholarship__c+'\n Vape : '+opp.Vape_Needed__c+'\n Allergies : '+opp.Allergies__c+', '+opp.Allergic_Reaction__c+
                                 '\n Client Cell Phone : '+opp.Incoming_Number__c+'\n Family Contact & Number : '+opp.Family_Contact_Name__c+'/'+opp.Family_Contact_Relationship__c+
                                 '/'+opp.Family_Contact_Phone__c+'\n Cash Client : '+ opp.Cash_Client__c+'\n Previous ACAs : '+opp.Previous_ACAs__c+'\n Previous Treatment Episodes : '+opp.Previous_Treatment_Episodes__c+'\n\n INCOMING FLIGHT INFORMATION \n Arrival Date/Time : '+opp.Arrival_Date_Time__c.format()+'\n Travel Notes : '+opp.Travel_Notes__c+
                                 '\n Departing Airport : '+opp.Airport__c+'\n Arrival Airport : '+opp.Arriving_Airport__c+'\n Airline : '+opp.Airline__c+'\n Flight Number : '+opp.Flight_Number__c+
                                 '\n\nCURRENT SUBSTANCE ABUSE INFORMATION \n Drug of Choice #1 : '+opp.Drug_of_Choice_1__c+'\n Current Use Details Drug #1 : '+opp.Current_Use_Details_Drug_1__c+
                                 '\n Date of Last Use Drug #1 : '+opp.Date_of_Last_Use_Drug_1__c+ '\n Frequency of Use Drug #1 : '+opp.Frequency_of_Use_Drug_1__c+'\n Drug of Choice #2 : '+opp.Drug_of_Choice_2__c+'\n Current Use Details Drug #2 : '+opp.Current_Use_Details_Drug_2__c+
                                 '\n Date of Last Use Drug #2 : '+opp.Date_of_Last_Use_Drug_2__c+'\n Frequency of Use Drug #2 : '+opp.Frequency_of_Use_Drug_2__c+'\n Drug of Choice #3 : '+opp.Drug_of_Choice_3__c+'\n Current Use Details Drug #3 : '+opp.Current_Use_Details_Drug_3__c+
                                 '\n Date of Last Use Drug #3 : '+opp.Date_of_Last_Use_Drug_3__c+'\n Frequency of Use Drug #3 : '+opp.Frequency_of_Use_Drug_3__c+'\n\nMENTAL HEALTH INFORMATION \n Psychiatric/Co-occurring Issues : '+
                                 opp.Psychiatric_Co_occurring_Issues__c +'\n\nDIET INFORMATION \n Diet : '+opp.Diet__c+'\n\nFMLA Needed INFORMATION \n FMLA Needed: '+opp.FMLA_Needed__c;
            
            }
            emailBody = emailBody + '\n Sunshine Mobile App Username : ' + MobAppUsername + '\n Sunshine Mobile App Password : ' + MobAppPassword; 
            System.debug('++emailbody'+emailBody);
            
            String emailSubject = 'Client Arrival Form For : '+opp.Name;
            
            if(opp.Sunshine_Center__r.name != null){
                
                //Fetching the Email Recipients from the Custom Setting, where the emails are updated as per Sunshine Centers
                List<String> emailRecipients = new List<String>();
                List<String> bccRecipients = new List<String>();
                for(Client_Arrival_Form_Emails__c cafe : Client_Arrival_Form_Emails__c.getall().values()){
                    if(cafe.Sunshine_Center__c.contains(opp.Sunshine_Center__r.Name)){
                        emailRecipients.add(cafe.Name);
                    }
                }
                
                if(emailRecipients.size()!=null){
                    
                    //Setting up the email message 
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = emailRecipients;
                    message.subject = emailSubject;
                    message.plainTextBody = emailBody;
                    message.setWhatId(opp.id);//This field will link the out going email as an Activity on the Opportunity
                    message.setSenderDisplayName(UserInfo.getName());
                    message.setUseSignature(false); 
                    
                    String feedBody = '';
                    if(opp.Sunshine_Center__r.name!='Willowsprings Recovery' && opp.Sunshine_Center__r.name!='Willow IOP' && opp.Sunshine_Center__r.name!='Mountain Springs Recovery' && opp.Sunshine_Center__r.name!='Mountain Springs IOP'){
                        bccRecipients.add('providers@headlandsats.com');
                        message.bccAddresses = bccRecipients;
                        //Setting up the Chatter Feed Post for the email that just went out
                        feedBody = 'From : '+UserInfo.getName()+'\n'+
                                      'To : '+emailRecipients+'\n'+
                                      'BCC : '+bccRecipients+'\n'+
                                      'Subject : '+emailSubject+'\n'+'\n'+
                                      emailBody;
                    }else{
                        message.setBccSender(false);
                        //Setting up the Chatter Feed Post for the email that just went out
                        feedBody = 'From : '+UserInfo.getName()+'\n'+
                                      'To : '+emailRecipients+'\n'+
                                      'Subject : '+emailSubject+'\n'+'\n'+
                                      emailBody;
                    }
                    
                    FeedItem fi = new FeedItem();
                    fi.Body = feedBody;
                    fi.Type = 'AdvancedTextPost';
                    fi.ParentId = opp.id;
                    
                    //Updating the Opportunity, with the checkbox and the time stamp, to ensure further validation rule can come into play
                    opp.Client_Arrival_Form_Email_Sent__c = True;
                    opp.Client_Arrival_Form_Email_Sent_Date_Time__c = dateTime.Now();
                    
                    try{
                        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    
                        insert fi;
                        update opp;
                                            
                        if (results[0].success) {
                            result = 'The Email was Sucessfully Sent!!';
                        } else {
                            System.debug('The email failed to send: '+ results[0].errors[0].message);
                            result = 'OOOPS, Some thing went wrong while Sending the email. Please Contact Naveen on Chatter!!';    
                        }
                    }catch(exception e){
                        system.debug('the email failed to send : '+e.getMessage());
                        result = 'OOOPS, Some thing went wrong while Sending the email. Please Contact Naveen on Chatter!!';    
                    }
                    
                    
                }else{
                    //If no recipients are found in the custom setting
                    result = 'The Email Could not be sent, as no recipients were found for the mentioned Sunshine Center : '+opp.Sunshine_Center__r.Name+'!!';
                }
            }else{
                //If no Sunshine Center is present in the Custom Setting, we will not know which recipients to send the email to.
                result = 'The Email Could not be sent, as no Sunshine Center was mentioned on the Opportunity!!';
            }

         }
         
          system.debug('result:'+ result);
          return result;
    
    }
}