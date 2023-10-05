global class ScheduleBatchToMakrTaskAsOverdue implements Schedulable{
    global void execute(SchedulableContext sc){
        BatchToMakrTaskAsOverdue batchInstance = new BatchToMakrTaskAsOverdue();
        database.executeBatch(batchInstance);
    }
}