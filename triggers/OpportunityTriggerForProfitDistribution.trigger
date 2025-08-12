trigger OpportunityTriggerForProfitDistribution on Opportunity (after update) {
    
    Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
    
    for(Opportunity currentOpportunity : Trigger.new){
        if(currentOpportunity.stageName == 'Closed Won' 
           && currentOpportunity.stageName != Trigger.oldMap.get(currentOpportunity.Id).stageName 
           && currentOpportunity.Deal_Profit__c != null){
               opportunityMap.put(currentOpportunity.Id,currentOpportunity);
           }
    }
    if(opportunityMap.isEmpty()) return;
    
    List<OpportunityContactRole> ocrList = [SELECT Id,OpportunityId,Commission_Percentage__c,Calculated_Commission__c 
                                            from OpportunityContactRole Where OpportunityId IN :opportunityMap.keySet()];
    if(ocrList.isEmpty()) return;
    
    for(OpportunityContactRole currentOCR : ocrList){
        Decimal Profit = (opportunityMap.get(currentOCR.OpportunityId).Deal_Profit__c)/100;
        currentOCR.Calculated_Commission__c = currentOCR.Commission_Percentage__c * Profit;
    }
    
    update ocrList;
}