/*
    controller class for txdc_mastertreatmentplan vf component. Master Treatment Plan is a record type of 
    tx and dc plans object.
    @author: Huma Zafar
    TestClass : txdc_mastertreatmentplanTest
*/
public class txdc_mastertreatmentplan {

    public Tx_and_D_C_Plans__c txdc {
        get;
        set;
    }
    list < Master_Problem__c > lstMP{
        get;
        set;
    }
    public boolean showAddProblems {
        get;
        set;
    }
    public boolean EditPage {
        get;
        set;
    }

    public boolean IsClosed {

        get;
        set;
    }
    public Id selectedMP {
        get;
        set {
            selectedMP = value;
        }
    }
    public Id selObjective {
        get;
        set {
            selObjective = value;
        }
    }
    public Id selTask {
        get;
        set {
            selTask = value;
        }
    }

    //hidden field
    public string SelectedSignedOption {
        get;
        set;
    }
    public string ImageUrlAddress {
        get;
        set;
    }


    public boolean callJS {

        get;
        set;
    }

    String name;



    public list < MasterProblemAndObjectives > lstMasterProblems {
        get;
        set;
    }
    public Map < Id, List < TaskObj >> mapObjectiveTasks {
        get;
        set;
    }
    public Map < Integer, String > mapDigitsWords = new Map < Integer, String > ();
    public Map < String,Integer > mapWordsDigit = new Map < String, Integer > ();

    id txdcId;
    integer problemcount;

    public string RecordType {
        get;
        set;
    }

    //AWS
    public string accessKeyId {
        get;
        set;
    }
    public string secretAccessKey {
        get;
        set;
    }
    public string OrgName {
        get;
        set;
    }
    final string AWSURL;

    public User userObj{
    
        get;
        set;
    }
    
    public ID TargetID{
        
        get;
        set;
    }
    
    public Integer TargetIndex{
        
        get;
        set;
    }
    
    public Integer ObjectiveIndex{
        
        get;
        set;
    }
    
    public Integer MasterProblemIndex{
        
        get;
        set;
    }

    public txdc_mastertreatmentplan() {

        //System.debug('In Constructor...');
        showAddProblems = false;
    //    txdcId = ApexPages.CurrentPage().getParameters().get('rId');
        id clientChartId = ApexPages.CurrentPage().getParameters().get('id');

        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;

        callJS = false;

        name = [Select id, name from user where id =: userinfo.getUserID()].name;

        txdc = [select id, Dimension_1__c, Dimension_2__c, Dimension_3__c, Dimension_4__c, Dimension_5__c, Dimension_6__c, Client_Chart__c, Client_Chart__r.Name, RecordType.Name,
            Notes__c, Client_Strengths__c, Client_Weaknesses__c, I_am_here_because__c, My_plans_after_discharge_are__c, Status__c, Date_Time__c, Estimated_Length_of_Stay__c,
            Client_Image_Url__c, Client_Signed_User__c, Client_Closed_Date__c, SignedBy__c, Staff_Signature_URL__c, Staff_Signed_User__c, Staff_Closed_Date__c,
            Client_Chart__r.Treatment_Center__r.Name, Client_Image_Url_Closed__c, Staff_Signature_URL_Closed__c,
            Staff_Active_Date__c, Client_Active_Date__c, Client_Signed_User_Closed__c, Staff_Signed_User_Closed__c, Intern_Signature_URL__c, Intern_Closed_Date__c,
            Intern_Signed_User__c,Discharge_Criteria__c ,
            Name_of_Primary_Therapist2__c from Tx_and_D_C_Plans__c where Client_Chart__c =: clientChartId and RecordType.Name = 'Master Treatment Plan' limit 1
        ];

        txdcId = txdc.id;
        EditPage = false;

        RecordType = txdc.RecordType.Name;

        userObj = [Select id, name, title, User_Role__c from user where id =: userinfo.getUserID()];

        if (txdc.Status__c == '' || txdc.Status__c == 'Open') {

            txdc.Status__c = 'Open';
            txdc.SignedBy__c = 'None';
        }
       mapDigitsWords = Constants.LoadDigitsWords();
        loadDetoxMasterPrbAndObjectives();

        problemcount = lstMasterProblems.size();
        

        IsClosed = checkTargetClosed();
    }

