/*
TestClass = ClientTicket_CtrlTest
*/
public  class CustomMetaDataConfig  implements IConfigRetriever {
   
    static Map<string,ClientTicketConfig__mdt> mapOfConfig = new Map<string,ClientTicketConfig__mdt>();
    public Object getConfiguration(Object configName){

        string configNameStr = String.valueOf(configName);
        if(mapOfConfig.containsKey(configNameStr)){
            return mapOfConfig.get(configNameStr).Configs__c;
        }
        List<ClientTicketConfig__mdt> clientConfigs = [SELECT Id, DeveloperName, 
                                                Configs__c FROM ClientTicketConfig__mdt 
                                               ];
        if(clientConfigs.isEmpty()){
            return '';
        }
        
        for(ClientTicketConfig__mdt iConfig : clientConfigs){
            mapOfConfig.put(iConfig.DeveloperName,iConfig); 
        }    
        return mapOfConfig.containsKey(configNameStr) ? mapOfConfig.get(configNameStr).Configs__c : '';
    } 
}