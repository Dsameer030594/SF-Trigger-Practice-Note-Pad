public class LeadTriggerHandler {
//2.Prefix first name with Dr when new Lead is created or updated

    public static void prefixDrtoFirstName(List<Lead> leadList){
        
        for(Lead ld : leadList){
            ld.FirstName = 'Dr.' + ld.FirstName;
        }
    }
    
    //6.When a lead is created or updated then check if the email of the lead is already there in existing contacts. If the email already exists then throw an error.
  
    public static void throwErrorIfEmailIsExists(List<Lead> leadList, Map<Id, Lead> leadOldMap){
        Set<String> leadEmails =  new Set<String>();
        // Collect email addresses from Lead records
        for(Lead ld : leadList){
            if(ld.Email != null && ld.Email != leadOldMap.get(ld.Id).Email){
                leadEmails.add(ld.Email);
            }
        }
        // Query existing Contacts with matching email addresses
        Set<String> existingContactEmails = new Set<String>();
        for(Contact con : [Select Id, Email from Contact where Email IN:leadEmails]){
            existingContactEmails.add(con.Email);
        }
        
        // Check for duplicate emails and add error if found
        for(Lead ld : leadList){
            if(existingContactEmails.contains(ld.Email) && ld.Email != null){
                ld.Email.addError('A Contact with this email already exists.');
            }
        }   
    }

    //14. Whenever lead is created with lead source as web then give rating as cold otherwise hot
    public static void changeLeadRatingAccordingtoLeadSource(List<Lead> leadList){
        
        for(Lead ld : leadList){
            if(ld.LeadSource == 'Web'){
                ld.Rating = 'Cold';
                
            } else {
                ld.Rating = 'Hot';
            }
        }
        
    }

}