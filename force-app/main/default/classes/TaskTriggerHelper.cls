public class TaskTriggerHelper {
    static TaskTriggerHelper handlerInstance;
    
    public static TaskTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new TaskTriggerHelper();
        return handlerInstance;
    }
    
    public void beforeInsert(List<Task> newTaskList){
        try{
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
                            // if(leadIdbyLeadRecMap.get(taskRec.WhatId).Owner.Profile.name == 'Pre-Sales Team'){
                            //     taskRec.Is_Pre_Sales_Member_Call_Activity__c = true;
                            // }
                            // if(leadIdbyLeadRecMap.get(taskRec.WhatId).Owner.Profile.name == 'Sales Team'){
                            //     taskRec.Is_Sales_Member_Call_Activity__c = true;
                            // }
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
            system.debug('After task Insert');
            set<Id> taskIdsToBeMarkedAsClosed = new Set<Id>();
            Set<Id> setOfLeadIds = new Set<Id>();
            List<Lead__c> leadList = new List<Lead__c>();
            List<Task> taskListToBeMarkedAsCompleted = new List<task>();
            for(Task taskRec : newTaskList){
                system.debug('taskRec<--->'+taskRec);
                system.debug('taskRec<--->'+taskRec.Id);
                
            }
            
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('TaskTriggerHelper', 'After Task Insert', e, null);
        }
    }
    public void beforeUpdate(Map<Id, Task> newTaskMap, Map<Id, Task> oldTaskMap){
        system.debug('Before Task Update');
        try{
            set<Id> relatedLeadIdsSet = new Set<Id>();
            set<Id> taskIdsToBeMarkedAsClosed = new Set<Id>();
            Map<Id, Lead__c> leadIdbyLeadRecMap = new Map<Id, Lead__c>();
            
            for(Task taskRec : newTaskMap.values()){
                if(taskRec.WhatId != null){
                    if((Id.valueOf(taskRec.WhatId)).getSObjectType().getDescribe().getName() == 'Lead__c' && taskRec.Call_ID__c != null)
                        relatedLeadIdsSet.add(taskRec.WhatId);
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
        
        try{
            for(Task taskrec : newTaskMap.values()){
                if(taskrec.Conversation_Duration__c == 0 && taskrec.Call_ID__c != null && taskrec.Total_Call_Duration__c != oldTaskMap.get(taskrec.Id).Total_Call_Duration__c){
                    system.debug('taskrec.WhatId--->'+taskrec.WhatId);
                    leadIdsSet.add(taskrec.WhatId);
                }
                if(taskRec.WhatId != null){
                    if((Id.valueOf(taskRec.WhatId)).getSObjectType().getDescribe().getName() == 'Lead__c' && taskRec.Call_ID__c != null){
                        setOfCalledLeadIds.add(taskRec.WhatId);
                    }
                }
            }
            system.debug('leadIdsSet-->'+leadIdsSet);
            if(!leadIdsSet.isEmpty()){
                List<Task> taskListToInsertAfterFirstNotConnect = new List<Task>();
                List<Task> taskListToInsertAfterNotConnect = new List<Task>();
                Map<String,integer> leadIdByNotConnectedTaskCount = new Map<String, integer>();
                Map<String,string> leadIdByLeadOwnerId = new Map<String, string>();
                
                // get only call related tasks
                List<Lead__c> leadList = [Select Id,Lead_Stage__c,Lead_Substage__c,ownerId,(Select Id,Call_ID__c,Conversation_Duration__c,WhatId From Tasks where Call_ID__c != null) From Lead__c where id in : leadIdsSet and Lead_Stage__c = : ConstantClass.LeadStageNotConnected];
                system.debug('leadList-->'+leadList);
                if(!leadList.isEmpty()){
                    for(Lead__c leadRec : leadList){
                        if(leadRec.Lead_Stage__c == ConstantClass.LeadStageNotConnected){
                            //only a single task for not connected call
                            leadIdByLeadOwnerId.put(leadRec.Id,leadRec.ownerId);
                            system.debug('leadRec.tasks.size() -->'+leadRec.tasks.size());
                            if(leadRec.tasks.size() == 1){
                                system.debug('leadRec.tasks[0].Conversation_Duration__c-->'+leadRec.tasks[0].Conversation_Duration__c);
                                if(leadRec.tasks[0].Conversation_Duration__c == 0){
                                    Task taskRec = new Task();
                                    taskRec.Subject = ConstantClass.SecondCallTAskAfterFirstNotConnect;
                                    taskRec.whatId = leadRec.Id;
                                    taskRec.ownerId = leadRec.ownerId;
                                    taskRec.ActivityDate = system.today();
                                    taskrec.IsReminderSet = true;
                                    taskrec.OwnerId = leadRec.ownerId;
                                    taskrec.ReminderDateTime = System.now().addMinutes(115);
                                    taskListToInsertAfterFirstNotConnect.add(taskRec);
                                }
                            }else{
                                system.debug('More then 1 task');
                                for(Task taskRec : leadRec.tasks){
                                    system.debug('taskRec.Conversation_Duration__c--->'+taskRec.Conversation_Duration__c);
                                    if(taskRec.Conversation_Duration__c == 0 || taskRec.Conversation_Duration__c == null){
                                        if(leadIdByNotConnectedTaskCount.containskey(taskRec.WhatId)){
                                            leadIdByNotConnectedTaskCount.put(taskRec.WhatId, leadIdByNotConnectedTaskCount.get(taskRec.WhatId) + 1);
                                        }else{
                                            leadIdByNotConnectedTaskCount.put(taskRec.WhatId, 1);
                                        }
                                    }else{
                                        leadIdByNotConnectedTaskCount.remove(taskRec.WhatId);
                                    }
                                }
                            }
                            
                        }
                    }
                    system.debug('taskListToInsertAfterFirstNotConnect-->'+taskListToInsertAfterFirstNotConnect);
                    if(!taskListToInsertAfterFirstNotConnect.isEmpty()){
                        insert taskListToInsertAfterFirstNotConnect;
                    }
                    system.debug('leadIdByNotConnectedTaskCount-->'+leadIdByNotConnectedTaskCount);
                    if(!leadIdByNotConnectedTaskCount.isEmpty()){
                        List<Lead__C> leadListToBeMarkedasDropped = new List<Lead__C>();
                        
                        for(string leadid : leadIdByNotConnectedTaskCount.keyset()){
                            system.debug('leadIdByNotConnectedTaskCount.get(leadId)-->'+leadIdByNotConnectedTaskCount.get(leadId));
                            //if 2 not connected
                            if(leadIdByNotConnectedTaskCount.get(leadId) == 2){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.thirdCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadid;
                                taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                                taskRec.ActivityDate = system.today();
                                taskrec.IsReminderSet = true;
                                taskrec.ReminderDateTime = System.now().addMinutes(115);
                                taskListToInsertAfterNotConnect.add(taskRec);
                            }
                            //if 3 not connected
                            else if(leadIdByNotConnectedTaskCount.get(leadId) == 3){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.forthCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadid;
                                taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                                taskRec.ActivityDate = system.today().addDays(1);
                                taskrec.IsReminderSet = true;
                                Time timeInstance = Time.newInstance(11, 0, 0, 0);
                                taskrec.ReminderDateTime = dateTime.newInstance(system.today().addDays(1), timeInstance);
                                taskListToInsertAfterNotConnect.add(taskRec); 
                            }
                            //if 4 not connected
                            else if(leadIdByNotConnectedTaskCount.get(leadId) == 4){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.fifthCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadid;
                                taskrec.OwnerId = leadIdByLeadOwnerId.get(leadid);
                                taskRec.ActivityDate = system.today().addDays(1);
                                taskrec.IsReminderSet = true;
                                Time timeInstance = Time.newInstance(11, 0, 0, 0);
                                taskrec.ReminderDateTime = dateTime.newInstance(system.today().addDays(2), timeInstance);
                                taskListToInsertAfterNotConnect.add(taskRec); 
                            }
                            //if 5 not connected
                            else if(leadIdByNotConnectedTaskCount.get(leadId) == 5){
                                Lead__c leadRecToMarkDrop = new Lead__c();
                                leadRecToMarkDrop.Id = leadid;
                                leadRecToMarkDrop.Lead_Stage__c = ConstantClass.LeadStageDrop;
                                leadRecToMarkDrop.Lead_Substage__c = 'Ringing no response';
                                leadListToBeMarkedasDropped.add(leadRecToMarkDrop);
                            }
                        }
                        system.debug('leadListToBeMarkedasDropped--->'+leadListToBeMarkedasDropped);
                        
                        system.debug('taskListToInsertAfterNotConnect-->'+taskListToInsertAfterNotConnect);
                        if(!taskListToInsertAfterNotConnect.isEmpty()){
                            system.debug('inside inserting task');
                            insert taskListToInsertAfterNotConnect;
                            system.debug('taskListToInsertAfterNotConnect-->'+taskListToInsertAfterNotConnect);
                        }
                        if(!leadListToBeMarkedasDropped.isEmpty()){
                            system.debug('inside updating Task task');
                            update leadListToBeMarkedasDropped;
                            system.debug('leadListToBeMarkedasDropped-->'+leadListToBeMarkedasDropped);
                        }
                    }
                }
            }
            if(!setOfCalledLeadIds.isEmpty()){ 
                existingLeadList = [Select Id,(Select Id,Status,CreatedDate From Tasks where (Subject Like '%call%' or Call_ID__c != null or Subject Like '%Call%' or Subject Like 'call%' or Subject Like 'Call%') and status = 'Open') From Lead__c where Id In:setOfCalledLeadIds];
                system.debug('existingLeadList--->'+existingLeadList);
                if(!existingLeadList.isEmpty()){
                    for(Lead__c ld : existingLeadList){
                        if(!ld.Tasks.isEmpty()){
                            for(Task taskRec : ld.Tasks){
                                system.debug('taskRec.CreatedDate--->'+taskRec.CreatedDate);
                                system.debug('system.now().addminutes(-1)--->'+system.now().addminutes(-1));
                                if(taskRec.CreatedDate < system.now().addminutes(-1)){
                                    Task taskRecToMarkCompleted = new task();
                                    taskRecToMarkCompleted.Id = taskRec.Id;
                                    taskRecToMarkCompleted.Status = 'Completed';
                                    taskListToBeMarkedAsCompleted.add(taskRecToMarkCompleted);
                                }
                            }
                        }
                    }
                    system.debug('taskListToBeMarkedAsCompleted---> '+taskListToBeMarkedAsCompleted);
                    if(!taskListToBeMarkedAsCompleted.isEmpty()){
                        update taskListToBeMarkedAsCompleted;
                    }
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('TaskTriggerHelper', 'After Task Update', e, null);
        }
    }
    
}