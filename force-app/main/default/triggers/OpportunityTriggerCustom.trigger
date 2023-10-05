trigger OpportunityTriggerCustom on Opportunity__c (after insert,before update, before insert) {
    SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('Opportunity');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c){
        OpportunityTriggerHelper handlerInstance = OpportunityTriggerHelper.getInstance();
        
        if(trigger.isafter&& trigger.isInsert){
            handlerInstance.afterInsert(trigger.newMap);
        }
        if(trigger.isbefore && trigger.isUpdate){
            handlerInstance.beforeUpdate(trigger.newMap, trigger.oldMap);
        }
        if(trigger.isBefore && trigger.isInsert){
            system.debug('Inside Before Insert.....');
            handlerInstance.beforeInsert(trigger.new);
        }
    }
}