//Test Class: SEOTimesheetWeeklyUpdateBatchTest
global class SEOTimesheetWeeklyUpdateBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    
   string query;
   string userID;
   Set<string> profiles;
   Date eDate;
   Date sDate;
   string uRole;
   Map<string,SEO_Timesheet__c> mapOfTimeSheet;
    
    global SEOTimesheetWeeklyUpdateBatch (){
          

        
           profiles = new Set<string>();
           
           profiles.add('Custom - Digital Marketing User');
           profiles.add('Digital Marketing - Writer');
           profiles.add('Digital Marketing - SEO');
           
           if(test.isRunningTest()){
               profiles.add('System Administrator');
               uRole='SEO Associate';
            
           }
           
           uRole='SEO Associate';
           mapOfTimeSheet = new Map<string,SEO_Timesheet__c>();
         // userID = '0050P0000075sXB';
           //query = 'select id, Email, FirstName, LastName,profile.name,Username, IsActive FROM User where profile.name IN : profiles and IsActive=true';
           query = 'select id, Email, FirstName, LastName,profile.name,Username,User_Role__c, UserRole.Name, IsActive FROM User where UserRole.Name = :uRole and IsActive=true';
            // query = 'select id, Email, FirstName, LastName,profile.name,Username, IsActive FROM User where IsActive=true' ;
           //query = 'select id, Email, FirstName, LastName,profile.name,Username, IsActive FROM User where ID =: userID';

       
        if(Test.isRunningTest())
            query += ' limit 200';
   

    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('query :::'+query);

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<user> scope){
    
        Set<string> setOfUser = new Set<string>();
        
        for(User iuser : scope)
            setOfUser.add(iuser.ID);
            
        Map<ID,integer> mapOfOutReachAgainstSeo = new Map<ID,integer>();
        string key = '';
        //Date eDate = Date.today().toStartofWeek().addDays(1);
        //Date sDate = eDate.addDays(-7);
       // Date eDate =  Date.newInstance(2018, 12, 19);
        //Date sDate =  Date.newInstance(2018, 11, 1);
        DateTime eDate=Date.today().toStartofWeek().addDays(5);
        eDate = eDate.addHours(15+7).addMinutes(59).addSeconds(59);
        
        DateTime sDate=eDate.addDays(-7);
        sDate = sDate.addSeconds(1);
        
          if(test.isRunningTest()){
              eDate = Date.today().AddDays(2);
              sDate = Date.today();
           }
        System.debug('Start Date: '+sDate+' End Date: '+eDate+' Today: '+Date.today());

                
       /* AggregateResult[] outReachReqConverted = [select AssignedSeo__c,Count(id ) from OUTREACH_REQUEST__c where Status__c ='Converted'
                                                  AND AssignedSeo__c IN : setOfUser  AND CreatedDate >= : sDate AND CreatedDate <= : eDate
                                                  group By AssignedSeo__c]; */
        AggregateResult[] outReachReqConverted = [select AssignedSeo__c,Count(id ) from OUTREACH_REQUEST__c where Status__c ='Converted'
                                                  AND AssignedSeo__c IN : setOfUser  AND Outreach_Request_Converted_Date_Time__c >= : sDate AND Outreach_Request_Converted_Date_Time__c <= : eDate
                                                  group By AssignedSeo__c];
                                                  
        AggregateResult[] totalContentPublished = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Link Published'
                                                    AND Published_Date_Time__c >= : sDate AND Published_Date_Time__c <= : eDate group By OwnerID];
                                                     
                                                     
        AggregateResult[] totalOnSiteBlog  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Link Published'
                                                    AND Published_Date_Time__c >= : sDate AND Published_Date_Time__c <= : eDate AND Type__c='On-Site Blog Post' group By OwnerID ];
                                                     
                                                            
        AggregateResult[] totalOrganicLandingPagesPublished  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Link Published'
                                                    AND Published_Date_Time__c >= : sDate AND Published_Date_Time__c <= : eDate AND Type__c='Organic Landing Page' group By OwnerID ];
         
                                                            
        AggregateResult[] totalGuestPostsPublished  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Link Published'
                                                    AND Published_Date_Time__c >= : sDate AND Published_Date_Time__c <= : eDate AND Type__c='Guest Posts' group By OwnerID ];
        
         
        AggregateResult[] totalResourceLinksPublished  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Link Published'
                                                    AND Published_Date_Time__c >= : sDate AND Published_Date_Time__c <= : eDate AND Type__c='Resource Link' group By OwnerID ];
                                                    
        AggregateResult[] totalInfographicsPublished  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Link Published'
                                                    AND Published_Date_Time__c >= : sDate AND Published_Date_Time__c <= : eDate AND Type__c='Infographics' group By OwnerID ];
        
        AggregateResult[] totalBrokenLinksPublished  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Link Published'
                                                    AND Published_Date_Time__c >= : sDate AND Published_Date_Time__c <= : eDate AND Type__c='Broken Link' group By OwnerID ];
                
        AggregateResult[] totalKeywordMentionsPublished  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Link Published'
                                                    AND Published_Date_Time__c >= : sDate AND Published_Date_Time__c <= : eDate AND Type__c='Keyword Mention' group By OwnerID ];
                        
        AggregateResult[] totalSkyscrapersPublished  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Link Published'
                                                    AND Published_Date_Time__c >= : sDate AND Published_Date_Time__c <= : eDate AND Type__c='Skyscraper Link' group By OwnerID ];
                                                     
                                                            
        AggregateResult[] NoofSEOPageChecklistCreated  = [select createdbyid,Count(id ) from Target_Page__c  where createdbyid IN :setOfUser
                                                    AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By createdbyid ];
        
                                                     
                                                     
        AggregateResult[] NoOutreachAccountsMarkedasContributor  = [select OwnerID,Count(id ) from outreach_Account__c  where OwnerID IN :setOfUser and Status__c='Contributor' 
                                                    AND Contributed_Date__c >= : sDate AND Contributed_Date__c <= : eDate group By OwnerID ];
        
        AggregateResult[] SEOPageChecklistEdits  = [select OwnerID,Count(id ) from Target_Page__c  where OwnerID IN :setOfUser
                                                    AND LastModifiedDate >= : sDate AND LastModifiedDate <= : eDate group By OwnerID ];
        
  /////////////////////////////PIE CHART DATA/////////////////////////////////////////////
  
          AggregateResult[] GP_CRInProgress  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Content Request in Progress'
                                                     AND Type__c='Guest Posts' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
  
          AggregateResult[] GP_Content_Returned_For_Editing  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Content Returned For Editing'
                                                    AND Type__c='Guest Posts'AND CreatedDate >= : sDate AND CreatedDate <= : eDate  group By OwnerID ];
        
          AggregateResult[] GP_InitialContentSubmitted  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Initial Content Submitted'
                                                   AND Type__c='Guest Posts' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
                                            
          AggregateResult[] GP_ClosedAccepted  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Closed Accepted'
                                                    AND Type__c='Guest Posts'AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
                                                
          AggregateResult[] GP_ClosedRejected  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Closed Rejected'
                                                    AND Type__c='Guest Posts' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
  
        
         AggregateResult[] RL_CRInProgress  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Content Request in Progress'
                                                    AND Type__c='Resource Link' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
  
          AggregateResult[] RL_Content_Returned_For_Editing  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Content Returned For Editing'
                                                     AND Type__c='Resource Link' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
        
          AggregateResult[] RL_InitialContentSubmitted  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Initial Content Submitted'
                                                    AND Type__c='Resource Link' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
                                            
          AggregateResult[] RL_ClosedAccepted  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Closed Accepted'
                                                    AND Type__c='Resource Link' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
                                                
          AggregateResult[] RL_ClosedRejected  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Closed Rejected'
                                                    AND Type__c='Resource Link' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
  
  
          AggregateResult[] OLP_CRInProgress  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Content Request in Progress'
                                                    AND Type__c='Organic Landing Page' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
  
          AggregateResult[] OLP_Content_Returned_For_Editing  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Content Returned For Editing'
                                                    AND Type__c='Organic Landing Page' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
        
          AggregateResult[] OLP_InitialContentSubmitted  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Initial Content Submitted'
                                                   AND Type__c='Organic Landing Page' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
                                            
          AggregateResult[] OLP_ClosedAccepted  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Closed Accepted'
                                                    AND Type__c='Organic Landing Page' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
                                                
          AggregateResult[] OLP_ClosedRejected  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Closed Rejected'
                                                    AND Type__c='Organic Landing Page' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
                                                    
         AggregateResult[] BP_CRInProgress  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Content Request in Progress'
                                                   AND Type__c='On-Site Blog Post' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
  
          AggregateResult[] BP_Content_Returned_For_Editing  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Content Returned For Editing'
                                                   AND Type__c='On-Site Blog Post' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
        
          AggregateResult[] BP_InitialContentSubmitted  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Initial Content Submitted'
                                                     AND Type__c='On-Site Blog Post' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
                                            
          AggregateResult[] BP_ClosedAccepted  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Closed Accepted'
                                                    AND Type__c='On-Site Blog Post' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];
                                                
          AggregateResult[] BP_ClosedRejected  = [select OwnerID,Count(id ) from CONTENT_REQUEST__c where OwnerID IN :setOfUser and Status__c ='Closed Rejected'
                                                    AND Type__c='On-Site Blog Post' AND CreatedDate >= : sDate AND CreatedDate <= : eDate group By OwnerID ];                                              
                                                    
        Map<id, Integer> mapEmailCountToOA = new Map<id, Integer>();
        Date ActivityEDate=date.newinstance(eDate.year(), eDate.month(), eDate.day());
        Date ActivitySDate=date.newinstance(sDate.year(), sDate.month(), sDate.day());

            for( Outreach_Account__c OAObj : [SELECT OwnerID,(SELECT Id FROM ActivityHistories where ActivitySubtype='Email' and  ActivityDate>= : ActivitySDate AND ActivityDate<= : ActivityEDate) 
                     FROM Outreach_Account__c where LastActivityDate >= : ActivitySDate AND LastActivityDate <= : ActivityEDate])
                {
                  mapEmailCountToOA.put(OAObj.OwnerID, OAObj.ActivityHistories.size());
                }

       
      
        
        for(AggregateResult agr : outReachReqConverted){

            mapOfTimeSheet.put((string)agr.get('AssignedSeo__c'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('AssignedSeo__c'), Outreach_Requests_Status_Conversion__c = (Decimal)agr.get('expr0')));
             
        }
        
         for(AggregateResult agr : totalContentPublished){
            
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.Total_Content_Published__c = (Decimal)agr.get('expr0');
                continue;
      
            }
            

             mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Total_Content_Published__c = (Decimal)agr.get('expr0')));
          
            
         }
         
          for(AggregateResult agr : totalOnSiteBlog){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.Blog_Posts_Published__c = (Decimal)agr.get('expr0');
                continue;
                
            }

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Blog_Posts_Published__c = (Decimal)agr.get('expr0')));
           
            
         }
         
           for(AggregateResult agr : totalOrganicLandingPagesPublished){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.Organic_Landing_Pages_Published__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Organic_Landing_Pages_Published__c = (Decimal)agr.get('expr0')));
         
            
         }
         
            for(AggregateResult agr : totalGuestPostsPublished){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.Guest_Posts_Published__c = (Decimal)agr.get('expr0');
                continue;
                
            }

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Guest_Posts_Published__c = (Decimal)agr.get('expr0')));
             
         }
         
         
            for(AggregateResult agr : totalResourceLinksPublished){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.Resource_Links_Published__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Resource_Links_Published__c = (Decimal)agr.get('expr0')));
            
         }
         
            for(AggregateResult agr : totalInfographicsPublished){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.Infographics_Published__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Infographics_Published__c = (Decimal)agr.get('expr0')));
            
         }
         
            for(AggregateResult agr : totalBrokenLinksPublished){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.Broken_Links_Published__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Broken_Links_Published__c = (Decimal)agr.get('expr0')));
            
         }
            
         
                  
            for(AggregateResult agr : totalKeywordMentionsPublished){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.Keyword_Mention_Published__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Keyword_Mention_Published__c = (Decimal)agr.get('expr0')));
            
         }
         
                           
            for(AggregateResult agr : totalSkyscrapersPublished){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.Skyscraper_Links_Published__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Skyscraper_Links_Published__c = (Decimal)agr.get('expr0')));
            
         }
            
         
            
            
            for(AggregateResult agr : NoofSEOPageChecklistCreated){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('CreatedByid'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('CreatedByid'));
                seo.Number_of_SEO_Page_Checklist_Created__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('CreatedByid'),new SEO_Timesheet__c(CreatedByid = (ID)agr.get('CreatedByid'), Number_of_SEO_Page_Checklist_Created__c = (Decimal)agr.get('expr0')));
           
         }
         
         
         for(AggregateResult agr : NoOutreachAccountsMarkedasContributor){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID')); 
                seo.Num_Outreach_Accounts_as_Contributor__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), Num_Outreach_Accounts_as_Contributor__c = (Decimal)agr.get('expr0')));
           
         }
         
         
         
         for(AggregateResult agr : SEOPageChecklistEdits){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.Number_of_SEO_Page_Checklist_Edited__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            
            if( (Decimal)agr.get('expr0')==null)
            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'),Number_of_SEO_Page_Checklist_Edited__c = 0));
            else
            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'),Number_of_SEO_Page_Checklist_Edited__c = (Decimal)agr.get('expr0')));
           
         }
         
         
          
         for(AggregateResult agr : GP_CRInProgress){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.GuestPost_Content_Request_in_Progress__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), GuestPost_Content_Request_in_Progress__c = (Decimal)agr.get('expr0')));
           
         }
         
         
         for(AggregateResult agr : GP_Content_Returned_For_Editing){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.GuestPost_Content_Returned_For_Editing__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), GuestPost_Content_Returned_For_Editing__c = (Decimal)agr.get('expr0')));
           
         }
         
         
        for(AggregateResult agr : GP_ClosedRejected){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.GuestPost_Closed_Rejected__c = (Decimal)agr.get('expr0');
                continue;
                
            }

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), GuestPost_Closed_Rejected__c = (Decimal)agr.get('expr0')));
           
         }
         
         
           for(AggregateResult agr : GP_ClosedAccepted){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
              seo.GuestPost_Closed_Accepted__c = (Decimal)agr.get('expr0');
                continue;
                
            }

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), GuestPost_Closed_Accepted__c = (Decimal)agr.get('expr0')));
           
         }
         
         for(AggregateResult agr : GP_InitialContentSubmitted){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.GuestPost_Initial_Content_Submitted__c = (Decimal)agr.get('expr0');
                continue;
                
            }

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), GuestPost_Initial_Content_Submitted__c = (Decimal)agr.get('expr0')));
           
         }
        ///
        
        
                  
         for(AggregateResult agr : RL_CRInProgress){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.RL_Content_Request_in_Progress__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), RL_Content_Request_in_Progress__c = (Decimal)agr.get('expr0')));
           
         }
         
         
         for(AggregateResult agr : RL_Content_Returned_For_Editing){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.RL_Content_Returned_For_Editing__c = (Decimal)agr.get('expr0');
                continue;
                
            }

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), RL_Content_Returned_For_Editing__c = (Decimal)agr.get('expr0')));
           
         }
         
         
        for(AggregateResult agr : RL_ClosedRejected){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.RL_Closed_Rejected__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), RL_Closed_Rejected__c = (Decimal)agr.get('expr0')));
           
         }
         
         
           for(AggregateResult agr : RL_ClosedAccepted){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.RL_Closed_Accepted__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), RL_Closed_Accepted__c = (Decimal)agr.get('expr0')));
           
         }
         
         for(AggregateResult agr : RL_InitialContentSubmitted){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.RL_Initial_Content_Submitted__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), RL_Initial_Content_Submitted__c = (Decimal)agr.get('expr0')));
           
         }
         
         
         //
         
              for(AggregateResult agr : OLP_CRInProgress){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.OLP_Content_Request_in_Progress__c = (Decimal)agr.get('expr0');
                continue;
                
            }

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), OLP_Content_Request_in_Progress__c = (Decimal)agr.get('expr0')));
           
         }
         
         
         for(AggregateResult agr : OLP_Content_Returned_For_Editing){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.OLP_Content_Returned_For_Editing__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            


            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), OLP_Content_Returned_For_Editing__c = (Decimal)agr.get('expr0')));
           
         }
         
         
        for(AggregateResult agr : OLP_ClosedRejected){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.OLP_Closed_Rejected__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), OLP_Closed_Rejected__c = (Decimal)agr.get('expr0')));
           
         }
         
         
           for(AggregateResult agr : OLP_ClosedAccepted){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.OLP_Closed_Accepted__c = (Decimal)agr.get('expr0');
                continue;
                
            }

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), OLP_Closed_Accepted__c = (Decimal)agr.get('expr0')));
           
         }
         
         for(AggregateResult agr : OLP_InitialContentSubmitted){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.OLP_Initial_Content_Submitted__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), OLP_Initial_Content_Submitted__c = (Decimal)agr.get('expr0')));
           
         }
         
         
         ///
            for(AggregateResult agr : BP_CRInProgress){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.BP_Content_Request_in_Progress__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            
        

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), BP_Content_Request_in_Progress__c = (Decimal)agr.get('expr0')));
           
         }
         
         
         for(AggregateResult agr : BP_Content_Returned_For_Editing){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.BP_Content_Returned_For_Editing__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), BP_Content_Returned_For_Editing__c = (Decimal)agr.get('expr0')));
           
         }
         
         
        for(AggregateResult agr : BP_ClosedRejected){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));
                seo.BP_Closed_Rejected__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), BP_Closed_Rejected__c = (Decimal)agr.get('expr0')));
           
         }
         
         
           for(AggregateResult agr : BP_ClosedAccepted){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.BP_Closed_Accepted__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), BP_Closed_Accepted__c = (Decimal)agr.get('expr0')));
           
         }
         
         for(AggregateResult agr : BP_InitialContentSubmitted){
            
            if(mapOfTimeSheet.containsKey((string)agr.get('OwnerID'))){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)agr.get('OwnerID'));

                seo.BP_Initial_Content_Submitted__c = (Decimal)agr.get('expr0');
                continue;
                
            }
            

            mapOfTimeSheet.put((string)agr.get('OwnerID'),new SEO_Timesheet__c(OwnerID = (ID)agr.get('OwnerID'), BP_Initial_Content_Submitted__c = (Decimal)agr.get('expr0')));
           
         }
         
         
         
         system.debug('$$$$$$' +mapEmailCountToOA);
         for(id OAOwnerID : mapEmailCountToOA.keyset()){
             
                if(mapOfTimeSheet.containsKey((string)OAOwnerID)){
                
                SEO_Timesheet__c seo = mapOfTimeSheet.get((string)OAOwnerID);

                seo.Number_of_Emails_sent_in_Salesforce__c = (Decimal)mapEmailCountToOA.get(OAOwnerID);
                
            }
            else{
                 SYSTEM.DEBUG('AYA' +OAOwnerID );
                 SYSTEM.DEBUG('AYA' +mapOfTimeSheet);
       
                 mapOfTimeSheet.put((string)OAOwnerID,new SEO_Timesheet__c(OwnerID = OAOwnerID, Number_of_Emails_sent_in_Salesforce__c = mapEmailCountToOA.get(OAOwnerID)));
           
            }
            

            }

            for(string u : setOfUser)
                {
                    if(!mapOfTimeSheet.containsKey(u)){
                    mapOfTimeSheet.put(u,new SEO_Timesheet__c(OwnerID = (ID)u,Start_Date_Time__c=sDate,End_Date_Time__c= eDate));
                    
                    }
                    
                    else{
                    SEO_Timesheet__c seo = mapOfTimeSheet.get(u);
                    seo.Start_Date_Time__c=sDate;
                    seo.End_Date_Time__c=eDate;
                    
                    }
         
                }
         
       
        
      
      
    }
    
    global void finish(Database.BatchableContext BC){
    
         INSERT mapOfTimeSheet.values();
    
    }




}