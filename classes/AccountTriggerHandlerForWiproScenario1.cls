public class AccountTriggerHandlerForWiproScenario1 {
    public static void deleteAccountCase(List<Account> accountList){
       	List<Id> accountParentIds = new List<Id>();
        List<Id> accountNonParentIds = new List<Id>();
        for(Account currentAccount : accountList){
            if(currentAccount.ParentId != null){
                accountParentIds.add(currentAccount.Id);
            }else{
                accountNonParentIds.add(currentAccount.Id);
            }
        }
        
        if(!accountNonParentIds.isEmpty()){
            List<Case> deleteCaseList = [SELECT Id from Case Where AccountId IN :accountNonParentIds];
            delete deleteCaseList;
        }
        if(!accountParentIds.isEmpty()){
            List<Case> parentCaseList = [SELECT Id,Account.ParentId,AccountId from Case Where AccountId IN :accountParentIds];
            List<Case> updateCaseList = new List<Case>();
            
            for(Case currentCase : parentCaseList){
                currentCase.AccountId = currentCase.Account.ParentId;
                updateCaseList.add(currentCase);
            }
            if(!updateCaseList.isEmpty()){
                update updateCaseList;
            }
        }
    }
}