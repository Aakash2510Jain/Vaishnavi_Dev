@isTest
public class TriggerTestClass {
    @isTest
    public static void testAfterInsert() {
        Explorer_Configuration__c  accDocConfig = new Explorer_Configuration__c();
        accDocConfig.Name = 'Channel Partner';
        accDocConfig.Folders__c = 'RERA;PAN;Aadhar;GST;CP Agreement;GST Declaration';
        //.getValues('Channel Partner');
        insert accDocConfig;
        Channel_Partner__c cp = new Channel_Partner__c();
        cp.CP_Name__c = 'Testing Channel Partner';
        insert cp;
    }   
    @isTest(seeallData = true)
    public static void testAfterUpdateAGM() {
        Assignment_Group_Member__c agmRec = [Select Id,Active__c From Assignment_Group_Member__c limit 1];
        if(agmRec.Active__c){
            agmRec.Active__c = false;
        }else{
            agmRec.Active__c = true;
        }
        update agmRec;
    }   
}