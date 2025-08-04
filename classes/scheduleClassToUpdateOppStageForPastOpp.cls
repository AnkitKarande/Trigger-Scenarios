public class scheduleClassToUpdateOppStageForPastOpp implements Schedulable{
    public void execute(SchedulableContext SC){
        Database.executeBatch(new batchClassToUpdateOppStageForPastOpp(),200);
    }
}