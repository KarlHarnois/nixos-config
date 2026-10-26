// ==UserScript==
// @name        Calendar notification permission
// @match       https://calendar.google.com/*
// @run-at      document-start
// ==/UserScript==

Notification.requestPermission();
Object.defineProperty(Notification, "permission", { get: () => "granted" });
