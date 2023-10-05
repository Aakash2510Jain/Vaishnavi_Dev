public without sharing class createTaskForRenquiry {
    public static void insertTask(Map<Id, Lead__c> existingLeadIdByNewLeadRec ){
        system.debug('Insert TAsk');
        List<Task> taskListToInsert = new List<Task>();
        Map<Id, Lead__c> leadRecByIdMap = new Map<Id, Lead__c>();
        
        if(!existingLeadIdByNewLeadRec.isEmpty()){
            leadRecByIdMap = new Map<Id, Lead__c>([Select Id,Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c From Lead__c where Id in : existingLeadIdByNewLeadRec.keySet()]);
            system.debug('leadRecByIdMap'+leadRecByIdMap);
            if(!leadRecByIdMap.isEmpty()){
                for(Id leadId : leadRecByIdMap.keyset()){
                    Task taskRecToInsert = new Task();
                    taskRecToInsert.Subject  = ConstantClass.TaskSubjectForDuplicateLead;
                    taskRecToInsert.WhatId  = leadId;
                    if(!test.isRunningTest())
                        taskRecToInsert.OwnerId = existingLeadIdByNewLeadRec.get(leadId).OwnerId;
                    taskRecToInsert.Lead_Source__c = existingLeadIdByNewLeadRec.get(leadId).Lead_Source__c;
                    taskRecToInsert.Lead_Source_Type__c = existingLeadIdByNewLeadRec.get(leadId).Lead_Source_Type__c;
                    taskRecToInsert.Lead_Sub_Source__c = existingLeadIdByNewLeadRec.get(leadId).Lead_Sub_Source__c;
                    taskListToInsert.add(taskRecToInsert);
                }
                system.debug('taskListToInsert--->'+taskListToInsert);
                if(!taskListToInsert.isEmpty()){
                    insert taskListToInsert;
                }
            }
        }
    }
}