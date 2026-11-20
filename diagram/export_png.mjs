// Xuất reloop-architecture.drawio → reloop-architecture.png bằng viewer draw.io trong Chrome headless (máy không có draw.io desktop).
// Dùng: node export_png.mjs   (cần mạng để tải viewer-static.min.js từ viewer.diagrams.net)
import { spawn } from 'node:child_process';
import { mkdtempSync, readFileSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = join(dirname(fileURLToPath(import.meta.url)), '..', 'static', 'images', '2-Proposal'); // nơi Hugo lấy ảnh
const NAME = process.argv[2] ?? 'reloop-architecture';
const CHROME = process.env.CHROME ?? 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const xml = readFileSync(join(HERE, `${NAME}.drawio`), 'utf8');
const tmp = mkdtempSync(join(tmpdir(), 'drawio-'));
const html = join(tmp, 'view.html');
writeFileSync(html, `<!doctype html><html><head><meta charset="utf-8"><style>body{margin:0;background:#fff}</style></head><body>
<div id="g" class="mxgraph" data-mxgraph="${JSON.stringify({ xml, toolbar: '', nav: false, resize: false, 'auto-fit': false }).replace(/&/g, '&amp;').replace(/"/g, '&quot;')}"></div>
<script src="https://viewer.diagrams.net/js/viewer-static.min.js"></script></body></html>`);

const port = 9500;
const chrome = spawn(CHROME, ['--headless=new', `--remote-debugging-port=${port}`, `--user-data-dir=${join(tmp, 'p')}`, '--window-size=1600,1000', 'about:blank'], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
let wsUrl;
for (let i = 0; i < 50 && !wsUrl; i++) {
  await sleep(200);
  try { wsUrl = (await (await fetch(`http://127.0.0.1:${port}/json/list`)).json()).find((t) => t.type === 'page')?.webSocketDebuggerUrl; } catch {}
}
const ws = new WebSocket(wsUrl);
await new Promise((r) => ws.addEventListener('open', r));
let id = 0;
const pending = new Map();
ws.addEventListener('message', (e) => { const m = JSON.parse(e.data); if (m.id && pending.has(m.id)) { pending.get(m.id)(m); pending.delete(m.id); } });
const send = (method, params = {}) => new Promise((r) => { const i = ++id; pending.set(i, r); ws.send(JSON.stringify({ id: i, method, params })); });

await send('Page.navigate', { url: 'file:///' + html.replace(/\\/g, '/') });
let box;
for (let i = 0; i < 60 && !box; i++) {
  await sleep(500);
  const r = await send('Runtime.evaluate', { expression: `(() => { const s = document.querySelector('#g svg'); if (!s) return null; const b = s.getBoundingClientRect(); return b.width > 100 ? {x:b.x,y:b.y,w:b.width,h:b.height} : null; })()`, returnByValue: true });
  box = r.result?.result?.value;
}
if (!box) throw new Error('viewer draw.io không vẽ được sơ đồ');
await sleep(1500); // chờ icon
await send('Emulation.setDeviceMetricsOverride', { width: Math.ceil(box.x + box.w + 20), height: Math.ceil(box.y + box.h + 20), deviceScaleFactor: 2, mobile: false });
const shot = await send('Page.captureScreenshot', { format: 'png', clip: { x: box.x, y: box.y, width: box.w, height: box.h, scale: 1 }, captureBeyondViewport: true });
writeFileSync(join(HERE, `${NAME}.png`), Buffer.from(shot.result.data, 'base64'));
console.log(`ok ${NAME}.png ${Math.round(box.w)}x${Math.round(box.h)} (x2)`);
ws.close();
chrome.kill();
process.exit(0);
