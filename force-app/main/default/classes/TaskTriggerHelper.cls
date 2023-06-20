public class TaskTriggerHelper {
    static TaskTriggerHelper handlerInstance;
    
    public static TaskTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new TaskTriggerHelper();
        return handlerInstance;
    }
    
    public void beforeInsert(List<Task> newTaskList){
      
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
    public void afterUpdate(List<Task> newTaskList){
        
    }
    
}