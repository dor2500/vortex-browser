import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const root = path.resolve(__dirname, '..');

const profileDir = path.join(root, '.profile');

if (fs.existsSync(profileDir)) {
  console.log('🧹 Cleaning isolated profile directory...');
  fs.rmSync(profileDir, { recursive: true, force: true });
  console.log('✅ Clean complete.');
} else {
  console.log('✨ Already clean.');
}
