public class ClsDashBoardUtil{
    
     public static void RefreshDashboard(string dashboardID) {

        String requestUrl = '/dash/dashboardRefresh.apexp?id=' + dashboardID;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        string url = URL.getSalesforceBaseUrl().toExternalForm() + requestUrl;
        system.debug('%%%%%' + url);
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Cookie', 'sid=' + UserInfo.getSessionId());
        // req.setHeader('Cookie','sid='+accesstoken+''); 

        if (test.isRunningTest() == false) {
            HTTPResponse res = http.send(req);
            String output = res.getBody();
            System.debug('>>>>' + output);
        }
    }
    public static void CreateImageFromDashboard(string dashboardID,List<Document> lstAttachment) {
        
        integer index;
        PageReference dbPage = new PageReference('/' + dashboardID); //constructing your dashboard page's URL
        Blob pageBlob;
        if (test.isRunningTest()) {
            pageBlob = blob.valueOf('<img src="/servlet/servlet.ChartServer?"');

        } else {
            pageBlob = dbPage.getContent(); //Hitting the page and retrieving the HTML
        }




        String dHtml = pageBlob.toString(); //The response doesn't hold the image, it holds the HTML text of the dashboard.
        //system.debug(dhtml);
        string imgUrl = '';
    
        Map < Integer, String > imageURLIndexedMap = new Map < Integer, String > ();

        Integer count = 0;
        for (Boolean flag = true; flag == true;) //loop untill there is no <img/> present in the dHtml
        {
            if (dHtml.contains('<img')) {
                dHtml = dHtml.subString(dHtml.indexOf('<img')); //discard anything present before the <img phrase.
                imgUrl = dHtml.subString(dHtml.indexOf('"') + 1); //finding " means finding the src attribute value of <img/> tag
                imgUrl = imgUrl.subString(0, imgUrl.indexOf('"') - 1); //fetch the text till next ". so you have all of the src value of the image tag.
                if (!imgUrl.contains('servlet')) // does the src value has servlet in it?
                {
                    dHtml = dHtml.subString(dHtml.indexOf('"') + 1); //if no, increase the counter by 1 and continue searching
                    imgUrl = '';
                } else {
                    //found? great!!!!!
                    system.debug('found');
                    String tempimgUrl = EncodingUtil.urlDecode(imgUrl, 'UTF-8'); //URL decode the src value.
                    imgUrl = imgUrl.replaceAll('&amp;', '&'); //simple replace
                    // if(tempimgUrl.contains('Your Chart Name you provided in dashboard')) //just to verify you have got the intended chart URL, match with your chart header text.
                    imageURLIndexedMap.put(count, imgUrl);
                    count++;
                    dHtml = dHtml.subString(dHtml.indexOf('<img') + 5); //increase the counter, and continue searching for me, or just break.
                    imgUrl = '';
                }
            } else {
                flag = false; //terminating the loop
            }
        }

        system.debug(imageURLIndexedMap);

       lstAttachment = new List < Document > ();
        
         index = 2000;
         string query = 'dash_20%';
         string name = 'dash_'; // initializing name here so use it in else block
        if(dashboardID == System.Label.CGDashboard_ID){
             index = 1000;
             query = 'dash_10%';
        }
        
        else if(dashboardID == System.Label.OutComeSurveyDasboard){
             index = 3000;
             query = 'dash_30%';
        }
        else{
            name = 'dash_'+dashboardID;
            index = 9000;
            query = name+'90%';
       }
      system.debug('name='+name);
        
        //string name = 'dash_';
       
        Map < string, string > mapOfDocument = new Map < string, string > ();
        Id folderID = [SELECT Id,name  FROM Folder where name = 'Public'
            LIMIT 1
        ].Id;

        for (Document iDoc: [Select ID, Name from Document where Name like :query]) {

            mapOfDocument.put(iDoc.Name, iDoc.Id);
        }
        for (integer numbers: imageURLIndexedMap.keySet()) {
            dbPage = new PageReference(imageURLIndexedMap.get(numbers)); //constructing your dashboard page's URL



            if (test.isRunningTest() == false) {
                pageBlob = dbPage.getContent(); //Hitting the page and retrieving the HTML
            } else {
                pageBlob = blob.valueOf('abc test');
            }


            //  dHtml = pageBlob.toString();
            String csvBody = EncodingUtil.base64Encode(pageBlob);

            system.debug(csvBody);
            Document iDoc = new Document();
            iDoc.Name = name + index++;
            iDoc.folderid = folderID;
            iDoc.IsPublic = true;
            iDoc.Type = 'png';
            iDoc.Body = pageBlob;

            if (mapOfDocument.containsKey(iDoc.Name))
                iDoc.Id = mapOfDocument.get(iDoc.Name);
            //insert attach;
            lstAttachment.add(iDoc);
        }
        system.debug('lstAttachment.size()=='+lstAttachment.size());
  upsert lstAttachment;

    }
    
    public static void sendEmail(string labelName,string reciepientList){
    
         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
         message.setSenderDisplayName('Tom Kearns'); 
         message.setReplyTo('no-reply@company.com');
         message.setUseSignature(false); 
         message.setBccSender(false); 
         message.setSaveAsActivity(false); 
         Contact cnt = [select id, Email from Contact where email = 'test@test.com' limit 1];
         message.setTargetObjectId(cnt.id);
        //EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = ‘Test Account Alert Email’];
        message.setTemplateID([Select Id from EmailTemplate where Name =: labelName limit 1][0].ID); 
       //message.setWhatId(account.Id); //This is important for the merge fields in template to work
       message.toAddresses = reciepientList.split(';');
       Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
       Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
 
      if (results[0].success) 
      {
       System.debug('The email was sent successfully.');
      } else {
       System.debug('The email failed to send: ' +  results[0].errors[0].message);
      }
     
    }

}