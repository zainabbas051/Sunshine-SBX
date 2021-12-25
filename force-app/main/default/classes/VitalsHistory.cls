//Test Class : VitalsHistory_Test
public class VitalsHistory {
    
    public string ClientId {get; set;}
    public string ClientName {get; set;}
    
    public list<Recurring_Assessment__c> ListVitals {get; set;}
    
    public VitalsHistory()
    {
        ClientId = ApexPages.CurrentPage().getParameters().get('ID');
        ListVitals = new list<Recurring_Assessment__c>();
        getAllVitals();
    }
    
    public void getAllVitals()
    {
        ListVitals = new list<Recurring_Assessment__c>();
        for(Recurring_Assessment__c vitals: [select id, Clinical_Evaluation_3__c, createdDate, BP_Systolic__c, 
                                                BP_Diastolic__c, Temperature__c, Pulse__c, Respirations__c,
                                                X02_Saturation__c,Owner.Name, Time_Due__c, LastModifiedDate,
                                                Related_To__c, Client_Chart__r.Name from Recurring_Assessment__c where 
                                                Client_Chart__c =: ClientId and Recordtype.name = 'Vital Signs' and Status__c = 'Closed'
                                                order by createdDate DESC])
        {
            ListVitals.add(vitals);
        }
        if(ListVitals.size()>0)
            ClientName = ListVitals[0].Client_Chart__r.Name;
    }
    
    

}