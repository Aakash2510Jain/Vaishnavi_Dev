public class TaskTriggerHelper {
    static TaskTriggerHelper handlerInstance;
    
    public static TaskTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new TaskTriggerHelper();
        return handlerInstance;
    }
    
    public void beforeInsert(List<Task> newTaskList){
        set<Id> connectedLeadIds = new Set<Id>();
        set<Id> calledLeadIds = new Set<Id>();
        List<Lead__c> existingConnectedLeads = new List<Lead__c>();
        List<Lead__c> existingCalledLeads = new List<Lead__c>();
        List<Lead__c> leadToBeUpdatedAsConnected = new List<Lead__c>();
        List<Lead__c> leadToBeUpdatedAsCalled = new List<Lead__c>();
        
        if(!newTaskList.isEmpty()){
            for(Task taskRec : newTaskList){
                system.debug('taskRec.Subject--->'+taskRec.Subject);
                if((taskRec.Subject).containsIgnoreCase(ConstantClass.TaskSubjectForConnectedCall)){
                    connectedLeadIds.add(taskRec.WhatId);
                }
                if((taskRec.Subject).containsIgnoreCase(ConstantClass.TaskSubjectForCalledCall)){
                    calledLeadIds.add(taskRec.WhatId);
                }
            }   
            system.debug('connectedLeadIds--->'+connectedLeadIds);
            if(!connectedLeadIds.isEmpty()){
                existingConnectedLeads = [Select Id,Lead_Stage__c,Total_Calls__c,Total_Connected_Call__c,Total_Connected_Duration__c From Lead__c where (Lead_Stage__c =: ConstantClass.LeadStageNewEnquiry OR Lead_Stage__c =: ConstantClass.LeadStageReEnquiry OR Lead_Stage__c =: ConstantClass.LeadStageNotConnected) and Id In : connectedLeadIds limit 1000];
                if(!existingConnectedLeads.isEmpty()){
                    for(Lead__c leadRec : existingConnectedLeads){
                        Lead__c leadRecToMarkConnected = new Lead__c();
                        leadRecToMarkConnected.Id = leadRec.Id;
                        leadRecToMarkConnected.Lead_Stage__c = ConstantClass.LeadStageConnected;
                        leadToBeUpdatedAsConnected.add(leadRecToMarkConnected);
                    }
                    if(!leadToBeUpdatedAsConnected.isEmpty()){
                        update leadToBeUpdatedAsConnected;
                    }
                }
            }
            if(!calledLeadIds.isEmpty()){
                existingCalledLeads = [Select Id,Lead_Stage__c,Total_Calls__c,Total_Connected_Call__c,Total_Connected_Duration__c From Lead__c where (Lead_Stage__c =: ConstantClass.LeadStageNewEnquiry OR Lead_Stage__c =: ConstantClass.LeadStageReEnquiry) and Id In : calledLeadIds limit 1000];
                if(!existingCalledLeads.isEmpty()){
                    for(Lead__c leadRec : existingCalledLeads){
                        Lead__c leadRecToMarkCalled = new Lead__c();
                        leadRecToMarkCalled.Id = leadRec.Id;
                        leadRecToMarkCalled.Lead_Stage__c = ConstantClass.LeadStageNotConnected;
                        leadToBeUpdatedAsCalled.add(leadRecToMarkCalled);
                    }
                    if(!leadToBeUpdatedAsCalled.isEmpty()){
                        update leadToBeUpdatedAsCalled;
                    }
                }
            }
        }            
    }
    public void afterInsert(List<Task> newTaskList){
        
    }
    public void beforeUpdate(Map<Id, Task> newTaskMap, Map<Id, Task> oldTaskMap){
        try{
            set<Id> leadIdset = New set<Id>();
            List<Lead__c> leadList = new list<Lead__c>();
            List<Lead__c> LeadListToUpdate = New List<Lead__c>();
            Map<Id, List<Task>> taskByLeadId = new Map<Id, List<Task>>();
            
            for (task task : newTaskMap.values()){
                if (task.CallDurationInSeconds != null && task.CallDurationInSeconds != oldTaskMap.get(task.id).CallDurationInSeconds  && task.CallDurationInSeconds > oldTaskMap.get(task.id).CallDurationInSeconds){
                    if (taskByLeadId.containsKey(task.WhatId))
                        taskByLeadId.get(task.WhatId).add(task);
                    else
                        taskByLeadId.put(task.WhoId, new list<Task>{ task });
                    //task.Status = 'Completed';
                }
            }
            
            if (!taskByLeadId.isEmpty()){
                leadList = [select id, Total_Calls__c, Total_Connected_Call__c,Total_Connected_Duration__c,First_Called_Date_Time__c,First_Connected_Date_Time__c FROM Lead__c Where Id IN : taskByLeadId.keySet()];
                if (!leadList.isEmpty()){
                    for (Lead__c leadRec : leadList){
                        Lead__c leadToUpdate = new Lead__c();
                        leadToUpdate.Id = leadRec.id;
                        
                        integer callTime = 0;
                        integer talkTime = 0;
                        integer totalCall = 0;
                        integer connectedCallCount = 0;
                        
                        if (leadRec.First_Called_Date_Time__c == null)
                            leadToUpdate.First_Called_Date_Time__c = taskByLeadId.get(leadRec.id)[0].createdDate;
                        leadToUpdate.Last_Contacted_Date_Time__c = taskByLeadId.get(leadRec.id)[0].createdDate;
                        if (taskByLeadId.containsKey(leadRec.id)){
                            for (Task taskrec : taskByLeadId.get(leadRec.id)){
                                callTime += integer.valueOf(taskrec.CallDurationInSeconds) > 0 ? integer.valueOf(taskrec.CallDurationInSeconds) : 0;
                                totalCall += 1;
                                if (taskrec.CallDurationInSeconds != null && integer.valueOf(taskrec.CallDurationInSeconds) > 0){
                                    if (leadRec.First_Connected_Date_Time__c == null)
                                        leadToUpdate.First_Connected_Date_Time__c = taskByLeadId.get(leadRec.id)[0].createdDate;
                                    talkTime += integer.valueOf(taskrec.CallDurationInSeconds) > 0 ? integer.valueOf(taskrec.CallDurationInSeconds) : 0;
                                    //leadToUpdate.Last_Called_Date_Time__c = taskByLeadId.get(leadRec.id)[0].Activity_Date_Time__c;
                                    connectedCallCount += 1;
                                }
                            }
                            if (leadRec.Total_Call_Duration__c == null)
                                leadRec.Total_Call_Duration__c = 0;
                            leadToUpdate.Total_Call_Duration__c = callTime + leadRec.Total_Call_Duration__c;
                            if (leadRec.Total_Connected_Duration__c == null)
                                leadRec.Total_Connected_Duration__c = 0;
                            leadToUpdate.Total_Connected_Duration__c = talkTime + leadRec.Total_Connected_Duration__c;
                            if (leadRec.Total_Calls__c == null)
                                leadRec.Total_Calls__c = 0;
                            leadToUpdate.Total_Calls__c = totalCall + leadRec.Total_Calls__c;
                            if (leadRec.Total_Connected_Call__c == null)
                                leadRec.Total_Connected_Call__c = 0;
                            leadToUpdate.Total_Connected_Call__c = connectedCallCount + leadRec.Total_Connected_Call__c;
                            
                            LeadListToUpdate.add(leadToUpdate);
                        }
                    }
                    if (!LeadListToUpdate.isEmpty()){
                        update LeadListToUpdate;
                    }
                }
            }
        } catch (exception ex){
            system.debug('Error==>' + ex.getMessage());
            system.debug('Error==>@@' + ex.getLineNumber());
        }
    }
    public void afterUpdate(List<Task> newTaskList){
        
    }
    
}