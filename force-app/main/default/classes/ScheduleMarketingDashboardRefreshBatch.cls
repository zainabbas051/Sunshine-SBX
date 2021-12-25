public class ScheduleMarketingDashboardRefreshBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    public string accesstoken;
    public Database.QueryLocator start(Database.BatchableContext bc) { 
       
     
        string dashboardid = Label.MarketingDashboardID; 
        String queryString = 'Select Id from Dashboard where ID =:dashboardid'; 
        return Database.getQueryLocator(queryString);
    }
    
    public void execute(Database.BatchableContext bc, List<sObject>  scope) { 
       RefreshDashboard();
    CreateImageFromDashboard();
    }
    void RefreshDashboard(){
    String requestUrl = '/dash/dashboardRefresh.apexp?id='+Label.MarketingDashboardID;
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    string url =  URL.getSalesforceBaseUrl().toExternalForm() + requestUrl;
    system.debug('%%%%%' + url);
    req.setEndpoint(url );
    req.setMethod('GET');
    req.setHeader('Cookie','sid='+UserInfo.getSessionId()); 
   // req.setHeader('Cookie','sid='+accesstoken+''); 
   
   if(test.isRunningTest() == false){
    HTTPResponse res = http.send(req);
    String output = res.getBody();
    System.debug('>>>>'+output);
   }
   
 
 }
 void CreateImageFromDashboard() {
  PageReference dbPage = new PageReference('/'+Label.MarketingDashboardID); //constructing your dashboard page's URL
  Blob pageBlob;
  if(test.isRunningTest()){
       pageBlob = blob.valueOf('<img src="/servlet/servlet.ChartServer?"');

  }
  else{
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
 
  List < Attachment > lstAttachment = new List < Attachment > ();
  for (integer numbers: imageURLIndexedMap.keySet()) {
   dbPage = new PageReference(imageURLIndexedMap.get(numbers)); //constructing your dashboard page's URL
   
   if(test.isRunningTest() == false){
        pageBlob = dbPage.getContent(); //Hitting the page and retrieving the HTML
   }
   else{
       pageBlob = blob.valueOf('abc test');
   }
  
   //  dHtml = pageBlob.toString();
   String csvBody = EncodingUtil.base64Encode(pageBlob);

   system.debug(csvBody);

   Attachment attach = new Attachment();
   attach.Body = pageBlob;
   attach.Name = numbers + '.jpeg';
   attach.ContentType = 'image/jpeg';
   attach.ParentID = Label.MarketingDashboardRecordID;
   //insert attach;
   lstAttachment.add(attach);
  }
  insert lstAttachment;


 }
     public void finish(Database.BatchableContext bc) {
    }
}