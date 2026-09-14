#!/usr/bin/env python3
"""Pastel desktop widgets. Native GTK/Wayland, local state, no extra service."""
import datetime as dt
import json
import os
from pathlib import Path
import queue
import signal
import subprocess
import threading
import time
import gi

gi.require_version('Gtk', '3.0')
gi.require_version('GtkLayerShell', '0.1')
from gi.repository import Gtk, Gdk, GLib, GLibUnix, GtkLayerShell

ROOT = Path(__file__).resolve().parent
STATE = Path(os.environ.get('XDG_STATE_HOME', str(Path.home()/'.local/state'))) / 'neobrutal'
STATE.mkdir(parents=True, exist_ok=True)

def run(*args):
    try:
        return subprocess.check_output(args, text=True, stderr=subprocess.DEVNULL, timeout=3).strip()
    except (OSError, subprocess.SubprocessError):
        return ''

def launch(*args):
    try:
        subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)
    except OSError:
        pass

def box(vertical=False, spacing=12, cls=None):
    w = Gtk.Box(orientation=Gtk.Orientation.VERTICAL if vertical else Gtk.Orientation.HORIZONTAL, spacing=spacing)
    if cls: w.get_style_context().add_class(cls)
    return w

def label(text='', cls=None):
    w = Gtk.Label(label=text)
    w.set_xalign(0)
    if cls: w.get_style_context().add_class(cls)
    return w

def button(text, fn, cls=None):
    w = Gtk.Button(label=text)
    w.connect('clicked', lambda *_: fn())
    if cls: w.get_style_context().add_class(cls)
    return w

def add(parent, child, expand=False):
    parent.pack_start(child, expand, expand, 0)
    return child

def card(title=None):
    w = box(True, 12, 'card')
    if title: add(w, label(title, 'heading'))
    return w