    public void EditFullPage() {
        EditPage = true;
    }
    //Make the page readOnly
    public void ReadOnlyPage() {

        EditPage = false;
    }
    
   

    void loadDetoxMasterPrbAndObjectives() {

        lstMasterProblems = new list < MasterProblemAndObjectives > ();
        mapObjectiveTasks = new map < Id, List < TaskObj >> ();

        lstMP = [select id, As_Evidence_By__c, Goal_Plan__c, Problem__c, Problem_Description__c,
            Tx_and_D_C_Plans__c  from Master_Problem__c where Tx_and_D_C_Plans__c =: txdcId order by CreatedDate asc
        ];
        
        system.debug('$$$$test' + lstMP.size());
        
        Set<ID> SetOfMainProblem  = new Set<ID>();
        
        for(Master_Problem__c iMP : lstMP)
            SetOfMainProblem.add(iMP.ID);
        
        Map<ID, List<Detox_Objectives__c>> iMapOfDetoxObj = new  Map<ID, List<Detox_Objectives__c>>();
        
        for(Detox_Objectives__c iObj : [Select ID,Name, Objective_Description_Long__c, Intervention__c, Staff_Responsible__c,
                Tx_and_D_C_Plans__c, Objective__c, Master_Problem__c From Detox_Objectives__c where Master_Problem__c in : SetOfMainProblem order by CreatedDate]){
        
            if(iMapOfDetoxObj.containsKey(iObj.Master_Problem__c))
                iMapOfDetoxObj.get(iObj.Master_Problem__c).add(iObj);
            else
            
                iMapOfDetoxObj.put(iObj.Master_Problem__c , new List<Detox_Objectives__c> {  iObj });
            
                    
        }

        MasterProblemAndObjectives wrapMP;
        Objectives wrapObj;
        list < Objectives > lstDO = new list < Objectives > ();

        integer counter = 0;
        integer innercounter = 0;
        for (Master_Problem__c MP: lstMP) {
            if (iMapOfDetoxObj.containsKey(MP.ID)) {
                for (Detox_Objectives__c D: iMapOfDetoxObj.get(MP.ID)) {
                    lstDO.add(new Objectives(D, innercounter,false));
                    mapObjectiveTasks.put(D.id, new List < TaskObj > ());
                    innercounter++;
                }

              
            }
            wrapMP = new MasterProblemAndObjectives(MP, lstDO, counter,false);
            lstMasterProblems.add(wrapMP);
            
            lstDO = new list < Objectives > ();
            counter++;
            innercounter = 0;

        }

        LoadObjectivesTasks();
        system.debug('&&&&&lstMasterProblems '+ lstMasterProblems.size());
        if (lstMasterProblems.size() == 0) {
        
        Master_Problem__c mp = new Master_Problem__c();
        mp.Tx_and_D_C_Plans__c = txdcId;
        mp.Problem__c = 'Problem ' + mapDigitsWords.get(1);
         lstMP.add(mp);

            wrapMP = new MasterProblemAndObjectives(mp, lstDO, counter,false);
            lstMasterProblems.add(wrapMP);
        }

        ProblemCount = lstMP.size();
    }

