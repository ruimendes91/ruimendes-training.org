public with sharing class LoginAsController {
    public String[] permSets {get; set;}
    public string url {get; set;}
    public string targetPerm {get; set;}
     
    public List<SelectOption> getItems() {
        List<PermissionSet> PermSetList = new List<PermissionSet>([SELECT Id, Description FROM PermissionSet Where Description in: permSets]);    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Please Select User to Emulate...'));
        For(PermissionSet P : PermSetList){
             options.add(new SelectOption(P.Id,P.Description));  
        }
        return options;
    }


    public PageReference emulateUser() {
    	User demoUser = [Select Id, Alias from User where Alias = 'duser1'];

    	// Clear existing assignments
    	List<PermissionSetAssignment> userAssignments = [SELECT Id, PermissionSet.Description from PermissionSetAssignment where AssigneeId = :demoUser.Id];
    	
    	for(PermissionSetAssignment assignment : userAssignments)
    	{
    		if(assignment.PermissionSet.Description != null && assignment.PermissionSet.Description != '')
    			delete assignment;
    	}
    	
    	// Assign the selected permission set to the demo user
    	PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = targetPerm, AssigneeId = demoUser.Id);
    	insert psa;
    	
    	// SU to the demoUser
        Pagereference loginas = new PageReference('/servlet/servlet.su');
        loginas.getParameters().put('oid',Userinfo.getOrganizationId());
        loginas.getParameters().put('suorgadminid', demoUser.Id);
        loginas.getParameters().put('retURL', url);
        loginas.getParameters().put('targetURL', url);
        loginas.setRedirect(true);
        return loginas;
    }
    
    public boolean getLogout(){
        String profileid = UserInfo.getUserId();
        string demoid = [select id from User where Alias = 'duser1' limit 1].id;
        
        if(profileid == demoid){
            return true;
        }
    
        return false;
    }
    
    public PageReference returnToAdmin(){
        Pagereference returnToAdmin = new PageReference('/secur/logout.jsp');
        returnToAdmin.setRedirect(true);
        return returnToAdmin;    
    }
        
    
    
}