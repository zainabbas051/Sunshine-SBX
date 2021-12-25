public with sharing class CopyContentRequestController {

    public Content_Request__c ContentRequest {get; set;}
    public Boolean isFloating {get; set;}


    public CopyContentRequestController() {

        String sObjId = ApexPages.currentPage().getParameters().get('id');
        String isFloatingParam = ApexPages.currentPage().getParameters().get('isFloating');
        isFloating = isFloatingParam != null && isFloatingParam.length() > 0 && Boolean.valueOf(isFloatingParam);

        Content_Request__c temp = [select id,OwnerId, Anchor_Text_1__c, Anchor_Text_2__c, Anchor_Text_3__c, Anchor_Text_4__c, Anchor_Text_5__c, 
                                   Anchor_Text_Allowed__c, Assigned_Writer__c, Category__c, Closed_Rejected_Reason__c, Contact_Email_Address__c, Contact_Phone_Number__c, 
                                   Document_URL__c, Email_Address_Used_to_Initiate_Contact__c, FloatingOperation__c, General_Guidelines_for_Website__c, H1_Title__c, 
                                   H2_Sub_Title_1__c, H2_Sub_Title_10__c, H2_Sub_Title_2__c, H2_Sub_Title_3__c, H2_Sub_Title_4__c, H2_Sub_Title_5__c, 
                                   H2_Sub_Title_6__c, H2_Sub_Title_7__c, H2_Sub_Title_8__c, H2_Sub_Title_9__c, IsFloating__c, Link_Published_URL__c, 
                                   Priority__c, Prospect_URL__c, Special_Instructions_for_Content__c, Status__c, Sub_Category__c, Target_URL_1__c, 
                                   Target_URL_2__c, Target_URL_3__c, Target_URL_4__c, Target_URL_5__c, Title_of_the_content_request__c, Type__c, 
                                   Word_Count__c, Writer_Status__c, Related_Outreach_Account__c,Related_Outreach_Account__r.Prospect_URL__c,
                                   Related_Outreach_Account__r.Contact_Email_Address__c from Content_Request__c where id = :sObjId];
        ContentRequest = isFloating ? temp : temp.clone(false, false, false, false);
        
         if (!isFloating) {
         ContentRequest.Related_Outreach_Account__c = null;
         }
        
    }

    public PageReference Save() {
        if (isFloating) {
         Outreach_Account__c newOA = [select id,Prospect_URL__c,Contact_Email_Address__c from Outreach_Account__c where id=:ContentRequest.Related_Outreach_Account__c];
         ContentRequest.Prospect_URL__c= newOA.Prospect_URL__c;
         ContentRequest.Contact_Email_Address__c= newOA.Contact_Email_Address__c;
         ContentRequest.Email_Address_Used_to_Initiate_Contact__c= null;
         ContentRequest.OwnerId=UserInfo.getUserId();
          update ContentRequest;
        } else {
            insert ContentRequest;
        }
        PageReference yourPage = new PageReference('/' + ContentRequest.Id);
        return yourPage ;
    }
}