    public PageReference submitFunc() {

        try {
            showAddProblems = false;
            System.debug('submit button method');
            upsert txdc;

            list < Master_Problem__c > lstMP = new list < Master_Problem__c > ();
            map < Id, Master_Problem__c > mapMP = new map < Id, Master_Problem__c > ();
            list < Detox_Objectives__c > lstDO = new list < Detox_Objectives__c > ();

            for (MasterProblemAndObjectives wrapMP: lstMasterProblems) {
                lstMP.add(wrapMP.MP);
                if (!mapMP.containsKey(wrapMP.MP.Id)) {
                    mapMP.put(wrapMP.MP.id, wrapMP.MP);
                }

                for (Objectives ob: wrapMP.lstObjectives) {
                    lstDO.add(ob.Obj);
                }
            }
            /*if(lstMP.size()>0)
                upsert lstMP; */
            if (mapMP.size() > 0)
                upsert mapMP.values();

            System.debug('lstDO:::' + lstDO);
            if (lstDO.size() > 0)
                upsert lstDO;
            EditPage = false;

            map < Id, Task > mapObjTasks = new map < Id, Task > ();
            if (mapObjectiveTasks.size() > 0) {
                for (Id mId: mapObjectiveTasks.keySet()) {
                    List < TaskObj > lstTaskDetail = mapObjectiveTasks.get(selObjective);
                    for (TaskObj iTskObj: lstTaskDetail) {
                        if (!mapObjTasks.containsKey(iTskObj.task.Id)) {
                            mapObjTasks.put(iTskObj.task.Id, iTskObj.task);
                        }
                    }
                }
            }

            if (mapObjTasks.size() > 0) {
                update mapObjTasks.values();
            }

            //PageReference retURL = new PageReference('/apex/TestSignature?rId=' + txdcId);
            //retURL.setRedirect(true);
            //return retURL;
            return null;
        } catch (exception e) {
            return null;
        }
    }

    boolean checkTargetClosed() {


        for (string key: mapObjectiveTasks.keySet()) {

            for (TaskObj iTk: mapObjectiveTasks.get(key)) {

                if (iTk.task.Status == 'Open')
                    return false;
            }
        }

        return true;

    }
    
     public void EditTarget() {
    
        
        TaskObj tk = mapObjectiveTasks.get(TargetID).get(TargetIndex);
        tk.isEdit = true;
    } 
    
    public void EditProblem(){
        
         MasterProblemAndObjectives wrapMP = lstMasterProblems.get(MasterProblemIndex);
         wrapMP.isEdit = true;
    }
    
    public void SaveProblem(){
        
         MasterProblemAndObjectives wrapMP = lstMasterProblems.get(MasterProblemIndex);
        
         upsert wrapMP.MP;
         wrapMP.isEdit = false;
    }
    
    public void DeleteProblem(){
        
         MasterProblemAndObjectives wrapMP = lstMasterProblems.get(MasterProblemIndex);
         List<Detox_Objectives__c> lstDetoxObj = new List<Detox_Objectives__c>();
         
         for(Objectives iobj :  lstMasterProblems.get(MasterProblemIndex).lstObjectives)
             lstDetoxObj.add(iobj.Obj);
        
        delete  lstDetoxObj;
        
        if(wrapMP.MP.ID != NULL)
             delete wrapMP.MP;
        
        lstMasterProblems.remove(MasterProblemIndex);
        
        problemcount = lstMasterProblems.size();
        mapDigitsWords = Constants.LoadDigitsWords();
        
                 
    }
    
    
    
    
    public void Edit() {
        
         Objectives obj = lstMasterProblems.get(MasterProblemIndex).lstObjectives.get(ObjectiveIndex);    
         obj.IsEdit = true;

    }
    
    public void SaveObjective(){
        
        Objectives obj = lstMasterProblems.get(MasterProblemIndex).lstObjectives.get(ObjectiveIndex);  
        obj .isEdit = false;
        update obj.Obj;
    }

