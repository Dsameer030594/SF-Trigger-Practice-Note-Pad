@RestResource(urlMapping = '/Cases')
global class CaseManager {

    @httpGet
    global static List<Case> getCases(){
       List<Case> caseList = [SELECT Id, Status, Type, Origin, Subject, Priority, Description, IsClosed FROM Case LIMIT 10];
        return caseList;
    }
    @httpPost
    global static Id createCases(String Subject, String Origin, String Priority, String Status){
        Case cs = new Case();
        cs.Subject = 'Subject';
        cs.Origin = 'Origin';
        cs.Priority = 'Priority';
        cs.Status = 'Status';
        insert cs;
        return cs.Id;
    }
}

// END POINT WILL BE Developer console link : https://jditbusiness-dev-ed.develop.my.salesforce.com/
// final end Point :  https://jditbusiness-dev-ed.develop.my.salesforce.com/services/apexrest/Cases\
//