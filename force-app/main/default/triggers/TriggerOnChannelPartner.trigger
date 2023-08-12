trigger TriggerOnChannelPartner on Channel_Partner__c (after insert) {
    SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('ChannelPartner');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c){
        
        channelPartnerTriggerHandler cpHandler = channelPartnerTriggerHandler.getInstance();
        
        if(trigger.isInsert && Trigger.isAfter){
            cpHandler.afterInsert(Trigger.newMap);
        }
    }
}