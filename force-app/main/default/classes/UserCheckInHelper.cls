public with sharing class UserCheckInHelper {
       @AuraEnabled(cacheable = true)
    public static UserTrack OnpageLoad(string userId){
        UserTrack usr = new UserTrack();

        User xUser = [Select Name
                      From User
                      where Id = :UserInfo.getUserId()];

        list<User_Tracking__c> userTracking = [select id, Checkin_Datetime__c, Checkout_Datetime__c, BreakTime_Started__c, Member__c
                                               from User_Tracking__c
                                               where Member__c = :userId and CreatedDate = TODAY
                                               limit 1];
        if (!userTracking.isEmpty()){
            //if(System.now().time() > Time.newInstance(14, 45, 00, 00))
            usr.IsbreakStarted = userTracking[0].BreakTime_Started__c;
            usr.checkin = true;
            if (userTracking[0].Checkout_Datetime__c != null)
                usr.checkout = true;
            else
                usr.checkout = false;
        } else{
            usr.checkin = false;
            usr.checkout = true;
        }

        usr.username = xUser.Name;

        return usr;
    }

    @AuraEnabled
    public static String UserCheckin(string userId){


        List<Lead> leadList = new List<Lead>();
        String eventStatus = 'Something went wrong';
        string groupName = '';
        DateTime dt = DateTime.now();
        
        String dayOfWeek = dt.format('EEEE');
        /*if(dayOfWeek == 'Sunday'){
         eventStatus = 'You can not checkin on sunday.';
         return eventStatus;
         }*/
		map<string, string> mapofGroupNameBySourceIntent = new map<string, string>();
        if (userId != null){
            boolean isTaskAssignmentGroupMember = false;
            list<User_Tracking__c> userTracking = new list<User_Tracking__c>();
            list<Assignment_Group_Member__c> agmList = new list<Assignment_Group_Member__c>();
            userTracking = [select id, Checkin_Datetime__c, Checkout_Datetime__c, Member__c
                            from User_Tracking__c
                            where Member__c = :userId and CreatedDate = TODAY
                            limit 1];
           
            if (userTracking.isEmpty()){
               
                User_Tracking__c userTrackRec = new User_Tracking__c();
                userTrackRec.Member__c = userId;
                userTrackRec.Checkin_Datetime__c = DateTime.now();
                insert userTrackRec;
                if (!agmList.isEmpty()){
                    for (Assignment_Group_Member__c agm : agmList){
                        agm.Out_Of_Office__c = false;
                    }

                    update agmList;
					
                  
                    /*BatchToAssignLeadsFromQueue batchInstance = new BatchToAssignLeadsFromQueue();
                     database.executeBatch(batchInstance);*/

                }
				LeadAssignmentExecutionCriteria.validateEntryCriteria(); 
                eventStatus = 'Checkin successful';
            } else{
                eventStatus = 'Your checkin was already created.';
            }

        } else{
            eventStatus = 'User is not registered in system.Please contact to your admin.';
        }


        return eventStatus;
    }

    @AuraEnabled
    public static String UserCheckout(string userId){
        String eventStatus = 'Something went wrong';
        if (userId != null){
            list<User_Tracking__c> userTracking = new list<User_Tracking__c>();
            list<Assignment_Group_Member__c> agmList = new list<Assignment_Group_Member__c>();
            userTracking = [select id, Checkin_Datetime__c, Checkout_Datetime__c, Member__c
                            from User_Tracking__c
                            where Member__c = :userId and createddate = TODAY
                            limit 1];
            agmList = [select id, Group_Member__c
                       from Assignment_Group_Member__c
                       where Group_Member__c = :userId];
            if (!userTracking.isEmpty()){
                for (User_Tracking__c ut : userTracking){
                    ut.Checkout_Datetime__c = DateTime.now();
                }
                update userTracking;
                if (!agmList.isEmpty()){
                    for (Assignment_Group_Member__c agm : agmList){
                        agm.Out_Of_Office__c = true;
                        agm.BreakTime_Started__c = false;
                    }

                    update agmList;
                }
                eventStatus = 'Checkout datetime has been updated.';
            } else{
                eventStatus = 'You can not checkout without checkin.';
            }

        } else{
            eventStatus = 'User is not registered in system.Please contact to your admin.';
        }


        return eventStatus;
    }

    @AuraEnabled
    public static void manageBreakTime(string userId){
        UserTrack usr = new UserTrack();
        List<Assignment_Group_Member__c> agmListToBeUpdated = new List<Assignment_Group_Member__c>();
        list<User_Tracking__c> userTracking = [select id, BreakTime_Started__c, Checkin_Datetime__c, Checkout_Datetime__c, Member__c
                                               from User_Tracking__c
                                               where Member__c = :userId and CreatedDate = TODAY
                                               limit 1];
        List<Assignment_Group_Member__c> agmList = [Select Id, BreakTime_Started__c
                                                    From Assignment_Group_Member__c
                                                    where Group_Member__c = :userId];
        if (!userTracking.isEmpty()){
            userTracking[0].BreakTime_Started__c = !userTracking[0].BreakTime_Started__c;
            update userTracking[0];
        }
        if (!agmList.isEmpty()){
            for (Assignment_Group_Member__c agm : agmList){
                Assignment_Group_Member__c agmRec = new Assignment_Group_Member__c();
                agmRec.Id = agm.Id;
                agmRec.BreakTime_Started__c = !agm.BreakTime_Started__c;
                agmListToBeUpdated.add(agmRec);
            }
            if (!agmListToBeUpdated.isEmpty()){
                update agmListToBeUpdated;
            }
        }
    }

    public class UserTrack{
        @AuraEnabled
        public boolean checkin;
        @AuraEnabled
        public boolean checkout;
        @AuraEnabled
        public boolean IsbreakStarted;
        @AuraEnabled
        public String username;

    }

}