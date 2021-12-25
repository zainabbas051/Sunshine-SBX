public without sharing class customEmailClassOpp{
    
   
    private final Opportunity opp;
    public Opportunity opp1;
    String placementCenter = null;//String that helps to determince the Center
    Public Boolean selectionPage = True;
    Public String FullName= '';
    
    Public customEmailClassOpp(ApexPages.StandardController controller){
        opp=(Opportunity)Controller.getRecord();
        String opp_id = ApexPages.currentPage().getParameters().get('id');//Getting the Id of the Opportunity to populate the fields in the Body
        if(opp_id != Null){
            opp1 = [select Name, Client_DOB__c, Subscriber_Name__c, Insurance_Providers__c, Insurance_Policy__c, 
                    Group_Number__c, Insurance_Provider_Phone_Number__c,
                    Subscriber_DOB__c, Subscriber_DOBtext__c, SSN_Last_4__c from Opportunity where id =: opp_id];
        }
        if(opp_id == Null)
            opp1 = new Opportunity();
        
        for(Placement_Center__c pc : [Select id, Name, Email__c from Placement_Center__c Where Active__c =: True ORDER BY Name ASC]){
            allPlacementCenterMap.put(pc.id,pc);
        }
    }
    
    Public Boolean selectionPageFlag{//Get the flag to display the VF page
        get{
            return selectionPage;
        }set;
    }
    
    Public Map<Id,Placement_Center__c> allPlacementCenterMap{//A Map of All Placement Centers in the System
        get{
            if(allPlacementCenterMap == Null){
                allPlacementCenterMap = new Map<Id,Placement_Center__c>();
            }
            return allPlacementCenterMap;
        }set;
    }
    
    Public String fromUserName{//Get the User name to display on the VF page
        get{
            String userName = UserInfo.getName();
            return userName;
        }set;
    }
    
    public PageReference pleacementCenterSet() {
        return null;
    }
                
    public List<SelectOption> getItems() {//Determine the pick list containing Rehab Centers
        List<SelectOption> options = new List<SelectOption>(); 
        if(allPlacementCenterMap.keySet().size()>0){
            for(Id pcId : allPlacementCenterMap.KeySet()){
                options.add(new SelectOption(pcId,allPlacementCenterMap.get(pcId).Name));
            }
        }
        /*
        //options.add(new SelectOption('A Better Life Recovery','A Better Life Recovery'));
        //options.add(new SelectOption('Akua Mind and Body','Akua Mind and Body'));
        options.add(new SelectOption('A Better Today','A Better Today'));
        options.add(new SelectOption('Affinity Recovery','Affinity Recovery'));
        options.add(new SelectOption('Altus Recovery','Altus Recovery'));
        //options.add(new SelectOption('Anaheim Lighthouse','Anaheim Lighthouse'));
        options.add(new SelectOption('Avalon Malibu','Avalon Malibu'));
        options.add(new SelectOption('Beaches Recovery','Beaches Recovery'));
        options.add(new SelectOption('Capo by the Sea','Capo by the Sea'));
        options.add(new SelectOption('Desert Cove','Desert Cove'));
        options.add(new SelectOption('Discovery House','Discovery House'));
        options.add(new SelectOption('Elements','Elements'));
        //options.add(new SelectOption('Design for Change','Design for Change'));
        //options.add(new SelectOption('Hope by the Sea','Hope by the Sea'));
        //options.add(new SelectOption('Insight to Recovery','Insight to Recovery'));
        options.add(new SelectOption('Into Action Recovery','Into Action Recovery'));
        //options.add(new SelectOption('Luminance','Luminance'));
        options.add(new SelectOption('Maple Mountain Recovery','Maple Mountain Recovery'));
        options.add(new SelectOption('Miramar Recovery','Miramar Recovery'));
        options.add(new SelectOption('Monarch Shores','Monarch Shores'));
        options.add(new SelectOption('New Method Wellness','New Method Wellness'));
        options.add(new SelectOption('Ocean Hills Recovery','Ocean Hills Recovery'));
        options.add(new SelectOption('Pac Hills','Pac Hills'));
        //options.add(new SelectOption('Pacific Medical Care','Pacific Medical Care'));
        options.add(new SelectOption('Pacific Bay Recovery','Pacific Bay Recovery'));
        options.add(new SelectOption('Pines Recovery Group','Pines Recovery Group'));
        options.add(new SelectOption('Pinnacle','Pinnacle'));
        options.add(new SelectOption('Ridgeview Ranch','Ridgeview Ranch'));
        //options.add(new SelectOption('Safe harbor','Safe harbor'));
        //options.add(new SelectOption('Sherwood Hills Recovery','Sherwood Hills Recovery'));
        //options.add(new SelectOption('Serenity Now','Serenity Now'));
        options.add(new SelectOption('Sherwood Hills','Sherwood Hills'));
        options.add(new SelectOption('Solid Landings','Solid Landings'));
        options.add(new SelectOption('Sovereign Health','Sovereign Health'));
        options.add(new SelectOption('Windward Way Recovery','Windward Way Recovery'));
        //options.add(new SelectOption('Spencers Recovery','Spencers Recovery'));
        //options.add(new SelectOption('Whole Life Recovery','Whole Life Recovery'));
        */
        return options;  
        
    }
                   
    public String getplacementCenter() {
        return placementCenter;
    }
                    
    public void setplacementCenter(String placementCenter){ 
        this.placementCenter = placementCenter; 
    }
    
    public pagereference go(){//This method is used to set the To and CC email address based on the Center Chosen
        selectionPage = False;//Setting the flag to change the Page Block Displayed on the VF page
        if(opp1.Name!=Null){
            String[] OppFirstName = opp1.Name.split(' ');
            opp.Address__c = 'Please Verify : '+OppFirstName[0];//Setting the Subject of the Email
        }
        if(opp1.Name==Null){
            
            opp.Address__c = 'Please Verify ';//Setting the Subject of the Email
        }
        String Body = '';
        if(opp1.Name != Null)
            Body = Body+ '\n'+'Client: '+opp1.Name+'\n';
        if(opp1.Client_DOB__c != Null)
            Body = Body+'Client DOB: '+opp1.Client_DOB__c+'\n'+'\n';
        if(opp1.Client_DOB__c == Null)
            Body = Body+'\n';    
        if(opp1.Subscriber_Name__c != Null)
            Body = Body+'Subscriber: '+opp1.Subscriber_Name__c+'\n';
        if(opp1.Insurance_Providers__c != Null)
            Body = Body+'Provider: '+opp1.Insurance_Providers__c+'\n';
        if(opp1.Insurance_Policy__c != Null)
            Body = Body+'ID#: '+opp1.Insurance_Policy__c+'\n';
        if(opp1.Group_Number__c != Null)
            Body = Body+'Group #: '+opp1.Group_Number__c+'\n';
        if(opp1.Insurance_Provider_Phone_Number__c != Null)
            Body = Body+'Insurance Number: '+opp1.Insurance_Provider_Phone_Number__c+'\n';
        if(opp1.Subscriber_DOBtext__c != Null)
            Body = Body+'Subscriber DOB: '+opp1.Subscriber_DOBtext__c+'\n';
        if(opp1.SSN_Last_4__c != Null)
            Body = Body+'SSN (Last 4): '+opp1.SSN_Last_4__c;
                      
        opp.Insurance_Notes__c = Body;//Setting the Body of the email
        opp.Country__c = UserInfo.getUserEmail();//Setting the BCC Address
        if(placementCenter != null){
            opp.Address_2__c = allPlacementCenterMap.get(placementCenter).Email__c;//Setting the To Recipient
            opp.City__c = 'team@eliterehabplacement.com';//Setting the CC Recipient
        }
        /*if(placementCenter == 'Solid Landings'){
            opp.Address_2__c = 'ac@solidlandings.com;tahnil@solidlandings.com';//Setting the To Recipient
            opp.City__c = 'team@eliterehabplacement.com';//Setting the CC Recipient
        }
        
        if(placementCenter == 'Spencers Recovery'){
            opp.Address_2__c = 'cindyn@spencerrecovery.com;jonathane@spencerrecovery.com;charliek@spencerrecovery.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Pac Hills'){
            opp.Address_2__c = 'dustinh@covhills.com;sarah@covhills.com;blairj@covhills.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Capo by the Sea'){
            opp.Address_2__c = 'patty4na@hotmail.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Altus Recovery'){
            opp.Address_2__c = 'Nziesman@altustreatment.com;cniles@altustreatment.com;joeyscolari@gmail.com;sarmand@altustreatment.com;ariggle@altustreatment.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'A Better Today'){
            opp.Address_2__c = 'corey.p@abtrs.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Avalon Malibu'){
            opp.Address_2__c = 'cyrus@avalonmalibu.com;kelly@avalonmalibu.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        
        if(placementCenter == 'Beaches Recovery'){
            opp.Address_2__c = 'insuranceverification@NETORG154067.onmicrosoft.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Pinnacle'){
            opp.Address_2__c = 'tyler@resourcesforrecovery.org;chris@resourcesforrecovery.org';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Pacific Bay Recovery'){
            opp.Address_2__c = 'Bryan@pacificmedicalcare.net';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Desert Cove'){
            opp.Address_2__c = 'JDuFour@desertcoverecovery.com;Bnichols@desertcoverecovery.com;Mcleary@desertcoverecovery.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Pines Recovery Group'){
            opp.Address_2__c = 'duanec@thepinesrecovery.com;aaronr@thepinesrecovery.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Sovereign Health'){
            opp.Address_2__c = 'ts@sovhealth.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Into Action Recovery'){
            opp.Address_2__c = 'masteradmin@intoactionrecovery.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        if(placementCenter == 'Monarch Shores'){
            //opp.Address_2__c = 'bruce@monarchshores.com;chad@monarchshores.com;jennyk@monarchshores.com;patricia@monarchshores.com;catherine@monarchshores.com;zeinah@monarchshores.com ';
            opp.Address_2__c = 'ac@monarchshores.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'Ridgeview Ranch'){
            opp.Address_2__c = 'info@ridgeviewranchca.org';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        
        if(placementCenter == 'Ocean Hills Recovery'){
            opp.Address_2__c = 'elite@ohr1.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        if(placementCenter == 'Discovery House'){
            opp.Address_2__c = 'vob@recoveryas.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        
        if(placementCenter == 'New Method Wellness'){
            opp.Address_2__c = 'brook@newmethodwellness.com;nmwsusie@gmail.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        if(placementCenter == 'Miramar Recovery'){
            opp.Address_2__c = 'dhughlett@miramarrecovery.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        if(placementCenter == 'Windward Way Recovery'){
            opp.Address_2__c = 'wwadmissions@windwardwayrecovery.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        if(placementCenter == 'Sherwood Hills'){
            opp.Address_2__c = 'tylerg@sherwoodhills.com;Richard@sherwoodhills.com;verifications@sherwoodhills.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        if(placementCenter == 'Maple Mountain Recovery'){
            opp.Address_2__c = 'mboman@maplemountainrecovery.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        if(placementCenter == 'Affinity Recovery'){
            opp.Address_2__c = 'evan@affinityrecovery.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        if(placementCenter == 'Elements'){
            opp.Address_2__c = 'denny.hooten@theelements.com';
            opp.City__c = 'team@eliterehabplacement.com';
        }
        */
        return Null;
    }
    
    public pagereference cancel1(){
        return new pagereference('/'+opp.id); 
    }
    
    Public pagereference sendEmail(){//To send the Email
        String[] toaddress = new String[]{};
        String[] ccaddress = new String[]{};
        String[] bccaddress = new String[]{};
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        if(opp.Address_2__c != Null){//Splitting the To Recipients            
            for(String s : opp.Address_2__c.split(';',0)){
                toaddress.add(s);        
            }            
        }
        
        if(opp.City__c != Null){ //Splitting the CC Recipients            
            for(String s : opp.City__c.split(';',0)){
                ccaddress.add(s);        
            }            
        }
        
        if(opp.Country__c != Null){ //Splitting the  BCC Recipients            
            for(String s : opp.Country__c.split(';',0)){
                bccaddress.add(s);        
            }            
        }
        
        String userEmailAddress = UserInfo.getUserEmail();
        String userName = UserInfo.getName();
        
        
        if(checkRequiredFieldsSave() == False){//Checking to make the sure email add is in the correct format
            return Null;
        }
        
        mail.setToAddresses(toaddress);
        mail.setCCAddresses(ccaddress);
        mail.setBCCAddresses(bccaddress);
        mail.setsubject(opp.Address__c);
        mail.setPlainTextBody(opp.Insurance_Notes__c);
        mail.setReplyTo(userEmailAddress);
        mail.setSenderDisplayName(userName);
        mail.setBccSender(false);
        mail.setUseSignature(false); 
        
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        try{
            
            /*String feedBody = 'From : '+UserInfo.getName()+'\n'+
                              'To : '+opp.Address_2__c+'\n'+
                              'CC : '+opp.City__c+'\n'+
                              'BCC : '+opp.Country__c+'\n'+
                              'Subject : '+opp.Address__c+'\n'+'\n'+
                              opp.Insurance_Notes__c;
            */
            
            
            String feedBody = UserInfo.getName()+' emailed the rehab center : "'+allPlacementCenterMap.get(placementCenter).Name+'" at : '+dateTime.Now();
            FeedItem fi = new FeedItem();
            fi.Body = feedBody;
            fi.Type = 'AdvancedTextPost';
            //fi.Visibility = 'AllUsers';
            fi.ParentId = opp1.id;
                        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            
            
            Opportunity oppupdate = new Opportunity();
            oppupdate.id = opp.id;
            oppupdate.Last_Activity_Date__c = DateTime.now();
            update oppupdate ;
            
            insert fi;
        }
        catch (exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'We have been unable to send the email presently because of some technical difficulty, Please try again after some time'));
        }
        
        return new pagereference('/'+opp.id);         
    }
    
    public boolean checkRequiredFieldsSave(){//To check is the email is in the correct format
    String message='';      
        Boolean success=true;
         
         if(opp.Address_2__c == '' || opp.Address_2__c == Null){
                    
               success=false;
               message='The To Email Address field cannot be left empty';
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
               
               return success;
                 
         }
         
         if(opp.Address__c == '' || opp.Address__c == Null){
                    
               success=false;
               message='The Subject field cannot be left empty';
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
               
               return success;
                 
         }
         
         if(opp.Address_2__c != Null){
         String[] toAddress = opp.Address_2__c.split(';',0);
        
         for(String s : toAddress){
         
             String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
             Pattern p = Pattern.compile(emailRegex );
             Matcher pm = p.matcher(s);
             
             
             if(s != ''){
             if(!pm.Matches()){
             success=false;
             message='The email address:'+s+' '+'entered by you in To Address is not in correct format.';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             }
                          
         
         }
         }
         
         
         if(opp.City__c != Null){
         String[] ccAddress = opp.City__c.split(';',0);
         for(String c : ccAddress){
         
             String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
             Pattern p = Pattern.compile(emailRegex );
             Matcher pm = p.matcher(c);
             
             
             if(c != ''){
             if(!pm.Matches()){
             success=false;
             message='The email address:'+c+' '+'entered by in CC Address you is not in correct format.';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             }
         }
         }
         
         if(opp.Country__c != Null){
         String[] bccAddress = opp.Country__c.split(';',0);
         for(String c : bccAddress){
         
             String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
             Pattern p = Pattern.compile(emailRegex );
             Matcher pm = p.matcher(c);
             
             
             if(c != ''){
             if(!pm.Matches()){
             success=false;
             message='The email address:'+c+' '+'entered by in BCC Address you is not in correct format.';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));             
             }
             }
         }
         }
        return success;
    }

}