trigger webToLeadData on Lead (before insert) {
    for(Lead l : Trigger.New){
        if(l.LeadSource == 'Insurance Form' || l.LeadSource == 'Monarch Shores Insurance Form'){
            if(l.Subscriber_First_Name__c != '' && l.subscriber_Last_Name__c != ''){
                String subName = l.Subscriber_First_Name__c + ' ' + l.subscriber_Last_Name__c;
                l.Subscriber_Name__c = subName;
                
            }
            if(l.Name != '' ){
                //l.company = l.Name;
                
            }
            
            if(l.Contact_First_Name__c != '' && l.Contact_Last_Name__c != ''){
                String notes = 'Contact Name: '+  l.Contact_First_Name__c + ' ' + l.Contact_Last_Name__c  +'\r\n'+
                               'Contact Email: '+  l.Email + '\r\n'+
                               'Contact Phone: '+  l.Phone + '\r\n'+
                               '\r\n'+
                               'Other Notes: '+  l.Additional_Notes__c;
                
                l.Additional_Notes__c = notes;
            }
            
            //if(l.Subscriber_DOB_Text__c != ''){
                //String[] dob = l.Subscriber_DOB_Text__c.split('-',3);
                //date myDate = date.newInstance(Integer.valueOf(dob[0]), Integer.valueOf(dob[1]), Integer.valueOf(dob[2]));
                //l.Subscriber_DOB__c = myDate;
            //}
           // updateLead.add(l);
        }
        if(l.leadSource == 'Contact Form' || l.LeadSource == 'Monarch Shores Contact Form'){
            if(l.Preferred_Contact__c != ''){
                String notes = 'Preferred Contact: '+  l.Preferred_Contact__c +'\r\n'+
                               'Other Notes: '+  l.Additional_Notes__c;
                
                l.Additional_Notes__c = notes;
            }
        }
    }
    
//    update updateLead;

}