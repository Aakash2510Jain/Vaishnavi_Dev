trigger SiteVisitTrigger on Visit__c (after insert, after update) {
SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('SiteVisit');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c){
        SiteVisitTriggerHelper handlerInstance = SiteVisitTriggerHelper.getInstance();
        
        if(trigger.isAfter && trigger.isInsert){
            //handlerInstance.afterInsert(trigger.newMap);
        }
        if(trigger.isAfter && trigger.isUpdate){
            handlerInstance.afterUpdate(trigger.newMap, trigger.oldMap);
        }
    }
}