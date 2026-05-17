---
description: "Use when writing, reviewing, or running Apex unit tests for this Salesforce project. Covers Apex test class conventions, test data setup, security testing (CRUD/FLS, CSRF, sharing), coverage requirements, and review checklist. Apply when creating new Apex classes, refactoring existing ones, or performing code review."
applyTo: "force-app/main/default/classes/**"
---

# Apex Testing Guidelines

## When to Apply These Rules

- **New feature**: every new Apex class or method must have a corresponding test class or test method before the feature is considered complete
- **Refactoring**: existing test methods must still pass after refactoring; add regression tests for any behaviour that was previously untested
- **Code review**: use the [Review Checklist](#code-review-checklist) to flag missing tests, insecure patterns, or inadequate assertions

## Running Apex Tests

```bash
sf apex run test --test-level RunLocalTests --output-dir test-results --result-format human
sf apex run test --class-names MyControllerTest --result-format human   # single class
```

---

## Test Class Conventions

### Declaration

Every test class must be annotated with `@isTest` and declare `with sharing`:

```apex
@isTest
public with sharing class MyControllerTest {
```

### One Test Class Per Production Class

Name the test class `<ProductionClassName>Test` and place it in the same `classes/` folder:

| Production class | Test class |
|-----------------|-----------|
| `CRUD_FLS_Challenge.cls` | `CRUD_FLS_ChallengeTest.cls` |
| `CSRF_Mitigation_Demo.cls` | `CSRF_Mitigation_DemoTest.cls` |

---

## Test Data Setup

Use `@testSetup` for data shared across all methods in a class. Create data inline inside a single test method only when that test requires a unique state:

```apex
@testSetup
static void setup() {
    Castle__c castle = new Castle__c(Name = 'Test Castle');
    insert castle;

    Treasures__c t = new Treasures__c(
        Name = 'Golden Crown',
        Castle__c = castle.Id,
        Found__c = true
    );
    insert t;

    Requisition__c req = new Requisition__c(
        Castle__c = castle.Id,
        Approved__c = false
    );
    insert req;
}
```

**Rules:**
- Never query or rely on existing org data — always create test records explicitly
- Do not hard-code record IDs
- Commented-out test methods (e.g. in `CreateTestMassControllerTest`) do not count toward coverage — uncomment or rewrite them

---

## Test Method Structure

Follow the **Arrange / Act / Assert** pattern. Wrap the action under test in `Test.startTest()` / `Test.stopTest()` to reset governor limits:

```apex
@isTest
static void approveReq_validId_setsApprovedTrue() {
    // Arrange — load data created by @testSetup
    Requisition__c req = [SELECT Id FROM Requisition__c LIMIT 1];

    // Act
    Test.startTest();
    MyController ctrl = new MyController();
    ctrl.selectedId = req.Id;
    ctrl.approveReq();
    Test.stopTest();

    // Assert
    Requisition__c updated = [SELECT Approved__c FROM Requisition__c WHERE Id = :req.Id];
    System.assertEquals(true, updated.Approved__c, 'Expected Approved__c to be true after approveReq()');
}
```

### Method Naming

`methodUnderTest_condition_expectedOutcome` — no ambiguity about what is being tested:

```apex
// Good
static void getRandomTreasure_flsBlocked_returnsNull() { }
static void approveReq_nullId_doesNotDml() { }
static void constructor_noRecords_initializesEmptyList() { }

// Bad — not enough information
static void testApprove() { }
static void test1() { }
```

### Assertions

- Every test method must have at least one `System.assertEquals` / `System.assertNotEquals` / `System.assert`
- Always supply a failure message as the third argument so failures are self-describing
- Prefer `System.assertEquals(expected, actual, message)` over `System.assert(condition)` when comparing values

---

## Security Test Patterns

This is a security training project. Every class that enforces (or deliberately bypasses) CRUD, FLS, or sharing **must** have tests that verify that enforcement.

### Testing CRUD/FLS Checks

Use `System.runAs()` with a user whose profile lacks the relevant object or field permission:

```apex
@isTest
static void getRandomTreasure_noFls_returnsEarly() {
    // Create a user with a profile that does not have Read on Treasures__c
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Minimum Access - Salesforce' LIMIT 1];
    User restrictedUser = new User(
        Alias = 'rstd',
        Email = 'restricted@example.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Restricted',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        ProfileId = p.Id,
        TimeZoneSidKey = 'America/Los_Angeles',
        UserName = 'restricted_' + Datetime.now().getTime() + '@example.com'
    );
    insert restrictedUser;

    System.runAs(restrictedUser) {
        Test.startTest();
        CRUD_FLS_Challenge ctrl = new CRUD_FLS_Challenge();
        ctrl.getRandomTreasure();
        Test.stopTest();

        System.assertEquals(null, ctrl.chestContents,
            'FLS check should have blocked access and left chestContents null');
    }
}
```

### Testing CSRF Mitigation

Verify that the safe method ignores URL parameters and only acts on bound state:

```apex
@isTest
static void approveReqNoCSRF_boundId_approvesRecord() {
    Requisition__c req = [SELECT Id FROM Requisition__c LIMIT 1];
    Test.startTest();
    CSRF_Mitigation_Demo ctrl = new CSRF_Mitigation_Demo();
    ctrl.approve = req.Id;      // state is set through the component property, not URL
    ctrl.approveReqNOCSRF();
    Test.stopTest();

    Requisition__c updated = [SELECT Approved__c FROM Requisition__c WHERE Id = :req.Id];
    System.assertEquals(true, updated.Approved__c, 'Record should be approved via bound property');
}

@isTest
static void approveReqVulnerable_urlParam_canBeAbused() {
    // This test documents the vulnerable path — it is intentionally simple
    // to illustrate the attack surface without enabling exploitation
    CSRF_Challenge ctrl = new CSRF_Challenge();
    // The vulnerable method reads from the page URL; in a test context
    // ApexPages.currentPage() is null unless a PageReference is set
    PageReference page = Page.CSRF_Demo;
    Test.setCurrentPage(page);
    // Demonstrates that parameter can be injected without user interaction
    ApexPages.currentPage().getParameters().put('approve', 'someId');
    // No assert needed — this test exists to document the vulnerable interface
}
```

### Testing Sharing Enforcement

For classes that use `with sharing`, confirm that a user without record visibility cannot retrieve data:

```apex
@isTest
static void query_withSharing_ownerOnlySeesTreasures() {
    User owner = /* create user A */;
    User other = /* create user B */;
    Treasures__c ownerRecord = /* insert record owned by owner */;

    System.runAs(other) {
        Test.startTest();
        CRUD_Demo ctrl = new CRUD_Demo();
        Test.stopTest();
        // other should not see owner's treasure when sharing is enforced
        System.assertEquals(0, ctrl.treasures.size(),
            'with sharing should hide records the running user does not own');
    }
}
```

---

## What Every Test Class Must Cover

When creating or reviewing a test class, ensure the following scenarios are addressed:

| Scenario | Required? |
|---------|-----------|
| Happy path (valid input, correct permissions) | Always |
| Null / empty input guard | Always |
| CRUD/FLS block returns early without DML | When class checks permissions |
| `with sharing` hides inaccessible records | When class uses `with sharing` |
| CSRF mitigation: action ignores URL parameters | When class handles approvals/DML actions |
| DML exception is caught and surfaced | When class performs DML |
| Governor limit edge cases (bulk, 200 records) | When class processes collections |

---

## Code Review Checklist

When reviewing an Apex class or its test class, flag the following issues:

**Missing tests:**
- [ ] No test class exists for the production class
- [ ] Commented-out test methods that should be active
- [ ] Test method has no assertions
- [ ] Happy path covered but no negative/permission-denied path

**Insecure patterns missing test coverage:**
- [ ] CRUD/FLS check in production code but no `System.runAs()` test that exercises the denied branch
- [ ] `ApexPages.currentPage().getParameters()` used for DML triggers but no test verifying CSRF protection
- [ ] Vulnerable demo class (`// VULNERABLE:`) has no companion test documenting the attack vector

**Test quality issues:**
- [ ] Test queries org data instead of inserting test records
- [ ] `System.assertEquals` called without a failure message
- [ ] Test method name does not describe the condition and expected outcome
- [ ] Missing `Test.startTest()` / `Test.stopTest()` around the action under test

---

## Coverage Requirements

Salesforce requires **75% code coverage** across all Apex for production deployment:

- New classes: aim for **90%+**
- Refactored classes: coverage must not decrease after the change
- Bug fixes: add a failing test that reproduces the bug *before* applying the fix
