public class SiteVisitTriggerHelper {
    static SiteVisitTriggerHelper handlerInstance;
    
    public static SiteVisitTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new SiteVisitTriggerHelper();
        return handlerInstance;
    }
    public void afterInsert(Map<Id, Visit__c> newVisitmap){
        try{
            set<Id> convertedSiteVisitIds = new Set<Id>();
            
            for(Visit__c visitRec : newVisitmap.values()){
                if(visitRec.Lead__c != null){
                    convertedSiteVisitIds.add(visitRec.Lead__c);
                }
            }
            if(!convertedSiteVisitIds.isEmpty()){
                EmailIUtility.notifyVaishnaviTeam(convertedSiteVisitIds,'Customer Visited Site');
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('SiteVisitTriggerHelper', 'After Site Visit Insert', e, null);
        }
    }
}