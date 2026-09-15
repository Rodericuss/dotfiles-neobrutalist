#!/usr/bin/env python3
"""Install theme/base files with a persistent, per-file rollback manifest."""
from pathlib import Path
import datetime
import json
import shutil
import sys

root = Path(__file__).resolve().parent
home = Path.home()
state = home / '.local/state/neobrutal'
manifest_path = state / 'restore.json'


def apply(full=False):
    state.mkdir(parents=True, exist_ok=True)
    manifest = json.loads(manifest_path.read_text()) if manifest_path.exists() else {}
    backup = home / '.local/state/dotfiles-backups' / ('neobrutal-apply-' + datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f'))
    files = {}
    trees = [(root / 'config', home / '.config')]
    if full:
        trees = [(root / 'base/config', home / '.config'),
                 (root / 'base/fonts', home / '.local/share/fonts')] + trees
    for source, target in trees:
        for src in sorted(source.rglob('*')):
            if src.is_file() and '__pycache__' not in src.parts:
                files[target / src.relative_to(source)] = src
    for dst, src in files.items():
        if str(dst) not in manifest:
            if dst.exists() or dst.is_symlink():
                saved = backup / dst.relative_to(home)
                saved.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(dst, saved, follow_symlinks=False)
                manifest[str(dst)] = str(saved)
            else:
                manifest[str(dst)] = None
            # Persist before changing the destination, including on interrupted installs.
            pending = manifest_path.with_suffix('.tmp')
            pending.write_text(json.dumps(manifest, indent=2))
            pending.replace(manifest_path)
        dst.parent.mkdir(parents=True, exist_ok=True)
        if dst.is_symlink():
            dst.unlink()
        shutil.copy2(src, dst)
        try:
            text = dst.read_text()
        except UnicodeDecodeError:
            continue
        if '/home/amitis' in text:
            dst.write_text(text.replace('/home/amitis', str(home)))
    print('Installed. Rollback manifest:', manifest_path)


def restore():
    if not manifest_path.exists():
        raise SystemExit('No saved configuration to restore.')
    for dst, src in json.loads(manifest_path.read_text()).items():
        target = Path(dst)
        if target.is_symlink() or target.is_file():
            target.unlink()
        if src:
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, target, follow_symlinks=False)
    manifest_path.unlink()
    print('Previous configuration restored. Installed packages are retained.')


if __name__ == '__main__':
    if '--restore' in sys.argv:
        restore()
    else:
        apply('--full' in sys.argv)
