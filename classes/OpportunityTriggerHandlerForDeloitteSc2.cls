public with sharing class OpportunityTriggerHandlerForDeloitteSc2 {

    public class OpportunityCount {
        public Integer closedCount = 0;
        public Integer openCount = 0;
    }

    public static void afterInsert(List<Opportunity> opportunityList){
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity currentOpportunity : opportunityList){
            if(currentOpportunity.AccountId != null){
                accountIds.add(currentOpportunity.AccountId);
            }
        }
        if(!accountIds.isEmpty()){
            calculateOpportunityCount(accountIds);
        }
    }
    public static void afterUpdate(List<Opportunity> opportunityList,Map<Id,Opportunity> OpportunityOldMap){
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity currentOpportunity : opportunityList){
            if(currentOpportunity.AccountId != null 
                && currentOpportunity.stageName != OpportunityOldMap.get(currentOpportunity.Id).stageName){
                    accountIds.add(currentOpportunity.AccountId);
                }
        }
        if(!accountIds.isEmpty()){
            calculateOpportunityCount(accountIds);
        }
    }
    public static void afterDelete(List<Opportunity> opportunityList){
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity currentOpportunity : opportunityList){
            if(currentOpportunity.AccountId != null){
                accountIds.add(currentOpportunity.AccountId);
            }
        }
        if(!accountIds.isEmpty()){
            calculateOpportunityCount(accountIds);
        }
    }
    public static void afterUndelete(List<Opportunity> opportunityList){
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity currentOpportunity : opportunityList){
            if(currentOpportunity.AccountId != null){
                accountIds.add(currentOpportunity.AccountId);
            }
        }
        if(!accountIds.isEmpty()){
            calculateOpportunityCount(accountIds);
        }
    }

    public static void calculateOpportunityCount(Set<Id> accountIds){

        List<Account> updateAccountList = new List<Account>();
        List<Opportunity> opportunityList = [SELECT Id,AccountId,StageName from Opportunity Where AccountId IN :accountIds];
        Map<Id,OpportunityCount> accountIdOpportunityCountMap = new Map<Id,OpportunityCount>();
        for(Opportunity currentOpportunity : opportunityList){
            if(!accountIdOpportunityCountMap.containsKey(currentOpportunity.AccountId)){
                accountIdOpportunityCountMap.put(currentOpportunity.AccountId,new OpportunityCount());
            }
            System.debug('==Initial'+accountIdOpportunityCountMap);
            if(currentOpportunity.stageName == 'Closed Won' || currentOpportunity.stageName == 'Closed Lost'){
                accountIdOpportunityCountMap.get(currentOpportunity.AccountId).closedCount++;
            }else{
                accountIdOpportunityCountMap.get(currentOpportunity.AccountId).openCount++;
            }
            System.debug('==After'+accountIdOpportunityCountMap);
        }

        for(Id accountId : accountIdOpportunityCountMap.keySet()){
            Account accountRecord = new Account(Id=accountId);
            accountRecord.Close_Opportunities__c = accountIdOpportunityCountMap.get(accountId).closedCount;
            accountRecord.Open_Opportunities__c = accountIdOpportunityCountMap.get(accountId).openCount;
            updateAccountList.add(accountRecord);
        }

        if(!updateAccountList.isEmpty()){
            update updateAccountList;
        }
    }
}