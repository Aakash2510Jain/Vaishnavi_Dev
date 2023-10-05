public class TaskTriggerHelper {
    static TaskTriggerHelper handlerInstance;
    
    public static TaskTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new TaskTriggerHelper();
        return handlerInstance;
    }
    
    public void beforeInsert(List<Task> newTaskList){
        try{
            //Appenfding Profile name in the end of task
            system.debug('Before Task Insert');
            set<Id> relatedLeadIdsSet = new Set<Id>();
            set<Id> taskIdsToBeMarkedAsClosed = new Set<Id>();
            Map<Id, Lead__c> leadIdbyLeadRecMap = new Map<Id, Lead__c>();
            
            for(Task taskRec : newTaskList){
                system.debug('taskRec--->'+taskRec);
                system.debug('taskRec--->'+taskRec.Id);
                if(taskRec.WhatId != null){
                    if((Id.valueOf(taskRec.WhatId)).getSObjectType().getDescribe().getName() == 'Lead__c')
                        relatedLeadIdsSet.add(taskRec.WhatId);
                }
            }
            if(!relatedLeadIdsSet.isEmpty()){
                leadIdbyLeadRecMap = new Map<Id, Lead__c>([Select Id,Owner.Profile.name From Lead__c where Id in :relatedLeadIdsSet]);
                if(!leadIdbyLeadRecMap.isEmpty()){
                    for(Task taskRec : newTaskList){
                        if(leadIdbyLeadRecMap.containsKey(taskRec.WhatId)){
                            taskRec.Subject += ' - '+ leadIdbyLeadRecMap.get(taskRec.WhatId).Owner.Profile.name;
                        }
                    }
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('TaskTriggerHelper', 'Befoe Task Insert', e, null);
        }
    }
    public void afterInsert(List<Task> newTaskList){
        try{   
            
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('TaskTriggerHelper', 'After Task Insert', e, null);
        }
    }
    public void beforeUpdate(Map<Id, Task> newTaskMap, Map<Id, Task> oldTaskMap){
        system.debug('Before Task Update');
        try{
            //Checking how many time a lead has been updated
            //Also marking Call realted tasks by Sales and Pre-Sales Team
            set<Id> relatedLeadIdsSet = new Set<Id>();
            set<Id> taskIdsToBeMarkedAsClosed = new Set<Id>();
            Map<Id, Lead__c> leadIdbyLeadRecMap = new Map<Id, Lead__c>();
            
            for(Task taskRec : newTaskMap.values()){
                if(taskRec.WhatId != null){
                    if((Id.valueOf(taskRec.WhatId)).getSObjectType().getDescribe().getName() == 'Lead__c' && taskRec.Call_ID__c != null)
                        relatedLeadIdsSet.add(taskRec.WhatId);
                }
                if(taskrec.Conversation_Duration__c == 0 && taskrec.Call_ID__c != null && taskrec.Total_Call_Duration__c != oldTaskMap.get(taskrec.Id).Total_Call_Duration__c){
                    system.debug('taskrec.WhatId--->'+taskrec.WhatId);
                    if(taskrec.No_of_times_Updated__c == null)
                        taskrec.No_of_times_Updated__c = 0;
                    taskrec.No_of_times_Updated__c = taskrec.No_of_times_Updated__c + 1;
                }
            }
            if(!relatedLeadIdsSet.isEmpty()){
                leadIdbyLeadRecMap = new Map<Id, Lead__c>([Select Id,Owner.Profile.name From Lead__c where Id in :relatedLeadIdsSet]);
                if(!leadIdbyLeadRecMap.isEmpty()){
                    for(Task taskRec : newTaskMap.values()){
                        if(leadIdbyLeadRecMap.containsKey(taskRec.WhatId)){
                            if(leadIdbyLeadRecMap.get(taskRec.WhatId).Owner.Profile.name == 'Pre-Sales Team'){
                                taskRec.Is_Pre_Sales_Member_Call_Activity__c = true;
                            }
                            if(leadIdbyLeadRecMap.get(taskRec.WhatId).Owner.Profile.name == 'Sales Team'){
                                taskRec.Is_Sales_Member_Call_Activity__c = true;
                            }
                        }
                    }
                }
            }
        }catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('TaskTriggerHelper', 'Befoe Task Insert', e, null);
        }
    }
    
    public void afterUpdate(Map<Id, Task> newTaskMap, Map<Id, Task> oldTaskMap){
        system.debug('After update');
        set<id> leadIdsSet = new Set<id>();
        set<id> setOfCalledLeadIds = new Set<id>();
        List<Lead__c> existingLeadList = new List<Lead__c>();
        List<Task> taskListToBeMarkedAsCompleted = new List<task>();
        
        set<Id> leadIdSet = new set<Id>();
        
        try{
            
            for(Task taskrec : newTaskMap.values()){
                system.debug('taskrec--> '+taskrec);
                system.debug('taskrec.Conversation_Duration__c---> '+taskrec.Conversation_Duration__c);
                system.debug('taskrec.Call_ID__c----> '+taskrec.Call_ID__c);
                system.debug('taskrec.Total_Call_Duration__c---> '+taskrec.Total_Call_Duration__c);
                system.debug('oldTaskMap.get(taskrec.Id).Total_Call_Duration__c--->'+oldTaskMap.get(taskrec.Id).Total_Call_Duration__c);
                
                if(taskrec.Conversation_Duration__c == 0 && taskrec.Call_ID__c != null && taskrec.Total_Call_Duration__c != oldTaskMap.get(taskrec.Id).Total_Call_Duration__c){
                    //Not Connected Call Tasks
                    system.debug('taskrec.WhatId--->'+taskrec.WhatId);
                    leadIdsSet.add(taskrec.WhatId);
                }
                if(taskRec.WhatId != null && taskRec.Call_ID__c != null){
                    if((Id.valueOf(taskRec.WhatId)).getSObjectType().getDescribe().getName() == 'Lead__c' ){
                        //Call Tasks related to Leads
                        setOfCalledLeadIds.add(taskRec.WhatId);
                    }
                }
            }
            if(!setOfCalledLeadIds.isEmpty()){ 
                existingLeadList = [Select Id,Last_Contacted_Date_Time__c,(Select Id,Status,CreatedDate From Tasks where (Subject Like '%call%' or Call_ID__c != null or Subject Like '%Call%' or Subject Like 'call%' or Subject Like 'Call%') and status = 'Open' and CreatedDate <: system.now().addminutes(-1)) From Lead__c where Id In:setOfCalledLeadIds];
                system.debug('existingLeadList--->'+existingLeadList);
                if(!existingLeadList.isEmpty()){
                    for(Lead__c ld : existingLeadList){
                        if(!ld.Tasks.isEmpty()){
                            for(Task taskRec : ld.Tasks){
                                system.debug('taskRec--> '+taskRec);
                                system.debug('taskRec.CreatedDate--->'+taskRec.CreatedDate);
                                system.debug('system.now().addminutes(-1)--->'+system.now().addminutes(-1));
                                
                                Task taskRecToMarkCompleted = new task();
                                taskRecToMarkCompleted.Id = taskRec.Id;
                                taskRecToMarkCompleted.Status = 'Completed';
                                taskListToBeMarkedAsCompleted.add(taskRecToMarkCompleted);
                            }
                        }
                    }
                    system.debug('taskListToBeMarkedAsCompleted---> '+taskListToBeMarkedAsCompleted);
                    if(!taskListToBeMarkedAsCompleted.isEmpty()){
                        update taskListToBeMarkedAsCompleted;
                    }
                }
            }
            system.debug('leadIdsSet-->'+leadIdsSet);
            if(!leadIdsSet.isEmpty()){
                List<Task> taskListToInsertAfterFirstNotConnectPreSales = new List<Task>();
                List<Task> taskListToInsertAfterFirstNotConnectSales = new List<Task>();
                List<Task> taskListToInsertAfterNotConnectPreSales = new List<Task>();
                List<Task> taskListToInsertAfterNotConnectSales = new List<Task>();
                Map<String,integer> leadIdByNotConnectedTaskCountPreSales = new Map<String, integer>();
                Map<String,integer> leadIdByNotConnectedTaskCountSales = new Map<String, integer>();
                Map<String,string> leadIdByLeadOwnerId = new Map<String, string>();
                
                List<Lead__c> preSaleLeadList = new List<Lead__c>();
                List<Lead__c> SaleLeadList = new List<Lead__c>();
                
                // get only call related tasks
                preSaleLeadList = [Select Id,Lead_Stage__c,Lead_Substage__c,ownerId,isQualified__c,(Select Id,Call_ID__c,Conversation_Duration__c,WhatId From Tasks where Call_ID__c != null and Is_Pre_Sales_Member_Call_Activity__c = true and (Conversation_Duration__c = 0.0 or Conversation_Duration__c = 0 or Conversation_Duration__c = null)) From Lead__c where id in : leadIdsSet];
                system.debug('preSaleLeadList-->'+preSaleLeadList);
                
                SaleLeadList = [Select Id,Lead_Stage__c,Lead_Substage__c,ownerId,(Select Id,Call_ID__c,Conversation_Duration__c,WhatId From Tasks where Call_ID__c != null and Is_Sales_Member_Call_Activity__c = true and (Conversation_Duration__c = 0.0 or Conversation_Duration__c = 0 or Conversation_Duration__c = null)) From Lead__c where id in : leadIdsSet];
                system.debug('SaleLeadList--->'+SaleLeadList);
                
                if(!preSaleLeadList.isEmpty()){
                    for(Lead__c leadRec : preSaleLeadList){
                        //only a single task for not connected call
                        leadIdByLeadOwnerId.put(leadRec.Id,leadRec.ownerId);
                        system.debug('leadRec.tasks.size() -->'+leadRec.tasks.size());
                        if(leadRec.isQualified__c == false){
                            if(leadRec.tasks.size() == 1){
                                system.debug('leadRec.tasks[0].Conversation_Duration__c-->'+leadRec.tasks[0].Conversation_Duration__c);
                                if(leadRec.tasks[0].Conversation_Duration__c == 0){
                                    Task taskRec = new Task();
                                    taskRec.Subject = ConstantClass.SecondCallTAskAfterFirstNotConnect;
                                    taskRec.whatId = leadRec.Id;
                                    taskRec.Due_Date_Time__c = system.now().addminutes(120);
                                    taskRec.ownerId = leadRec.ownerId;
                                    taskRec.ActivityDate = system.today();
                                    taskrec.IsReminderSet = true;
                                    taskrec.OwnerId = leadRec.ownerId;
                                    taskrec.ReminderDateTime = System.now().addMinutes(115);
                                    taskListToInsertAfterFirstNotConnectPreSales.add(taskRec);
                                }
                            }else{
                                system.debug('More then 1 task');
                                for(Task taskRec : leadRec.tasks){
                                    system.debug('taskRec.Conversation_Duration__c--->'+taskRec.Conversation_Duration__c);
                                    if(taskRec.Conversation_Duration__c == 0 || taskRec.Conversation_Duration__c == null){
                                        if(leadIdByNotConnectedTaskCountPreSales.containskey(taskRec.WhatId)){
                                            leadIdByNotConnectedTaskCountPreSales.put(taskRec.WhatId, leadIdByNotConnectedTaskCountPreSales.get(taskRec.WhatId) + 1);
                                        }else{
                                            leadIdByNotConnectedTaskCountPreSales.put(taskRec.WhatId, 1);
                                        }
                                    }else{
                                        leadIdByNotConnectedTaskCountPreSales.remove(taskRec.WhatId);
                                    }
                                }
                            }
                        }
                    }
                    system.debug('taskListToInsertAfterFirstNotConnectPreSales-->'+taskListToInsertAfterFirstNotConnectPreSales);
                    if(!taskListToInsertAfterFirstNotConnectPreSales.isEmpty()){
                        insert taskListToInsertAfterFirstNotConnectPreSales;
                    }
                    system.debug('leadIdByNotConnectedTaskCountPreSales-->'+leadIdByNotConnectedTaskCountPreSales);
                    if(!leadIdByNotConnectedTaskCountPreSales.isEmpty()){
                        List<Lead__C> leadListToBeMarkedasDropped = new List<Lead__C>();
                        
                        for(string leadid : leadIdByNotConnectedTaskCountPreSales.keyset()){
                            system.debug('leadIdByNotConnectedTaskCountPreSales.get(leadId)-->'+leadIdByNotConnectedTaskCountPreSales.get(leadId));
                            //if 2 not connected
                            if(leadIdByNotConnectedTaskCountPreSales.get(leadId) == 2){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.thirdCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadid;
                                taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                                taskRec.ActivityDate = system.today();
                                taskrec.IsReminderSet = true;
                                taskRec.Due_Date_Time__c = System.now().addMinutes(120);
                                taskrec.ReminderDateTime = System.now().addMinutes(115);
                                taskListToInsertAfterNotConnectPreSales.add(taskRec);
                            }
                            //if 3 not connected
                            else if(leadIdByNotConnectedTaskCountPreSales.get(leadId) == 3){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.forthCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadid;
                                taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                                taskRec.ActivityDate = system.today().addDays(1);
                                taskrec.IsReminderSet = true;
                                Time timeInstance = Time.newInstance(11, 0, 0, 0);
                                taskrec.ReminderDateTime = dateTime.newInstance(system.today().addDays(1), timeInstance);
                                taskRec.Due_Date_Time__c = dateTime.newInstance(system.today().addDays(1), timeInstance).addMinutes(60);
                                taskListToInsertAfterNotConnectPreSales.add(taskRec); 
                            }
                            //if 4 not connected
                            else if(leadIdByNotConnectedTaskCountPreSales.get(leadId) == 4){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.fifthCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadid;
                                taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                                taskRec.ActivityDate = system.today().addDays(1);
                                taskrec.IsReminderSet = true;
                                Time timeInstance = Time.newInstance(11, 0, 0, 0);
                                taskrec.ReminderDateTime = dateTime.newInstance(system.today().addDays(2), timeInstance);
                                taskRec.Due_Date_Time__c = dateTime.newInstance(system.today().addDays(2), timeInstance).addMinutes(60);
                                taskListToInsertAfterNotConnectPreSales.add(taskRec); 
                            }
                            //if 5 not connected
                            else if(leadIdByNotConnectedTaskCountPreSales.get(leadId) == 5){
                                Lead__c leadRecToMarkDrop = new Lead__c();
                                leadRecToMarkDrop.Id = leadid;
                                leadRecToMarkDrop.Lead_Stage__c = ConstantClass.LeadStageDrop;
                                leadRecToMarkDrop.Lead_Substage__c = 'Ringing no response';
                                leadListToBeMarkedasDropped.add(leadRecToMarkDrop);
                            }
                        }
                        system.debug('leadListToBeMarkedasDropped--->'+leadListToBeMarkedasDropped);
                        
                        system.debug('taskListToInsertAfterNotConnectPreSales-->'+taskListToInsertAfterNotConnectPreSales);
                        if(!taskListToInsertAfterNotConnectPreSales.isEmpty()){
                            system.debug('inside inserting task');
                            insert taskListToInsertAfterNotConnectPreSales;
                            system.debug('taskListToInsertAfterNotConnectPreSales-->'+taskListToInsertAfterNotConnectPreSales);
                        }
                        
                        if(!leadListToBeMarkedasDropped.isEmpty()){
                            system.debug('inside updating Task task');
                            update leadListToBeMarkedasDropped;
                            system.debug('leadListToBeMarkedasDropped-->'+leadListToBeMarkedasDropped);
                        }
                    }
                }
                if(!SaleLeadList.isEmpty()){
                    for(Lead__c leadRec : SaleLeadList){
                        system.debug('leadRec.Lead_Stage__c--->'+leadRec.Lead_Stage__c);
                        //only a single task for not connected call
                        leadIdByLeadOwnerId.put(leadRec.Id,leadRec.ownerId);
                        system.debug('leadRec.tasks.size() -->'+leadRec.tasks.size());
                        if(!leadRec.tasks.isEmpty()){
                            if(leadRec.tasks.size() == 1){
                                system.debug('leadRec.tasks[0].Conversation_Duration__c-->'+leadRec.tasks[0].Conversation_Duration__c);
                                if(leadRec.tasks[0].Conversation_Duration__c == 0){
                                    Task taskRec = new Task();
                                    taskRec.Subject = ConstantClass.SecondCallTAskAfterFirstNotConnect;
                                    taskRec.whatId = leadRec.Id;
                                    taskRec.Due_Date_Time__c = system.now().addminutes(120);
                                    taskRec.ownerId = leadRec.ownerId;
                                    taskRec.ActivityDate = system.today();
                                    taskrec.IsReminderSet = true;
                                    taskrec.OwnerId = leadRec.ownerId;
                                    taskrec.ReminderDateTime = System.now().addMinutes(115);
                                    taskListToInsertAfterFirstNotConnectSales.add(taskRec);
                                }
                            }else{
                                system.debug('More then 1 task');
                                for(Task taskRec : leadRec.tasks){
                                    system.debug('taskRec.Conversation_Duration__c--->'+taskRec.Conversation_Duration__c);
                                    if(taskRec.Conversation_Duration__c == 0 || taskRec.Conversation_Duration__c == null){
                                        if(leadIdByNotConnectedTaskCountSales.containskey(taskRec.WhatId)){
                                            leadIdByNotConnectedTaskCountSales.put(taskRec.WhatId, leadIdByNotConnectedTaskCountSales.get(taskRec.WhatId) + 1);
                                        }else{
                                            leadIdByNotConnectedTaskCountSales.put(taskRec.WhatId, 1);
                                        }
                                    }else{
                                        leadIdByNotConnectedTaskCountSales.remove(taskRec.WhatId);
                                    }
                                }
                            }
                        }
                    }
                    system.debug('taskListToInsertAfterFirstNotConnectSales-->'+taskListToInsertAfterFirstNotConnectSales);
                    if(!taskListToInsertAfterFirstNotConnectSales.isEmpty()){
                        insert taskListToInsertAfterFirstNotConnectSales;
                    }
                    system.debug('leadIdByNotConnectedTaskCountSales-->'+leadIdByNotConnectedTaskCountSales);
                    if(!leadIdByNotConnectedTaskCountSales.isEmpty()){
                        List<Lead__C> leadListToBeMarkedasDropped = new List<Lead__C>();
                        
                        for(string leadid : leadIdByNotConnectedTaskCountSales.keyset()){
                            system.debug('leadIdByNotConnectedTaskCountSales.get(leadId)-->'+leadIdByNotConnectedTaskCountSales.get(leadId));
                            //if 2 not connected
                            if(leadIdByNotConnectedTaskCountSales.get(leadId) == 2){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.thirdCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadid;
                                taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                                taskRec.ActivityDate = system.today();
                                taskrec.IsReminderSet = true;
                                taskRec.Due_Date_Time__c = System.now().addMinutes(120);
                                taskrec.ReminderDateTime = System.now().addMinutes(115);
                                taskListToInsertAfterNotConnectSales.add(taskRec);
                            }
                            //if 3 not connected
                            else if(leadIdByNotConnectedTaskCountSales.get(leadId) == 3){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.forthCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadid;
                                taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                                taskRec.ActivityDate = system.today().addDays(1);
                                taskrec.IsReminderSet = true;
                                Time timeInstance = Time.newInstance(11, 0, 0, 0);
                                taskrec.ReminderDateTime = dateTime.newInstance(system.today().addDays(1), timeInstance);
                                taskRec.Due_Date_Time__c = dateTime.newInstance(system.today().addDays(1), timeInstance).addMinutes(60);
                                taskListToInsertAfterNotConnectSales.add(taskRec); 
                            }
                            //if 4 not connected
                            else if(leadIdByNotConnectedTaskCountSales.get(leadId) == 4){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.fifthCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadid;
                                taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                                taskRec.ActivityDate = system.today().addDays(1);
                                taskrec.IsReminderSet = true;
                                Time timeInstance = Time.newInstance(11, 0, 0, 0);
                                taskrec.ReminderDateTime = dateTime.newInstance(system.today().addDays(2), timeInstance);
                                taskRec.Due_Date_Time__c = dateTime.newInstance(system.today().addDays(2), timeInstance).addMinutes(60);
                                taskListToInsertAfterNotConnectSales.add(taskRec); 
                            }
                            //if 5 not connected
                            else if(leadIdByNotConnectedTaskCountSales.get(leadId) == 5){
                                Lead__c leadRecToMarkDrop = new Lead__c();
                                leadRecToMarkDrop.Id = leadid;
                                leadRecToMarkDrop.Lead_Stage__c = ConstantClass.LeadStageDrop;
                                leadRecToMarkDrop.Lead_Substage__c = 'Ringing no response';
                                leadListToBeMarkedasDropped.add(leadRecToMarkDrop);
                            }
                        }
                        system.debug('leadListToBeMarkedasDropped--->'+leadListToBeMarkedasDropped);
                        
                        system.debug('taskListToInsertAfterFirstNotConnectSales-->'+taskListToInsertAfterFirstNotConnectSales);
                        if(!taskListToInsertAfterNotConnectSales.isEmpty()){
                            system.debug('inside inserting task');
                            insert taskListToInsertAfterNotConnectSales;
                            system.debug('taskListToInsertAfterNotConnectSales-->'+taskListToInsertAfterNotConnectSales);
                        }
                        if(!leadListToBeMarkedasDropped.isEmpty()){
                            system.debug('inside updating Task task');
                            update leadListToBeMarkedasDropped;
                            system.debug('leadListToBeMarkedasDropped-->'+leadListToBeMarkedasDropped);
                        }
                    }
                }
            }
            system.debug('setOfCalledLeadIds---> '+setOfCalledLeadIds);            
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('TaskTriggerHelper', 'After Task Update', e, null);
        }
    }
    
}