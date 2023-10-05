trigger LeadTrigger on Lead__c (before insert, after insert, before update,after update) {
 SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('Lead');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c){
        LeadTriggerHandler handlerInstance = LeadTriggerHandler.getInstance();
        
        if(trigger.isBefore && trigger.isInsert){
            handlerInstance.beforeInsert(trigger.new);
        }
        if(trigger.isAfter && trigger.isInsert){
            
            system.debug('After lead Insert');
            handlerInstance.afteInsert(trigger.newMap, trigger.oldMap);
            
            //Lead Assignment
            //LeadAssignmentExecutionCriteria.validateEntryCriteria();
            
            //delete duplicate leads	
            BatchToDeleteDuplicateLeads batchInstance = new BatchToDeleteDuplicateLeads();
            database.executeBatch(batchInstance);
            
            BatchToAssignIncomingLead batchInstance1 = new BatchToAssignIncomingLead();
            database.executeBatch(batchInstance1);
            
        }
        if(trigger.isBefore && trigger.isUpdate){
            handlerInstance.beforeUpdate(trigger.newMap, trigger.oldMap);
        }
        if(trigger.isAfter && trigger.isUpdate){
            handlerInstance.afterUpdate(trigger.newMap, trigger.oldMap);
        }
    }
}