    public PageReference ActiveTXDxPlans() {

        callJs = false;
        //if active then it will go for close after complete signature
        
        if(txdc.Client_Closed_Date__c != null &&   txdc.Status__c == 'Review Pending') txdc.Status__c = 'In Use';
        if (txdc.Status__c == 'In Use') {

            if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == null) {

                txdc.Staff_Signature_URL_Closed__c = AWSURL + ImageUrlAddress;
                txdc.Staff_Signed_User_Closed__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
                txdc.Staff_Closed_Date__c = DateTime.Now();
                txdc.SignedBy__c = 'Staff';
            } else if (SelectedSignedOption == 'Patient') {

                txdc.Client_Image_Url_Closed__c = AWSURL + ImageUrlAddress;
                txdc.Client_Signed_User_Closed__c = '(Patient) ' + txdc.Client_Chart__r.Name;
                txdc.Client_Closed_Date__c = DateTime.Now();
                txdc.SignedBy__c = 'Client';
            } else if (userObj.User_Role__c != null) {

                txdc.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
                txdc.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
                txdc.Intern_Closed_Date__c = DateTime.Now();
                txdc.SignedBy__c = 'Client';
                txdc.Status__c = 'Review Pending';
            }

            /*if ((txdc.Staff_Signed_User_Closed__c != null || String.isNotBlank(txdc.Staff_Signed_User_Closed__c)) && (txdc.Client_Signed_User_Closed__c != null || String.isNotBlank(txdc.Client_Signed_User_Closed__c))) {
                txdc.Status__c = 'Closed';
                txdc.SignedBy__c = 'All'; // signing is complete


            }*/
            
            //only staff signature is required tkt # 302
            if ((txdc.Staff_Signed_User_Closed__c != null || String.isNotBlank(txdc.Staff_Signed_User_Closed__c))) {
                txdc.Status__c = 'Closed';
                txdc.SignedBy__c = 'All'; // signing is complete


            }

               if(txdc.Status__c == 'In Use' ){
                callJS = true;
            }

            update txdc;
            return null;


        }

