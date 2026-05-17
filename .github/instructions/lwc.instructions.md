---
description: "Use when writing, reviewing, or modifying Lightning Web Components (LWC) or Aura components. Covers component structure, data access patterns, event handling, security (XSS, access control), and SLDS styling conventions."
applyTo: "force-app/main/default/lwc/**,force-app/main/default/aura/**"
---

# Lightning Component Development Guidelines

This project uses **Aura** as the primary UI framework. **LWC is used for all new components**. Apply the appropriate framework section when creating or modifying components.

## When to Apply These Rules

- **New component**: follow the [New Component Checklist](#new-component-checklist) before writing any markup or JS
- **Refactoring**: check the [Code Review Checklist](#code-review-checklist) on the existing component first; preserve security constraints during restructuring
- **Maintenance**: do not loosen `access` levels or introduce raw HTML rendering without explicit justification
- **Code review**: run through the [Code Review Checklist](#code-review-checklist) and call out every violation inline

---

## New Component Checklist

Before writing a new component, confirm and implement each item:

- [ ] **Framework choice**: use LWC for new work; only extend existing Aura components
- [ ] **No raw HTML rendering**: `lwc:inner-html` (LWC) and `aura:unescapedHtml` (Aura) are not used with user-supplied data
- [ ] **Minimum access on attributes**: Aura attributes default to `private`; only escalate to `public`/`global` when required for cross-component communication
- [ ] **Apex calls go through a `with sharing` controller**: never call `@AuraEnabled` methods on `without sharing` classes unless documented
- [ ] **Errors are caught and shown**: every Apex call has an error handler that surfaces feedback to the user
- [ ] **No sensitive data exposed globally**: record IDs passed between components use `@api` (LWC) or `public` (Aura) — never `global` unless required by a managed package
- [ ] **SLDS used for layout and styling**: custom CSS only for cases not covered by SLDS utilities

---

## Security: XSS Prevention

### LWC

LWC auto-escapes all `{expression}` bindings. Never bypass this:

Never use `lwc:inner-html` with unescaped strings. LWC auto-escapes text bindings — do not bypass it:

```html
<!-- SAFE: LWC escapes content automatically -->
<p>{userInput}</p>

<!-- VULNERABLE: disables escaping, enables XSS if userInput contains <script> -->
<p lwc:inner-html={userInput}></p>
```

If rich text is required, sanitize input server-side with ESAPI before returning it from Apex.

### Aura

Never use `aura:unescapedHtml` with user-supplied data:

```html
<!-- SAFE: formattedText escapes output -->
<lightning:formattedText value="{!v.userInput}" />

<!-- VULNERABLE: renders raw HTML from attribute -->
<aura:unescapedHtml value="{!v.userInput}" />
```

---

## Access Control on Component Attributes (Aura)

Default all attributes to `private`. Escalate only when there is a documented reason:

```xml
<!-- VULNERABLE: any component in any namespace can read and set this -->
<aura:attribute name="cofferSize" access="global" type="Decimal" default="100000" />

<!-- CORRECT: only this component can interact with this attribute -->
<aura:attribute name="cofferSize" access="private" type="Decimal" default="100000" />

<!-- Acceptable for parent-child in same namespace -->
<aura:attribute name="selectedId" access="public" type="String" />
```

Access levels (least to most permissive): `private` → `public` → `global`

---

## Aura Component Structure

Place all files for a component in `force-app/main/default/aura/<ComponentName>/`:

| File | Purpose |
|------|---------|
| `<Name>.cmp` | Markup — keep logic-free; bind to controller/helper actions |
| `<Name>Controller.js` | Thin event handlers only — delegate to helper |
| `<Name>Helper.js` | All reusable logic and Apex call wiring |
| `<Name>Renderer.js` | Custom rendering lifecycle (avoid unless necessary) |
| `<Name>.css` | Component-scoped styles |
| `<Name>.design` | App Builder/Flow configuration |
| `<Name>.auradoc` | Documentation |

### Controller / Helper Pattern

Keep controllers thin. All Apex calls and business logic go in the helper:

```javascript
// <Name>Controller.js — thin, delegates immediately
({
    handleApprove: function(component, event, helper) {
        helper.approveRequisition(component);
    }
})

// <Name>Helper.js — owns the Apex call and result handling
({
    approveRequisition: function(component) {
        var action = component.get('c.approveReq');
        action.setParams({ recordId: component.get('v.selectedId') });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                component.set('v.message', 'Approved successfully.');
            } else {
                var errors = response.getError();
                component.set('v.message', errors[0] && errors[0].message);
            }
        });
        $A.enqueueAction(action);
    }
})
```

---

## LWC Component Structure

Create all LWC files under `force-app/main/default/lwc/<componentName>/`:

```
force-app/main/default/lwc/myComponent/
  myComponent.html          # Template
  myComponent.js            # Component class
  myComponent.css           # Scoped styles (optional)
  myComponent.js-meta.xml   # Deployment metadata
  __tests__/
    myComponent.test.js     # Jest unit tests
```

### LWC Component Class

```javascript
import { LightningElement, api, wire } from 'lwc';
import getTreasures from '@salesforce/apex/CRUD_Demo.getTreasures';

export default class TreasureList extends LightningElement {
    @api castleId;      // public input — set by parent

    treasures;
    error;

    @wire(getTreasures, { castleId: '$castleId' })
    wiredTreasures({ data, error }) {
        if (data) {
            this.treasures = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.treasures = undefined;
        }
    }
}
```

### Data Access: Wire vs. Imperative

| Use case | Pattern |
|----------|---------|
| Read on component load or when a property changes | `@wire` adapter |
| Read triggered by a user action (button click) | Imperative `async/await` |
| Write (DML) | Always imperative |

```javascript
// Imperative call for user-triggered write
async handleSave() {
    try {
        await saveTreasure({ record: this.draftRecord });
        this.dispatchEvent(new CustomEvent('saved'));
    } catch (error) {
        this.error = error.body.message;
    }
}
```

---

## Event Communication

| Direction | Mechanism |
|-----------|----------|
| Child → Parent | `CustomEvent` dispatched from child, `on<eventname>` handler in parent template |
| Parent → Child | `@api` property on child set from parent template |
| Unrelated components | Lightning Message Service (LMS) — preferred; pub-sub pattern as fallback |

```javascript
// Child — dispatch
this.dispatchEvent(new CustomEvent('treasureselected', { detail: { id: this.recordId } }));
```

```html
<!-- Parent template — handle -->
<c-treasure-list ontreasureselected={handleTreasureSelected}></c-treasure-list>
```

```javascript
// Parent JS
handleTreasureSelected(event) {
    this.selectedTreasureId = event.detail.id;
}
```

---

## SLDS Usage

Use SLDS utility classes; write custom CSS only when SLDS has no equivalent:

```html
<!-- Grid layout -->
<div class="slds-grid slds-gutters">
    <div class="slds-col slds-size_1-of-2">...</div>
</div>

<!-- SLDS card -->
<article class="slds-card">
    <div class="slds-card__header">Title</div>
    <div class="slds-card__body">Content</div>
</article>
```

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| LWC folder/component | camelCase | `accountList` |
| Aura folder/component | PascalCase with prefix | `LTNG_Access_Control_Demo` |
| JS functions | camelCase | `handleClick` |
| Custom events | kebab-case | `record-selected` |
| CSS classes | SLDS utility first, then BEM | `slds-button`, `my-component__title` |
