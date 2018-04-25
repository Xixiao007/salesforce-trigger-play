@isTest
public class ManagingApex1Test {
  public static final Integer ACCOUNT_COUNT = 2;
  public static final Integer CONTACTS_ON_EACH_ACCOUNT = 3;

  @testSetup
  public static void initializeClassTestData(){
    createTestAccounts(ACCOUNT_COUNT, CONTACTS_ON_EACH_ACCOUNT);
  }

  @isTest
  public static void testBasicOperation(){
    List<Account> accounts = [SELECT Id, OwnerId from Account];
    User u = getTestUser();
    System.runAs(u){
      for(Account act: accounts){
        act.OwnerId = u.id;
      }
      Test.startTest();
      update accounts;
      Test.stopTest();

      List<Contact> updatedContacts = [SELECT Id, OwnerId from Contact];
      for (Contact ct: updatedContacts){
        System.assertEquals(u.id, ct.OwnerId, 'Account and contact owner does not match');
      }
    }
  }

  public static void createTestAccounts(Integer accounts, Integer contactsPerAccount){
    Database.DMLOptions dml = new Database.DMLOptions();
    dml.DuplicateRuleHeader.AllowSave = true;

    List<Account> accountList = new List<Account>();
    for(Integer a = 0; a < accounts; a++){
      accountList.add(new Account(Name='Dons Company ' + String.ValueOf(a)));
    }
    database.insert(accountList, dml);

    List<Contact> contacts = new List<Contact>();
    for(Account act: accountList){
      for(Integer c = 0; c < contactsPerAccount; c++){
        contacts.add(new Contact(FirstName='Don' + String.ValueOf(c), LastName='Smith' + String.ValueOf(c), AccountId=act.id));
        System.debug('this is a test');
      }
    }
    Database.insert(contacts, dml);
  }

  public static User getTestUser(){
    User u = new User(Alias = 'pbp1',
    Email = 'play@123.com',
    FirstName = 'Joe',
    LastName = 'Smith',
    TimeZoneSidKey = 'America/Los_Angeles',
    UserName = 'playbyplay1@123.com',
    ProfileID = UserInfo.GetProfileId(),
    LocaleSidKey='en_US',
    EmailEncodingKey='UTF-8',
    LanguageLocaleKey='en_US');

    return u;
  }
}
