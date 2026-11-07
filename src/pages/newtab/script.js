// ==============================================================================
// VORTEX BROWSER - NEW TAB CONTROLLER
// ==============================================================================

const ENGINES = {
  google: { name: 'Google', url: 'https://www.google.com/search?q=' },
  duckduckgo: { name: 'DuckDuckGo', url: 'https://duckduckgo.com/?q=' },
  brave: { name: 'Brave Search', url: 'https://search.brave.com/search?q=' },
  bing: { name: 'Bing', url: 'https://www.bing.com/search?q=' },
  startpage: { name: 'Startpage', url: 'https://www.startpage.com/sp/search?query=' }
};

const I18N = {
  he: {
    lang_toggle: 'EN',
    placeholder: 'חפש באינטרנט או הזן כתובת URL...',
    privacy_status: 'חסימת מעקב מתקדמת פעילה • מנוע Gecko 159+',
    space_core: 'ראשי',
    space_work: 'עבודה',
    space_dev: 'פיתוח',
    space_media: 'מדיה',
    greetings: {
      morning: 'בוקר טוב',
      afternoon: 'צהריים טובים',
      evening: 'ערב טוב',
      night: 'לילה טוב'
    }
  },
  en: {
    lang_toggle: 'עב',
    placeholder: 'Search the web or type a URL...',
    privacy_status: 'Enhanced Tracking Protection Active • Gecko 159+ Engine',
    space_core: 'Core',
    space_work: 'Work',
    space_dev: 'Dev',
    space_media: 'Media',
    greetings: {
      morning: 'Good morning',
      afternoon: 'Good afternoon',
      evening: 'Good evening',
      night: 'Good night'
    }
  }
};

let currentLang = localStorage.getItem('vortex_lang') || 'he';
let currentTheme = localStorage.getItem('vortex_theme') || 'obsidian';
let currentEngine = localStorage.getItem('vortex_engine') || 'google';

// --- Clock & Date ---
function updateClock() {
  const now = new Date();
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  document.getElementById('clockDisplay').textContent = `${hours}:${minutes}`;

  const langCode = currentLang === 'he' ? 'he-IL' : 'en-US';
  const options = { weekday: 'long', month: 'long', day: 'numeric' };
  document.getElementById('dateDisplay').textContent = now.toLocaleDateString(langCode, options);

  // Greeting
  const h = now.getHours();
  let greetKey = 'morning';
  if (h >= 12 && h < 17) greetKey = 'afternoon';
  else if (h >= 17 && h < 21) greetKey = 'evening';
  else if (h >= 21 || h < 5) greetKey = 'night';

  const t = I18N[currentLang].greetings[greetKey];
  document.getElementById('greetingDisplay').textContent = `${t}, Dor`;
}

// --- Search Handler ---
const searchForm = document.getElementById('searchForm');
const searchInput = document.getElementById('searchInput');

searchForm.addEventListener('submit', (e) => {
  e.preventDefault();
  const q = searchInput.value.trim();
  if (!q) return;

  // Check if it's a URL
  const isUrl = /^(https?:\/\/|[a-z0-9-]+\.[a-z]{2,})/i.test(q) && !q.includes(' ');
  if (isUrl) {
    const target = q.startsWith('http') ? q : `https://${q}`;
    window.location.href = target;
  } else {
    const engineUrl = ENGINES[currentEngine]?.url || ENGINES.google.url;
    window.location.href = engineUrl + encodeURIComponent(q);
  }
});

// --- Search Engine Selector ---
const engineBtn = document.getElementById('engineBtn');
const engineMenu = document.getElementById('engineMenu');

engineBtn.addEventListener('click', (e) => {
  e.stopPropagation();
  engineMenu.classList.toggle('open');
});

document.addEventListener('click', () => {
  engineMenu.classList.remove('open');
});

engineMenu.querySelectorAll('.engine-item').forEach(item => {
  item.addEventListener('click', () => {
    currentEngine = item.dataset.engine;
    localStorage.setItem('vortex_engine', currentEngine);
    engineMenu.classList.remove('open');
  });
});

// --- Spaces Switcher ---
const spacesBar = document.getElementById('spacesBar');
spacesBar.querySelectorAll('.space-pill').forEach(pill => {
  pill.addEventListener('click', () => {
    spacesBar.querySelectorAll('.space-pill').forEach(p => p.classList.remove('active'));
    pill.classList.add('active');
    localStorage.setItem('vortex_active_space', pill.dataset.space);
  });
});

// --- Language Toggle ---
const langToggle = document.getElementById('langToggle');
langToggle.addEventListener('click', () => {
  currentLang = currentLang === 'he' ? 'en' : 'he';
  localStorage.setItem('vortex_lang', currentLang);
  applyLanguage();
});

function applyLanguage() {
  document.documentElement.lang = currentLang;
  document.documentElement.dir = currentLang === 'he' ? 'rtl' : 'ltr';
  document.getElementById('langText').textContent = I18N[currentLang].lang_toggle;
  searchInput.placeholder = I18N[currentLang].placeholder;

  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.dataset.i18n;
    if (I18N[currentLang][key]) {
      el.textContent = I18N[currentLang][key];
    }
  });

  updateClock();
}

// --- Theme Toggle ---
const themes = ['obsidian', 'cyberpunk', 'nord'];
const themeToggle = document.getElementById('themeToggle');
themeToggle.addEventListener('click', () => {
  const nextIdx = (themes.indexOf(currentTheme) + 1) % themes.length;
  currentTheme = themes[nextIdx];
  document.documentElement.setAttribute('data-theme', currentTheme);
  localStorage.setItem('vortex_theme', currentTheme);
});

// Init
document.documentElement.setAttribute('data-theme', currentTheme);
applyLanguage();
setInterval(updateClock, 1000);
updateClock();

