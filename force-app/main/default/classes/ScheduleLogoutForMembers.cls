global class ScheduleLogoutForMembers implements Schedulable{
    global void execute(SchedulableContext sc){
        BuildMaps.makeAllMemberOOF();
    }
}