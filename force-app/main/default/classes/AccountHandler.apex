public with sharing class AccountHandler {

    // Method to create a new Account
    public static Account createAccount(String accName, String accPhone) {
        Account acc = new Account(
            Name = accName,
            Phone = accPhone
        );
        insert acc;
        return acc;
    }

    // Method to update Account phone number
    public static void updateAccountPhone(Id accId, String newPhone) {
        Account acc = [SELECT Id, Phone FROM Account WHERE Id = :accId LIMIT 1];
        acc.Phone = newPhone;
        update acc;
    }

    // Method to fetch Accounts by name
    public static List<Account> getAccountsByName(String accName) {
        return [SELECT Id, Name, Phone FROM Account WHERE Name = :accName];
    }
}
