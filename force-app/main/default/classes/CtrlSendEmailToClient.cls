/*
    Purpose: this controller is for sending email to client
    Modified Date: 03/23/2016
*/
public class CtrlSendEmailToClient{
    
    public string ToEmail{get;set;}
    public string CCEmail{get;set;}
    public string FromUserName{get;set;}
    public string BCCEmail{get;set;}
    public string EmailSubject{get;set;}
    public string EmailBody{get;set;}
    
    private string RecordId;
    
    string LeadId;
    string OpptyId;
    
    //constructor
    public CtrlSendEmailToClient(){
        
        //get record id
        RecordId = ApexPages.currentPage().getParameters().get('id');
        
        BCCEmail ='';
        
        //get obj id of Lead to see if task was created against Lead
        Schema.DescribeSObjectResult Lead_DSR = Lead.SObjectType.getDescribe();
        LeadId = Lead_DSR.getKeyPrefix();
        
        //get obj id of Opportunity to see if task was created against Opportunity
        Schema.DescribeSObjectResult Oppty_DSR = Opportunity.SObjectType.getDescribe();
        OpptyId = Oppty_DSR.getKeyPrefix();

        FromUserName = UserInfo.getName();
        CCEmail = UserInfo.getUserEmail();
        
        //identify if the record is lead or opportunity
        if(RecordId.startsWith(LeadId)){
            
            //query lead email address
            Lead QueryLead = [select id,Email from Lead where Id =:RecordId];
            ToEmail = QueryLead.Email;                        
        }        
        else if(RecordId.startsWith(OpptyId)){
            
            //query oppty email address
            Opportunity QueryOppty = [select id,Email__c from Opportunity where Id =:RecordId];
            ToEmail = QueryOppty.Email__c;   
        }
    }
    
    //this method is called on cancel button
    public pagereference cancel(){
        return new pagereference('/'+RecordId); 
    }
    
    //this method is called on send button
    public PageReference sendEmailToClient(){
                
        //email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         
        mail.setToAddresses(new list<string>{ToEmail});
        mail.setCCAddresses(new list<string>{CCEmail});
        if(BCCEmail!=null && BCCEmail!='')
            mail.setBCCAddresses(new list<string>{BCCEmail});
             
        mail.setsubject(EmailSubject);
        mail.setPlainTextBody(EmailBody);
        mail.setReplyTo(CCEmail);
        mail.setSenderDisplayName(FromUserName);
        mail.setBccSender(false);
        mail.setUseSignature(false); 
        mail.setSaveAsActivity(true); 
        if(RecordId.startsWith(LeadId)){
            mail.setTargetObjectId(RecordId);
        }
        else{ 
            mail.setWhatId(RecordId);
        }
        try{
            //send email
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            
            //create chatter feed          
            String feedBody = 'From : '+FromUserName+'\n'+
                                  'To : '+ToEmail+'\n'+
                                  'CC : '+CCEmail+'\n'+
                                  'BCC : '+BCCEmail+'\n'+
                                  'Subject : '+EmailSubject+'\n'+'\n'+
                                  EmailBody;
                
            FeedItem fi = new FeedItem();
            fi.Body = feedBody;
            fi.Type = 'AdvancedTextPost';
            fi.ParentId = RecordId;
            insert fi;
            
            if(RecordId.startsWith(OpptyId)){
                Opportunity opp = new Opportunity();
                opp.id = RecordId;
                opp.Last_Activity_Date__c = DateTime.now();
                update opp;
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'We have been unable to send the email presently because of some technical difficulty, Please try again after some time'));
            return null;
        }
        return new pagereference('/'+RecordId); 
    }
}