trigger SubscriberTriggerForPwcScenario1 on Subscriber__c (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            SubscriberTriggerHandlerForPwcScenario1.beforeInsert(trigger.new);
        }
        if(Trigger.isDelete){
            SubscriberTriggerHandlerForPwcScenario1.beforeDelete(trigger.old);
        }
    }
}