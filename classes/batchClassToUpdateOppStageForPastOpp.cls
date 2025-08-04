public class batchClassToUpdateOppStageForPastOpp implements Database.Batchable<sObject>{
    public QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Name, CloseDate, StageName from Opportunity Where CloseDate = LAST_N_DAYS:30');
    }

    public void execute(Database.BatchableContext BC, List<Opportunity> OpportunityList){
        List<Opportunity> updateOpportunityList = new List<Opportunity>();

        for(Opportunity currentOpportunity : OpportunityList){
            if(currentOpportunity.StageName != 'Closed Won' && currentOpportunity.StageName != 'Closed Lost' &&  currentOpportunity.CloseDate < (Date.today().addDays(-30))){
                currentOpportunity.StageName = 'Closed Lost';
                updateOpportunityList.add(currentOpportunity);
            }
        }
        if(!updateOpportunityList.isEmpty()){
            update updateOpportunityList;
        }
    }

    public void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'admin@email.com'});
        email.setSubject('Batch Job Completed: Opportunity Stage Updated');
        email.setPlainTextBody('Hi,\n\n' +
        'The scheduled batch job has successfully updated Opportunities to "Closed Lost" ' +
        'where the Close Date was more than 30 days old.\n\n' +
        'This helps maintain accurate pipeline data and ensures outdated opportunities are handled.\n\n' +
        'Regards,\nSalesforce Automation');

        Messaging.sendEmail(email);
    }
}