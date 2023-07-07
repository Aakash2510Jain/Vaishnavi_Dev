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
}