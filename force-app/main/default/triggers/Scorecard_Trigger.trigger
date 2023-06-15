trigger Scorecard_Trigger on Scorecard__c (after insert,after update) {
    if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
    {
        ScoreCardTriggerHelper.beforeInsert(trigger.new,Trigger.Old);
    }
}