import importlib.util
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('browser', ROOT / 'firefox.py')
browser = importlib.util.module_from_spec(spec)
spec.loader.exec_module(browser)


class FirefoxTest(unittest.TestCase):
    def test_repeat_upgrade_and_restore(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            base = home / '.mozilla/firefox'
            profile = base / 'test.default'
            (profile / 'chrome').mkdir(parents=True)
            (base / 'profiles.ini').write_text('[Profile0]\nPath=test.default\nIsRelative=1\n')
            uuid = '12345678-1234-1234-1234-123456789abc'
            prefs = 'user_pref("extensions.webextensions.uuids", ' + json.dumps(json.dumps({browser.ADDON: uuid})) + ');\n'
            (profile / 'prefs.js').write_text(prefs)
            original = {'user.js': 'user_pref("custom.setting", 1);\n',
                        'chrome/userChrome.css': '/* custom chrome */\n',
                        'chrome/userContent.css': '/* custom content */\n'}
            for name, text in original.items():
                (profile / name).write_text(text)
            browser.install(home)
            first = {name: (profile / name).read_text() for name in original}
            browser.install(home)
            self.assertEqual(first, {name: (profile / name).read_text() for name in original})
            self.assertIn('stylesheets", true', first['user.js'])
            self.assertIn(uuid, first['chrome/userContent.css'])
            self.assertEqual((profile / 'prefs.js').read_text(), prefs)
            subprocess.run(['python', str(ROOT / 'apply.py'), '--restore'], env={**os.environ, 'HOME': directory}, check=True)
            for name, text in original.items():
                self.assertEqual((profile / name).read_text(), text)

    def test_without_sidebery_and_later_install(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            profile = home / '.mozilla/firefox/new'
            profile.mkdir(parents=True)
            (profile.parent / 'profiles.ini').write_text('[Profile0]\nPath=new\nIsRelative=1\n')
            browser.install(home)
            self.assertNotIn('#TabsToolbar { display: none', (profile / 'chrome/userChrome.css').read_text())
            self.assertTrue((profile / 'user.js').exists())
            self.assertFalse((profile / 'prefs.js').exists())

    def test_missing_profile_does_not_create_fake_profile(self):
        with tempfile.TemporaryDirectory() as directory:
            browser.install(Path(directory))
            self.assertEqual(list(Path(directory).iterdir()), [])
