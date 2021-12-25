public  class SendAlumniMeetingRequestEmail_Ctrl {

   public string ppName{get;set;}
   public string referenceId {get;set;}

   public void getInfo(){
   
   string accId;
   string fName ;
   string lName ;
   string ph ;
   string email ;
   string meetingdate;
   
    Map<String, object> parametersMap=new Map<String, object>();
    
     system.debug('%%%%%%%=> ' + ApexPages.currentPage().getParameters().size());
                        if (ApexPages.currentPage() != null 
                        && ApexPages.currentPage().getParameters()!=null 
                        && ApexPages.currentPage().getParameters().size()>0){
                            parametersMap=ApexPages.currentPage().getParameters();
                        }
                        
                         system.debug('%%%%%%%=> ' + parametersMap);
                       
                        
                         for(String key: parametersMap.keyset()){

                        if(key=='x_FirstName'){
                        fName=parametersMap.get(key)+'';
                        }
                        else if(key=='x_LastName'){
                        lName =parametersMap.get(key)+'';
                        }
                        else if(key=='x_Email'){
                        email =parametersMap.get(key)+'';
                        }
                        else if(key=='x_MeetingDate'){
                        meetingdate=parametersMap.get(key)+'';
                        }
                        else if(key=='x_AccName'){
                        accId=parametersMap.get(key)+'';
                        }
                        else if(key=='x_Phone'){
                        ph=parametersMap.get(key)+'';
                        }
                        }
                        

   sendEmail(accId,fName,lName,ph,email,meetingdate);
   }
    @Future(callout=true)
    private static void sendEmail(string accId,string fName,string lName,string Phone, string Email, string meetingdate){
        
     
        //PageReference ref = page.SendEmailConfimationPdf;
        
        List<String> EmailIds = new List<string>();
      
        
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where Address = 'contact.admissions@sunshinebh.com' limit 1];
        

        String addresses;
        
        
        Contact con = [Select id from Contact where Account.Id =:accId limit 1];
       // EmailTemplate templateId = [Select id from EmailTemplate where name = ''];
          EmailIds.add('safia.osman@hotmail.com');
         EmailIds.add('michellel@sunshinebh.com');
         EmailIds.add('naveenc@sunshinebh.com');
 
        
        emailMessage.setToAddresses( EmailIds  );
         emailMessage.setWhatId(con.Id);
         emailMessage.setHtmlBody('You got a request to join the Alumni meeting on <b>'+meetingdate+'</b>'+
                                  '<p>Full name: '+ fName+' '+lName+'</p>'+
                                  '<p>Email: '+Email+'</p>'+
                                  '<p>Phone: '+Phone+'</p>'+
                                  '<p><b>Please provide them with a zoom link to that meeting'+'</b></p>');
       emailMessage.setSubject('New Alumni Recovery Group Meeting Request');
       // emailMessage.setTemplateID(templateId.Id);
        emailMessage.setOrgWideEmailAddressId(owa.id);
        emailMessage.setTargetObjectId(con.Id);
        emailMessage.saveAsActivity = false;
       // email.setWhatId(aRecordId);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
    
    }
}