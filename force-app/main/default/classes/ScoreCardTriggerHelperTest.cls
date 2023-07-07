@isTest
public class ScoreCardTriggerHelperTest {
	@isTest
    static void beforeInsert(){
        List<Scorecard__c> newList = new List<Scorecard__c>();
        List<Scorecard__c> oldList = new List<Scorecard__c>();
        
        for (Integer i = 0; i < 5; i++) {
            Scorecard__c scorecard = new Scorecard__c();
            scorecard.Enabled__c = true;
            newList.add(scorecard);
        }
        insert newList;
        
        Test.startTest();
        ScoreCardTriggerHelper.beforeInsert(newList, oldList);
        Test.stopTest(); 
    }
}