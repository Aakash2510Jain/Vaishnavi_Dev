public class assignLeads {
    
    public static void assignLeadsToPreSales(List<Lead__c> leadList){
        List<Assignment_Group_Member__c> agmList = [Select Id,Group_Member__c,Name,Assignment_Id__c,Last_Sequence__c From Assignment_Group_Member__c where Assignment_Group__r.Name = 'Pre Sales' order by LastModifiedDate ASC limit 1];
        for(Lead__c leadRec : leadList){
            leadRec.Ownerid = agmList[0].Group_Member__c;
        }
        update leadList;
        agmList[0].Last_Sequence__c = system.now().getTime();
        update agmList;
    }
}