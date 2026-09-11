#!/usr/bin/env python3
"""Install chrome CSS and scoped Sidebery CSS without touching tabs or extension databases."""
from pathlib import Path
import configparser,datetime,json,re,shutil
home=Path.home(); root=Path(__file__).resolve().parent
firefox=home/'.mozilla/firefox'
profiles=configparser.ConfigParser(); profiles.read(firefox/'profiles.ini')
state=home/'.local/state/neobrutal'; state.mkdir(parents=True,exist_ok=True)
manifest_path=state/'restore.json'; manifest=json.loads(manifest_path.read_text()) if manifest_path.exists() else {}
backup=home/'.local/state/dotfiles-backups'/('neobrutal-firefox-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'))
addon='{3c078156-979c-498b-8990-85f7987dd929}'

def write(target,text):
    if str(target) not in manifest:
        if target.exists():
            saved=backup/target.relative_to(home); saved.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(target,saved); manifest[str(target)]=str(saved)
        else: manifest[str(target)]=None
    target.parent.mkdir(parents=True,exist_ok=True); target.write_text(text)

for section in profiles.sections():
    if not section.startswith('Profile'): continue
    p=Path(profiles[section]['Path'])
    if profiles[section].get('IsRelative')=='1': p=firefox/p
    if not (p/'prefs.js').exists(): continue
    prefs=(p/'prefs.js').read_text()
    uuid=None
    for line in prefs.splitlines():
        if line.startswith('user_pref("extensions.webextensions.uuids",'):
            mapping=json.loads(json.loads(line.split(', ',1)[1][:-2])); uuid=mapping.get(addon)
    if not uuid: continue  # Only the actual profile with Sidebery installed.
    write(p/'chrome/userChrome.css',(root/'config/firefox/userChrome.css').read_text())
    content=p/'chrome/userContent.css'
    old=content.read_text() if content.exists() else ''
    old=re.sub(r'/\* BEGIN NEOBRUTAL SIDEBERY \*/.*?/\* END NEOBRUTAL SIDEBERY \*/','',old,flags=re.S)
    css=(root/'config/firefox/sideberry.css').read_text()
    write(content,old+'\n/* BEGIN NEOBRUTAL SIDEBERY */\n@-moz-document url-prefix("moz-extension://'+uuid+'/") {\n'+css+'\n}\n/* END NEOBRUTAL SIDEBERY */\n')
    print('Installed Firefox + scoped Sidebery CSS:',p/'chrome')
manifest_path.write_text(json.dumps(manifest,indent=2))
