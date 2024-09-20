public class AccounttriggerHandler {
    // 1.Create related contact and Opportunity when Account is created
    public static void createRelatedConadndOpp(List<Account> accList){
      
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Account acc : accList){
            if(acc.Name != null){
              Contact con = new Contact();
                Opportunity opp = new Opportunity();
            con.LastName = 'Abc';
            con.AccountId = acc.Id; // lookup field
            conList.add(con);
            
                opp.Name = 'xyz';
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.Today();
            opp.AccountId = acc.Id;
            oppList.add(opp);   // list
            }  
        }
        
        if(!conList.isEmpty()){
            insert conList;
        }
        if(oppList.size()>0){
            insert oppList;
        }
        
    }
    
    //4.Whenever phone field is updated in account then 
    //the name field should also get updated with name and phone number in accounts
    
    public static void updateAccNameWithNameAndPhone(List<Account> accList, Map<Id, Account> accOldMap){
        
        for(Account acc : accList){
            if(acc.Phone != accOldMap.get(acc.Id).Phone){   // new Value = acc.Phone , old value accOldMap.get(acc.Id).Phone
                acc.Name = acc.Name + acc.Phone;
                
            }
        }
    }
    
    // 5.Prevent account from deleting, if it has 2 or more contacts 
    // Before delete will be used here
    public static void prevetAccountDletion(List<Account> accList){
        
        Set<Id> accIds = new Set<Id>();
        Map<Id, Account> accMap = new Map<Id, Account>();
        
        for(Account acc : accList){
            accIds.add(acc.Id);  // set
        }
        
        for(Account acc : [Select Id, Name,(Select Id, AccountId, FirstName, LastName from Contacts)
                           from Account where Id IN: accIds]){
                               accMap.put(acc.Id, acc);  // map
                           }
        //for showing error use context variable bcoz error shows on context variable
        
        for(Account acc : accList){
            if(accMap.get(acc.Id).Contacts.size() >= 2){
                acc.addError('account cannot be deleted because this account has more than 2 related Contacts');
            }
        }  
    }
    // 10. Divide individual balance equally on contacts based on the total balance on related accounts whenever account is updated
    public static void divideBalanceOnContact(List<Account> accList, Map<Id, Account> accOldMap){
        Set<Id> accIds = new Set<Id>();
        List<Contact> conList = new List<Contact>();
        for(Account acc : accList){
            if(acc.Balance__c != null && acc.Balance__c != accOldMap.get(acc.Id).Balance__c){
                accIds.add(acc.Id);
            }
        }
        for(Account acc : [Select Id, Balance__c,(Select Id, AccountId, IndividualBalance__c FROM Contacts) from Account where Id IN: accIds]){
            Decimal amount = acc.Balance__c/acc.Contacts.size();
            
            for(Contact con : acc.Contacts){
                con.IndividualBalance__c = amount;
                conList.add(con);
            }
        }
        
        update conList;
        
    }
    
    // 11. Whenever new account is created with annual revenue more than 50,000 then add Smriti Sharan as contact name
    //After insert will be used here.
    public static void addContactnameasSmriti(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        
        for(Account acc : accList){
            if(acc.AnnualRevenue >= 50000){
                Contact con = new Contact();
                con.FirstName = 'Smriti';
                con.LastName = 'Sharan';
                con.AccountId = acc.Id;
                conList.add(con);
            }
        }
        if(!conList.isEmpty()){
            insert conList;
        }  
    }
    
    // 12. Whenever account is created with industry as banking then create a contact for account,contact lastname as account name and contact phone as account phone
    // After insert will be used here.
    public static void addConNamePhoneAsAccNamePhone(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        
        for(Account acc : accList){
            if(Acc.Industry == 'Banking'){
                Contact con = new Contact();
                con.FirstName = 'Test';
                con.LastName = acc.Name;
                con.Phone = acc.Phone;
                con.AccountId = acc.Id;
                conList.add(con);
            }
        }
        if(!conList.isEmpty()){
            insert conList;
        }  
    }
    //15. Whenever account phone is modified then update contact record with phone field 
    //(otherphone with oldvalue and homephone with new value) associated with account records.
    
    public static void updateContactHomePhoneandOtherPhone(List<Account> accList, Map<Id, Account> accOldMap){
        // Create a list to hold the contacts that need to be updated
        List<Contact> conList = new List<Contact>();
        Map<Id, Account> accMap = new Map<Id, Account>();
        
        for(Account acc : accList){
            // Check if the phone field of the account has been changed
            if(acc.Phone != accOldMap.get(acc.Id).Phone && accOldMap != null){
                accMap.put(acc.Id, acc);
            }
        }
        
        for(Account acc : [Select Id, Name, Phone,(Select Id, AccountId, HomePhone, OtherPhone from Contacts) from Account where Id IN: accMap.keySet()]){
            if(accMap.containsKey(acc.Id)){
                for(Contact con : acc.Contacts){
                    con.HomePhone = accMap.get(acc.Id).Phone;
                    con.OtherPhone = accOldMap.get(acc.Id).Phone;
                    conList.add(con);
                }
            }
        }
        if(!conList.isEmpty()){
            update conList;
        } 
    }
    
    // 18.When a new Account record is inserted verify the industry field value, 
    // if industry field value is Education then assign the owner as Smriti
    
    //Owner is a lookup field populating user id therefore  get user record and put that in ownerid
    
    public static void assignOwnerAsSmriti(List<Account> accList){
        
        List<User> urList = new List<User>();
        
        for(Account acc : accList){
            if(acc.Industry == 'Education'){
                for(User ur : [SELECT Id, Username, Name, Phone FROM User where Username= 'smriti@sfdc.com']){
                    acc.OwnerId = ur.Id;
                    urList.add(ur);
                }  
            }
        }
        update urList;
    }
    
    //19.The trigger will prevent the users from deleting the Accounts. 
    //This is because System Administrator has all the permissions, we cannot change the permissions.
    
    public static void preventDeletionAcc(List<Account> accList){
        Set<Id> adminIds =  new Set<Id>();
        // Fetching System Administrator Ids
        for(User u : [Select Id, Name from User where Name = 'System Administrator']){
            adminIds.add(u.Id);
        }
        
        // Checking if any of the Account owners are System Administrators
        
        for(Account acc : accList){
            if(adminIds.contains(acc.OwnerId)){
                acc.addError('You cannot delete the Account record.');
            }
        }
    }
    // Creates the number of contacts which are equal to the number which we will enter in the Number of Locations field on the Account Object.
    public static void createConEqualsNoOfLocation(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        
        for(Account acc : accList){
            if(acc.NumberofLocations__c != null && acc.NumberofLocations__c >0){
                for(Integer i = 1; i<= acc.NumberofLocations__c; i++){
                    Contact con = new Contact();
                    con.FirstName = 'Test';
                    con.LastName = 'Contact' + i;
                    con.AccountId = acc.Id;
                    conList.add(con);
                }
            }
        }
        insert conList;
    } 
}