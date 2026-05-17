# Project Guidelines

## Project Overview

This is a **Salesforce DX security training project** focused on demonstrating and remediating common Salesforce vulnerabilities (XSS, CSRF, SOQL injection, CRUD/FLS bypass, access control issues). Source API version: **54.0**.

## Code Style & Formatting

- Run `npm run prettier` before committing — Prettier is enforced via `lint-staged`/Husky on pre-commit
- Run `npm run lint` to enforce ESLint rules on Aura and LWC code
- All file types formatted by Prettier: `.cls`, `.html`, `.js`, `.xml`, `.json`, `.md`

## Architecture

```
force-app/main/default/
  classes/      # Apex controllers, utilities, and test classes
  aura/         # Aura (Lightning) components — primary UI framework used here
  lwc/          # Lightning Web Components (stub — reserved for LWC work)
  pages/        # Visualforce pages
  objects/      # Custom object definitions
  triggers/     # Apex triggers
```

## Build and Test

```bash
npm run test:unit          # Run Jest unit tests
npm run test:unit:coverage # Run tests with coverage report
npm run lint               # ESLint on aura/ and lwc/
npm run prettier           # Format all files
```

## Security Conventions

This project explicitly demonstrates and mitigates Salesforce security vulnerabilities. When writing code:

- **Always** use `with sharing` on Apex classes unless there is an explicit, documented reason to use `without sharing` or `inherited sharing`
- **Never** expose DML or SOQL without CRUD/FLS checks unless the class is part of a deliberate "vulnerable" demo (mark it with a `// VULNERABLE: <reason>` comment)
- **Always** check field/object accessibility before SOQL queries using `Schema.sObjectType`
- **Never** use `escape="false"` in Visualforce without output-encoding user-supplied values (use ESAPI or equivalent)
- **Never** read parameters directly from `ApexPages.currentPage().getParameters()` without CSRF protection via `@ReadOnly` or state validation

## Conventions

- Apex test classes use `@isTest public with sharing class ...` naming `<ClassName>Test`
- Demo/challenge classes are named with a descriptive suffix: `_Demo`, `_Challenge`, `_Mitigation_Demo`
- See `.github/instructions/` for language-specific and task-specific guidance
