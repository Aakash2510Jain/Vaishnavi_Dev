trigger OpportunityTriggerCustom on Opportunity__c (after insert) {
    SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('Account');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c){
        OpportunityTriggerHelper handlerInstance = OpportunityTriggerHelper.getInstance();
        
        if(trigger.isafter&& trigger.isInsert){
            handlerInstance.afterInsert(trigger.newMap);
        }
    }
}