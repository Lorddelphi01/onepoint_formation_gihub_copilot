#!/usr/bin/env node
/**
 * Audit local tutorial references and demo coverage.
 *
 * Usage:
 *   npm run audit
 *   npm run audit -- --report=./audit-report.md
 */

const {
  existsSync,
  readdirSync,
  readFileSync,
  statSync,
  writeFileSync
} = require('fs');
const { extname, join, relative, resolve } = require('path');

const rootDir = join(__dirname, '..', '..');
const demosPath = join(__dirname, 'demos.json');
const reportArgument = process.argv.find(argument => argument.startsWith('--report='));
const reportPath = reportArgument ? resolve(rootDir, reportArgument.slice('--report='.length)) : null;

function findChapterDirectories() {
  return readdirSync(rootDir)
    .filter(name => /^\d{2}-/.test(name))
    .filter(name => existsSync(join(rootDir, name, 'README.md')))
    .sort();
}

function findMarkdownFiles() {
  const files = [];
  function visit(directory) {
    for (const entry of readdirSync(directory)) {
      if (entry === '.git' || entry === 'node_modules') continue;
      const path = join(directory, entry);
      const stat = statSync(path);
      if (stat.isDirectory()) {
        visit(path);
      } else if (stat.isFile() && extname(entry).toLowerCase() === '.md') {
        files.push(path);
      }
    }
  }
  visit(rootDir);
  return files;
}

function withoutFencedCode(content) {
  return content.replace(/```[\s\S]*?```/g, '').replace(/~~~[\s\S]*?~~~/g, '');
}

