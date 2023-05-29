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
                existingConnectedLeads = [Select Id,Lead_Stage__c From Lead__c where (Lead_Stage__c =: ConstantClass.LeadStageNewEnquiry OR Lead_Stage__c =: ConstantClass.LeadStageReEnquiry OR Lead_Stage__c =: ConstantClass.LeadStageNotConnected) and Id In : connectedLeadIds limit 1000];
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
                existingCalledLeads = [Select Id,Lead_Stage__c From Lead__c where (Lead_Stage__c =: ConstantClass.LeadStageNewEnquiry OR Lead_Stage__c =: ConstantClass.LeadStageReEnquiry) and Id In : calledLeadIds limit 1000];
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
    public void beforeUpdate(List<Task> newTaskList){
        
    }
    public void afterUpdate(List<Task> newTaskList){
        
    }
        
}