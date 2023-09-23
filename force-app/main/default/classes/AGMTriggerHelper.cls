public class AGMTriggerHelper {
    static AGMTriggerHelper handlerInstance;
    
    public static AGMTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new AGMTriggerHelper();
        return handlerInstance;
    }
    public void afterUpdate(Map<Id, Assignment_Group_Member__c> newAGMMap,Map<Id, Assignment_Group_Member__c> oldAGMMap ){
        Set<Id> forAGMGoingOFF = new Set<Id>();
        Set<Id> forAGMGoingON = new Set<Id>();
        List<Assignment_Group__c> assignmentGroupList = new List<Assignment_Group__c>();
        List<Assignment_Group__c> assignmentGroupListToUpdate = new List<Assignment_Group__c>();
        List<Assignment_Group_Member__c> agmListToUpdate = new List<Assignment_Group_Member__c>();
        
        for(Assignment_Group_Member__c agmRec : newAGMMap.values()){
            if(agmRec.Out_Of_Office__c != oldAGMMap.get(agmRec.Id).Out_Of_Office__c){
                if(agmRec.Out_Of_Office__c == true && agmRec.Assignment_Group__c != null){
                    forAGMGoingOFF.add(agmRec.Assignment_Group__c);
                }
                if(agmRec.Out_Of_Office__c == false && agmRec.Assignment_Group__c != null){
                    forAGMGoingON.add(agmRec.Assignment_Group__c);
                }
            }
        }
        if(!forAGMGoingOFF.isEmpty()){
            assignmentGroupList = [Select Id,Last_Allocated_RRid__c,(Select Id,Out_Of_Office__c,Assignment_Id__c,Group_Member__r.Name From Assignment_Group_Members__r ORDER BY Out_Of_Office__c DESC) From Assignment_Group__c where Id In : forAGMGoingOFF];
            if(!assignmentGroupList.isEmpty()){
                for(Assignment_Group__c AG : assignmentGroupList){
                    
                    integer i = 1;
                    for(Assignment_Group_Member__c agmRec : AG.Assignment_Group_Members__r){
                        system.debug('agmRec.Group_Member__r.Name--> '+agmRec.Group_Member__r.Name);
                        Assignment_Group_Member__c agmRecToUpdate = new Assignment_Group_Member__c();
                        agmRecToUpdate.id = agmRec.Id;
                        agmRecToUpdate.Assignment_Id__c = i;
                        agmListToUpdate.add(agmRecToUpdate);
                        i++;
                    }
                }
                update agmListToUpdate;
            }
        }
        if(!forAGMGoingON.isEmpty()){
            assignmentGroupList = [Select Id,Last_Allocated_RRid__c,(Select Id,Out_Of_Office__c,Assignment_Id__c,Group_Member__r.Name From Assignment_Group_Members__r ORDER BY Out_Of_Office__c ASC) From Assignment_Group__c where Id In : forAGMGoingON];
            if(!assignmentGroupList.isEmpty()){
                for(Assignment_Group__c AG : assignmentGroupList){
                    integer i = 1;
                    for(Assignment_Group_Member__c agmRec : AG.Assignment_Group_Members__r){
                        system.debug('agmRec.Group_Member__r.Name--> '+agmRec.Group_Member__r.Name);
                        Assignment_Group_Member__c agmRecToUpdate = new Assignment_Group_Member__c();
                        agmRecToUpdate.id = agmRec.Id;
                        agmRecToUpdate.Assignment_Id__c = i;
                        agmListToUpdate.add(agmRecToUpdate);
                        i++;
                    }
                }
                update agmListToUpdate;
            }
        }
    }
}