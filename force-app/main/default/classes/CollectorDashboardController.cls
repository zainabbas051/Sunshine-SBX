public class CollectorDashboardController {

    public List<CollectorLineItem> Collectors {get; set;}
    public List<Insurance_Collector_Round_Robin_User__c> UserIds {get; set;}
    public CollectorLineItem NewCollectorItem {get; set;}

    public CollectorDashboardController() {
        LoadUsers();
    }

    private void LoadUsers() {
        UserIds = [select Last_Assigned_To__c, User_Id__c from Insurance_Collector_Round_Robin_User__c];

        set<id> setUserIds = new set<id>();
        for (Insurance_Collector_Round_Robin_User__c user : UserIds) {
            setUserIds.add(user.User_Id__c);
        }
        map<id, User> mapUsers = new map<id, User>([select id, Name, Collector_Holder__c from User where id in: setUserIds]);

        Collectors = new List<CollectorLineItem>();
        CollectorLineItem temp;
        for (Integer i = 0; i < UserIds.size(); i++) {
            Insurance_Collector_Round_Robin_User__c user = UserIds.get(i);
            string userId =  user.User_Id__c;
            temp = new CollectorLineItem(i, user, mapUsers.get(userId));
            Collectors.add(temp);
        }
    }

    public PageReference DeleteCollectorItem() {
        if (Collectors.size() == 1) {
            showError(ApexPages.Severity.Error, 'You can not delete the last collector');
            return null;
        }
        string itemPositionToDelete = system.CurrentPageReference().getParameters().get('itemPositionToDelete');
        Integer index = Integer.valueOf(itemPositionToDelete);
        CollectorLineItem itemToDelete = Collectors.get(index);
        if (itemToDelete.IsNewCollectorItem) {
            Collectors.remove(index);
            NewCollectorItem = null;
        } else {

            if (itemToDelete.Collector.Last_Assigned_To__c) {
                Integer nextAssignToIndex = Collectors.size() <= index + 1 ? 0 : index + 1;
                CollectorLineItem nextAssignToItem = Collectors.get(nextAssignToIndex);
                nextAssignToItem.Collector.Last_Assigned_To__c = true;
                update nextAssignToItem.Collector;
            }

            delete itemToDelete.Collector;
        }
        LoadUsers();
        return null;
    }

    public void MakeNewCollectorItem() {
        if (NewCollectorItem != null) return;
        Integer index = Collectors.size();
        NewCollectorItem = new CollectorLineItem(index);
        NewCollectorItem.IsNewCollectorItem = true;
        Collectors.add(NewCollectorItem);
    }

    public void SaveNewCollectorItem() {
        if (NewCollectorItem == null) return;

        Insurance_Collector_Round_Robin_User__c newCollector = new Insurance_Collector_Round_Robin_User__c();
        id pickedUserId = NewCollectorItem.User.Collector_Holder__c;
        User user = [select id, Name from User where id = : pickedUserId];
        newCollector.User_Id__c = pickedUserId;
        newCollector.Name = user.Name;
        newCollector.Last_Assigned_To__c = Collectors.size() == 1;
        upsert newCollector;
        NewCollectorItem = null;
        LoadUsers();
    }

    private boolean showError(ApexPages.Severity severity, String error) {
        ApexPages.addMessage(new ApexPages.Message(severity, error));
        return false;
    }

    public class CollectorLineItem {
        public Boolean IsNewCollectorItem {get; private set;}
        public Integer ItemPosition {get; private set;}
        public Insurance_Collector_Round_Robin_User__c Collector {get; private set;}
        public User User {get; private set;}

        public CollectorLineItem(Integer itemPosition) {
            this.IsNewCollectorItem = true;
            this.ItemPosition = itemPosition;
            this.User = new User();
        }

        public CollectorLineItem(Integer itemPosition, Insurance_Collector_Round_Robin_User__c collector, User user) {
            this.ItemPosition = itemPosition;
            this.IsNewCollectorItem = false;
            this.Collector = collector;
            this.User = user;
        }
    }
}