class Shell:
    def __init__(self):
        self.windows = {}
        self.metrics = {}
        self.tasks = []
        try: self.tasks = json.loads((STATE/'tasks.json').read_text())
        except (OSError, ValueError): pass
        self.remaining = 25 * 60
        self.running = False
        self.deadline = 0
        self.mode = 'Focus'
        self.timer_labels = []
        self.clocks = []
        self.stats_labels = []
        self.music_labels = []
        self.volume_scales = []
        self.volume_sync = False
        self.task_boxes = []
        self.updating = queue.Queue()
        css = Gtk.CssProvider()
        css.load_from_path(str(ROOT/'style.css'))
        Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), css, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        self.make_dashboard()
        self.make_widgets()
        self.render_tasks()
        GLib.timeout_add_seconds(1, self.tick)
        threading.Thread(target=self.poll, daemon=True).start()
        GLibUnix.signal_add(GLib.PRIORITY_DEFAULT, signal.SIGUSR1, self.toggle_signal, 'dashboard')
        GLibUnix.signal_add(GLib.PRIORITY_DEFAULT, signal.SIGUSR2, self.toggle_signal, 'widgets')
        self.tick()

    def window(self, name, content, width, anchor=None):
        w = Gtk.Window(title='Neobrutal '+name)
        w.set_default_size(width, -1)
        w.set_resizable(False)
        GtkLayerShell.init_for_window(w)
        GtkLayerShell.set_namespace(w, 'neobrutal')
        GtkLayerShell.set_layer(w, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_keyboard_mode(w, GtkLayerShell.KeyboardMode.ON_DEMAND)
        if anchor:
            for edge in anchor:
                GtkLayerShell.set_anchor(w, edge, True)
                GtkLayerShell.set_margin(w, edge, 80 if edge == GtkLayerShell.Edge.TOP else 20)
        outer = box(True, 0, 'surface')
        add(outer, content)
        w.add(outer)
        w.connect('key-press-event', lambda _, e: self.hide_all() if e.keyval == Gdk.KEY_Escape else False)
        self.windows[name] = w
        w.show_all()
        w.hide()
        return w

    def hide_all(self):
        for w in self.windows.values(): w.hide()
        return True

    def toggle_signal(self, name):
        self.toggle(name)
        return True

    def toggle(self, name):
        names = ['tasks', 'calendar'] if name == 'widgets' else ['dashboard']
        visible = self.windows[names[0]].get_visible()
        for n in names:
            if visible: self.windows[n].hide()
            else: self.windows[n].show_all()

    def clock(self):
        c = card()
        t = add(c, label('', 'clock'))
        d = add(c, label('', 'muted'))
        self.clocks.append((t,d))
        return c

    def media(self):
        c = card('♫  NOW PLAYING')
        name = add(c, label('Nothing playing', 'song'))
        name.set_max_width_chars(32)
        name.set_ellipsize(3)
        artist = add(c, label('Open a music player to begin', 'muted'))
        artist.set_max_width_chars(36)
        artist.set_ellipsize(3)
        self.music_labels.append((name,artist))
        dots = box(False, 5)
        for cls in ['peach','pink','pink','yellow','yellow','green','green','blue','blue','lilac']:
            dot=label('●', cls); add(dots,dot,True)
        add(c,dots)
        controls = box(False, 10)
        for text,cmd in [('󰒮','previous'),('󰐎','play-pause'),('󰒭','next')]:
            add(controls,button(text,lambda cmd=cmd: launch('playerctl',cmd),'peach'),True)
        add(c,controls)
        return c

    def volume(self):
        c = card('󰕾  AUDIO')
        scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL,0,100,1)
        scale.set_value_pos(Gtk.PositionType.RIGHT)
        scale.connect('value-changed', self.change_volume)
        self.volume_scales.append(scale)
        add(c,scale)
        row=box()
        add(row,button('Mute',lambda: launch('pamixer','-t'),'pink'),True)
        add(row,button('Mixer',lambda: launch('pavucontrol')),True)
        add(c,row)
        return c

    def change_volume(self,scale):
        if not self.volume_sync: launch('pamixer','--set-volume',str(round(scale.get_value())))

    def stats(self):
        c=card('󰍛  SYSTEM SPECS')
        add(c,label('Arch Linux  ·  Hyprland', 'muted'))
        for key,title in [('cpu','CPU'),('ram','RAM'),('disk','Disk')]:
            row=box()
            add(row,label(title),True)
            value=add(row,label('…'))
            self.stats_labels.append((key,value))
            add(c,row)
        up=add(c,label('','muted')); self.stats_labels.append(('uptime',up))
        return c

    def make_dashboard(self):
        root=box(True,14,'dashboard')
        header=box()
        add(header,label('▦  DESKTOP', 'heading'),True)
        add(header,button('×',self.hide_all,'pink'))
        add(root,header)
        body=box(False,14)
        left=box(True)
        profile=card()
        add(profile,label('󰣇','avatar'))
        add(profile,label(os.environ.get('USER','user'), 'song'))
        add(profile,label('●  Online','green'))
        add(left,profile)
        for title,cmd in [('󰈹  Firefox',['firefox']),('󰆍  Terminal',['kitty']),('󰉋  Files',['hyprctl','eval','hl.dispatch(hl.dsp.workspace.toggle_special("yazi"))']),('󰏘  Editor',['neovide']),('󰙯  Discord',['hyprctl','eval','hl.dispatch(hl.dsp.workspace.toggle_special("discord"))'])]:
            add(left,button(title,lambda cmd=cmd: (self.hide_all(), launch(*cmd))))
        add(body,left)
        middle=box(True)
        add(middle,self.clock())
        add(middle,self.media(),True)
        add(body,middle,True)
        right=box(True)
        add(right,self.stats(),True)
        add(right,self.volume())
        add(right,button('✓  Tasks & focus',lambda: self.toggle('widgets'),'green'))
        add(body,right)
        add(root,body)
        links=box(False,12)
        for title,url,cls in [('GitHub','https://github.com','blue'),('Reddit','https://reddit.com','peach'),('YouTube','https://youtube.com','pink'),('WhatsApp','https://web.whatsapp.com','green'),('Gmail','https://mail.google.com','lilac')]:
            add(links,button(title,lambda url=url: launch('xdg-open',url),cls),True)
        add(root,links)
        self.window('dashboard',root,880)

    def task_card(self):
        c=card('✓  TASKS')
        row=box(False,8)
        entry=Gtk.Entry(); entry.set_placeholder_text('What needs to be done?')
        entry.connect('activate',lambda *_: self.add_task(entry))
        add(row,entry,True)
        add(row,button('+',lambda: self.add_task(entry),'pink'))
        add(c,row)
        tasks=box(True,10)
        scroll=Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER,Gtk.PolicyType.AUTOMATIC)
        scroll.set_min_content_height(150)
        scroll.add(tasks)
        add(c,scroll,True)
        self.task_boxes.append(tasks)
        return c

    def save_tasks(self):
        tmp=STATE/'tasks.json.tmp'; tmp.write_text(json.dumps(self.tasks,ensure_ascii=False)); tmp.replace(STATE/'tasks.json')

    def add_task(self,entry):
        text=entry.get_text().strip()
        if text:
            self.tasks.append({'text':text,'done':False})
            self.save_tasks(); self.render_tasks(); entry.set_text('')

    def complete(self,i,done):
        self.tasks[i]['done']=done; self.save_tasks()

    def remove(self,i):
        self.tasks.pop(i); self.save_tasks(); self.render_tasks()

    def render_tasks(self):
        for container in self.task_boxes:
            for child in container.get_children(): container.remove(child)
            if not self.tasks: add(container,label('A little space for your next idea.', 'muted'))
            for i,task in enumerate(self.tasks):
                row=box(False,8)
                check=Gtk.CheckButton(label=task['text']); check.set_active(task['done'])
                check.get_child().set_line_wrap(True); check.get_child().set_max_width_chars(27)
                check.connect('toggled',lambda w,i=i:self.complete(i,w.get_active()))
                add(row,check,True)
                add(row,button('×',lambda i=i:self.remove(i)))
                add(container,row)
            container.show_all()

    def timer(self):
        c=card('◷  A LITTLE TIME TO FOCUS')
        row=box(False,8)
        for title,mins in [('Focus',25),('Break',5),('Long',15)]:
            add(row,button(title,lambda t=title,m=mins:self.set_timer(t,m),'green' if title=='Focus' else None),True)
        add(c,row)
        t=add(c,label('25:00','timer'))
        self.timer_labels.append(t)
        row=box()
        add(row,button('󰐎  Start / pause',self.toggle_timer,'peach'),True)
        add(row,button('↻',lambda:self.set_timer(self.mode,{'Focus':25,'Break':5,'Long':15}[self.mode]),'lilac'))
        add(c,row)
        return c

    def set_timer(self,title,mins):
        self.mode=title; self.remaining=mins*60; self.running=False; self.tick()

    def toggle_timer(self):
        if self.running: self.remaining=max(0,int(self.deadline-time.monotonic()))
        else: self.deadline=time.monotonic()+self.remaining
        self.running=not self.running

    def make_widgets(self):
        left=box(True,16)
        add(left,self.task_card())
        add(left,self.timer())
        self.window('tasks',left,385,[GtkLayerShell.Edge.LEFT,GtkLayerShell.Edge.TOP])
        right=box(True,16)
        add(right,self.clock())
        c=card()
        cal=Gtk.Calendar(); add(c,cal)
        add(right,c)
        add(right,self.media())
        self.window('calendar',right,360,[GtkLayerShell.Edge.RIGHT,GtkLayerShell.Edge.TOP])

    def poll(self):
        previous=None
        while True:
            try:
                nums=list(map(int,Path('/proc/stat').read_text().splitlines()[0].split()[1:]))
                total=sum(nums[:8]); idle=nums[3]+nums[4]
                cpu=0 if previous is None else 100*(1-(idle-previous[1])/max(1,total-previous[0]))
                previous=(total,idle)
                mem={line.split(':')[0]:int(line.split()[1]) for line in Path('/proc/meminfo').read_text().splitlines()}
                fs=os.statvfs(Path.home())
                hours=int(float(Path('/proc/uptime').read_text().split()[0]))//3600
                minutes=int(float(Path('/proc/uptime').read_text().split()[0]))//60%60
                data={'cpu':f'{cpu:.0f}%', 'ram':f'{100*(1-mem["MemAvailable"]/mem["MemTotal"]):.0f}%', 'disk':f'{100*(1-fs.f_bavail/fs.f_blocks):.0f}%', 'uptime':f'Up {hours}h {minutes:02}m', 'title':run('playerctl','metadata','title'), 'artist':run('playerctl','metadata','artist'), 'volume':run('pamixer','--get-volume')}
                self.updating.put(data)
            except (OSError,ValueError): pass
            time.sleep(3)

    def tick(self):
        now=dt.datetime.now()
        for t,d in self.clocks:
            t.set_text(now.strftime('%H:%M'))
            d.set_text(now.strftime('%A, %d %B %Y'))
        if self.running:
            self.remaining=max(0,int(self.deadline-time.monotonic()))
            if self.remaining==0:
                self.running=False
                launch('notify-send','Focus timer',self.mode+' session finished')
        for t in self.timer_labels: t.set_text(f'{self.remaining//60:02}:{self.remaining%60:02}')
        while not self.updating.empty(): self.metrics=self.updating.get_nowait()
        for key,w in self.stats_labels: w.set_text(self.metrics.get(key,'…'))
        for name,artist in self.music_labels:
            name.set_text(self.metrics.get('title') or 'Nothing playing')
            artist.set_text(self.metrics.get('artist') or 'Your music will appear here')
        self.volume_sync=True
        for scale in self.volume_scales:
            if not scale.has_grab(): scale.set_value(float(self.metrics.get('volume') or 0))
        self.volume_sync=False
        return True

if __name__=='__main__':
    app=Shell()
    Gtk.main()
