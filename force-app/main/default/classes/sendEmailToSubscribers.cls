public without sharing class sendEmailToSubscribers {
    
    public static void sendEmailToSubscribers(Report_Dashboard_Schedules__mdt mdtRec) {
        set<string> setOfDays = new set<string>{'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'};
        set<string> setOfDaysInCS = new set<string>();
        List<string> listOfRecipients = new List<string>();

        Datetime dt = datetime.now();
        String dayOfWeek = dt.format('EEEE');
        Integer currentHour = Datetime.now().hour();
        if(currentHour == 14)
        {
            currentHour = 2;
        }

        if(mdtRec.Day_of_Week__c != null && !String.isBlank(mdtRec.Day_of_Week__c))
        {
            if(mdtRec.Day_of_Week__c.contains(';')){
                for(string days : mdtRec.Day_of_Week__c.split(';'))
                {
                    setOfDaysInCS.add(days.toLowerCase());
                }
                
            }
            else {
                setOfDaysInCS.add(mdtRec.Day_of_Week__c.toLowerCase());
            }
        }
        for(string daysInCS : setOfDaysInCS){
            string daysInLower = daysInCS.toLowerCase();
            if(!setOfDays.contains(daysInLower)){
                return;
            }
        }

        if(mdtRec.Email_Recipients__c != null && !String.isBlank(mdtRec.Email_Recipients__c))
        {
            if(mdtRec.Email_Recipients__c.contains(';')){
                for(string emailRec : mdtRec.Email_Recipients__c.split(';'))
                {
                    listOfRecipients.add(emailRec);
                }
                
            }
            else {
                listOfRecipients.add(mdtRec.Email_Recipients__c);
            }
        }

        if(listOfRecipients.size() == 0)
        {
            return;
        }

        if(setOfDaysInCS.contains(dayOfWeek.toLowerCase()) && currentHour == integer.valueOf(mdtRec.Time_of_Day__c))
        {
            createEmailBody(mdtRec.Report_Dashboard_ID__c, mdtRec.Type__c, listOfRecipients);
        }
        
    }

    public static void createEmailBody(string repDashId, string repDashType, list<string> listOfRecps)
    {
        string Report_Name = '';
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        if(repDashType.toLowerCase() == 'report')
        {
            Report_Name = [SELECT Id,DeveloperName,Name FROM Report where id =: repDashId].name;
            attachments = returnReportData(repDashId);
        }
        else if(repDashType.toLowerCase() == 'dashboard')
        {
            Report_Name = [select id, Title from Dashboard where id =: repDashId].Title;
            system.debug('in dashboard block');
            List < Document > lstAttachment;
            ClsDashBoardUtil.RefreshDashboard(repDashId);
            ClsDashBoardUtil.CreateImageFromDashboard(repDashId,lstAttachment);
            PageReference pref; /*= page.SendEmailToSubscribersVFP	;
            pref.getParameters().put('dashid',repDashId);
            pref.setRedirect(true);*/
            Blob b;
            if(!test.isRunningTest())
                b = pref.getContentasPDF();
            else
                b = Blob.valueOf('Test Data');
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(Report_Name+'.pdf');
            efa.setBody(b);
            //efa.setContentType('image/png');
            attachments.add(efa);
                      
        }
        if(test.isRunningTest()){
            Blob b = Blob.valueOf('Test Data');
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('test');
            efa.setBody(b);
            attachments.add(efa);
        }
        string repOrDash = repDashType.toLowerCase() == 'report' ? 'Report' : 'Dashbaord';
        string Report_URL = URL.getSalesforceBaseUrl().toExternalForm() + '/'+repDashId;
        string emHtmlBody = '<p>Hi,</p>';
        emHtmlBody += '<br/>';
        emHtmlBody +='<p>Please find attached the '+ repOrDash+ ': <strong>'+Report_Name+'</strong>.</p><br/><br/>';

        emHtmlBody += '<p>You can download it and review the Data. In case you would like to view the '+ repOrDash+ 'data in Salesforce, Please Click Here : '+Report_URL+'</p>';

        emHtmlBody += '<p>Thanks,</p>';
        emHtmlBody += '<p>Sunshine BH</p>'; 
        string emSub = 'Scheduled ' + repOrDash + ' : '+ Report_Name+ ' is Ready to Review';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        //mail.setToAddresses(new List<String>{'smanisheng@gmail.com'});
        mail.setToAddresses(listOfRecps);
        mail.setSubject(emSub);
        mail.setHtmlBody(emHtmlBody);
        if(!test.isRunningTest())
            mail.setFileAttachments(attachments);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    public static List<Messaging.EmailFileAttachment> returnReportData(string repId){
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        List<Report>reportList = [SELECT Id,DeveloperName,Name FROM Report where id =: repId];
        if(reportList.size()>0){
           for(Report report:reportList){
               String reportId = (String)report.Id;     
               string reportName = (String)report.Name;     
               ApexPages.PageReference objPage = new ApexPages.PageReference('/servlet/PrintableViewDownloadServlet?isdtp=p1&reportId='+reportId);                    
               Messaging.EmailFileAttachment objMsgEmailAttach = new Messaging.EmailFileAttachment();
               objMsgEmailAttach.setFileName(reportName+'.csv');
               if(!Test.isRunningTest())
                   objMsgEmailAttach.setBody(objPage.getContent());
               objMsgEmailAttach.setContentType('text/csv');
               attachments.add(objMsgEmailAttach);
           }
        }
        return attachments;
    }
}