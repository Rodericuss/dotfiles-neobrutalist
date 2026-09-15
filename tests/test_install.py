"""Isolated install/rollback checks; no changes to the real desktop."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class InstallationTest(unittest.TestCase):
    def test_repeat_install_and_restore_symlink(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            env = {**os.environ, 'HOME': directory}
            target = home / '.config/kitty/kitty.conf'
            target.parent.mkdir(parents=True)
            original = home / 'original'
            original.write_text('previous config')
            target.symlink_to(original)
            local = home / '.config/hypr/local.lua'
            local.parent.mkdir(parents=True)
            local.write_text('-- local settings')
            for _ in range(2):
                subprocess.run(['python', str(ROOT / 'apply.py'), '--full'], env=env, check=True)
            self.assertEqual(original.read_text(), 'previous config')
            self.assertTrue((home / '.config/nvim/init.lua').exists())
            self.assertIn(directory, (home / '.config/hypr/hyprpaper.conf').read_text())
            self.assertTrue(os.access(home / '.config/neobrutal/scripts/focus', os.X_OK))
            subprocess.run(['python', str(ROOT / 'apply.py'), '--restore'], env=env, check=True)
            self.assertTrue(target.is_symlink())
            self.assertEqual(target.read_text(), 'previous config')
            self.assertFalse((home / '.config/nvim/init.lua').exists())
            self.assertEqual(local.read_text(), '-- local settings')

    def test_dry_run_does_not_write(self):
        with tempfile.TemporaryDirectory() as directory:
            env = {**os.environ, 'HOME': directory}
            for key in ('XDG_CONFIG_HOME', 'XDG_DATA_HOME', 'XDG_STATE_HOME'):
                env.pop(key, None)
            result = subprocess.run([str(ROOT / 'install.sh'), '--dry-run'], env=env, check=True, capture_output=True, text=True)
            self.assertIn('ripgrep', result.stdout)
            self.assertIn('fzf', result.stdout)
            self.assertEqual(list(Path(directory).iterdir()), [])


if __name__ == '__main__':
    unittest.main()
