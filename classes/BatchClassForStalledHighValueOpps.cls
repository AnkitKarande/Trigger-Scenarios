public with sharing class BatchClassForStalledHighValueOpps implements Database.Batchable<sObject>, Database.Stateful {
    
    private Integer highValueDealCount = 0;

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id,Name,LastStageChangeDate,StageName,OwnerId,Amount '
                +'from Opportunity Where LastStageChangeDate < LAST_N_DAYS:10'
                +'AND StageName != \'Closed Won\' AND StageName != \'Closed Lost\'');
    }
    public void execute(Database.BatchableContext BC, List<Opportunity> opportunityList){

        List<Task> newTaskList = new List<Task>();
        for(Opportunity currentOpportunity : opportunityList){
            if(currentOpportunity.Amount > 100000){
                Task taskRecord = new Task();
                    taskRecord.Subject = 'High-value deal stuck – immediate follow-up required.';
                    taskRecord.Status = 'Not Started';
                    taskRecord.Priority = 'High';
                    taskRecord.WhatId = currentOpportunity.Id;
                    taskRecord.OwnerId = currentOpportunity.OwnerId;
                newTaskList.add(taskRecord);
                highValueDealCount++;
            }
        }
        if(!newTaskList.isEmpty()){
            insert newTaskList;
        }
    }
    public void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Stalled High-Value Deals Reminder');
        mail.setPlainTextBody('There are ' + highValueDealCount 
                            +' high-value opportunities stalled for more than 10 days. ' 
                            + 'Please review the pipeline and follow up with sales reps.');
        mail.setToAddresses(new String[]{'salesmanager@mail.com'});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }

}