        if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == null) {


            txdc.Staff_Signature_URL__c = AWSURL + ImageUrlAddress;
            txdc.Staff_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            txdc.Staff_Active_Date__c = DateTime.Now();
            txdc.SignedBy__c = 'Staff';
        } else if (SelectedSignedOption == 'Patient') {

            txdc.Client_Image_Url__c = AWSURL + ImageUrlAddress;
            txdc.Client_Signed_User__c = '(Patient) ' + txdc.Client_Chart__r.Name;
            txdc.Client_Active_Date__c = DateTime.Now();
            txdc.SignedBy__c = 'Client';
        } else if (userObj.User_Role__c != null) {

            txdc.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
            txdc.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
            txdc.Intern_Closed_Date__c = DateTime.Now();
            txdc.SignedBy__c = 'Client';
            txdc.Status__c = 'Review Pending';
        }

        if ((txdc.Staff_Signed_User__c != null || String.isNotBlank(txdc.Staff_Signed_User__c)) && (txdc.Client_Signed_User__c != null || String.isNotBlank(txdc.Client_Signed_User__c))) {
            txdc.Status__c = 'In Use';
            txdc.SignedBy__c = 'Client'; // to sign in again for just client by ticket number # 302


        }

        if(txdc.Status__c == 'Open'){
            callJS = true;
        }

        update txdc;
        return null;
    }

    public void AddMoreProblems() {
        
        system.debug('$$$$$$ ' +lstMasterProblems.size() );
        showAddProblems = true;
        if(lstMasterProblems.size()>0){
            if(lstMasterProblems.get(0).mp.Id == null){
                insert lstMasterProblems.get(0).mp;
            }
            mapWordsDigit = Constants.LoadWordsDigit();
            integer probNo= lstMasterProblems.size();
             system.debug('$$$$$problem' + probNo);
            ProblemCount=probNo + 1;
        }
        else
        ProblemCount++;
        
        
        Master_Problem__c mp = new Master_Problem__c();
        mp.Tx_and_D_C_Plans__c = txdcId;
        mp.Problem__c = 'Problem ' + mapDigitsWords.get(ProblemCount);
         system.debug('$$$$$problem' + ProblemCount);
        system.debug('$$$$$problem' +  mp.Problem__c);
        lstMP.add(mp);
        insert mp;
        list < Objectives > lsto = new list < Objectives > ();
        Detox_Objectives__c do_instance = new Detox_Objectives__c();
        do_instance.Master_Problem__c = mp.id;
        Objectives ob = new Objectives(do_instance, 0,true);
        lsto.add(ob);
        insert do_instance;
        mapObjectiveTasks.put(do_instance.id, new List < TaskObj > ());
        MasterProblemAndObjectives wrapMP = new MasterProblemAndObjectives(mp, lsto, 0, true);
        lstMasterProblems.add(wrapMP);

    }

    public void DeleteObjective() {

        Detox_Objectives__c do_instance = new Detox_Objectives__c();
        do_instance.Id = selObjective;
        Delete do_instance;
        loadDetoxMasterPrbAndObjectives();
    }

    public void AddMoreObjectives() {

        Detox_Objectives__c do_instance = new Detox_Objectives__c();
        do_instance.Master_Problem__c = selectedMP;
        insert do_instance;

        Objectives ob = new Objectives(do_instance, 0,true);
        for (MasterProblemAndObjectives mpo: lstMasterProblems) {

            if (mpo.MP.Id == selectedMP) {
                mpo.lstObjectives.add(ob);
                mapObjectiveTasks.put(do_instance.Id, new List < TaskObj > ());
                break;
            }
        }
    }

    public void AddTargets() {
        Task objTask = new Task();
        objTask.RecordTypeId = Constants.TaskTxDcPlansRecordTypeId;
        objTask.whatId = selObjective;
        objTask.Status = 'Open';
        //objTask.Created_By_Alias__c = name.substring(0, 1) + name.split(' ')[1].substring(0, 1).touppercase();
        insert objTask;
        objTask = [Select ID, whatId,ActivityDate ,Status,Description ,Closed_By__c, End_Date__c  , CreatedDate , Created_By_Alias__c from task where ID =: objTask.ID];
        
        // add task in map
        if (mapObjectiveTasks.containsKey(objTask.WhatId))
            mapObjectiveTasks.get(objTask.WhatId).add( new TaskObj(objTask , true));
        else
            mapObjectiveTasks.put(objTask.WhatId, new List <TaskObj> {
                new TaskObj(objTask ,true)
            });
      
    }



    public void DeleteTarget() {
        Task objTask = new Task();
        objTask.Id = selTask;
        delete objTask;
        LoadObjectivesTasks();
         IsClosed = checkTargetClosed();
    }

    public void LoadObjectivesTasks() {

        List < TaskObj > lstTskObj;

        for (Id mapTask: mapObjectiveTasks.keySet()) {

            mapObjectiveTasks.put(mapTask, new List < TaskObj > ());
        }
        List < Task > lastTasks = [Select Id, ActivityDate, Description, Status, whatId, End_Date__c, Created_By_Alias__c,
            CreatedDate, Closed_By__c
            From Task
            WHERE RecordTypeId =: Constants.TaskTxDcPlansRecordTypeId
        ];

        for (Task t: lastTasks) {
            if (mapObjectiveTasks.containsKey(t.WhatId)) {
                lstTskObj = mapObjectiveTasks.get(t.WhatId);
                lstTskObj.add(new taskObj(t,false));
                mapObjectiveTasks.put(t.WhatId, lstTskObj);
            }
        }
    }

    public class MasterProblemAndObjectives {

        public Master_Problem__c MP {
            get;
            set;
        }
        public list < Objectives > lstObjectives {
            get;
            set;
        }
        public integer index {
            get;
            set;
        }
        
        public boolean isEdit {
            get;
            set;
        }

        public MasterProblemAndObjectives(Master_Problem__c mprb, list < Objectives > lstobj, integer i , boolean aEdit) {

            MP = mprb;
            lstObjectives = lstobj;
            index = i;
            isEdit = aEdit;
        }
    }

    public class Objectives {
        public integer index {
            get;
            set;
        }
        
        public boolean isEdit {
            get;
            set;
        }
        
        public Detox_Objectives__c Obj {
            get;
            set;
        }

        public Objectives(Detox_Objectives__c o, integer i , boolean aEdit) {
            Obj = o;
            index = i;
            isEdit = aEdit;
        }

    }
    
    public class TaskObj{
        
        public Task task {get;set;}
        public boolean isEdit {get ;set;}
        
        public TaskObj(Task aTask, boolean aEdit){
            
            task = aTask;
            isEdit = aEdit;
        }
    }

    public void SaveTargets() {

        TaskObj tk = mapObjectiveTasks.get(TargetID).get(TargetIndex);
        tk.isEdit = false;
      
        if (tk.task.Status != 'Open') {
            tk.task.Closed_By__c = name.substring(0, 1) + name.split(' ')[1].substring(0, 1).touppercase();
            tk.task.End_Date__c = Date.Today();
           
        }
            
       update tk.task;
     
       IsClosed = checkTargetClosed();

    }
}