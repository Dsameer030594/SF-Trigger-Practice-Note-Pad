public class OpportunityTriggerHandler {
    
    //3. Update Account Rating to 'Hot' on account when 
    //opportunity stage equals ‘closed one’
    public static void updateAccountRating(List<Opportunity> oppList, Map<Id, Opportunity> oppOldMap){
        
        List<Account> accList = new List<Account>();
        //Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        Set<Id> oppIds = new Set<Id>();
        
        for(Opportunity opp : oppList){
            if(opp.StageName != null && opp.StageName != oppOldMap.get(opp.Id).StageName){
                //oppMap.put(opp.AccountId, opp);
                oppIds.add(opp.AccountId);
            }
        }
        
        /*   for(Account acc :[Select Id, Name, Rating from Account where Id IN: oppMap.keySet()]){
if(oppMap.containsKey(acc.Id)){
acc.Rating = 'Hot';
accList.add(acc);
}
}  */
        
        for(Account acc :[Select Id, Name, Rating from Account where Id IN: oppIds]){
            if(oppIds.contains(acc.Id)){
                acc.Rating = 'Hot';
                accList.add(acc);
            }
        }
        
        if(!accList.isEmpty()){
            update accList;
        }
        
    }
    
    //7.Write a trigger to update a field (city) in Account when 
    //same field(city) is updated in opportunity
    public static void updateAccFieldIfOppFieldIsUpdated (List<Opportunity> oppList, Map<Id, Opportunity> oppOldMap){
        
        List<Account> accList = new List<Account>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        
        for(Opportunity opp : oppList){
            if(opp.City__c != null && opp.City__c != oppOldMap.get(opp.Id).City__c){
                oppMap.put(opp.AccountId, opp);
            }
        }
        
        for(Account acc : [Select Id, Name, City__c,(Select Id, AccountId, City__c from Opportunities) 
                           from Account where Id IN:oppMap.keySet()]){
                               
                               if(oppMap.conTainsKey(acc.Id)){
                                   acc.City__c = oppMap.get(acc.Id).City__c;
                                   accList.add(acc);
                               }
                           }
        
        if(!accList.isEmpty()){
            update accList;
        }
        
    }
    // 8.Whenever TestPhoneOpportunity__c field in opportunity is updated ,its related field (TestPhoneAccount__c) in Account 
    // and (TestPhoneContact__c ) in Contact should get updated with the updated value with TestPhoneOpportunity__c
    //After update will be used here
    public static void updaterelatedAccNadConField(List<Opportunity> oppList, Map<Id, Opportunity> oppOldMap){
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        
        for(Opportunity opp : oppList){
            if(opp.TestPhoneOpportunity__c != null && opp.TestPhoneOpportunity__c != oppOldMap.get(opp.Id).TestPhoneOpportunity__c){
                oppMap.put(opp.AccountId, opp);
            }
        }
        // Updating related Account and Contact records
        if(!oppMap.isEmpty()){
            // Querying related Account and Contact records
            // Account is Parent for Opportunity (From Opp to Acc create Child to Parent SOQL)
            // But Contact is child for Opportunity (From Parent to child create SOQL)
            
            for(Account acc: [Select Id, Name,TestPhoneAccount__c, 
                              (Select Id, AccountId, LastName, TestPhoneContact__c from Contacts )from Account where Id IN:oppMap.keySet()]){
                                  
                                  if(oppMap.containsKey(acc.Id)){
                                      acc.TestPhoneAccount__c = oppMap.get(acc.Id).TestPhoneOpportunity__c;
                                      accList.add(acc);
                                  } 
                                  for(Contact con : acc.Contacts){
                                      con.TestPhoneContact__c = oppMap.get(con.AccountId).TestPhoneOpportunity__c;
                                      conList.add(con);
                                  }  
                              }
            // Performing updates
            if (!accList.isEmpty()) {
                update accList;
            }
            if (!conList.isEmpty()) {
                update conList;
            }
            
        } 
    } 
    
    //9.When an opportunity is inserted or updated then if the stage name is ‘Closed won’ then add the task.
    public static void createRelatedTask(List<Opportunity> oppList, Map<Id, Opportunity> oppOldMap){
        List<Task> tskList = new List<Task>();
        
        for(Opportunity opp : oppList){
            if((opp.StageName == 'Closed won' && oppOldMap == null && opp.StageName != null)
               ||(opp.StageName == 'Closed won' && oppOldMap != null && opp.StageName != oppOldMap.get(opp.Id).StageName)){
                   
                   Task tk = new Task();
                   tk.Status = 'In Progress';
                   tk.Subject = 'Email';
                   tk.Priority = 'Normal';
                   tk.WhatId = opp.AccountId;
                   tskList.add(tk);
               }
        }
        
        if(!tskList.isEmpty()){
            insert tskList;
        }
    }
    
    //16.Whenever opportunity stagename is modified to closed won then set closedate as today and type as customer.
    
    public static void setCloseDateandTypeOfOpp(List<Opportunity> oppList, Map<Id, Opportunity> oppOldMap){
        
        For(Opportunity opp : oppList){
            if(opp.StageName != oppOldMap.get(opp.Id).StageName && opp.StageName =='Closed Won' && oppOldMap!= null ){
                opp.CloseDate = System.Today();
                opp.Type = 'New Customer';
            }
        }
    }
    
    // 1. Create a field on Opportunity as Client Contact, 
    // Once an Opportunity Client Contact updates then update Account 
    // Client Contact with the same on Opportunity Client Contact.
    public static void updateClientContactonAccandOpp(List<Opportunity> oppList, Map<Id, Opportunity> oppOldMap){
        Set<Id> uniqueRecords = new Set<Id>();
        //Set<Id> accIds = new Set<Id>();
        //List<Opportunity> newoppList = new List<Opportunity>();
        //Map<Id, Opportunity> oppnewMap = new Map<Id, Opportunity>();
        for(Opportunity opp : oppList){    //10
           //if the Client Contact of Opportunity is null then we are not changing the Account Client Contact
            if(opp.Client_Contact__c != oppOldMap.get(opp.Id).Client_Contact__c && opp.Client_Contact__c != null && opp.AccountId!=null){   // 4
                //new value != old value
                // new value = opp.Client_Contact__c,  old value = oppOldMap.get(opp.Id).Client_Contact__c
                uniqueRecords.add(opp.AccountId);  //4
                // newoppList.add(opp);   // add method
                // accIds.add(opp.Id);    // add method
                // oppnewMap.put(opp.Id, opp);     // put method   (key, value),            
                
            }
        }
        List<Account> accList = new List<Account>();
       
        
        for(Opportunity opp : [Select Id, AccountId, Name, Account.Name, Account.Client_Contact__c from Opportunity Where AccountId IN: uniqueRecords]){   // =: same as IN:   //4   // 50k
            Account acc = new Account();
            acc.Client_Contact__c = opp.Client_Contact__c;
            acc.Id = opp.AccountId;  // lookup field
            accList.add(acc);   
        }
        
        if(!accList.isEmpty()){
            update accList;
        }
        
        
    }
}