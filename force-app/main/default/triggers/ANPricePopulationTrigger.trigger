trigger ANPricePopulationTrigger on Lead (before Insert, before Update){
    
    /*Integer Executive_Treatment = 300;
    Integer Luxury_Rehab_Centers = 300;
    Integer Rehab_for_Men = 200;
    Integer Rehab_for_Women = 200;
    Integer Mature_Adult_Rehabs = 200;
    Integer Young_Adult_Rehabs = 200;
    Integer Teen_Adolescent_Rehabs = 200;
    Integer LGBT_Friendly_Rehabs = 200;
    Integer X12_Step_Based_Treatment_Centers = 200;
    Integer Non_12_Step_Rehab_Centers = 200;
    Integer Faith_Based_Rehab_Centers = 200;
    Integer Holistic_Addiction_Rehab_Centers = 200;
    Integer Dual_Diagnosis_Rehab_Centers = 200;
    Integer Rehabs_on_the_Ocean = 200;
    Integer Lake_Front_Addiction_Centers = 200;
    Integer Mountain_Lodge_Recovery_Centers = 200;
    Integer Wilderness_Camps = 200;
    Integer Residential_Addiction_Rehabs = 200;
    Integer On_Site_Detox = 200;
    Integer Rehabs_with_Aftercare_Programs = 200;
    Integer Rehabs_with_One_on_One_Counseling = 200;
    Integer Insurance_Friendly_Rehabs = 300;
    Integer Private_Pay_Rehab_Centers = 300;
    Integer Financing_Available = 200;
    Integer Scholarships_Available = 200;
    Integer Alcohol_Rehab_Centers = 300;
    Integer Prescriptions_Drug_Rehabs = 300;
    Integer Opiate_Addiction_Centers = 200;
    Integer Crystal_Meth_Rehab_Centers = 100;
    Integer Heroin_Rehab_Centers = 100;
    Integer Marijuana_Rehab_Centers = 100;
    Integer Alabama = 100;
    Integer Alaska = 100;
    Integer Arizona = 100;
    Integer Arkansas = 100;
    Integer California = 100;
    Integer Colorado = 100;
    Integer Connecticut = 100;
    Integer Delaware = 100;
    Integer Florida = 100;
    Integer Georgia = 100;
    Integer Hawaii = 100;
    Integer Idaho = 100;
    Integer Illinois = 100;
    Integer Indiana = 100;
    Integer Iowa = 100;
    Integer Kansas = 100;
    Integer Kentucky = 100;
    Integer Louisiana = 100;
    Integer Maine = 100;
    Integer Maryland =100 ;
    Integer Massachusetts = 100;
    Integer Michigan = 100;
    Integer Minnesota = 100;
    Integer Mississippi = 100;
    Integer Missouri = 100;
    Integer Montana = 100;
    Integer Nebraska = 100;
    Integer Nevada = 100;
    Integer New_Hampshire = 100;
    Integer New_Jersey = 100;
    Integer New_Mexico = 100;
    Integer New_York = 100;
    Integer North_Carolina = 100;
    Integer North_Dakota = 100;
    Integer Ohio = 100;
    Integer Oklahoma = 100;
    Integer Oregon = 100;
    Integer Pennsylvania = 100;
    Integer Rhode_Island = 100;
    Integer South_Carolina = 100;
    Integer South_Dakota = 100;
    Integer Tennessee = 100;
    Integer Texas = 100;
    Integer Utah = 100;
    Integer Vermont = 100;
    Integer Virginia = 100;
    Integer Washington = 100;
    Integer Washington_DC = 100;
    Integer West_Virginia = 100;
    Integer Wisconsin = 100;
    Integer Wyoming = 100;
    Integer Featured_Listing = 200;
    Integer Rehabs_with_Private_Rooms = 200;
    
    Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
    Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    Id recTypeId = rtMapByName.get('Addiction Network').getRecordTypeId();
    
    for(Lead l : Trigger.New){
        if(l.recordTypeId == recTypeId){
            Integer Billing_Amount = 0;
            if(l.Executive_Treatment__c == True)
                Billing_Amount = Billing_Amount + Executive_Treatment;
            if(l.Luxury_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Luxury_Rehab_Centers;
            if(l.Rehab_for_Men__c == True)
                Billing_Amount = Billing_Amount + Rehab_for_Men;
            if(l.Rehab_for_Women__c == True)
                Billing_Amount = Billing_Amount + Rehab_for_Women;
            if(l.Mature_Adult_Rehabs__c == True)
                Billing_Amount = Billing_Amount + Mature_Adult_Rehabs;
            if(l.Young_Adult_Rehabs__c == True)
                Billing_Amount = Billing_Amount + Young_Adult_Rehabs;
            if(l.Teen_Adolescent_Rehabs__c == True)
                Billing_Amount = Billing_Amount + Teen_Adolescent_Rehabs;
            if(l.LGBT_Friendly_Rehabs__c == True)
                Billing_Amount = Billing_Amount + LGBT_Friendly_Rehabs;
            if(l.X12_Step_Based_Treatment_Centers__c == True)
                Billing_Amount = Billing_Amount + X12_Step_Based_Treatment_Centers;
            if(l.Non_12_Step_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Non_12_Step_Rehab_Centers;
            if(l.Faith_Based_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Faith_Based_Rehab_Centers;
            if(l.Holistic_Addiction_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Holistic_Addiction_Rehab_Centers;
            if(l.Dual_Diagnosis_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Dual_Diagnosis_Rehab_Centers;
            if(l.Rehabs_on_the_Ocean__c == True)
                Billing_Amount = Billing_Amount + Rehabs_on_the_Ocean;
            if(l.Lake_Front_Addiction_Centers__c == True)
                Billing_Amount = Billing_Amount + Lake_Front_Addiction_Centers;
            if(l.Mountain_Lodge_Recovery_Centers__c == True)
                Billing_Amount = Billing_Amount + Mountain_Lodge_Recovery_Centers;
            if(l.Wilderness_Camps__c == True)
                Billing_Amount = Billing_Amount + Wilderness_Camps;
            if(l.Residential_Addiction_Rehabs__c == True)
                Billing_Amount = Billing_Amount + Residential_Addiction_Rehabs;
            if(l.On_Site_Detox__c == True)
                Billing_Amount = Billing_Amount + On_Site_Detox;
            if(l.Rehabs_with_Aftercare_Programs__c == True)
                Billing_Amount = Billing_Amount + Rehabs_with_Aftercare_Programs;
            if(l.Rehabs_with_One_on_One_Counseling__c == True)
                Billing_Amount = Billing_Amount + Rehabs_with_One_on_One_Counseling;
            if(l.Insurance_Friendly_Rehabs__c == True)
                Billing_Amount = Billing_Amount + Insurance_Friendly_Rehabs;
            if(l.Private_Pay_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Private_Pay_Rehab_Centers;
            if(l.Financing_Available__c == True)
                Billing_Amount = Billing_Amount + Financing_Available;
            if(l.Scholarships_Available__c == True)
                Billing_Amount = Billing_Amount + Scholarships_Available;
            if(l.Alcohol_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Alcohol_Rehab_Centers;
            if(l.Prescriptions_Drug_Rehabs__c == True)
                Billing_Amount = Billing_Amount + Prescriptions_Drug_Rehabs;
            if(l.Opiate_Addiction_Centers__c == True)
                Billing_Amount = Billing_Amount + Opiate_Addiction_Centers;
            if(l.Crystal_Meth_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Crystal_Meth_Rehab_Centers;
            if(l.Heroin_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Heroin_Rehab_Centers;
            if(l.Marijuana_Rehab_Centers__c == True)
                Billing_Amount = Billing_Amount + Marijuana_Rehab_Centers;
            if(l.Alabama__c == True)
                Billing_Amount = Billing_Amount + Alabama;
            if(l.Alaska__c == True)
                Billing_Amount = Billing_Amount + Alaska;
            if(l.Arizona__c == True)
                Billing_Amount = Billing_Amount + Arizona;
            if(l.Arkansas__c == True)
                Billing_Amount = Billing_Amount + Arkansas;
            if(l.California__c == True)
                Billing_Amount = Billing_Amount + California;
            if(l.Colorado__c == True)
                Billing_Amount = Billing_Amount + Colorado;
            if(l.Connecticut__c == True)
                Billing_Amount = Billing_Amount + Connecticut;
            if(l.Delaware__c == True)
                Billing_Amount = Billing_Amount + Delaware;
            if(l.Florida__c == True)
                Billing_Amount = Billing_Amount + Florida;
            if(l.Georgia__c == True)
                Billing_Amount = Billing_Amount + Georgia;
            if(l.Hawaii__c == True)
                Billing_Amount = Billing_Amount + Hawaii;
            if(l.Idaho__c == True)
                Billing_Amount = Billing_Amount + Idaho;
            if(l.Illinois__c == True)
                Billing_Amount = Billing_Amount + Illinois;
            if(l.Indiana__c == True)
                Billing_Amount = Billing_Amount + Indiana;
            if(l.Iowa__c == True)
                Billing_Amount = Billing_Amount + Iowa;
            if(l.Kansas__c == True)
                Billing_Amount = Billing_Amount + Kansas;
            if(l.Kentucky__c == True)
                Billing_Amount = Billing_Amount + Kentucky;
            if(l.Louisiana__c == True)
                Billing_Amount = Billing_Amount + Louisiana;
            if(l.Maine__c == True)
                Billing_Amount = Billing_Amount + Maine;
            if(l.Maryland__c == True)
                Billing_Amount = Billing_Amount + Maryland;
            if(l.Massachusetts__c == True)
                Billing_Amount = Billing_Amount + Massachusetts;
            if(l.Michigan__c == True)
                Billing_Amount = Billing_Amount + Michigan;
            if(l.Minnesota__c == True)
                Billing_Amount = Billing_Amount + Minnesota;
            if(l.Mississippi__c == True)
                Billing_Amount = Billing_Amount + Mississippi;
            if(l.Missouri__c == True)
                Billing_Amount = Billing_Amount + Missouri;
            if(l.Montana__c == True)
                Billing_Amount = Billing_Amount + Montana;
            if(l.Nebraska__c == True)
                Billing_Amount = Billing_Amount + Nebraska;
            if(l.Nevada__c == True)
                Billing_Amount = Billing_Amount + Nevada;
            if(l.New_Hampshire__c == True)
                Billing_Amount = Billing_Amount + New_Hampshire;
            if(l.New_Jersey__c == True)
                Billing_Amount = Billing_Amount + New_Jersey;
            if(l.New_Mexico__c == True)
                Billing_Amount = Billing_Amount + New_Mexico;
            if(l.New_York__c == True)
                Billing_Amount = Billing_Amount + New_York;
            if(l.North_Carolina__c == True)
                Billing_Amount = Billing_Amount + North_Carolina;
            if(l.North_Dakota__c == True)
                Billing_Amount = Billing_Amount + North_Dakota;
            if(l.Ohio__c == True)
                Billing_Amount = Billing_Amount + Ohio;
            if(l.Oklahoma__c == True)
                Billing_Amount = Billing_Amount + Oklahoma;
            if(l.Oregon__c == True)
                Billing_Amount = Billing_Amount + Oregon;
            if(l.Pennsylvania__c == True)
                Billing_Amount = Billing_Amount + Pennsylvania;
            if(l.Rhode_Island__c == True)
                Billing_Amount = Billing_Amount + Rhode_Island;
            if(l.South_Carolina__c == True)
                Billing_Amount = Billing_Amount + South_Carolina;
            if(l.South_Dakota__c == True)
                Billing_Amount = Billing_Amount + South_Dakota;
            if(l.Tennessee__c == True)
                Billing_Amount = Billing_Amount + Tennessee;
            if(l.Texas__c == True)
                Billing_Amount = Billing_Amount + Texas;
            if(l.Utah__c == True)
                Billing_Amount = Billing_Amount + Utah;
            if(l.Vermont__c == True)
                Billing_Amount = Billing_Amount + Vermont;
            if(l.Virginia__c == True)
                Billing_Amount = Billing_Amount + Virginia;
            if(l.Washington__c == True)
                Billing_Amount = Billing_Amount + Washington;
            if(l.Washington_DC__c == True)
                Billing_Amount = Billing_Amount + Washington_DC;
            if(l.West_Virginia__c == True)
                Billing_Amount = Billing_Amount + West_Virginia;
            if(l.Wisconsin__c == True)
                Billing_Amount = Billing_Amount + Wisconsin;
            if(l.Wyoming__c == True)
                Billing_Amount = Billing_Amount + Wyoming;
            if(l.Featured_Listing__c ==True)
                Billing_Amount = Billing_Amount + Featured_Listing;
            if(l.Rehabs_with_Private_Rooms__c == True)
                Billing_Amount = Billing_Amount + Rehabs_with_Private_Rooms;        
            l.Monthly_Bill__c = Billing_Amount;
            if(l.Banner_Total__c != Null ){
                l.Monthly_Bill__c = l.Monthly_Bill__c + l.Banner_Total__c;    
            }
            if(l.Discount__c != Null){
                l.Monthly_Bill__c = l.Monthly_Bill__c - l.Discount__c; 
            }
        }    
    }*/
    
}