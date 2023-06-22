public class OpportunityTriggerHelper {
  static OpportunityTriggerHelper handlerInstance;
    
    public static OpportunityTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new OpportunityTriggerHelper();
        return handlerInstance;
    }
     public void afterInsert(Map<Id, opportunity__c> newOpportunityMap){
         List<Visit__c> visitRecordsUnderLeadList = new List<Visit__c>();
         List<Visit__c> visitListToUpdate = new List<Visit__c>();
         Map<String, String> leadIdByOpportunityId = new Map<String, String>();
         
         for(Opportunity__C oppRecord : newOpportunityMap.values()){
             if(oppRecord.Lead__c != null)
                 leadIdByOpportunityId.put(oppRecord.Lead__c, oppRecord.Id);
         }
         if(!leadIdByOpportunityId.isEmpty()){
             visitRecordsUnderLeadList = [Select Id,Lead__c,Opportunities__c from Visit__c where Lead__c in : leadIdByOpportunityId.keyset() ];
             if(!visitRecordsUnderLeadList.isEmpty()){
                 for(Visit__c visitRecord  : visitRecordsUnderLeadList){
                     Visit__c visitRecToUpdate = new Visit__c();
                     visitRecToUpdate.Id = visitRecord.id;
                     visitRecToUpdate.Opportunities__c = leadIdByOpportunityId.get(visitRecord.Lead__c);
                     visitListToUpdate.add(visitRecToUpdate);
                 }
                 if(!visitListToUpdate.isEmpty()){
                     update visitListToUpdate;
                 }
             }
         }
         
         
     }
}