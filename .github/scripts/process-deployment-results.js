const fs = require('fs');
const path = require('path');

const [deployOutputFile, orgAlias] = process.argv.slice(2);

if (!deployOutputFile) {
  console.error('Usage: node process-deployment-results.js <deploy-output.json> <org-alias>');
  process.exit(1);
}

const raw = fs.readFileSync(deployOutputFile, 'utf8');
const output = JSON.parse(raw);
const result = output.result ?? output;

const lines = [];

function line(text = '') {
  lines.push(text);
}

function hr() {
  line('---');
}

// Header
line(`## Salesforce Deployment Report`);
if (orgAlias) line(`**Org:** \`${orgAlias}\``);
line(`**Status:** ${result.status ?? 'Unknown'}`);
line(`**Deploy ID:** \`${result.id ?? 'N/A'}\``);
line();

// Component summary
hr();
line('### Components');
line(`| Result | Count |`);
line(`|--------|-------|`);
line(`| Deployed | ${result.numberComponentsDeployed ?? 0} |`);
line(`| Errors   | ${result.numberComponentErrors ?? 0} |`);
line(`| Total    | ${result.numberComponentsTotal ?? 0} |`);
line();

// Component errors
const componentErrors = result.details?.componentFailures ?? [];
if (componentErrors.length > 0) {
  line('### Component Errors');
  for (const err of componentErrors) {
    line(`- **${err.fullName}** (${err.componentType}): ${err.problem}`);
  }
  line();
}

// Test summary
const testResult = result.runTestResult;
if (testResult) {
  hr();
  line('### Tests');
  line(`| Result | Count |`);
  line(`|--------|-------|`);
  line(`| Passed  | ${testResult.numTestsRun - testResult.numFailures} |`);
  line(`| Failed  | ${testResult.numFailures} |`);
  line(`| Total   | ${testResult.numTestsRun} |`);
  line();

  // Test failures
  const failures = testResult.failures ?? [];
  if (failures.length > 0) {
    line('### Test Failures');
    for (const f of failures) {
      line(`- **${f.name}.${f.methodName}**: ${f.message}`);
    }
    line();
  }

  // Code coverage
  const coverage = testResult.codeCoverage ?? [];
  if (coverage.length > 0) {
    hr();
    line('### Code Coverage');
    line(`| Class/Trigger | Lines Covered | Lines Total | Coverage |`);
    line(`|---------------|---------------|-------------|----------|`);

    for (const c of coverage.sort((a, b) => {
      const pctA = c.numLocations > 0 ? c.numLocationsCovered / c.numLocations : 0;
      const pctB = b.numLocations > 0 ? b.numLocationsCovered / b.numLocations : 0;
      return pctA - pctB;
    })) {
      const pct = c.numLocations > 0
        ? Math.round((c.numLocationsCovered / c.numLocations) * 100)
        : 0;
      const flag = pct < 75 ? ' ⚠️' : '';
      line(`| ${c.name} | ${c.numLocationsCovered} | ${c.numLocations} | ${pct}%${flag} |`);
    }
    line();

    const totalLines = coverage.reduce((s, c) => s + c.numLocations, 0);
    const coveredLines = coverage.reduce((s, c) => s + c.numLocationsCovered, 0);
    const avgPct = totalLines > 0 ? Math.round((coveredLines / totalLines) * 100) : 0;
    line(`**Overall coverage: ${avgPct}%** (${coveredLines}/${totalLines} lines)`);
    line();
  }
}

const summary = lines.join('\n');

// Write to GitHub Actions job summary if available
const summaryFile = process.env.GITHUB_STEP_SUMMARY;
if (summaryFile) {
  fs.appendFileSync(summaryFile, summary + '\n');
}

// Always print to stdout
console.log(summary);