function isExternalReference(reference) {
  return /^(?:[a-z][a-z\d+.-]*:|\/\/|#)/i.test(reference);
}

function cleanReference(reference) {
  const withoutTitle = reference.trim().replace(/\s+["'][^"']*["']\s*$/, '');
  return withoutTitle.split('#', 1)[0].split('?', 1)[0].trim();
}

function extractReferences(content) {
  const references = [];
  const source = withoutFencedCode(content);
  const markdownPattern = /!?\[[^\]]*\]\(([^)\s]+)(?:\s+["'][^)]*["'])?\)/g;
  const htmlPattern = /(?:href|src)\s*=\s*["']([^"']+)["']/gi;

  let match;
  while ((match = markdownPattern.exec(source)) !== null) {
    references.push(match[1]);
  }
  while ((match = htmlPattern.exec(source)) !== null) {
    references.push(match[1]);
  }
  return references;
}

function findLocalReferenceProblems() {
  const problems = [];
  for (const file of findMarkdownFiles()) {
    const content = readFileSync(file, 'utf8');
    for (const reference of extractReferences(content)) {
      const cleaned = cleanReference(reference);
      if (!cleaned || isExternalReference(cleaned)) continue;

      const target = resolve(join(file, '..'), cleaned);
      if (!existsSync(target)) {
        problems.push({
          file: relative(rootDir, file),
          reference,
          target: relative(rootDir, target)
        });
      }
    }
  }
  return problems;
}

function findDemoAssets() {
  const gifs = [];
  const tapes = [];
  for (const chapter of findChapterDirectories()) {
    const assetsDir = join(rootDir, chapter, 'assets');
    if (!existsSync(assetsDir)) continue;
    for (const file of readdirSync(assetsDir)) {
      const path = join(assetsDir, file);
      if (!statSync(path).isFile()) continue;
      if (file.endsWith('-demo.gif')) gifs.push(path);
      if (file.endsWith('.tape')) tapes.push(path);
    }
  }
  return { gifs, tapes };
}

function findReferencedGifs() {
  const references = new Set();
  for (const file of findMarkdownFiles()) {
    for (const reference of extractReferences(readFileSync(file, 'utf8'))) {
      const cleaned = cleanReference(reference);
      if (cleaned.endsWith('.gif')) {
        references.add(resolve(join(file, '..'), cleaned));
      }
    }
  }
  return references;
}

function findCopilotChapters() {
  return findChapterDirectories().filter(chapter => {
    const content = readFileSync(join(rootDir, chapter, 'README.md'), 'utf8');
    const codeBlocks = [...content.matchAll(/```(?:bash|shell|sh)?\s*([\s\S]*?)```/gi)]
      .map(match => match[1])
      .join('\n');
    return /\bcopilot(?:\s|$)/i.test(codeBlocks);
  });
}

function auditDemos() {
  const config = JSON.parse(readFileSync(demosPath, 'utf8'));
  const { gifs, tapes } = findDemoAssets();
  const configured = config.demos || [];
  const gifSet = new Set(gifs);
  const tapeSet = new Set(tapes);
  const referencedGifs = findReferencedGifs();

  const configProblems = [];
  for (const demo of configured) {
    const gif = join(rootDir, demo.chapter, 'assets', `${demo.name}.gif`);
    const tape = join(rootDir, demo.chapter, 'assets', `${demo.name}.tape`);
    if (!tapeSet.has(tape)) configProblems.push(`missing tape: ${relative(rootDir, tape)}`);
    if (!gifSet.has(gif)) configProblems.push(`missing GIF: ${relative(rootDir, gif)}`);
  }

  const orphanGifs = gifs.filter(gif => !referencedGifs.has(gif) &&
    !configured.some(demo => join(rootDir, demo.chapter, 'assets', `${demo.name}.gif`) === gif));
  const configuredChapters = new Set(configured.map(demo => demo.chapter));
  const uncoveredChapters = findCopilotChapters().filter(chapter => !configuredChapters.has(chapter));

  return {
    configuredCount: configured.length,
    gifs,
    tapes,
    referencedGifs,
    configProblems,
    orphanGifs,
    uncoveredChapters
  };
}

function formatReport(referenceProblems, demos) {
  const lines = [
    '# Audit des références et des démos',
    '',
    `- Références locales cassées : **${referenceProblems.length}**`,
    `- GIF présents : **${demos.gifs.length}**`,
    `- GIF référencés : **${demos.referencedGifs.size}**`,
    `- GIF orphelins : **${demos.orphanGifs.length}**`,
    `- Entrées dans \`demos.json\` : **${demos.configuredCount}**`,
    '',
    '## Références locales cassées',
    ''
  ];
  if (referenceProblems.length === 0) {
    lines.push('Aucune.');
  } else {
    for (const problem of referenceProblems) {
      lines.push(`- \`${problem.file}\` → \`${problem.reference}\` (attendu : \`${problem.target}\`)`);
    }
  }
  lines.push('', '## Cohérence de `demos.json`', '');
  if (demos.configProblems.length === 0) lines.push('Toutes les entrées ont un tape et un GIF correspondants.');
  else demos.configProblems.forEach(problem => lines.push(`- ${problem}`));
  lines.push('', '## GIF orphelins', '');
  if (demos.orphanGifs.length === 0) lines.push('Aucun.');
  else demos.orphanGifs.forEach(gif => lines.push(`- \`${relative(rootDir, gif)}\``));
  lines.push('', '## Chapitres avec commandes Copilot non couverts', '');
  if (demos.uncoveredChapters.length === 0) lines.push('Tous les chapitres détectés sont couverts.');
  else demos.uncoveredChapters.forEach(chapter => lines.push(`- \`${chapter}\``));
  lines.push('');
  return lines.join('\n');
}

function main() {
  const referenceProblems = findLocalReferenceProblems();
  const demos = auditDemos();
  const report = formatReport(referenceProblems, demos);

  console.log(report);
  if (reportPath) {
    writeFileSync(reportPath, report);
    console.log(`Report written to ${relative(rootDir, reportPath)}`);
  }

  if (referenceProblems.length > 0) process.exitCode = 1;
}

main();
