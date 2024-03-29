trigger TaskTrigger on Task (before insert,before Update, after update,after insert) {
 SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('Task');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c){
        TaskTriggerHelper handlerInstance = TaskTriggerHelper.getInstance();
        
        if(trigger.isBefore && trigger.isInsert){
           handlerInstance.beforeInsert(trigger.new);
        }
        if(trigger.isAfter && trigger.isInsert){
            handlerInstance.afterInsert(trigger.new);
        }
        if(trigger.isBefore && trigger.isUpdate){
            handlerInstance.beforeUpdate(trigger.newMap, trigger.oldMap);
        }
        if(trigger.isAfter && trigger.isUpdate){
            handlerInstance.afterUpdate(trigger.newMap, trigger.oldMap);
        }
    }
}