@isTest
private class OrgValidityTest {
   @IsTest
    static void testOrgValidity() {
       Test.startTest();
       OrgValidtyTestCallOutMocker  callOutMocker = new OrgValidtyTestCallOutMocker();
       Test.setMock(HttpCalloutMock.class, callOutMocker);
       OrgValidity oValidity = new OrgValidity();
       Test.stopTest();
    }
}