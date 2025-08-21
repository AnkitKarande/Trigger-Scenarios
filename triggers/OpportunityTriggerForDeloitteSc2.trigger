trigger OpportunityTriggerForDeloitteSc2 on Opportunity (after insert, after update, after delete, after undelete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            OpportunityTriggerHandlerForDeloitteSc2.afterInsert(Trigger.new);
        }else if(Trigger.isUpdate){
            OpportunityTriggerHandlerForDeloitteSc2.afterUpdate(Trigger.new,Trigger.oldMap);
        }else if(Trigger.isDelete){
            OpportunityTriggerHandlerForDeloitteSc2.afterDelete(Trigger.old);
        }else if(Trigger.isUndelete){
            OpportunityTriggerHandlerForDeloitteSc2.afterUndelete(Trigger.new);
        }
    }
}