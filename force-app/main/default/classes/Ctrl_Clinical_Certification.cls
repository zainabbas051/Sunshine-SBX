public without sharing class Ctrl_Clinical_Certification {
    public awsBucket__c bucket {
        get;
        set;
    } //Bucket permission set

    @AuraEnabled
    public static List < Certifications__c > GetAvailableCertification(string empID,string Tier,string sunshineCenter) {

        List < Certifications__c > lstAvailableCert = new List < Certifications__c > ();

        for (Certifications__c ce: [select Id, Name, Certification_Cost__c, Allocated_Tiers__c, (select id,Status__c,Related_Employee__c from Employee_Certifications__r) from Certifications__c where Allocated_Tiers__c INCLUDES(: Tier) and Sunshine_Center__c INCLUDES(:sunshineCenter) and Name!='Other' order by Name]) {
            List < Employee_Certifications__c > lstempcert = new List < Employee_Certifications__c >();
            
            for(Employee_Certifications__c ie :ce.Employee_Certifications__r){
           if(ie.Related_Employee__c==Id.ValueOf(empID) && ie.Status__c!='Request Denied' )
            
            lstempcert.add(ie);
            
            
            }
            
            
            
            if (lstempcert.size() == 0) {

                lstAvailableCert.add(ce);
            }
        }
        return lstAvailableCert;
    }

@AuraEnabled
    public static Map<string,Decimal>  GetSupervisorSummary(string supervisorId) {
    superVisorId = '%' + superVisorId +'%';
    AggregateResult[] agr=[select Tier_Allocation__c, count(id) , sum(Completed_Certifications__c) ,
                            sum(In_Progress_Certifications__c), sum(Certificate_Budget_Utilized__c),
                            sum(Certification_Budget_Allocation__c) 
                            from employee__c 
                            where Ultimate_Parent__c  like : supervisorId group by Tier_Allocation__c ];
      Map<string,Decimal> mapSupervisorSummary= new Map<string,Decimal>();
     for (AggregateResult ia : agr){
     
     decimal expr0 = (Decimal)ia.get('expr0');
     mapSupervisorSummary.put(ia.get('Tier_Allocation__c')+'-Total Reports',(expr0  == 0) ? 0 : expr0 );
     mapSupervisorSummary.put(ia.get('Tier_Allocation__c')+'-Total Completed Certifications',(Decimal)ia.get('expr1'));
     mapSupervisorSummary.put(ia.get('Tier_Allocation__c')+'-Total In-Progress Certifications',(Decimal)ia.get('expr2'));
     Decimal availableBudget= (Decimal)ia.get('expr4')-(Decimal)ia.get('expr3');
     mapSupervisorSummary.put(ia.get('Tier_Allocation__c')+'-Utilized Budget',(Decimal)ia.get('expr3'));
     mapSupervisorSummary.put(ia.get('Tier_Allocation__c')+'-Available Budget',availableBudget);
     }
    
     
     return mapSupervisorSummary;
}

@AuraEnabled
    public static integer GetNumberofCertifications(string empID) {
    List <Employee__c> empList=[select id,IsSupervisor__c,Supervisor_Name__c from Employee__c where Supervisor_Name__c=:Id.valueOf(empID)];
    return empList.size();
}


    @AuraEnabled
    public static List < Certifications__c > GetAllCertification() {

        List < Certifications__c > lstAvailableCert = new List < Certifications__c > ();

        lstAvailableCert = [select Id, Name, Certification_Cost__c, Allocated_Tiers__c from Certifications__c];

        return lstAvailableCert;
    }


    @AuraEnabled
    public static List < Employee__c > GetReportingEmployees(string superVisorId) {

        return getEmployees(superVisorId);

    }

    @AuraEnabled
    public static List < Employee__c > getTeir2Employees(string superVisorId){
        
           superVisorId = '%' + superVisorId +'%';
           List < Employee__c > ListEmp = [Select ID,Name__c,Employment_Start_Date__c,Tier_Allocation__c,User_Role__c,
                                           Count_of_Tier2_Mandatory_Certifications__c,Tier3_Mandatory_Training_Names__c,Tier2_Mandatory_Training_Names__c,Completed_90_day_review__c
                    FROM Employee__c WHERE 
                     Tier_2_Transition_Eligible_Date__c <=: Date.Today() AND 
                    Tier_2_Transition_Date__c = null AND Tier_Allocation__c='Tier 1'
                    AND (Ultimate_Parent__c  like : superVisorId)];
                    
           List < Employee__c > eligibleEmp = new List < Employee__c >();
                    
           AggregateResult countT = [Select Count(id) from Certifications__c where
                                                           Mandatory_for_Tier_2_Transition__c=True ];
            integer countOfT2Trainings = integer.valueof(countT.get('expr0'));
             if(countOfT2Trainings>0){
            for(Employee__c iEmp : ListEmp){
            if(iEmp.Count_of_Tier2_Mandatory_Certifications__c>=countOfT2Trainings)
                    eligibleEmp.add(iEmp);
            }
        return eligibleEmp;
         }
        return null;
        
       
    }
    
    @AuraEnabled
    public static List < Employee__c > getManualTierTransitEmployees(string superVisorId){
        
           superVisorId = '%' + superVisorId +'%';
           List < Employee__c > ListEmp = [Select ID,Name__c,Employment_Start_Date__c,Tier_Allocation__c,User_Role__c,
                                           Count_of_Tier2_Mandatory_Certifications__c,Tier3_Mandatory_Training_Names__c,Tier2_Mandatory_Training_Names__c,Completed_90_day_review__c
                    FROM Employee__c WHERE 
                    Tier_Allocation__c!='Tier 3'
                    AND (Ultimate_Parent__c  like : superVisorId)];
              return ListEmp;      
           
        
       
    }

    @AuraEnabled
    public static List < Employee__c > getTeir3Employees(string superVisorId){
        
         superVisorId = '%' + superVisorId +'%';
         List < Employee__c > ListEmp = [Select ID,Name__c,Employment_Start_Date__c,Tier_Allocation__c,User_Role__c,
                             Count_of_Tier3_Mandatory_Certifications__c,Tier2_Mandatory_Training_Names__c,Tier3_Mandatory_Training_Names__c,Completed_90_day_review__c
                FROM Employee__c WHERE Tier_3_Transition_Eligible_Date__c <=: Date.Today() AND 
                Tier_3_Transition_Date__c = null AND Tier_Allocation__c!='Tier 3'
                AND (Ultimate_Parent__c  like : superVisorId)];
                
       List < Employee__c > eligibleEmp = new List < Employee__c >();
                
       AggregateResult enableBtn = [Select Count(id) from Certifications__c where
                                                       Mandatory_for_Tier_3_Transition__c=True ];
        integer countOfT3Trainings = integer.valueof(enableBtn.get('expr0'));
        if(countOfT3Trainings>0){
        for(Employee__c iEmp : eligibleEmp){
        if(iEmp.Count_of_Tier3_Mandatory_Certifications__c==countOfT3Trainings)
                eligibleEmp.add(iEmp);
        }
        return eligibleEmp;
        }
        return ListEmp;
        
        
    }

    public static List < Employee__c > getEmployees(string superVisorId) {

        superVisorId = '%' + superVisorId +'%';
        return [Select Id, Name__c, Certificate_Budget_Utilized__c,
                 Designation__c,Employment_Start_Date__c,Sunshine_Center_Relation_To__c
            FROM Employee__c WHERE (Ultimate_Parent__c   like : superVisorId) order by Name__c
        ];
    }

    @AuraEnabled
    public static Budget_Utilization__c getEmployeeDetail(string empId) {

       /* return [Select ID, Certification_Budget_Allocation__c, Certificate_Budget_Utilized__c
            FROM Employee__c WHERE ID =: Id.valueOf(empId) limit 1
        ]; */
        
        return [select Sunshine_Center_NameF__c,
                Allocated_Budget__c,Available_BudgetF__c,
                Utilized_Budget__c from Budget_Utilization__c
                where RelatedEmployee__c=: Id.ValueOf(empId) and Year__c=: System.Today().year() limit 1];
    }

    @AuraEnabled
    public static List < Employee_Certifications__c > GetApplaiedCertification(string empID) {

        List < Employee_Certifications__c > lstAvailableCert = new List < Employee_Certifications__c > ();
       // empID = '%' + empID +'%';

        lstAvailableCert = [select Id, Certification_Name__c, Status__c, Date_Requested__c, Related_Employee__c, Certification_Cost__c, Certification_Cost_Paid_By__c from 
                            Employee_Certifications__c where Status__c = 'Requested'
                            AND
                             (
                              Related_Employee__c=: empID)];

        return lstAvailableCert;
    }

    @AuraEnabled
    public static List < Employee_Certifications__c > GetOngoingCertification(string empID) {

        List < Employee_Certifications__c > lstApprovedCert = new List < Employee_Certifications__c > ();
        //empID = '%' + empID +'%';

        lstApprovedCert = [select Id, Certification_Name__c, Status__c, Certification_Due_Date__c, Date_Requested__c, Related_Employee__c, Approved_Denied_By__r.Name, Date_Approved_Denied__c, Certification_Cost__c, 
                    Location_of_Training__c, Type_of_Certification__c, Date_of_Training__c,Related_Employee__r.Sunshine_Center_Relation_To__r.Name,
            Certification_Cost_Paid_By__c, Certification_URL__c, Approved_Denied_Notes__c from Employee_Certifications__c
            where Status__c IN('In-Progress', 'Submitted For Completion', 'Certificate Uploaded')
            AND (Related_Employee__c= : empID)
        ];

        return lstApprovedCert;
    }

    @AuraEnabled
    public static List < Employee_Certifications__c > GetCompletedCertification(string empID) {

        List < Employee_Certifications__c > lstcompletedCert = new List < Employee_Certifications__c > ();
       // empID = '%' + empID +'%';

        lstcompletedCert = [select Id, Certification_Name__c, Status__c, Submitted_Completed_Date__c, Certification_URL__c, Reimbursement_Request_Status__c, Reimbursement_Request_Receipt_URL__c, Certification_Completed_Date__c, Certification_Cost_Paid_By__c
            from Employee_Certifications__c where Status__c IN('Completed') AND
            (Related_Employee__c= : empID)
        ];

        return lstcompletedCert;
    }

    @AuraEnabled
    public static List < Employee_Certifications__c > GetRejectedCertification(string empID) {

        List < Employee_Certifications__c > lstrejectedCert = new List < Employee_Certifications__c > ();
        //empID = '%' + empID +'%';

        lstrejectedCert = [select Id, Certification_Name__c, Status__c, Date_Approved_Denied__c,
             Approved_Denied_by__r.Name, Date_Completed_Denied__c, Completed_Denied_Noted__c,
              Approved_Denied_Notes__c,Approved_Denied_by__c from Employee_Certifications__c
               where Status__c IN('Request Denied', 'Denied') AND 
                 (Related_Employee__c= : empID)];

        return lstrejectedCert;
    }

    @AuraEnabled
    public static List < Employee_Certifications__c > GetReinbursementCertification(string empID) {

        List < Employee_Certifications__c > lstReinbursCert = new List < Employee_Certifications__c > ();
        // empID = '%' + empID +'%';
        lstReinbursCert = [select Id, Certification_Name__c, Reimbursement_Request_Status__c, Reimbursement_Request_Submit_Date__c, Reimbursement_Request_Payout_Date__c
                             from Employee_Certifications__c where Reimbursement_Request_Status__c != null 
                              AND (
                             Related_Employee__c= : empID)];

        return lstReinbursCert;
    }

    @AuraEnabled
    public static void createCertificationRequest(string empID, string certId, string paidBy, decimal paidByEmp, boolean MandatoryTier2, boolean MandatoryTier3) {
        Employee_Certifications__c css = new Employee_Certifications__c();
        Id emp = Id.valueOf(empID);
        Id cert = Id.valueOf(certId);
        
        Employee__c empObj = [Select ID, Email__c,Supervisor_Name__r.Email__c FROM Employee__c  WHERE ID = :emp];
        css.Date_Requested__c = Date.Today();
        css.Status__c = 'Requested';
        css.Type_of_Certification__c = 'Staff Requested';
        css.Related_Employee__c = emp;
        css.Related_Certification__c = cert;
        css.Certification_Cost_Paid_By__c = paidBy;
        css.Employee_Responsibility_Amount__c = paidByEmp;
        css.Employee_Email__c = empObj.Email__c;
        css.Supervisor_Email__c = empObj.Supervisor_Name__r.Email__c;
        insert css;

    }
    
    @AuraEnabled
    public static void createOtherCertificationRequest(Employee_Certifications__c css) {
        
       
       
        css.Date_Requested__c = Date.Today();
        css.Type_of_Certification__c = 'Staff Requested'; 
        Certifications__c cert=[select id,Name from Certifications__c where Name='Other'];
        css.Related_Certification__c = cert.id;
        //css.Employee_Email__c = empObj.Email__c;
        //css.Supervisor_Email__c = empObj.Supervisor_Name__r.Email__c;
        insert css;

    }

    @AuraEnabled
    public static void createMandatoryCertifications(string empList, string certList, string supervisorId, Date trainingDate, string location, string Notes,boolean MandatoryTier2, boolean MandatoryTier3) {



        List < Employee__c > lstEmp =
            (List < Employee__c > ) System.JSON.deserialize(empList, List < Employee__c > .class);
        List < Certifications__c > lstCert =
            (List < Certifications__c > ) System.JSON.deserialize(certList, List < Certifications__c > .class);

        List < Employee_Certifications__c > ECList = new List < Employee_Certifications__c > ();
        for (Certifications__c ic: lstCert) {
            for (Employee__c ie: lstEmp) {
                Employee_Certifications__c empCert = new Employee_Certifications__c();
                empCert.Approved_Denied_By__c = Id.ValueOf(supervisorId);
                empCert.Certification_Cost_Paid_By__c = 'Company';
                empCert.Date_Approved_Denied__c = Date.Today();
                empCert.Date_of_Training__c = trainingDate;
                empCert.Certification_Due_Date__c = trainingDate;
                empCert.Date_Requested__c = Date.Today();
                //empCert.Location_of_Training__c=location;
                empCert.Related_Certification__c = ic.id;
                empCert.Related_Employee__c = ie.id;
                empCert.Status__c = 'In-Progress';
                empCert.Type_of_Certification__c = 'Mandatory Training';
                empCert.Approved_Denied_Notes__c = Notes;
                 empCert.Employee_Email__c = ie.Email__c;
                empCert.Supervisor_Email__c = ie.Supervisor_Name__r.Email__c;
                ECList.add(empCert);
            }

        }
        insert ECList;
        
    }


    @AuraEnabled
    public static void updateOngoingCertifications(string EmpcertId, string updateType, string awsUrl, date certDate) {
        Employee_Certifications__c css = new Employee_Certifications__c();
        // Id emp = Id.valueOf(empID);
        Id cert = Id.valueOf(EmpcertId);
        css.Id = cert;
        if (certDate == null)
            certDate = Date.Today();
        if (updateType == 'Completed') {

            css.Status__c = 'Certificate Uploaded';
            css.Certification_URL__c = awsUrl;
            css.Certification_Completed_Date__c = certDate;
        }

        if (updateType == 'Request Reinbursement') {
            // css.Date_Submitted_for_Completions__c= Date.Today();
            // css.Status__c='Submitted For Completion';
            css.Reimbursement_Request_Status__c = 'Submitted';
            css.Reimbursement_Request_Submit_Date__c = Date.Today();
            css.Reimbursement_Request_Receipt_URL__c = awsUrl;

        }

        // css.Related_Employee__c=emp;
        //css.Related_Certification__c=cert;
        update css;

    }

    @AuraEnabled
    public static void CompleteCertification(string EmpcertId) {
        Employee_Certifications__c css = new Employee_Certifications__c();
        Id cert = Id.valueOf(EmpcertId);
        css.Id = cert;
        css.Date_Submitted_for_Completions__c = Date.Today();
        css.Status__c = 'Submitted For Completion';
        update css;

    }

    @AuraEnabled
    public static void cancelCertificationRequest(string certificationRequestID) {
        Employee_Certifications__c css = new Employee_Certifications__c();
        css = [select id from Employee_Certifications__c where id =: Id.valueOf(certificationRequestID)];
        delete css;

    }

    @AuraEnabled
    public static Boolean getEnableRequestBtn(string empID) {

        return true;
       /* AggregateResult enableBtn = [select count(id) from Employee_Certifications__c where Related_Employee__c =: Id.Valueof(empID) and Status__c IN('Requested', 'In-Progress', 'Certificate Uploaded', 'Submitted For Completion') and Type_of_Certification__c = 'Staff Requested'];
        integer count = integer.valueof(enableBtn.get('expr0'));
        system.debug('%%%%%%%%%%%55' + count);
        if (count > 0)
            return false;
        else
            return true;
            */
    }
/*
    @AuraEnabled
    public static String uploadFileToAWS(
        String strfileName, String fileType,
        String fileContent) {
        //System.debug('parentId=' + parentId);
        System.debug('strfileName=' + strfileName);
        System.debug('fileType=' + fileType);
        HttpRequest req = new HttpRequest();

        Blob base64Content = EncodingUtil.base64Decode(EncodingUtil.urlDecode(fileContent, 'UTF-8'));
        String attachmentBody = fileContent;
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String dateString = Datetime.now().format('ddMMYYYYHHmmss');
        String filename = dateString + '_' + strfileName;

        awsBucket__c bucket = new awsBucket__c();
        bucket = awsBucket__c.getInstance('FREEPU');
        //AWS specific information
        String key = bucket.accessKeyId__c; //AWS key
        String secret = bucket.secretAccessKey__c; //AWS Secret key
        String bucketname = bucket.Bucket__c; //AWS bucket name
        String host = 's3.amazonaws.com'; //'s3.amazonaws.com:443'

        String method = 'PUT';
        String endPoint = 'https://' + bucketname + '.' + host + '/' + filename;

        req.setMethod(method);
        req.setEndpoint(endPoint);

        system.debug('Endpoint=' + endPoint);
        //create header information
        req.setHeader('Host', bucketname + '.' + host);
        req.setHeader('Access-Control-Allow-Origin', '*');
        req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
        req.setHeader('Content-Encoding', 'UTF-8');
        req.setHeader('Content-type', fileType);
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Date', formattedDateString);
        req.setHeader('ACL', 'public-read');
        //store file as blob       
        req.setBodyAsBlob(base64Content);

        //prepare for signing information
        String stringToSign = 'PUT\n\n' +
            fileType + '\n' +
            formattedDateString + '\n' + '/' + bucketname + '/' + filename;

        String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
        Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign), blob.valueof(secret));
        String signedKey = EncodingUtil.base64Encode(mac);

        //assign Authorization information
        String authHeader = 'AWS' + ' ' + key + ':' + signedKey;
        req.setHeader('Authorization', authHeader);

        //finally send information to AWS        
        Http http = new Http();
        HTTPResponse res = http.send(req);

        System.debug('*Resp:' + String.ValueOF(res.getBody()));
        System.debug('RESPONSE STRING: ' + res.toString());
        System.debug('RESPONSE STATUS: ' + res.getStatus());
        System.debug('STATUS_CODE: ' + res.getStatusCode());

        if (res.getStatusCode() == 200) {
            // insertAttachmentRecord (parentId,strfileName,endPoint);
            return endpoint;
        }
        return '';
    }
    */
    @AuraEnabled
    public static boolean isStaff(string empID) {

        Employee__c objUser = [Select ID, User_Role__c, IsSupervisor__c FROM Employee__c
            WHERE ID =: Id.valueOf(empID) LIMIT 1
        ];
        if (objUser.User_Role__c == 'Supervisor') {
            return true;
        }
        return false;
    }
    
     @AuraEnabled
    public static Employee__c empInfo(string empID) {

        Employee__c objUser = [Select ID, User_Role__c, IsSupervisor__c,email__c,Supervisor_Name__r.email__c FROM Employee__c
            WHERE ID =: Id.valueOf(empID) LIMIT 1
        ];
        return objUser;
    }

    @AuraEnabled
    public static List < Employee__c > getEmployeeList(string supervisorId) {
        supervisorId = '%' + supervisorId +'%';
        List < Employee__c > lstEmp = [select id, Name__c, Supervisor_Name__r.Email__c,Designation__c, User_Role__c,Tier_Allocation__c,
            email__c, Certificate_Pending_Approval__c,Certificate_Budget_Utilized__c,Certification_Budget_Allocation__c,
            Finished_Certificates__c, In_Progress__c,
            Total_Requested_Certification__c, Pending_Reimbursement_Requests__c
            FROM Employee__c WHERE Ultimate_Parent__c like:
            superVisorId
        ];
        return lstEmp;


    }
    
    
    @AuraEnabled
    public static Budget_Utilization__c getBudgetDetail(string empId) {

        return [select id, Allocated_Budget__c,Available_BudgetF__c,Utilized_Budget__c,Year__c,RelatedEmployee__c from 
                Budget_Utilization__c where RelatedEmployee__c=:Id.ValueOf(empId) and Year__c=:System.Today().year()
                  limit 1  ];
    }
    
        @AuraEnabled
    public static Employee__c getEmployeeProfileInfo(string empId) {

        return [select id,Sunshine_Center_Access__c,Name__c,Designation__c,Sunshine_Center_Relation_To__r.Name,Tier_Allocation__c,email__c,phone__c,
        Supervisor_Name__r.Name__c,Employee_Biography__c,Tabs_Access__c from 
                Employee__c where id=:Id.ValueOf(empId) 
                  limit 1  ];
    }


    @AuraEnabled
    public static EmployeeCertificationWrapper getCertificationRequests(string superVisorId){
        
        supervisorId = '%' + supervisorId +'%';
            
        List<Employee_Certifications__c> lstEmpCert = [select ID ,Certification_Name__c,Certification_Cost__c, Approved_Denied_Notes__c,Completed_Denied_Noted__c,Related_Certification__r.Certification_Cost__c,
                                    Available_Employee_Budget__c,Related_Employee__r.Name ,Related_Employee__r.Certificate_Budget_Utilized__c,Certification_URL__c,Approved_Denied_By__c,Completed_Denied_By__c,
                                    Related_Certification__r.Name ,Date_Approved_Denied__c,Date_Completed_Denied__c,Date_Requested__c,Certification_Cost_Paid_By__c,
                                    Status__c , Related_Employee__r.Tier_Allocation__c,Certification_Completed_Date__c,Reimbursement_Request_Status__c,Employee_Responsibility_Amount__c,Eligible_Reimbursement_Amount__c
                                    FROM Employee_Certifications__c 
                                    WHERE Related_Employee__r.Ultimate_Parent__c like: superVisorId
                                    AND Status__c IN ('Requested','Submitted For Completion','Completed') ];
        
        EmployeeCertificationWrapper empTier = new EmployeeCertificationWrapper(lstEmpCert);
        return empTier;
    }

 @AuraEnabled
    public static EmployeeCertificationWrapper getCompletedCertificationRequests(string superVisorId){
        
         supervisorId = '%' + supervisorId +'%';   
        List<Employee_Certifications__c> lstEmpCert = [select ID , 
                                    Related_Employee__r.Name ,Certification_URL__c,
                                    Related_Certification__r.Name ,
                                    Status__c , Related_Employee__r.Tier_Allocation__c
                                    FROM Employee_Certifications__c 
                                    WHERE Related_Employee__r.Ultimate_Parent__c like: superVisorId
                                    AND Status__c = 'Submitted For Completion'];
        
        EmployeeCertificationWrapper empTier = new EmployeeCertificationWrapper(lstEmpCert);
        return empTier;
    }

    @AuraEnabled
    public static void approveCertification(List<Employee_Certifications__c> approveLst,string SupervisorId){
        
        for(Employee_Certifications__c  approvRecord : approveLst){

            if(approvRecord.Status__c == 'Completed' && approvRecord.Reimbursement_Request_Status__c=='Submitted' ){
             approvRecord.Reimbursement_Request_Status__c = 'Approved';     
             approvRecord.Reimbursement_Request_Approved_Denied_by__c=Id.ValueOf(SupervisorId);
             approvRecord.Reimbursement_Request_Approved_Denied__c = Date.Today();
            }
           
            if(approvRecord.Status__c == 'Requested'){
                approvRecord.Status__c = 'In-Progress';
                approvRecord.Approved_Denied_By__c=Id.ValueOf(SupervisorId);
                approvRecord.Date_Approved_Denied__c=Date.Today();
                continue;
            }
            if(approvRecord.Status__c == 'Submitted For Completion'){
                approvRecord.Status__c = 'Completed';
                approvRecord.Approved_Denied_By__c=Id.ValueOf(SupervisorId);
                approvRecord.Date_Approved_Denied__c=Date.Today();
                continue;
            }            
        }
        update approveLst;   
    }

    @AuraEnabled
    public static void rejectCertification(List<Employee_Certifications__c> rejectLst, string SupervisorId){
        
        
        for(Employee_Certifications__c  rejectRec : rejectLst){

          if(rejectRec.Status__c == 'Completed' && rejectRec.Reimbursement_Request_Status__c=='Submitted' ){
            rejectRec.Reimbursement_Request_Status__c = 'Denied';     
             rejectRec.Reimbursement_Request_Approved_Denied_by__c=Id.ValueOf(SupervisorId);
             rejectRec.Reimbursement_Request_Approved_Denied__c = Date.Today();
            }
     
            if(rejectRec.Status__c == 'Submitted For Completion'){   
            rejectRec.Status__c = 'In-Progress';
            rejectRec.Approved_Denied_By__c=Id.ValueOf(SupervisorId);
            rejectRec.Date_Approved_Denied__c=Date.Today();
            
            }
            if(rejectRec.Status__c == 'Requested'){
            rejectRec.Status__c = 'Request Denied';  
            rejectRec.Approved_Denied_By__c=Id.ValueOf(SupervisorId);
            rejectRec.Date_Approved_Denied__c=Date.Today();    
            }
            
            
        }
        update rejectLst;   
    }
    
    @AuraEnabled
    public static void updateEmployee(Employee__c selectedEmpObj){

        update selectedEmpObj;
    }
    
    @AuraEnabled
    public static void updateEmployeeList(List<Employee__c> selectedEmpObj){

        update selectedEmpObj;
    }
    
    
    @AuraEnabled
    public static Employee__c  Login(string Username, 
                                    string Password,
                                    string IpAddress){
    
        List<Employee__c> lstEmp = new List<Employee__c>();
        lstEmp = [select id,isActive__c,Username__c,Password__c,IsSupervisor__c,User_Role__c,Tier_Allocation__c from Employee__c 
                 where Username__c=:Username and Password__c=:Password];
        
        if(lstEmp.isEmpty()){
            return null;
        }
        createLoginHistory(IpAddress,lstEmp[0].Id);
        return lstEmp[0];
    } 
    
    private static void createLoginHistory(string IpAddress,string empId){

        Employee_Login_History__c emp = new Employee_Login_History__c();
        Map<string,string> clientDetail = (Map<string,string>)System.JSON.deserialize(IpAddress, Map<string,string>.class);
        emp.Employee__c = empId;
        emp.Ip_Address__c = clientDetail.get('ip');
        emp.Client_Detail_JSON__c = IpAddress;
        emp.Coordinates__c = clientDetail.get('loc');
        emp.Country__c = clientDetail.get('country');
        emp.City__c = clientDetail.get('city');
        insert emp;
    }
    
     
    @AuraEnabled
    public static boolean SendResetPasswordEmail(string Username){

    List<String> EmailIds = new List<string>();
    List<Employee__c> lstEmp = [Select Id from Employee__c
                                where username__c =: Username];
    if(lstEmp.isEmpty()){
        return false;
    }
    Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
    OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where Address = 'contact.admissions@sunshinebh.com' limit 1];
    EmailIds.add(username);
    emailMessage.setToAddresses( EmailIds  );
    string url = URL.getSalesforceBaseUrl().toExternalForm()+'/ccp/s/certificationportallogin/forgotpassword?Id='+lstEmp[0].Id;
     emailMessage.setHtmlBody('To reset the password of your Clinical Certification Portal, Please click :'+
                                  '<p><b><a href="'+url+'">here</a></b></p>');
      emailMessage.setSubject('New Alumni Recovery Group Meeting Request');
      
    emailMessage.setOrgWideEmailAddressId(owa.id);
    emailMessage.saveAsActivity = false;
    // email.setWhatId(aRecordId);
    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
    return true;
    
    }  
    
    @AuraEnabled
    public static boolean ResetPassword(string password,string RecordId){

        try{
            Employee__c emp = new Employee__c();
            emp.Id = RecordId;
            emp.password__c = password;
            update emp;
            return true;
        }
        catch(Exception ex){
            return false;
        }
        
    }

    public class EmployeeCertificationWrapper{

        @AuraEnabled
        public List<Employee_Certifications__c> lstNewCert {get;set;}
        @AuraEnabled
        public List<Employee_Certifications__c> lstCompletedCert {get;set;}
        
        @AuraEnabled
        public List<Employee_Certifications__c> lstReimbursementCert {get;set;}
        
        public EmployeeCertificationWrapper(List<Employee_Certifications__c> lstEmpCert){

            lstNewCert = new List<Employee_Certifications__c>();
            lstCompletedCert = new List<Employee_Certifications__c>();
            lstReimbursementCert = new List<Employee_Certifications__c>();

            for(Employee_Certifications__c iEmp : lstEmpCert){
                switch on iEmp.Status__c {
                    when 'Requested' {
                        lstNewCert.add(iEmp);
                    }
                    when 'Submitted For Completion' {
                        lstCompletedCert.add(iEmp);
                    }
                    when 'Completed' {
                    if(iEmp.Reimbursement_Request_Status__c=='Submitted'){
                    lstReimbursementCert.add(iEmp);
                    }
                    }
                    
                    
                }
                
                
            }
        }
    }
}