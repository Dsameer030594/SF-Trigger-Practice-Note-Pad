public class editallOpportunity {

   public List<Opportunity> oppList{ get; set; }
   public Account currentAccount { get; set; }
    public Opportunity selectedOpportunity { get; set; }
    public Id accountId {get; set;}
    
public editallOpportunity(){
 // Constructor to initialize the controller
    
    oppList = new List<Opportunity>();
    
    // Retrieve the current account from the URL parameter
    accountId = ApexPages.currentPage().getParameters().get('id');
    
    if (accountId != null) {
            currentAccount = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id =:accountId];
            oppList= currentAccount.Opportunities;
        }
}
   public PageReference editIt() {
        return null;
    }


public void updateIt(){
   
   update oppList;
}

public PageReference cancelIt(){
        PageReference pf = new PageReference('/' + accountId);
        return pf;
    } 
    
 public PageReference deleteIt(){
  pageReference pf = new pageReference('/001/o');
   return pf; // or return a page reference to redirect the user
    }


}