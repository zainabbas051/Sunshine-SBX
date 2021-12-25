@isTest
private class CreateLeadFromWebTest 
{
    static testMethod void CreateLeadTest() 
    {
    CreateLeadFromWeb CLF = new CreateLeadFromWeb();
    CLF.PatientfirstName='abc';
    CLF.PatientlastName='abc';
    CLF.PatientDOB ='abc';
    CLF.Email ='abc';
    CLF.PhoneNumber ='abc';
    CLF.RTSource ='abc';
    CLF.campaignID='abc';
    CLF.firstName ='abc';
    CLF.lastName ='abc';
    CLF.SubscriberFirstName ='abc';
    CLF.SubscriberLastName ='abc';
    CLF.SubscriberDOB ='abc';
    CLF.SubscriberSSN ='abc';
    CLF.SubscriberInsuranceProvider ='abc';
    CLF.SubscriberInsuranceID ='abc';
    CLF.SubscriberGroupID ='abc';
    CLF.SubscriberInsurancePhone ='abc';
    CLF.OtherNotes ='abc';
    CLF.LeadSource ='Monarch Shores';
    List<selectOption> options=CLF.getCampaigns();
    CLF.LeadSource ='Chapters Capistrano';
    List<selectOption> options2=CLF.getCampaigns();
    CLF.LeadSource ='Willow Springs';
    List<selectOption> options3=CLF.getCampaigns();
    CLF.LeadSource ='Mountain Springs Recovery';
    List<selectOption> options4=CLF.getCampaigns();
    CLF.Save();
    }
}