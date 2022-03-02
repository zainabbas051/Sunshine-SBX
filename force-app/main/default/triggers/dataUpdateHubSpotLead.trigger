//Test Class : Service_Ip_To_AddressTest
trigger dataUpdateHubSpotLead on Lead (after update){
    
    List<Lead> leadList = new List<Lead>();
    for(Lead l : Trigger.New){
        if(l.Phone_Web__c == 'Web' && l.IP_Address_Source__c != null && l.IP_Address_Source__c != '' && l.IP_Address_Source__c != trigger.oldMap.get(l.id).IP_Address_Source__c){
            Lead l2 = new Lead(id = l.id, 
                                    IP_Address_Integration_Message__c = l.IP_Address_Integration_Message__c+'\n\n In-Progress'
                                    );
            leadList.add(l2);
            Service_Ip_To_Address.ipToAdressAPICall(l.IP_Address_Source__c,l.id);
        }        
    }
    
    if(leadList.size() != null)
        update leadList;
}