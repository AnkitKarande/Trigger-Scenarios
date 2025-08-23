public with sharing class ScheduleClassForStalledHighValueOpps implements Schedulable{
    public void execute(SchedulableContext SC){
       String jobId = Database.executeBatch(new BatchClassForStalledHighValueOpps(),200);
       System.debug('Stalled High Value Deal Batch Class Started With ID : '+jobId);
    }
}   