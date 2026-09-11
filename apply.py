#!/usr/bin/env python3
"""Install only this theme's files; retain an exact, per-file rollback manifest."""
from pathlib import Path
import datetime, json, shutil, subprocess, sys
root=Path(__file__).resolve().parent
home=Path.home()
state=home/'.local/state/neobrutal'
state.mkdir(parents=True,exist_ok=True)
if '--restore' in sys.argv:
    manifest=json.loads((state/'restore.json').read_text())
    subprocess.run([str(home/'.config/neobrutal/control'),'stop'],check=False)
    for dst,src in manifest.items():
        target=Path(dst)
        if src: shutil.copy2(src,target)
        elif target.exists(): target.unlink()
    (state/'restore.json').unlink()
    print('Previous configuration restored.')
else:
    backup=home/'.local/state/dotfiles-backups'/('neobrutal-apply-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'))
    backup.mkdir(parents=True)
    manifest={}
    for src in sorted((root/'config').rglob('*')):
        if not src.is_file() or '__pycache__' in src.parts: continue
        rel=src.relative_to(root/'config'); dst=home/'.config'/rel
        if dst.exists():
            saved=backup/rel; saved.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(dst,saved); manifest[str(dst)]=str(saved)
        else: manifest[str(dst)]=None
        dst.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(src,dst)
    # Keep the first rollback target when applying later refinements.
    if (state/'restore.json').exists():
        previous=json.loads((state/'restore.json').read_text()); manifest.update(previous)
    (state/'restore.json').write_text(json.dumps(manifest,indent=2))
    print('Theme installed. Backup:',backup)
