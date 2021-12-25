global class BestDrugRehabDetoxWebToLeadClass implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope){


        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        
        //Getting the Email body
        
        /*Pattern htmlPattern = Pattern.compile('</?[a-z][a-z0-9]*[^<>]*>'); 
        //String emailBody= htmlPattern.matcher(email.HTMLBody).replaceAll('');*/
        String emailBody = email.plainTextBody;
         
         system.debug(email.plainTextBody);
         system.debug(email.htmlBody);
         string htmlbody = email.htmlBody;
         htmlbody = htmlbody.replaceAll('<b>','');
         htmlbody = htmlbody.replaceAll('</b>','');
         htmlbody = htmlbody.replaceAll('<p>','');
         htmlbody = htmlbody.replaceAll('</p>','');
         htmlbody = htmlbody.replaceAll('<br />','');
         system.debug(htmlbody );
         system.debug(email.fromaddress);
        //Getting Lead record type  
        Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Elite Rehab Placement').getRecordTypeId();
        
        //Getting name & phone
        List<String> emailBodyList = htmlbody.split('\n');
        String lead_name = emailBodyList[0].substring(emailBodyList[0].indexOf('From:')+6);
        system.debug(emailBodyList[1].indexOf('Phone Number:'));
        String lead_phone = emailBodyList[1].substring(emailBodyList[1].indexOf('Phone Number:')+14);  
        
        //Processing for lead name
        String t_lead_name = lead_name.trim();
        Integer emailIndex  = t_lead_name.indexOf(' <');
        t_lead_name = t_lead_name.substring(0,emailIndex);
        List<String> name_list = t_lead_name.split(' ');
        
        String first_name = '';
        String last_name = '';
        if(name_list.size()>= 2){
            first_name = name_list[0];
            last_name = t_lead_name.substringAfter(' ');
        }
         else{
             first_name = t_lead_name;
             last_name = '.';
         }
        
        //Getting contents of body
        Integer insurance_index = htmlbody.indexOf('Insurance:');
        Integer message_index = htmlbody.indexOf('Message Body:');
        
        String insurance_info = htmlbody.substring(insurance_index+11, message_index-2);
        String t_ins_info = insurance_info.trim();
        String message = htmlbody.substring(message_index+14, htmlbody.length());
        
        
        String t_msg_info = '';
        if(message <> '' && message <> null){
            List<String> msg_list = message.split('--');
            String msg_info = '';
            Integer msg_size = msg_list.size();
            if(msg_size == 0 || msg_size == 1){
                msg_info = message;
            }    
            else if(msg_size >= 2){
                msg_info = message.substringBeforeLast('--');
            }
        
            t_msg_info = msg_info.trim();
        }
        String add_notes = 'Insurance: '+t_ins_info+'\n\n';
        if(t_msg_info <> '' && t_msg_info <> null){
            add_notes = add_notes + 'Message: ' + t_msg_info;
        }
        
        
        
        //Creating the lead  
        Lead l = new Lead();
        l.firstName = first_name;
        l.lastName = last_name;
        l.Company = l.firstName + ' ' + l.lastName;
        l.Email = email.fromaddress;
        l.Phone = lead_phone;  
        l.RecordTypeId = recTypeId;
        l.LeadSource = 'Web Lead';
        l.Status = 'Open';
        l.Additional_Notes__c = add_notes;
        l.RT_Source__c = 'BMG Form';
        l.RT_Channel__c = 'BMG Media';
        
        // to turn the Assignment Rules on
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        l.setOptions(dmo);
        
        try{
            insert l;
            }
        catch (exception e){}
          
        

        result.success = true;
        return result;

    }
}