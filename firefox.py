#!/usr/bin/env python3
"""Apply browser CSS/preferences, preserving unrelated settings and rollback."""
from pathlib import Path
import configparser
import datetime
import json
import re
import shutil

ROOT = Path(__file__).resolve().parent
ADDON = '{3c078156-979c-498b-8990-85f7987dd929}'


def block(old, name, text):
    begin, end = f'/* BEGIN {name} */', f'/* END {name} */'
    old = re.sub(re.escape(begin) + r'.*?' + re.escape(end) + r'\n?', '', old, flags=re.S)
    return old.rstrip() + '\n' + begin + '\n' + text.rstrip() + '\n' + end + '\n'


def install(home=None):
    home = Path.home() if home is None else Path(home)
    firefox = home / '.mozilla/firefox'
    profiles = configparser.ConfigParser(interpolation=None)
    profiles.read(firefox / 'profiles.ini')
    paths = set()
    for section in profiles.sections():
        if section.startswith('Profile') and profiles.has_option(section, 'Path'):
            path = Path(profiles[section]['Path'])
            if profiles[section].get('IsRelative', '1') == '1':
                path = firefox / path
            if path.is_dir():
                paths.add(path)
    if not paths:
        print('Firefox: no profile yet. Open and close Firefox once, then run python firefox.py.')
        return
    state = home / '.local/state/neobrutal'
    state.mkdir(parents=True, exist_ok=True)
    manifest_path = state / 'restore.json'
    manifest = json.loads(manifest_path.read_text()) if manifest_path.exists() else {}
    backup = home / '.local/state/dotfiles-backups' / ('neobrutal-firefox-' + datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f'))

    def write(target, text):
        if str(target) not in manifest:
            if target.exists() or target.is_symlink():
                saved = backup / str(len(manifest))
                saved.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(target, saved, follow_symlinks=False)
                manifest[str(target)] = str(saved)
            else:
                manifest[str(target)] = None
            pending = manifest_path.with_suffix('.tmp')
            pending.write_text(json.dumps(manifest, indent=2))
            pending.replace(manifest_path)
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.is_symlink():
            target.unlink()
        target.write_text(text)

    for path in sorted(paths):
        prefs = (path / 'prefs.js').read_text() if (path / 'prefs.js').exists() else ''
        uuid = None
        for match in re.finditer(r'user_pref\("extensions.webextensions.uuids",\s*("(?:\\.|[^"\\])*")\s*\);', prefs):
            try:
                uuid = json.loads(json.loads(match.group(1))).get(ADDON)
            except (ValueError, AttributeError):
                pass
        # Only embed a valid UUID in CSS; prefs.js is never modified.
        if uuid and not re.fullmatch(r'[a-fA-F0-9-]{36}', uuid):
            uuid = None
        user = path / 'user.js'
        old = user.read_text() if user.exists() else ''
        write(user, block(old, 'NEOBRUTAL PREFERENCES',
                         'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'))
        chrome = path / 'chrome/userChrome.css'
        old = chrome.read_text() if chrome.exists() else ''
        css = (ROOT / 'config/firefox/userChrome.css').read_text()
        # Upgrade the previous installer, which wrote the whole file directly.
        if old.startswith('/* Neobrutal browser chrome.'):
            old = ''
        if not uuid:
            css = css.replace('#TabsToolbar { display: none !important; }', '')
            css = css.replace('#sidebar-header { display: none !important; }', '')
        write(chrome, block(old, 'NEOBRUTAL FIREFOX', css))
        if uuid:
            content = path / 'chrome/userContent.css'
            old = content.read_text() if content.exists() else ''
            css = (ROOT / 'config/firefox/sideberry.css').read_text()
            write(content, block(old, 'NEOBRUTAL SIDEBERY',
                                 '@-moz-document url-prefix("moz-extension://' + uuid + '/") {\n' + css + '\n}'))
            print('Firefox + Sidebery themes configured:', path)
        else:
            print('Firefox theme configured:', path)
            print('Sidebery not detected: install/enable Sidebery, close Firefox, then run python firefox.py. Horizontal tabs remain visible.')
    print('Restart Firefox completely to load the themes and user.js preference.')


if __name__ == '__main__':
    install()
