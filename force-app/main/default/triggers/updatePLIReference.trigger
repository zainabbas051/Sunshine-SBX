//Test Class : createCollectionLineItemsTest
trigger updatePLIReference on Collection_Line_Item__c (after insert) {
    
    list<Temp_Payment_Line_Items__c> pliUpdateList = new List<Temp_Payment_Line_Items__c>();
    
    for(Collection_Line_Item__c cli : trigger.new){
        if(cli.Temp_Payment_Line_Items__c != null){
            Temp_Payment_Line_Items__c pli = new Temp_Payment_Line_Items__c(id = cli.Temp_Payment_Line_Items__c);
            pli.Collection_Line_Item__c = cli.id;
            pliUpdateList.add(pli);
        }
    }
    
    if(pliUpdateList.size()>0){
        update pliUpdateList;
    }
}