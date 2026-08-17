import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const rulesPath = path.join(
    __dirname,
    '..',
    'Shared (Extension)',
    'Resources',
    'xcancel_redirect_rules.json'
);
const rules = JSON.parse(readFileSync(rulesPath, 'utf8'));

function applyRule(rule, url) {
    const match = url.match(new RegExp(rule.condition.regexFilter));
    if (!match) return null;
    return rule.action.redirect.regexSubstitution.replace(/\\(\d)/g, (_, n) => match[n] ?? '');
}

// Mirrors how declarativeNetRequest evaluates a ruleset: the first rule
// (by ascending priority, then by original order) whose condition matches wins.
function redirectFor(url) {
    for (const rule of rules) {
        const result = applyRule(rule, url);
        if (result !== null) return result;
    }
    return null;
}

test('rule ids are unique', () => {
    const ids = rules.map((rule) => rule.id);
    assert.equal(new Set(ids).size, ids.length);
});

test('redirects bare x.com with no path', () => {
    assert.equal(redirectFor('https://x.com'), 'https://xcancel.com');
});

test('redirects bare twitter.com with trailing slash', () => {
    assert.equal(redirectFor('https://twitter.com/'), 'https://xcancel.com/');
});

test('redirects www.x.com', () => {
    assert.equal(redirectFor('https://www.x.com'), 'https://xcancel.com');
});

test('preserves path and query string on x.com', () => {
    assert.equal(
        redirectFor('https://x.com/someuser/status/123?s=20'),
        'https://xcancel.com/someuser/status/123?s=20'
    );
});

test('preserves path, query, and fragment on www.twitter.com', () => {
    assert.equal(
        redirectFor('https://www.twitter.com/someuser/status/999?ref=share#comments'),
        'https://xcancel.com/someuser/status/999?ref=share#comments'
    );
});

test('redirects plain http as well as https', () => {
    assert.equal(redirectFor('http://twitter.com/someuser'), 'https://xcancel.com/someuser');
});

test('does not match lookalike or unrelated domains', () => {
    assert.equal(redirectFor('https://x.company.com/foo'), null);
    assert.equal(redirectFor('https://notx.com/foo'), null);
    assert.equal(redirectFor('https://xtwitter.com/foo'), null);
    assert.equal(redirectFor('https://mobile.twitter.com/foo'), null);
    assert.equal(redirectFor('https://tiktok.com/@user/video/1'), null);
});
