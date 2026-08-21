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

// Mirrors declarativeNetRequest's urlFilter mini-language for the subset of
// syntax these rules use: a leading '|' anchors the match to the start of
// the URL, and '*' matches any run of characters.
function urlFilterToRegex(filter) {
    const anchored = filter.startsWith('|');
    const body = anchored ? filter.slice(1) : filter;
    const escaped = body.replace(/[.+?^${}()|[\]\\]/g, '\\$&').replace(/\*/g, '.*');
    return new RegExp((anchored ? '^' : '') + escaped);
}

// Mirrors declarativeNetRequest's "transform" redirect action: fields left
// unset on the transform (path, query, fragment) are carried over from the
// original URL untouched.
function applyRule(rule, normalizedUrl) {
    if (!urlFilterToRegex(rule.condition.urlFilter).test(normalizedUrl)) return null;
    const { transform } = rule.action.redirect;
    const result = new URL(normalizedUrl);
    if (transform.scheme) result.protocol = `${transform.scheme}:`;
    if (transform.host) result.hostname = transform.host;
    return result.toString();
}

// Mirrors how declarativeNetRequest evaluates a ruleset: the first rule
// (by ascending priority, then by original order) whose condition matches wins.
// Conditions are evaluated against the browser's already-normalized request
// URL (e.g. "https://x.com" becomes "https://x.com/"), same as real navigation.
function redirectFor(url) {
    const normalizedUrl = new URL(url).toString();
    for (const rule of rules) {
        const result = applyRule(rule, normalizedUrl);
        if (result !== null) return result;
    }
    return null;
}

test('rule ids are unique', () => {
    const ids = rules.map((rule) => rule.id);
    assert.equal(new Set(ids).size, ids.length);
});

test('rules avoid regexSubstitution and regexFilter, which Safari does not reliably support', () => {
    for (const rule of rules) {
        assert.equal('regexSubstitution' in rule.action.redirect, false);
        assert.equal('regexFilter' in rule.condition, false);
        assert.ok(rule.action.redirect.transform);
        assert.ok(rule.condition.urlFilter);
    }
});

test('redirects bare x.com with no path', () => {
    assert.equal(redirectFor('https://x.com'), 'https://xcancel.com/');
});

test('redirects bare twitter.com with trailing slash', () => {
    assert.equal(redirectFor('https://twitter.com/'), 'https://xcancel.com/');
});

test('redirects www.x.com', () => {
    assert.equal(redirectFor('https://www.x.com'), 'https://xcancel.com/');
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
