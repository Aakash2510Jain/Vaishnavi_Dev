public without sharing class BatchToMakrTaskAsOverdue implements database.batchable<sObject>{
    public database.queryLocator start(database.batchableContext bc){
        return database.getQueryLocator([Select Id From Task where Status = 'Open' and Due_Date_Time__c <: system.now() ]);
    }
    public void execute(database.batchableContext bc, List<task> taskList){
        List<Task> taskListToUpdated = new List<task>();
        
        if(!taskList.isEmpty()){
            for(Task taskRec : taskList){
                Task taskRecToUpdate = new Task();
                taskRecToUpdate.Id = taskRec.Id;
                taskRecToUpdate.Status = ConstantClass.TaskStatusAsOverdue;
                taskListToUpdated.add(taskRecToUpdate);
            }  
            if(!taskListToUpdated.isEmpty()){
                update taskListToUpdated;
            }
        }
          
    }
    public void finish(database.batchableContext bc){
    }
}