import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const root = path.resolve(__dirname, '..');

console.log('📦 Building Vortex Browser assets and distribution package...');

const profileDir = path.join(root, '.profile');
const chromeDir = path.join(profileDir, 'chrome');

fs.mkdirSync(chromeDir, { recursive: true });

fs.copyFileSync(
  path.join(root, 'src', 'chrome', 'userChrome.css'),
  path.join(chromeDir, 'userChrome.css')
);

fs.copyFileSync(
  path.join(root, 'src', 'chrome', 'userContent.css'),
  path.join(chromeDir, 'userContent.css')
);

console.log('✅ Chrome stylesheets synced.');
console.log('✅ Build complete!');
