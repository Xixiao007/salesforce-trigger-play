public class ManagingApex1 {

    public static void handleAccountUpdate(list<account> newList, Map<ID, Account> oldMap){

      List<Account> changedAccounts = new List<Account>();
      for(Account act: newList){
        if(act.OwnerId != oldMap.get(act.id).ownerId){
          changedAccounts.add(act);
        }
      }
      if(changedAccounts.size() == 0) {
        return;
      }

      Map<Id, Account> accountsMap = new Map<ID, Account>(newList);
      List<Contact> contacts = [SELECT Id, OwnerId, AccountId from contact where AccountID in :accountsMap.keySet()];

      for(contact ct: contacts){
        ct.OwnerId = accountsMap.get(ct.AccountID).OwnerId;
      }

      update contacts;
    }
}
