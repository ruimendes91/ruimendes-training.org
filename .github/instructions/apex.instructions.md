---
description: "Use when writing, reviewing, or modifying Apex classes, triggers, or controllers. Covers CRUD/FLS enforcement, SOQL safety, CSRF prevention, sharing rules, and Visualforce controller patterns for this security training project."
applyTo: "force-app/main/default/classes/**,force-app/main/default/triggers/**"
---

# Apex Development Guidelines

## When to Apply These Rules

- **New feature**: follow the [New Class Checklist](#new-class-checklist) before writing any code
- **Refactoring**: apply the [Code Review Checklist](#code-review-checklist) to the existing code first; do not remove security checks during refactoring
- **Bug fix**: identify which security rule was violated (if any) and add a regression test before changing the code
- **Code review**: run through the [Code Review Checklist](#code-review-checklist) and flag every violation inline

---

## New Class Checklist

Before writing a new Apex class, confirm and implement each item:

- [ ] Class declares `with sharing` (or documents the explicit reason for `without sharing`)
- [ ] Every SOQL query uses bind variables — no string concatenation
- [ ] Every SOQL query is preceded by an object-level `isAccessible()` check
- [ ] Every queried field with sensitive data is preceded by a field-level `isAccessible()` check
- [ ] Every `insert` / `update` / `delete` is preceded by the corresponding `isCreateable()` / `isUpdateable()` / `isDeletable()` check
- [ ] No DML is triggered directly from a URL parameter (`ApexPages.currentPage().getParameters()`)
- [ ] Any `escape="false"` Visualforce output wraps user-controlled values in `ESAPI.encoder().SFDC_HTMLENCODE()`
- [ ] DML operations are wrapped in try/catch with a meaningful error surfaced to the caller
- [ ] A companion test class `<ClassName>Test` is created alongside the production class

---

## Class Declaration

Always declare classes with `with sharing`. Document any exception:

```apex
// Standard — required for all new classes
public with sharing class CastleController { }

// Exception — must state the reason in a comment
public without sharing class ScheduledCleanupJob {
    // without sharing: runs as system in scheduled context; no user data returned
}

// Demo/vulnerable class — mark clearly so reviewers don't mistake it for production code
// VULNERABLE: intentionally omits FLS checks to demonstrate the bypass
public class CRUD_FLS_Challenge { }
```

---

## SOQL Safety

### Injection Prevention

Never concatenate user input into a SOQL string. Always use bind variables:

```apex
// SAFE — bind variable; user input cannot alter query structure
String searchName = ApexPages.currentPage().getParameters().get('name');
List<Treasures__c> results = [SELECT Id, Name FROM Treasures__c WHERE Name = :searchName];

// VULNERABLE — string concatenation allows SOQL injection
List<Treasures__c> results = Database.query(
    'SELECT Id, Name FROM Treasures__c WHERE Name = \'' + searchName + '\''
);
```

### CRUD / FLS Enforcement

Check accessibility **before** every query and DML. Return early (or throw) if the check fails:

```apex
// Before querying an object
if (!Schema.sObjectType.Treasures__c.isAccessible()) {
    return;
}

// Before reading a specific field
if (!Schema.sObjectType.Treasures__c.fields.Description__c.isAccessible()) {
    return;
}

// Before inserting
if (!Schema.sObjectType.Treasures__c.isCreateable()) {
    throw new AuraHandledException('Insufficient privileges to create records.');
}

// Before updating
if (!Schema.sObjectType.Requisition__c.isUpdateable()) {
    throw new AuraHandledException('Insufficient privileges to update records.');
}

// Before deleting
if (!Schema.sObjectType.Treasures__c.isDeletable()) {
    return;
}
```

---

## CSRF Prevention

Never trigger DML from a value read directly out of the URL. Bind action targets through Visualforce component properties:

```apex
// VULNERABLE: URL parameter drives DML — forged requests can approve any record
public void approveReq() {
    String id = ApexPages.currentPage().getParameters().get('approve'); // attacker controls this
    if (id != null) {
        Requisition__c req = [SELECT Id FROM Requisition__c WHERE Id = :id LIMIT 1];
        req.Approved__c = true;
        update req;
    }
}

// SAFE: DML target comes from a component-bound property set by user interaction
public String selectedId { get; set; }

public void approveReq() {
    if (selectedId == null) { return; }
    Requisition__c req = [SELECT Id FROM Requisition__c WHERE Id = :selectedId LIMIT 1];
    req.Approved__c = true;
    update req;
    selectedId = null; // reset after use
}
```

---

## Visualforce Output Encoding

When `escape="false"` is required, HTML-encode every user-controlled segment with ESAPI:

```apex
// VULNERABLE: raw user input injected into HTML markup
public String getPrettyText() {
    return '<b><font color="blue">' + basicText + '</font></b>'; // XSS if basicText contains <script>
}

// SAFE: user-controlled portion is HTML-encoded before embedding
public String getPrettyText() {
    return '<b><font color="blue">' + ESAPI.encoder().SFDC_HTMLENCODE(basicText) + '</font></b>';
}
```

Both managed (`OWASP.ESAPI`) and unmanaged (`ESAPI`) package namespaces are supported — use whichever is installed in the org.

---

## Error Handling

Surface DML and query exceptions at the controller boundary. Never swallow silently:

```apex
try {
    insert newTreasure;
} catch (DmlException e) {
    ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(0))
    );
}
```

For AuraEnabled methods, use `AuraHandledException` so the error reaches the component:

```apex
@AuraEnabled
public static void saveTreasure(Treasures__c record) {
    if (!Schema.sObjectType.Treasures__c.isCreateable()) {
        throw new AuraHandledException('You do not have permission to create Treasures.');
    }
    try {
        insert record;
    } catch (DmlException e) {
        throw new AuraHandledException(e.getDmlMessage(0));
    }
}
```

---

## Naming Conventions

| Type | Convention | Example |
|------|-----------|----------|
| Production class | PascalCase | `CastleController` |
| Demo class | `<Name>_Demo` | `CRUD_Demo` |
| Challenge class | `<Name>_Challenge` | `CSRF_Challenge` |
| Mitigation class | `<Name>_Mitigation_Demo` | `CSRF_Mitigation_Demo` |
| Test class | `<ClassName>Test` | `CRUD_FLS_ChallengeTest` |
| Methods | camelCase | `approveRequisition` |
| Variables | camelCase | `treasureList` |
| Constants | UPPER_SNAKE_CASE | `MAX_RECORDS` |

---

## Code Review Checklist

When reviewing any Apex class, flag the following violations:

**Sharing & access:**
- [ ] Class is missing `with sharing` and has no documented reason
- [ ] `without sharing` used in a Visualforce or Aura/LWC controller context without justification

**SOQL injection:**
- [ ] User input concatenated into a `Database.query()` string or inline SOQL
- [ ] Dynamic SOQL built with `+` operator containing any variable

**CRUD/FLS bypass:**
- [ ] SOQL query with no preceding `isAccessible()` check on the object
- [ ] `insert` / `update` / `delete` with no preceding `isCreateable()` / `isUpdateable()` / `isDeletable()` check
- [ ] Field values read without `fields.<fieldName>.isAccessible()` verification

**CSRF:**
- [ ] `ApexPages.currentPage().getParameters().get(...)` result used directly to select a DML target
- [ ] State-changing action driven by a GET parameter without view-state binding

**XSS / output encoding:**
- [ ] `escape="false"` in a Visualforce tag where the value contains user-supplied data not encoded with ESAPI
- [ ] Apex method returns HTML markup with raw user input embedded

**Error handling:**
- [ ] `catch` block is empty or only calls `System.debug`
- [ ] `AuraEnabled` method throws a raw `Exception` instead of `AuraHandledException`

**Vulnerable demo classes:**
- [ ] Class intentionally bypasses security but is missing a `// VULNERABLE: <reason>` comment
```
