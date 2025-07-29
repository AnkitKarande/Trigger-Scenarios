trigger AccountTriggerForWiproScenario1 on Account (After insert, Before Delete) {
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            AccountTriggerHandlerForWiproScenario1.deleteAccountCase(Trigger.old);
        }
    }
}