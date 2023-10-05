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
    
    public void beforeUpdate(Map<Id, opportunity__c> newOpportunityMap, Map<Id, opportunity__c> oldOpportunityMap){
        
        List<opportunity__c> oppListToUpdate = New List<opportunity__c>();
        for(Opportunity__C oppRecord : newOpportunityMap.values()){
            if(oppRecord.Opportunity_SubStage__c != oldOpportunityMap.get(oppRecord.Id).Opportunity_SubStage__c && (oppRecord.Next_Followup_Date_Time__c == null || oppRecord.Next_Followup_Date_Time__c < system.now())){
                oppRecord.Next_Followup_Date_Time__c.addError('Please specify future follow up date');
            }
            if(!String.isBlank(oppRecord.Phone__c) && oppRecord.Phone__c != oldOpportunityMap.get(oppRecord.Id).Phone__c){
                oppRecord.Phone__c = oppRecord.Phone__c.replaceAll('[^0-9]', '');
                oppRecord.Phone__c = '+91' + oppRecord.Phone__c.right(10);
            }
            if(!String.isBlank(oppRecord.Alternate_Phone__c)  && oppRecord.Alternate_Phone__c != oldOpportunityMap.get(oppRecord.Id).Alternate_Phone__c){
                oppRecord.Alternate_Phone__c = oppRecord.Alternate_Phone__c.replaceAll('[^0-9]', '');
                oppRecord.Alternate_Phone__c = '+91' +  oppRecord.Alternate_Phone__c.right(10);
            }
        }  
    }

    public void beforeInsert(List<opportunity__c> newOppList){
        system.debug('newOppList ===> '+newOppList);
        for(Opportunity__C oppRecord : newOppList){
            if(!String.isBlank(oppRecord.Phone__c)){
                oppRecord.Phone__c = oppRecord.Phone__c.replaceAll('[^0-9]', '');
                oppRecord.Phone__c = '+91' + oppRecord.Phone__c.right(10);
            }
            if(!String.isBlank(oppRecord.Alternate_Phone__c)){
                oppRecord.Alternate_Phone__c = oppRecord.Alternate_Phone__c.replaceAll('[^0-9]', '');
                oppRecord.Alternate_Phone__c = '+91' +  oppRecord.Alternate_Phone__c.right(10);
            }
        }
    }
}