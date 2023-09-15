public class AccountTriggerHelper {
    static AccountTriggerHelper handlerInstance;
    
    public static AccountTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new AccountTriggerHelper();
        return handlerInstance;
    }
    
    public void afterInsert(Map<Id, Account> newAccountMap){
        
        List<Contact> ContactList = new List<Contact>();
        List<Task> existingTaskList = new List<Task>();
        List<Task> taskToLinkToAccount = new List<Task>();
        List<task> existingTaskListUnderLead = new List<Task>();
        List<Task> taskListToInsertUnderOpportunity = new List<Task>();
        List<Opportunity__c> opportunityListToInsert = new List<Opportunity__c>();
        Map<Id,Account> accountIdbyAccountMap = new Map<Id,Account>();
        Map<string, string> leadIdByAccountId = new Map<string, string>();
        Map<string, string> accountIdByLeadId = new Map<string, string>();
         Map<string, string> accountIdByopportunityId = new Map<string, string>();
        
        if(!newAccountMap.isEmpty()){
            for(Account accountRecord : newAccountMap.values()){
                accountIdbyAccountMap.put(accountRecord.Id, accountRecord);
                if(accountRecord.Lead__c != null){
                    leadIdByAccountId.put(accountRecord.Lead__c, accountRecord.Id);
                    accountIdByLeadId.put(accountRecord.Id, accountRecord.Lead__c);
                }
            }
            if(!accountIdbyAccountMap.isEmpty()){
                for(Id accountId : accountIdbyAccountMap.keyset()){
                    Contact conRecord = new Contact();
                    conRecord.AccountId = accountId;
                    conRecord.LastName = accountIdbyAccountMap.get(accountId).Name;
                    ContactList.add(conRecord);
                    
                    Opportunity__c opportunityRec = new Opportunity__c();
                    opportunityRec.AccountId__c = accountId;
                    opportunityRec.Lead__c = accountIdbyAccountMap.get(accountId).Lead__c;
                    opportunityRec.Opportunity_Name__c = accountIdbyAccountMap.get(accountId).Name;
                    opportunityRec.Lead_Source__c = accountIdbyAccountMap.get(accountId).AccountSource;
                    opportunityRec.Lead_Sub_Source__c = accountIdbyAccountMap.get(accountId).Sub_Source__c;
                    opportunityRec.Lead_Source_Type__c = accountIdbyAccountMap.get(accountId).Source_Type__c;
                    opportunityRec.Email__c = accountIdbyAccountMap.get(accountId).Email__c;
                    opportunityRec.Phone__c = accountIdbyAccountMap.get(accountId).Phone;
                    opportunityRec.Pre_Sales_Team_Member__c = accountIdbyAccountMap.get(accountId).Pre_Sales_Team_Member__c;
                    opportunityRec.Sales_Team_Member__c = accountIdbyAccountMap.get(accountId).Sales_Team_Member__c;
                    if(accountIdbyAccountMap.get(accountId).Project__c != null){
                        opportunityRec.Project__c = accountIdbyAccountMap.get(accountId).Project__c;
                    }
                    opportunityListToInsert.add(opportunityRec);
                }
                if(!ContactList.isEmpty()){
                    insert ContactList;
                }
                if(!opportunityListToInsert.isEmpty()){
                    insert opportunityListToInsert;
                    for(Opportunity__c opp : opportunityListToInsert){
                        accountIdByopportunityId.put(opp.AccountId__c,opp.Id);
                    }
                    if(!accountIdByopportunityId.isEmpty()){
                        existingTaskListUnderLead = [Select AccountId,ActivityDate,agentId__c,agentNumber__c,Agent_Status__c,audioFile__c,CallDisposition,CallDurationInSeconds,callEndTime__c,CallObject,callStartTime__c,callStatus__c,CallType,Call_From__c,Call_ID__c,Call_recording__c,Call_Status__c,Call_To__c,Call_Type__c,campaignName__c,CompletedDateTime,Conversation_Comments__c,Conversation_Duration__c,CreatedById,CreatedDate,Customer_Status__c,Description,did__c,dispositionDescription__c,disposition__c,duration__c,Follow_Up_Date_Time__c,Id,IsArchived,IsClosed,IsDeleted,IsHighPriority,IsRecurrence,IsReminderSet,LastModifiedById,LastModifiedDate,Lead_Source_Type__c,Lead_Source__c,Lead_Sub_Source__c,Modified_Created_Date__c,monitorUcid__c,OwnerId,Priority,Recording_URL__c,RecurrenceActivityId,RecurrenceDayOfMonth,RecurrenceDayOfWeekMask,RecurrenceEndDateOnly,RecurrenceInstance,RecurrenceInterval,RecurrenceMonthOfYear,RecurrenceRegeneratedType,RecurrenceStartDateOnly,RecurrenceTimeZoneSidKey,RecurrenceType,ReminderDateTime,Ring_Duration__c,skillName__c,Status,Subject,SystemModstamp,TaskSubtype,tdc_360CTI__Call_Log__c,Total_Call_Duration__c,UCID__c,uui__c,WhatCount,WhatId,WhoCount,WhoId from Task where whatId in : leadIdByAccountId.keyset()];
                        if(!existingTaskListUnderLead.isEmpty()){
                            List<Task> taskListToBeClonned = new List<task>();
                            system.debug('existingTaskListUnderLead--->'+existingTaskListUnderLead);
                            for(Task taskRec : existingTaskListUnderLead){
                                Task taskRecClonned = taskRec.clone(false, true, true, true);
                                taskRecClonned.whatid = accountIdByopportunityId.get(leadIdByAccountId.get(taskRec.WhatId));
                                taskListToBeClonned.add(taskRecClonned);
                            }
                            system.debug('taskListToBeClonned--->'+taskListToBeClonned);
                            if(!taskListToBeClonned.isEmpty()){
                                insert taskListToBeClonned;
                            }
                        }
                    }
                }
            }
            /*if(!leadIdByAccountId.isEmpty()){
                existingTaskList = [Select Id,whatId From Task where whatId in :leadIdByAccountId.keyset()];
                if(!existingTaskList.isEmpty()){
                    for(Task taskRec : existingTaskList){
                        Task taskRecToUpdate = new Task();
                        taskRecToUpdate.Id = taskRec.Id;
                        taskRecToUpdate.WhatId = leadIdByAccountId.get(taskRec.Id);
                        taskToLinkToAccount.add(taskRecToUpdate);
                    }
                    if(!taskToLinkToAccount.isEmpty()){
                        update taskToLinkToAccount;
                    }
                }
            }*/
        }
    }
}