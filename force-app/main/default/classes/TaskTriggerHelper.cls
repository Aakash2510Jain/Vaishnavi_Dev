public class TaskTriggerHelper {
    static TaskTriggerHelper handlerInstance;
    
    public static TaskTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new TaskTriggerHelper();
        return handlerInstance;
    }
    
    public void beforeInsert(List<Task> newTaskList){
        set<Id> relatedLeadIdsSet = new Set<Id>();
        Map<Id, Lead__c> leadIdbyLeadRecMap = new Map<Id, Lead__c>();
        
        for(Task taskRec : newTaskList){
            if((Id.valueOf(taskRec.WhatId)).getSObjectType().getDescribe().getName() == 'Lead__c')
                relatedLeadIdsSet.add(taskRec.WhatId);
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
        
    }
    public void afterInsert(List<Task> newTaskList){
        
    }
    public void beforeUpdate(Map<Id, Task> newTaskMap, Map<Id, Task> oldTaskMap){
        try{
            Map<Id, List<Task>> calledLeadIdByListofTaskMap = new Map<Id, List<Task>>();
            Map<Id, List<Task>> connectedLeadIdByListofTaskMap = new Map<Id, List<Task>>();
            List<Lead__c> existingConnectedLeads = new List<Lead__c>();
            List<Lead__c> existingCalledLeads = new List<Lead__c>();
            List<Lead__c> calledLeadListToUpdate = New List<Lead__c>();
            List<Lead__c> connectedLeadListToUpdate = New List<Lead__c>();
            
            for (task task : newTaskMap.values()){
                if(task.Agent_Status__c != null && task.Agent_Status__c == ConstantClass.CallTaskAgentStatusANSWERED && task.Customer_Status__c != null && (task.Customer_Status__c == ConstantClass.CallTaskCustomerStatusNOT_ANSWERED || task.Customer_Status__c == ConstantClass.CallTaskCustomerStatusNO_Answer) && task.callStatus__c == ConstantClass.CallTaskCallStatusFAIL){
                    //called
                    if(calledLeadIdByListofTaskMap.containsKey(task.WhatId)){
                        calledLeadIdByListofTaskMap.get(task.WhatId).add(task);
                        //calledLeadIdByListofTaskMap.put(task.WhatId,);
                    }else{
                        calledLeadIdByListofTaskMap.put(task.WhatId, new List<Task>{task});
                    }
                    task.Status = 'Completed';
                }
                if(task.Agent_Status__c != null && task.Customer_Status__c != null && task.Agent_Status__c == ConstantClass.CallTaskAgentStatusANSWERED && task.Customer_Status__c == ConstantClass.CallTaskCustomerStatusANSWERED && task.callStatus__c != null && task.callStatus__c == ConstantClass.CallTaskCallStatusSUCCESS
                   && task.CallDurationInSeconds != oldTaskMap.get(task.id).CallDurationInSeconds && task.CallDurationInSeconds > 5){
                       //connected
                       if(connectedLeadIdByListofTaskMap.containsKey(task.WhatId)){
                           connectedLeadIdByListofTaskMap.get(task.WhatId).add(task);
                           //connectedLeadIdByListofTaskMap.put(task.WhatId,);
                       }else{
                           connectedLeadIdByListofTaskMap.put(task.WhatId, new List<Task>{task});
                       }           
                       task.Status = 'Completed';
                   }
            }
            
            if(!calledLeadIdByListofTaskMap.isEmpty()){
                existingCalledLeads = [select id,Lead_Stage__c,Total_Calls__c, Total_Connected_Call__c,Total_Connected_Duration__c,First_Called_Date_Time__c,Last_Contacted_Date_Time__c,Is_Telephonic_Conversation_Done__c,First_Connected_Date_Time__c,Total_Call_Duration__c FROM Lead__c Where Id IN : calledLeadIdByListofTaskMap.keyset()];
                if(!existingCalledLeads.isEmpty()){
                    
                    for (Lead__c leadRec : existingCalledLeads){
                        Lead__c leadToUpdate = new Lead__c();
                        leadToUpdate.Id = leadRec.id;
                        
                        integer totalCallTime = 0;
                        integer totalCall = 0;
                        
                        if (leadRec.First_Called_Date_Time__c == null)
                            leadToUpdate.First_Called_Date_Time__c = calledLeadIdByListofTaskMap.get(leadRec.id)[0].createdDate;
                        leadToUpdate.Last_Contacted_Date_Time__c = calledLeadIdByListofTaskMap.get(leadRec.id)[0].createdDate;
                        if (calledLeadIdByListofTaskMap.containsKey(leadRec.id)){
                            for (Task taskrec : calledLeadIdByListofTaskMap.get(leadRec.id)){
                                totalCallTime += integer.valueOf(taskrec.CallDurationInSeconds) > 0 ? integer.valueOf(taskrec.CallDurationInSeconds) : 0;
                                totalCall += 1;
                            }
                            if (leadRec.Total_Call_Duration__c == null)
                                leadRec.Total_Call_Duration__c = 0;
                            leadToUpdate.Total_Call_Duration__c = totalCallTime + leadRec.Total_Call_Duration__c;
                            if (leadRec.Total_Calls__c == null)
                                leadRec.Total_Calls__c = 0;
                            leadToUpdate.Total_Calls__c = totalCall + leadRec.Total_Calls__c;
                            //handle stage
                            if(leadRec.Lead_Stage__c == ConstantClass.LeadStageNewEnquiry || leadRec.Lead_Stage__c == ConstantClass.LeadStageReEnquiry){
                                leadToUpdate.Lead_Stage__c = ConstantClass.LeadStageNotConnected;
                            }
                            calledLeadListToUpdate.add(leadToUpdate);
                            //handle drop for 5 consecutive non connects
                            /*if(leadRec.Total_Calls__c >= 5 && leadRec.Total_Connected_Call__c ==0 ){
leadRec.Lead_Stage__c = ConstantClass.LeadStageDrop;
}*/
                        }
                    }
                    if(!calledLeadListToUpdate.isEmpty()){
                        update calledLeadListToUpdate;
                    }
                }
            }
            if(!connectedLeadIdByListofTaskMap.isEmpty()){
                existingConnectedLeads = [select id,Lead_Stage__c,Total_Calls__c, Total_Connected_Call__c,Total_Connected_Duration__c,First_Called_Date_Time__c,Last_Contacted_Date_Time__c,Is_Telephonic_Conversation_Done__c,First_Connected_Date_Time__c,Total_Call_Duration__c FROM Lead__c Where Id IN : connectedLeadIdByListofTaskMap.keyset()];
                if(!existingConnectedLeads.isEmpty()){
                    
                    for (Lead__c leadRec : existingConnectedLeads){
                        Lead__c leadToUpdate = new Lead__c();
                        leadToUpdate.Id = leadRec.id;
                        leadToUpdate.Is_Telephonic_Conversation_Done__c = true;
                        integer totalCallTime = 0;
                        integer totalCall = 0;
                        integer totalConnectedCallCount = 0;
                        
                        if (leadRec.First_Called_Date_Time__c == null)
                            leadToUpdate.First_Called_Date_Time__c = connectedLeadIdByListofTaskMap.get(leadRec.id)[0].createdDate;
                        leadToUpdate.Last_Contacted_Date_Time__c = connectedLeadIdByListofTaskMap.get(leadRec.id)[0].createdDate;
                        if (leadRec.First_Connected_Date_Time__c == null)
                            leadToUpdate.First_Connected_Date_Time__c = connectedLeadIdByListofTaskMap.get(leadRec.id)[0].createdDate;
                        if (connectedLeadIdByListofTaskMap.containsKey(leadRec.id)){
                            for (Task taskrec : connectedLeadIdByListofTaskMap.get(leadRec.id)){
                                totalCallTime += integer.valueOf(taskrec.CallDurationInSeconds) > 0 ? integer.valueOf(taskrec.CallDurationInSeconds) : 0;
                                totalCall += 1;
                                totalConnectedCallCount += 1;
                            }
                            if (leadRec.Total_Call_Duration__c == null)
                                leadRec.Total_Call_Duration__c = 0;
                            leadToUpdate.Total_Call_Duration__c = totalCallTime + leadRec.Total_Call_Duration__c;
                            if (leadRec.Total_Calls__c == null)
                                leadRec.Total_Calls__c = 0;
                            leadToUpdate.Total_Calls__c = totalCall + leadRec.Total_Calls__c;
                            leadToUpdate.Total_Connected_Call__c = totalConnectedCallCount + leadRec.Total_Connected_Call__c;
                            //handle stage
                            if(leadRec.Lead_Stage__c == ConstantClass.LeadStageNewEnquiry || leadRec.Lead_Stage__c == ConstantClass.LeadStageReEnquiry || leadRec.Lead_Stage__c == ConstantClass.LeadStageNotConnected){
                                leadToUpdate.Lead_Stage__c = ConstantClass.LeadStageConnected;
                            }
                            connectedLeadListToUpdate.add(leadToUpdate);
                        }
                    }
                    if(!connectedLeadListToUpdate.isEmpty()){
                        update connectedLeadListToUpdate;
                    }
                }
            }           
        } catch (exception ex){
            system.debug('Error==>' + ex.getMessage());
            system.debug('Error==>@@' + ex.getLineNumber());
        }
    }
    public void afterUpdate(Map<Id, Task> newTaskMap, Map<Id, Task> oldTaskMap){
        
        set<id> leadIdsSet = new Set<id>();
        
        for(Task taskrec : newTaskMap.values()){
            if((taskrec.Conversation_Duration__c == 0 || taskrec.Call_ID__c != null) && taskrec.Total_Call_Duration__c != oldTaskMap.get(taskrec.Id).Total_Call_Duration__c){
                leadIdsSet.add(taskrec.WhatId);
            }
        }
        if(!leadIdsSet.isEmpty()){
            List<Task> taskListToInsertAfterFirstNotConnect = new List<Task>();
            List<Task> taskListToInsertAfterNotConnect = new List<Task>();
            Map<String,integer> leadIdByNotConnectedTaskCount = new Map<String, integer>();
            
            // get only call related tasks
            List<Lead__c> leadList = [Select Id,Lead_Stage__c,Lead_Substage__c,(Select Id,Call_ID__c,Conversation_Duration__c From Tasks where Call_ID__c != null) From Lead__c where id in : leadIdsSet and Lead_Stage__c = : ConstantClass.LeadStageNotConnected];
            if(!leadList.isEmpty()){
                for(Lead__c leadRec : leadList){
                    if(leadRec.Lead_Stage__c == ConstantClass.LeadStageNotConnected){
                        //only a single task for not connected call
                        if(leadRec.tasks.size() == 1){
                            if(leadRec.tasks[0].Conversation_Duration__c == 0){
                                Task taskRec = new Task();
                                taskRec.Subject = ConstantClass.SecondCallTAskAfterFirstNotConnect;
                                taskRec.whatId = leadRec.Id;
                                taskRec.ActivityDate = system.today();
                                taskrec.IsReminderSet = true;
                                taskrec.ReminderDateTime = System.now().addMinutes(115);
                                taskListToInsertAfterFirstNotConnect.add(taskRec);
                            }
                        }else{
                            for(Task taskRec : leadRec.tasks){
                                if(taskRec.Conversation_Duration__c == 0){
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
                if(!taskListToInsertAfterFirstNotConnect.isEmpty()){
                    insert taskListToInsertAfterFirstNotConnect;
                }
                if(!leadIdByNotConnectedTaskCount.isEmpty()){
                    List<Lead__C> leadListToBeMarkedasDropped = new List<Lead__C>();
                    
                    for(string leadid : leadIdByNotConnectedTaskCount.keyset()){
                        
                        //if 2 not connected
                        if(leadIdByNotConnectedTaskCount.get(leadId) == 2){
                            Task taskRec = new Task();
                            taskRec.Subject = ConstantClass.thirdCallTAskAfterFirstNotConnect;
                            taskRec.whatId = leadid;
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
                            leadListToBeMarkedasDropped.add(leadRecToMarkDrop);
                        }
                    }
                    if(!leadListToBeMarkedasDropped.isEmpty()){
                        update leadListToBeMarkedasDropped;
                    }
                    if(!taskListToInsertAfterNotConnect.isEmpty()){
                        insert taskListToInsertAfterNotConnect;
                    }
                }
            }
        }
    }
    
}