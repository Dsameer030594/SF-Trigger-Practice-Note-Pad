public class ContactTriggerHandler {

    //17.When a new contact is created for existing account then set contact other phone as account phone

    public static void setConPhoneasAccPhone(List<Contact> conList){
        
        Set<Id> accIds = new Set<Id>();
        Map<Id, Account> accMap = new Map<Id, Account>();
        
        for(Contact con : conList){
            accIds.add(con.AccountId);
        }
        
        for(Account acc : [Select Id,Phone from Account where Id IN: accIds]){
            accMap.put(acc.Id, acc);
        }
            for(Contact con : conList){
            if(con.AccountId != null && accMap.containsKey(con.AccountId)){
                con.OtherPhone = accMap.get(con.AccountId).Phone;
            }
        }
    }
    
   // 20. When the value of AssistantPhone field on contact is updated , 
   // I would like the field value of phone__c the opportunity and phone on account also get updated.
   
    public static void updateRelatedOppAndAccount(List<Contact> conList, Map<Id, Contact> conOldMap){
       
        List<Account> accList = new List<Account>();
        List<Opportunity> oppList = new List<Opportunity>();
        Map<Id, Contact> connewMap = new Map<Id, Contact>();
        
        for(Contact con : conList){
           if(con.AssistantPhone != null && con.AccountId != null && con.AssistantPhone != conOldMap.get(con.Id).AssistantPhone){
               
               connewMap.put(con.AccountId, con);
           }
    }
        for(Account acc: [Select Id, Phone,(Select Id, AccountId, phone__c from Opportunities ) from Account where Id IN: connewMap.keySet()]){
            if(connewMap.containsKey(acc.Id)){
                acc.Phone = connewMap.get(acc.Id).AssistantPhone;
                accList.add(acc);
            }
            for(Opportunity opp : acc.Opportunities){
                opp.phone__c = connewMap.get(acc.Id).AssistantPhone;
                oppList.add(opp);
            }
        }
        update accList;
        update oppList;
       
    }
}