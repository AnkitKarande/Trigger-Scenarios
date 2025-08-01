public class SubscriberTriggerHandlerForPwcScenario1 {
    public static void beforeInsert(List<subscriber__c> subscriberList){
        Set<Id> subsAccountId = new Set<Id>();
        for(subscriber__c currentSubscriber : subscriberList){
            if(currentSubscriber.Account__c != null){
                subsAccountId.add(currentSubscriber.Account__c);
            }
            currentSubscriber.Recent__c = true;
        }
        if(subsAccountId.isEmpty()) return;
        List<subscriber__c> otherSubscriberList = [SELECT Id,Account__c,Recent__c from subscriber__c Where Account__c IN :subsAccountId];
        for(subscriber__c currentSubscriber : otherSubscriberList){
            currentSubscriber.Recent__c = false;
        }
        try{
        	update otherSubscriberList;    
        }catch(Exception e){
            System.debug('Exception occured when updating the other old subscriber '+e.getMessage());
        }     
    }
    public static void beforeDelete(List<Subscriber__c> subscriberList){
        Set<Id> subsAccountIds = new Set<Id>();
        Set<Id> deletedSubscriberIds = new Set<Id>();
        Map<Id,Subscriber__c> accountIdToSubscriberMap = new Map<Id,Subscriber__c>();
        for(subscriber__c currentSubscriber : subscriberList){
            if(currentSubscriber.Account__c != null){
                subsAccountIds.add(currentSubscriber.Account__c);
                deletedSubscriberIds.add(currentSubscriber.Id);
            }
        }
        if(subsAccountIds.isEmpty()) return;
        List<Subscriber__c> otherSubscriberList = [SELECT Id,Account__c,Recent__c from Subscriber__c Where Account__c IN :subsAccountIds 
                                                  AND Id Not IN :deletedSubscriberIds Order By CreatedDate DESC];
        for(Subscriber__c currentSubscriber : otherSubscriberList){
            if(!accountIdToSubscriberMap.containsKey(currentSubscriber.Account__c)){
                accountIdToSubscriberMap.put(currentSubscriber.Account__c,currentSubscriber);
            }
        }
        List<Subscriber__c> updateSubscriberList = new List<Subscriber__c>();
        for(Subscriber__c currentSubscriber : accountIdToSubscriberMap.Values()){
            currentSubscriber.Recent__c = true;
            updateSubscriberList.add(currentSubscriber);
        }
        if(!updateSubscriberList.isEmpty()){
            update updateSubscriberList;
        }
    }
}