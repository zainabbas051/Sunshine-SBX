global class ClientAdmittedInvocableCls {
    /*An invocable variable used as input or output variables in the process builder*/
    global class ActionRequest {
        @InvocableVariable(required = true)
        public string oppId;

        @InvocableVariable
        public string accId;
    }
    //This invocable method is used for processing the business by taking the input from process builder
    @InvocableMethod(label = 'Invoke Business Logic')
    global static void invokeService(List < ActionRequest > requests) {
        set<String> setOfIds = new set<String>();
        Set<String> setOfOppIds = new set<String>();
        
        list<App_Detail_History__c> listHistoryToUpd = new list<App_Detail_History__c>();
        for (ActionRequest requestObj: requests) {
            setOfIds.add(requestObj.accId);
            setOfOppIds.add(requestObj.oppId);
        }
        for(App_Detail_History__c appH: [select id, Opportunity__c, Alumni_App_Detail__c from App_Detail_History__c where Alumni_App_Detail__r.Account__c IN: setOfIds]){
            App_Detail_History__c appHToUpd = new App_Detail_History__c();
            appHToUpd.id = appH.id;
            if(appH.Opportunity__c != null && setOfOppIds.contains(appH.Opportunity__c)){
                appHToUpd.Active__c = true;
            }
            else{
                appHToUpd.Active__c = false;
            }
            listHistoryToUpd.add(appHToUpd);
        }

        update listHistoryToUpd;
    }
}