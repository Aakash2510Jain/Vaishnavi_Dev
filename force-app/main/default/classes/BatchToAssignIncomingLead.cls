public without sharing class BatchToAssignIncomingLead implements database.batchable<sObject>{
    public database.queryLocator start(database.batchableContext bc){
        return database.getQueryLocator([Select Id,OwnerId,Is_CTI_Lead__c,(Select Id,Subject,OwnerId From Tasks order by CreatedDate ASC limit 1) From Lead__c where Is_CTI_Lead__c = true]);
    }
    public void execute(database.batchableContext bc, List<Lead__c> leadList){
        List<Lead__c> leadListToUpdated = new List<Lead__c>();
        
        if(!leadList.isEmpty()){
            for(Lead__c leadRec : leadList){
                Lead__C leadRecToUpdate = new Lead__c();
                leadRecToUpdate.Id = leadRec.Id;
                leadRecToUpdate.Is_CTI_Lead__c = false;
                leadRecToUpdate.OwnerId = leadRec.tasks[0].OwnerId;
                leadListToUpdated.add(leadRecToUpdate);
            }  
            if(!leadListToUpdated.isEmpty()){
                update leadListToUpdated;
            }
        }
          
    }
    public void finish(database.batchableContext bc){
    }
}