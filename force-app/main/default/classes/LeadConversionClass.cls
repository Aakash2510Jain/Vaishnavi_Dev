public class LeadConversionClass {
    public static void convertLead(List<Lead__c> leadListToBeConverted ){
        Set<Id> leadIds = new Set<Id>();
        List<Task> existingTaskList = new List<Task>();
        List<Account> accountListToInsert = new List<Account>();
        Map<String, String> leadIdByAccountIdMap = new map<String, string>();
        
        if(!leadListToBeConverted.isEmpty()){
            for(Lead__c leadRec : leadListToBeConverted){
                system.debug('leadRec--->'+leadRec);
                leadIds.add(leadRec.Id);
                Account accRecToInsert = new Account();
                accRecToInsert.name = leadRec.Name__c != null ?leadRec.Name__c:leadRec.Name;
                accRecToInsert.Lead__c = leadRec.Id;
                accRecToInsert.Email__c = leadRec.Email__c;
                accRecToInsert.Phone = leadRec.Phone__c;
                accRecToInsert.AccountSource = leadRec.Lead_Source__c;
                accRecToInsert.Source_Type__c = leadRec.Lead_Source_Type__c;
                accRecToInsert.Sub_Source__c = leadRec.Lead_Sub_Source__c;
                accRecToInsert.Project__c = leadRec.Project__c;
                
                accRecToInsert.Campaign__c = leadRec.Campaign__c;
                accRecToInsert.Project__c = leadRec.Project__c;
                accRecToInsert.Site_Visit_Planned_Date__c = leadRec.Site_Visit_Date__c;
                accRecToInsert.Is_Budget_Verified__c = leadRec.Is_Budget_Verified__c;
                accRecToInsert.Project_Location__c = leadRec.Project_Location__c;
                accRecToInsert.Project_Completion_TimeLine__c = leadRec.Project_Completion_TimeLine__c;
                accRecToInsert.Unit_Availability__c = leadRec.Unit_Availability__c;
                
                accRecToInsert.Pre_Sales_Team_Member__c = leadRec.Pre_Sales_Team_Member__c;
                accRecToInsert.Sales_Team_Member__c = leadRec.Sales_Team_Member__c;
                
                accountListToInsert.add(accRecToInsert);
            }
            if(!accountListToInsert.isEmpty()){
                insert accountListToInsert;
                for(Account accRec : accountListToInsert){
                    leadIdByAccountIdMap.put(accRec.Lead__c, accRec.Id);
                }
            }
            
            system.debug('leadIdByAccountIdMap--->'+leadIdByAccountIdMap);
            if(!leadIdByAccountIdMap.isEmpty()){
                List<Task> taskListToBeClonned = new List<task>();
                List<Task> taskList = [Select AccountId,ActivityDate,agentId__c,agentNumber__c,Agent_Status__c,audioFile__c,CallDisposition,CallDurationInSeconds,callEndTime__c,CallObject,callStartTime__c,callStatus__c,CallType,Call_From__c,Call_ID__c,Call_recording__c,Call_Status__c,Call_To__c,Call_Type__c,campaignName__c,CompletedDateTime,Conversation_Comments__c,Conversation_Duration__c,CreatedById,CreatedDate,Customer_Status__c,Description,did__c,dispositionDescription__c,disposition__c,duration__c,Follow_Up_Date_Time__c,Id,IsArchived,IsClosed,IsDeleted,IsHighPriority,IsRecurrence,IsReminderSet,LastModifiedById,LastModifiedDate,Lead_Source_Type__c,Lead_Source__c,Lead_Sub_Source__c,Modified_Created_Date__c,monitorUcid__c,OwnerId,Priority,Recording_URL__c,RecurrenceActivityId,RecurrenceDayOfMonth,RecurrenceDayOfWeekMask,RecurrenceEndDateOnly,RecurrenceInstance,RecurrenceInterval,RecurrenceMonthOfYear,RecurrenceRegeneratedType,RecurrenceStartDateOnly,RecurrenceTimeZoneSidKey,RecurrenceType,ReminderDateTime,Ring_Duration__c,skillName__c,Status,Subject,SystemModstamp,TaskSubtype,tdc_360CTI__Call_Log__c,Total_Call_Duration__c,UCID__c,uui__c,WhatCount,WhatId,WhoCount,WhoId from Task where whatId in : leadIdByAccountIdMap.keyset()];
                system.debug('taskList--->'+taskList);
                for(Task taskRec : taskList){
                    Task taskRecClonned = taskRec.clone(false, true, true, true);
                    taskRecClonned.whatid = leadIdByAccountIdMap.get(taskRec.WhatId);
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