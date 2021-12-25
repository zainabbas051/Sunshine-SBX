global class AddictionNetworkWebToLeadClass implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope){
        system.debug('Email Body: '+email.plainTextBody);
        //String emailBody = email.plainTextBody;
        
        Pattern htmlPattern = Pattern.compile('</?[a-z][a-z0-9]*[^<>]*>'); 
        String emailBody= htmlPattern.matcher(email.HTMLBody).replaceAll('');
        system.debug('content without html: '+emailBody);
        
        Integer firstNameIndex = emailBody.indexOf('name');
        Integer lastNameIndex = emailBody.indexOf('Last Name');
        Integer companyIndex = emailBody.indexOf('Company');
        Integer contactPhoneIndex = emailBody.indexOf('Contact Phone');
        system.debug('Contact Phone Index: '+contactPhoneIndex);
        Integer contactEmailIndex = emailBody.indexOf('Contact Email');
        Integer categoryIndex = emailBody.indexOf('category');
        Integer treatmentCenterNameIndex = emailBody.indexOf('Treatment Center Name');
        Integer websiteIndex = emailBody.indexOf('Website');
        Integer intakeEmailIndex = emailBody.indexOf('Intake Email');
        Integer intakePhoneIndex = emailBody.indexOf('Intake Phone');
        Integer streetAddressIndex = emailBody.indexOf('Street Address');
        Integer cityIndex = emailBody.indexOf('City');
        Integer stateIndex = emailBody.indexOf('State');
        Integer zipIndex = emailBody.indexOf('Zip');
        Integer countryIndex = emailBody.indexOf('Country');
        Integer briefOverviewIndex = emailBody.indexOf('Brief Overview');
        Integer overviewOfProgramIndex = emailBody.indexOf('Overview of Program');
        Integer treatmentApproachIndex = emailBody.indexOf('Treatment Approach');
        Integer uniqueSellingPointsIndex = emailBody.indexOf('Unique Selling Points');       
        
        
        
        
        String firstName = emailBody.substring(firstNameIndex+5,lastNameIndex-2);
        system.debug('First Name: '+firstName);
        
        String lastName = emailBody.substring(lastNameIndex+10,companyIndex-2);
        system.debug('Last Name: '+lastName);
        
        String company = emailBody.substring(companyIndex+8,contactPhoneIndex-2);
        system.debug('company: '+company);
        String contactPhone = emailBody.substring(contactPhoneIndex+14,contactEmailIndex-2);
        system.debug('contactPhone: '+contactPhone);
        String contactEmail = emailBody.substring(contactEmailIndex+14,categoryIndex-2);
        system.debug('contactEmail : '+contactEmail);
        String category = emailBody.substring(categoryIndex+9,treatmentCenterNameIndex-2);
        system.debug('category : '+category);
        String treatmentCenterName = emailBody.substring(treatmentCenterNameIndex+22,websiteIndex-2);
        system.debug('treatmentCenterName: '+treatmentCenterName);
        String website = emailBody.substring(websiteIndex+8,intakeEmailIndex-2);
        system.debug('website: '+website);
        String intakeEmail = emailBody.substring(intakeEmailIndex+13,intakePhoneIndex-2);
        system.debug('intakeEmail: '+intakeEmail);
        String intakePhone = emailBody.substring(intakePhoneIndex+13,streetAddressIndex-2);
        system.debug('intakePhone: '+intakePhone);
        String streetAddress = emailBody.substring(streetAddressIndex+15,cityIndex-2);
        system.debug('streetAddress: '+streetAddress);
        String city = emailBody.substring(cityIndex+5,stateIndex-2);
        system.debug('city: '+city);
        String state = emailBody.substring(stateIndex+6,zipIndex-2);
        system.debug('state: '+state);
        String zip = emailBody.substring(zipIndex+4,countryIndex-2);
        system.debug('zip: '+zip);
        String country = emailBody.substring(countryIndex+8,briefOverviewIndex-2);
        system.debug('country: '+country);
        String briefOverview = emailBody.substring(briefOverviewIndex+15,overviewOfProgramIndex-2);
        system.debug('briefOverview: '+briefOverview);
        String overviewOfProgram = emailBody.substring(overviewOfProgramIndex+20,treatmentApproachIndex-2);
        system.debug('overviewOfProgram: '+overviewOfProgram);
        String treatmentApproach = emailBody.substring(treatmentApproachIndex+19,uniqueSellingPointsIndex-2);
        system.debug('treatmentApproach: '+treatmentApproach);
        String uniqueSellingPoints = emailBody.substring(uniqueSellingPointsIndex+22,emailBody.length());
        system.debug('uniqueSellingPoints: '+uniqueSellingPoints);
        
        
        system.debug('Last Name: '+lastName);
        
         Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
         Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
         Id recTypeId = rtMapByName.get('Addiction Network').getRecordTypeId();
        
        Lead l = new Lead();
        l.FirstName = firstName;
        l.LastName = lastName;
        l.Company = company;
        l.Phone = contactPhone;
        l.Email = contactEmail;
        l.Treatment_Center_Category__c = category;
        l.Treatment_Center_Name__c = treatmentCenterName;
        l.Website = website;
        l.Intake_Email__c = intakeEmail;
        l.Intake_Phone__c = intakePhone;
        l.Street_Address__c = streetAddress;
        l.City__c = city;
        l.State__c = state;
        l.Zip_Code__c = zip;
        l.Country__c = country;
        l.Details_short__c = briefOverview;
        l.Overview_of_Program__c = overviewOfProgram;
        l.Treatment_Approach__c = treatmentApproach;
        l.Unique_Selling_Points__c = uniqueSellingPoints;
        l.RecordTypeId = recTypeId;
        l.LeadSource = 'Web Lead';
        l.Status = 'To Build';
        try{
            insert l;
        }catch (exception e){}
        
        if(email.textAttachments != Null){
            for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                Attachment attachment = new Attachment();
                attachment.Name = tAttachment.fileName;
                attachment.Body = Blob.valueOf(tAttachment.body);
                attachment.ParentId = l.Id;
                attachment.Description = 'Lead ID: "'+l.Id+'"';
                insert attachment;
            }
        }
        if(email.binaryAttachments != Null){
            for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                Attachment attachment = new Attachment();
                attachment.Name = bAttachment.fileName;
                attachment.Body = bAttachment.body;
                attachment.ParentId = l.Id;
                attachment.Description = 'Lead ID: "'+l.Id+'"';
                insert attachment;
            }
        }
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        return result;
    }
}