trigger AGMTrigger on Assignment_Group_Member__c (after update) {
 SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('AGM');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c){
        AGMTriggerHelper handlerInstance = AGMTriggerHelper.getInstance();
        
        if(trigger.isAfter && trigger.isUpdate){
            handlerInstance.afterUpdate(trigger.newMap, trigger.oldMap);
        }
    }
}