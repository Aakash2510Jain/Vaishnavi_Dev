public class AccountTriggerHelper {
    static AccountTriggerHelper handlerInstance;
    
    public static AccountTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new AccountTriggerHelper();
        return handlerInstance;
    }
    
    public void afterInsert(Map<Id, Account> newAccountMap){
        Map<Id,Account> accountIdbyAccountMap = new Map<Id,Account>();
        List<Opportunity__c> opportunityListToInsert = new List<Opportunity__c>();
        List<Contact> ContactList = new List<Contact>();
        Map<string, string> leadIdByAccountId = new Map<string, string>();
        List<Task> existingTaskList = new List<Task>();
        List<Task> taskToLinkToAccount = new List<Task>();
        
        if(!newAccountMap.isEmpty()){
            for(Account accountRecord : newAccountMap.values()){
                if(accountRecord.Lead__c != null){
                    accountIdbyAccountMap.put(accountRecord.Id, accountRecord);
                    leadIdByAccountId.put(accountRecord.Lead__c, accountRecord.Id);
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
                    opportunityRec.Opportunity_Name__c = accountIdbyAccountMap.get(accountId).Name;
                    opportunityRec.Lead_Source__c = accountIdbyAccountMap.get(accountId).AccountSource;
                    opportunityRec.Lead_Sub_Source__c = accountIdbyAccountMap.get(accountId).Sub_Source__c;
                    opportunityRec.Lead_Source_Type__c = accountIdbyAccountMap.get(accountId).Source_Type__c;
                    opportunityListToInsert.add(opportunityRec);
                }
                if(!ContactList.isEmpty()){
                    insert ContactList;
                }
                if(!opportunityListToInsert.isEmpty()){
                    insert opportunityListToInsert;
                }
            }
            if(!leadIdByAccountId.isEmpty()){
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
            }
        }
    }
}