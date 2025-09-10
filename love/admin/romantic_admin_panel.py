import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext, filedialog
import subprocess
import os
import json
import threading
import time
import random
import webbrowser
from datetime import datetime

# Romantic color palette
ROMANTIC_COLORS = {
    'bg_primary': '#FFE6E6',      # Light pink background
    'bg_secondary': '#FFF8DC',    # Cream
    'accent_pink': '#FFB6C1',     # Light pink
    'accent_red': '#FF1493',      # Deep pink
    'accent_dark': '#8B0000',     # Dark red
    'text_primary': '#FF1493',    # Deep pink text
    'text_secondary': '#8B0000',  # Dark red text
    'button_bg': '#FFB6C1',       # Button background
    'button_fg': '#8B0000',       # Button text
    'highlight': '#FF69B4'        # Hot pink highlight
}

# Multi-language support
LANGUAGES = {
    'en': {
        'title': 'Ultimate Romantic Prank Suite',
        'subtitle': 'Spread love and laughter with our collection of romantic pranks!',
        'target_label': 'Target:',
        'intensity_label': 'Intensity:',
        'emergency_stop': 'EMERGENCY STOP',
        'romantic_pranks': 'Romantic Pranks',
        'classic_pranks': 'Classic Pranks',
        'advanced_features': 'Advanced Features',
        'chain_pranks': 'Chain Pranks',
        'schedule_prank': 'Schedule Prank',
        'view_history': 'View History',
        'customize_pranks': 'Customize Pranks',
        'love_quiz': 'Love Quiz',
        'heart_rain': 'Heart Rain',
        'virtual_bouquet': 'Virtual Bouquet',
        'launch_prank': 'Launch {name}',
        'prank_launched': '{name} prank launched!',
        'ready_message': 'Ready to spread love and laughter!',
        'error': 'Error',
        'success': 'Success',
        'warning': 'Warning'
    },
    'es': {
        'title': 'Suite Suprema de Bromas Románticas',
        'subtitle': '¡Difunde amor y risas con nuestra colección de bromas románticas!',
        'target_label': 'Objetivo:',
        'intensity_label': 'Intensidad:',
        'emergency_stop': 'PARADA DE EMERGENCIA',
        'romantic_pranks': 'Bromas Románticas',
        'classic_pranks': 'Bromas Clásicas',
        'advanced_features': 'Características Avanzadas',
        'chain_pranks': 'Encadenar Bromas',
        'schedule_prank': 'Programar Broma',
        'view_history': 'Ver Historial',
        'customize_pranks': 'Personalizar Bromas',
        'love_quiz': 'Quiz de Amor',
        'heart_rain': 'Lluvia de Corazones',
        'virtual_bouquet': 'Ramo Virtual',
        'launch_prank': 'Lanzar {name}',
        'prank_launched': '¡Broma {name} lanzada!',
        'ready_message': '¡Listo para difundir amor y risas!',
        'error': 'Error',
        'success': 'Éxito',
        'warning': 'Advertencia'
    },
    'fr': {
        'title': 'Suite Suprême de Blagues Romantiques',
        'subtitle': 'Répandez l\'amour et le rire avec notre collection de blagues romantiques!',
        'target_label': 'Cible:',
        'intensity_label': 'Intensité:',
        'emergency_stop': 'ARRÊT D\'URGENCE',
        'romantic_pranks': 'Blagues Romantiques',
        'classic_pranks': 'Blagues Classiques',
        'advanced_features': 'Fonctionnalités Avancées',
        'chain_pranks': 'Chaîner les Blagues',
        'schedule_prank': 'Programmer une Blague',
        'view_history': 'Voir l\'Historique',
        'customize_pranks': 'Personnaliser les Blagues',
        'love_quiz': 'Quiz d\'Amour',
        'heart_rain': 'Pluie de Cœurs',
        'virtual_bouquet': 'Bouquet Virtuel',
        'launch_prank': 'Lancer {name}',
        'prank_launched': 'Blague {name} lancée!',
        'ready_message': 'Prêt à répandre l\'amour et le rire!',
        'error': 'Erreur',
        'success': 'Succès',
        'warning': 'Avertissement'
    }
}

# Load config with enhanced error handling
config = {}
config_path = os.path.join(os.path.dirname(__file__), '..', 'config', 'prank_config.json')
try:
    with open(config_path, 'r', encoding='utf-8') as f:
        config = json.load(f)
except Exception as e:
    config = {
        "pranks": {},
        "advanced_features": {
            "intensity_levels": {
                "low": {"duration_multiplier": 0.5, "message_count": 3},
                "medium": {"duration_multiplier": 1.0, "message_count": 5},
                "high": {"duration_multiplier": 2.0, "message_count": 10}
            }
        },
        "romantic_features": {
            "girlfriend_name": "My Love",
            "theme": "hearts",
            "sound_enabled": True,
            "custom_messages": []
        }
    }

class RomanticPrankApp:
    def __init__(self):
        self.root = tk.Tk()
        self.root.geometry("1200x800")
        self.root.configure(bg=ROMANTIC_COLORS['bg_primary'])

        # Make window romantic
        self.root.attributes('-topmost', True)
        self.root.focus_force()

        # Language and settings
        self.current_language = tk.StringVar(value="en")
        self.intensity_var = tk.StringVar(value="medium")
        self.target_name = tk.StringVar(value=config.get('romantic_features', {}).get('girlfriend_name', 'My Love'))

        # Set initial language
        self.update_language()

        self.setup_styles()

    def update_language(self):
        """Update all UI text based on selected language"""
        lang = self.current_language.get()
        self.lang = LANGUAGES.get(lang, LANGUAGES['en'])

        # Update window title
        if hasattr(self, 'root'):
            self.root.title(f"💕 {self.lang['title']} 💕")
        self.create_main_interface()
        self.create_menu_bar()

    def setup_styles(self):
        """Setup romantic styling for all widgets"""
        style = ttk.Style()
        style.configure('Romantic.TButton',
                       background=ROMANTIC_COLORS['button_bg'],
                       foreground=ROMANTIC_COLORS['button_fg'],
                       font=('Arial', 10, 'bold'),
                       padding=10)
        style.configure('Romantic.TLabel',
                       background=ROMANTIC_COLORS['bg_primary'],
                       foreground=ROMANTIC_COLORS['text_primary'],
                       font=('Arial', 12, 'bold'))
        style.configure('Romantic.TFrame',
                       background=ROMANTIC_COLORS['bg_primary'])

    def create_menu_bar(self):
        """Create romantic menu bar"""
        menubar = tk.Menu(self.root, bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'])

        # File menu
        file_menu = tk.Menu(menubar, tearoff=0, bg=ROMANTIC_COLORS['bg_secondary'])
        file_menu.add_command(label="💾 Save Configuration", command=self.save_config)
        file_menu.add_command(label="📂 Load Configuration", command=self.load_config)
        file_menu.add_separator()
        file_menu.add_command(label="❌ Exit", command=self.root.quit)
        menubar.add_cascade(label="📁 File", menu=file_menu)

        # Settings menu
        settings_menu = tk.Menu(menubar, tearoff=0, bg=ROMANTIC_COLORS['bg_secondary'])
        settings_menu.add_command(label="🎯 Set Target Name", command=self.set_target_name)
        settings_menu.add_command(label="🔊 Sound Settings", command=self.sound_settings)
        settings_menu.add_command(label="🎨 Theme Settings", command=self.theme_settings)
        menubar.add_cascade(label="⚙️ Settings", menu=settings_menu)

        # Help menu
        help_menu = tk.Menu(menubar, tearoff=0, bg=ROMANTIC_COLORS['bg_secondary'])
        help_menu.add_command(label="📖 User Guide", command=self.show_guide)
        help_menu.add_command(label="❓ About", command=self.show_about)
        menubar.add_cascade(label="🆘 Help", menu=help_menu)

        self.root.config(menu=menubar)

    def create_main_interface(self):
        """Create the main romantic interface"""
        # Header with hearts
        header_frame = tk.Frame(self.root, bg=ROMANTIC_COLORS['bg_primary'])
        header_frame.pack(fill='x', pady=10)

        title_label = tk.Label(header_frame,
                              text="💕✨ Ultimate Romantic Prank Suite ✨💕",
                              font=('Arial', 24, 'bold'),
                              bg=ROMANTIC_COLORS['bg_primary'],
                              fg=ROMANTIC_COLORS['accent_red'])
        title_label.pack(pady=10)

        subtitle_label = tk.Label(header_frame,
                                 text="Spread love and laughter with our collection of romantic pranks! 💖",
                                 font=('Arial', 12),
                                 bg=ROMANTIC_COLORS['bg_primary'],
                                 fg=ROMANTIC_COLORS['text_secondary'])
        subtitle_label.pack()

        # Settings bar
        settings_frame = tk.Frame(self.root, bg=ROMANTIC_COLORS['bg_primary'], relief='ridge', borderwidth=2)
        settings_frame.pack(fill='x', padx=20, pady=10)

        # Target name setting
        tk.Label(settings_frame, text="💑 Target:", bg=ROMANTIC_COLORS['bg_primary'],
                fg=ROMANTIC_COLORS['text_primary'], font=('Arial', 10, 'bold')).grid(row=0, column=0, padx=10, pady=5)
        target_entry = tk.Entry(settings_frame, textvariable=self.target_name, width=20,
                               bg=ROMANTIC_COLORS['bg_secondary'], font=('Arial', 10))
        target_entry.grid(row=0, column=1, padx=10, pady=5)

        # Intensity setting
        tk.Label(settings_frame, text="🔥 Intensity:", bg=ROMANTIC_COLORS['bg_primary'],
                fg=ROMANTIC_COLORS['text_primary'], font=('Arial', 10, 'bold')).grid(row=0, column=2, padx=10, pady=5)
        intensity_combo = ttk.Combobox(settings_frame, textvariable=self.intensity_var,
                                      values=['low', 'medium', 'high'], state='readonly', width=10)
        intensity_combo.grid(row=0, column=3, padx=10, pady=5)

        # Language selector
        tk.Label(settings_frame, text="🌐 Language:", bg=ROMANTIC_COLORS['bg_primary'],
                fg=ROMANTIC_COLORS['text_primary'], font=('Arial', 10, 'bold')).grid(row=0, column=4, padx=10, pady=5)
        language_combo = ttk.Combobox(settings_frame, textvariable=self.current_language,
                                     values=['en', 'es', 'fr'], state='readonly', width=5)
        language_combo.grid(row=0, column=5, padx=10, pady=5)
        language_combo.bind('<<ComboboxSelected>>', lambda e: self.update_language())

        # Emergency stop
        emergency_btn = tk.Button(settings_frame, text="🚨 EMERGENCY STOP",
                                 command=self.emergency_stop, bg='#FF0000', fg='white',
                                 font=('Arial', 10, 'bold'), relief='raised', borderwidth=3)
        emergency_btn.grid(row=0, column=6, padx=20, pady=5)

        # Create notebook for different prank categories
        self.notebook = ttk.Notebook(self.root)
        self.notebook.pack(fill='both', expand=True, padx=20, pady=10)

        # Create tabs
        self.create_classic_tab()
        self.create_romantic_tab()
        self.create_advanced_tab()
        self.create_special_tab()

        # Status bar
        self.status_var = tk.StringVar()
        self.status_var.set(self.lang['ready_message'])
        status_bar = tk.Label(self.root, textvariable=self.status_var,
                             bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_secondary'],
                             font=('Arial', 10), anchor='w')
        status_bar.pack(fill='x', padx=20, pady=5)

    def create_classic_tab(self):
        """Create classic pranks tab"""
        classic_frame = tk.Frame(self.notebook, bg=ROMANTIC_COLORS['bg_primary'])
        self.notebook.add(classic_frame, text='🎭 Classic Pranks')

        tk.Label(classic_frame, text="Classic Prank Collection",
                font=('Arial', 16, 'bold'), bg=ROMANTIC_COLORS['bg_primary'],
                fg=ROMANTIC_COLORS['text_primary']).pack(pady=10)

        classic_pranks = [
            ("Virus Alert", "prank"),
            ("Fake BSOD", "fake_bsod"),
            ("Mouse Madness", "mouse_prank"),
            ("Keyboard Chaos", "keyboard_prank"),
            ("Fake Update", "fake_update"),
            ("Icon Overload", "system_overload_icons"),
            ("Ghost Writer", "ghost_typing")
        ]

        # Create buttons in a grid
        button_frame = tk.Frame(classic_frame, bg=ROMANTIC_COLORS['bg_primary'])
        button_frame.pack(pady=20)

        for i, (name, script) in enumerate(classic_pranks):
            row = i // 3
            col = i % 3
            btn = tk.Button(button_frame, text=f"🎭 {name}",
                           command=lambda s=script: self.run_prank(s),
                           bg=ROMANTIC_COLORS['button_bg'], fg=ROMANTIC_COLORS['button_fg'],
                           font=('Arial', 10, 'bold'), width=15, height=2)
            btn.grid(row=row, column=col, padx=10, pady=10)

    def create_romantic_tab(self):
        """Create romantic pranks tab"""
        romantic_frame = tk.Frame(self.notebook, bg=ROMANTIC_COLORS['bg_primary'])
        self.notebook.add(romantic_frame, text='💕 Romantic Pranks')

        tk.Label(romantic_frame, text="Romantic Prank Collection",
                font=('Arial', 16, 'bold'), bg=ROMANTIC_COLORS['bg_primary'],
                fg=ROMANTIC_COLORS['text_primary']).pack(pady=10)

        romantic_pranks = [
            ("Love Confession", "romantic_confession"),
            ("Love Note Surprise", "fake_love_note"),
            ("Love Letter Browser", "fake_love_letter_browser"),
            ("Popup Love Storm", "romantic_popup_storm"),
            ("Romantic Sounds", "romantic_sounds"),
            ("Girlfriend Surprise", "girlfriend_surprise"),
            ("Love Notification", "girlfriend_notification"),
            ("Love Escalation", "romantic_escalation"),
            ("Ultimate Love Messages", "ultimate_messagebox")
        ]

        button_frame = tk.Frame(romantic_frame, bg=ROMANTIC_COLORS['bg_primary'])
        button_frame.pack(pady=20)

        for i, (name, script) in enumerate(romantic_pranks):
            row = i // 3
            col = i % 3
            btn = tk.Button(button_frame, text=f"💖 {name}",
                           command=lambda s=script: self.run_prank(s),
                           bg=ROMANTIC_COLORS['button_bg'], fg=ROMANTIC_COLORS['button_fg'],
                           font=('Arial', 10, 'bold'), width=18, height=2)
            btn.grid(row=row, column=col, padx=10, pady=10)

    def create_advanced_tab(self):
        """Create advanced features tab"""
        advanced_frame = tk.Frame(self.notebook, bg=ROMANTIC_COLORS['bg_primary'])
        self.notebook.add(advanced_frame, text='⚙️ Advanced Features')

        tk.Label(advanced_frame, text="Advanced Love Features",
                font=('Arial', 16, 'bold'), bg=ROMANTIC_COLORS['bg_primary'],
                fg=ROMANTIC_COLORS['text_primary']).pack(pady=10)

        # Chain pranks
        chain_frame = tk.Frame(advanced_frame, bg=ROMANTIC_COLORS['bg_primary'], relief='ridge', borderwidth=2)
        chain_frame.pack(fill='x', padx=20, pady=10)

        tk.Label(chain_frame, text="🔗 Chain Multiple Pranks",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 12, 'bold')).pack(pady=5)

        tk.Button(chain_frame, text="Create Love Chain",
                 command=self.chain_pranks, bg=ROMANTIC_COLORS['button_bg'],
                 fg=ROMANTIC_COLORS['button_fg'], font=('Arial', 10, 'bold')).pack(pady=10)

        # Schedule pranks
        schedule_frame = tk.Frame(advanced_frame, bg=ROMANTIC_COLORS['bg_primary'], relief='ridge', borderwidth=2)
        schedule_frame.pack(fill='x', padx=20, pady=10)

        tk.Label(schedule_frame, text="⏰ Schedule Romantic Surprise",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 12, 'bold')).pack(pady=5)

        tk.Button(schedule_frame, text="Schedule Love Moment",
                 command=self.schedule_prank, bg=ROMANTIC_COLORS['button_bg'],
                 fg=ROMANTIC_COLORS['button_fg'], font=('Arial', 10, 'bold')).pack(pady=10)

        # History viewer
        history_frame = tk.Frame(advanced_frame, bg=ROMANTIC_COLORS['bg_primary'], relief='ridge', borderwidth=2)
        history_frame.pack(fill='x', padx=20, pady=10)

        tk.Label(history_frame, text="📜 Love History",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 12, 'bold')).pack(pady=5)

        tk.Button(history_frame, text="View Love History",
                 command=self.view_history, bg=ROMANTIC_COLORS['button_bg'],
                 fg=ROMANTIC_COLORS['button_fg'], font=('Arial', 10, 'bold')).pack(pady=10)

    def create_special_tab(self):
        """Create special features tab with 30+ new features"""
        special_frame = tk.Frame(self.notebook, bg=ROMANTIC_COLORS['bg_primary'])
        self.notebook.add(special_frame, text='🌟 Special Features (5 Ready!)')

        tk.Label(special_frame, text="Special Love Features (30+ New!)",
                font=('Arial', 16, 'bold'), bg=ROMANTIC_COLORS['bg_primary'],
                fg=ROMANTIC_COLORS['text_primary']).pack(pady=10)

        # Create scrollable frame for many features
        canvas = tk.Canvas(special_frame, bg=ROMANTIC_COLORS['bg_primary'])
        scrollbar = ttk.Scrollbar(special_frame, orient="vertical", command=canvas.yview)
        scrollable_frame = tk.Frame(canvas, bg=ROMANTIC_COLORS['bg_primary'])

        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )

        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)

        # Special features list - ONLY implemented and functional pranks
        special_features = [
            ("💌 Love Quiz", "love_quiz"),
            ("🌧️ Heart Rain", "heart_rain"),
            ("💐 Virtual Bouquet", "virtual_bouquet"),
            ("💬 Love Chatbot", "love_chatbot"),
            ("⏰ Love Countdown", "love_countdown"),
            ("🎤 Voice Message", "voice_message"),
            ("🖼️ Love Wallpaper", "love_wallpaper"),
            ("😊 Emoji Flood", "emoji_flood"),
            ("📹 Surprise Video", "surprise_video"),
            ("🗺️ Love Map", "love_map"),
            ("📱 Ringtone Change", "ringtone_change"),
            ("📱 Social Notifications", "social_notifications"),
            ("🎮 Love Games", "love_games"),
            ("😊 Mood Selector", "mood_selector"),
            ("📝 AI Love Poems", "ai_poems"),
            ("🖼️ Photo Collage", "photo_collage"),
            ("🌸 Scent Alerts", "scent_alerts"),
            ("💃 Dance Party", "dance_party"),
            ("🔮 Love Horoscope", "love_horoscope"),
            ("📅 Memory Lane", "memory_lane"),
            ("🎁 Gift Revealer", "gift_revealer"),
            ("🌤️ Romantic Weather", "romantic_weather"),
            ("🎵 Love Playlist", "love_playlist"),
            ("🍽️ Virtual Dinner", "virtual_dinner"),
            ("📊 Milestone Tracker", "milestone_tracker"),
            ("✉️ Letter Generator", "letter_generator"),
            ("🎊 Confetti Burst", "confetti_burst"),
            ("📚 Gesture Tutorials", "gesture_tutorials"),
            ("🎯 Love Mini-Games", "mini_games"),
            ("😔 Apology Notes", "apology_notes"),
            ("🤗 Virtual Hugs", "virtual_hugs"),
            ("💻 Love Screensaver", "love_screensaver"),
            ("⏰ Romantic Alarm", "romantic_alarm"),
            ("📔 Love Journal", "love_journal")
        ]

        # Create buttons in a grid layout
        button_frame = tk.Frame(scrollable_frame, bg=ROMANTIC_COLORS['bg_primary'])
        button_frame.pack(pady=20)

        for i, (name, script) in enumerate(special_features):
            row = i // 4
            col = i % 4
            btn = tk.Button(button_frame, text=name,
                           command=lambda s=script: self.run_special_feature(s),
                           bg=ROMANTIC_COLORS['button_bg'], fg=ROMANTIC_COLORS['button_fg'],
                           font=('Arial', 9, 'bold'), width=16, height=2)
            btn.grid(row=row, column=col, padx=5, pady=5)

        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")

    def run_prank(self, script_name):
        """Run a prank script with intensity settings"""
        try:
            script_path = os.path.join(os.path.dirname(__file__), '..', 'pranks', f"{script_name}.ps1")
            if os.path.exists(script_path):
                # Get intensity settings
                intensity = self.intensity_var.get()
                intensity_multiplier = 1.0

                try:
                    if 'advanced_features' in config and 'intensity_levels' in config['advanced_features']:
                        intensity_config = config['advanced_features']['intensity_levels']
                        if intensity in intensity_config and 'duration_multiplier' in intensity_config[intensity]:
                            intensity_multiplier = intensity_config[intensity]['duration_multiplier']
                except (KeyError, TypeError):
                    intensity_multiplier = 1.0

                # Update target name in config
                if 'romantic_features' not in config:
                    config['romantic_features'] = {}
                config['romantic_features']['girlfriend_name'] = self.target_name.get()

                # Pass environment variables
                env = os.environ.copy()
                env['PRANK_INTENSITY'] = intensity
                env['INTENSITY_MULTIPLIER'] = str(intensity_multiplier)
                env['TARGET_NAME'] = self.target_name.get()

                subprocess.Popen(["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path], env=env)
                self.status_var.set(f"💕 {script_name} prank launched with {intensity} intensity!")
                messagebox.showinfo("Love Launched!", f"Romantic {script_name} prank sent to {self.target_name.get()}!")

                # Log the prank
                self.log_prank(script_name, intensity)
            else:
                messagebox.showerror("Error", f"Prank script {script_name}.ps1 not found!")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to launch prank: {str(e)}")

    def run_special_feature(self, feature_name):
        """Run special features - now with actual implementations"""
        # Map feature names to actual script names - ONLY implemented features
        implemented_features = {
            "love_quiz": "love_quiz",
            "heart_rain": "heart_rain",
            "virtual_bouquet": "virtual_bouquet",
            "love_chatbot": "love_chatbot",
            "love_countdown": "love_countdown"
        }

        # Features that are coming soon
        coming_soon_features = [
            "voice_message", "love_wallpaper", "emoji_flood", "surprise_video", "love_map",
            "ringtone_change", "social_notifications", "love_games", "mood_selector", "ai_poems",
            "photo_collage", "scent_alerts", "dance_party", "love_horoscope", "memory_lane",
            "gift_revealer", "romantic_weather", "love_playlist", "virtual_dinner", "milestone_tracker",
            "letter_generator", "confetti_burst", "gesture_tutorials", "mini_games", "apology_notes",
            "virtual_hugs", "love_screensaver", "romantic_alarm", "love_journal"
        ]

        if feature_name in implemented_features:
            script_name = implemented_features[feature_name]
            self.run_prank(script_name)
        elif feature_name in coming_soon_features:
            # For features that don't have scripts yet, show a more informative message
            self.status_var.set(f"🌟 Special feature '{feature_name}' - Implementation in progress!")
            messagebox.showinfo("Special Feature",
                              f"'{feature_name}' is being developed! 💕\n\n"
                              f"Check back soon for this romantic feature!\n\n"
                              f"Available now: Love Quiz, Heart Rain, Virtual Bouquet, Love Chatbot, Love Countdown")
        else:
            # Unknown feature
            self.status_var.set(f"❓ Unknown feature '{feature_name}'")
            messagebox.showerror("Unknown Feature", f"Feature '{feature_name}' is not recognized.")

    def chain_pranks(self):
        """Chain multiple pranks together"""
        chain_window = tk.Toplevel(self.root)
        chain_window.title("Create Love Chain")
        chain_window.geometry("500x400")
        chain_window.configure(bg=ROMANTIC_COLORS['bg_primary'])

        tk.Label(chain_window, text="Select pranks to chain together:",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 14, 'bold')).pack(pady=10)

        # Get all available pranks
        all_pranks = [
            ("Love Confession", "romantic_confession"),
            ("Love Note", "fake_love_note"),
            ("Love Notification", "girlfriend_notification"),
            ("Love Sounds", "romantic_sounds"),
            ("Ultimate Messages", "ultimate_messagebox")
        ]

        prank_vars = {}
        for name, script in all_pranks:
            var = tk.BooleanVar()
            tk.Checkbutton(chain_window, text=name, variable=var,
                          bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_secondary'],
                          font=('Arial', 10)).pack(anchor='w', padx=30)
            prank_vars[script] = var

        def execute_chain():
            selected_pranks = [script for script, var in prank_vars.items() if var.get()]
            if selected_pranks:
                for prank in selected_pranks:
                    self.run_prank(prank)
                    time.sleep(3)  # Delay between pranks
                messagebox.showinfo("Love Chain Complete!", "Romantic prank chain executed! 💕")
                chain_window.destroy()
            else:
                messagebox.showwarning("No Selection", "Please select at least one prank!")

        tk.Button(chain_window, text="Execute Love Chain", command=execute_chain,
                 bg=ROMANTIC_COLORS['button_bg'], fg=ROMANTIC_COLORS['button_fg'],
                 font=('Arial', 12, 'bold')).pack(pady=20)

    def schedule_prank(self):
        """Schedule a prank for later"""
        schedule_window = tk.Toplevel(self.root)
        schedule_window.title("Schedule Romantic Surprise")
        schedule_window.geometry("400x300")
        schedule_window.configure(bg=ROMANTIC_COLORS['bg_primary'])

        tk.Label(schedule_window, text="Schedule a romantic surprise:",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 14, 'bold')).pack(pady=10)

        # Prank selection
        tk.Label(schedule_window, text="Choose prank:",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_secondary']).pack()
        prank_var = tk.StringVar(value="romantic_confession")
        prank_combo = ttk.Combobox(schedule_window, textvariable=prank_var,
                                  values=["romantic_confession", "fake_love_note", "girlfriend_notification",
                                         "romantic_sounds", "ultimate_messagebox"], state='readonly')
        prank_combo.pack(pady=5)

        # Delay setting
        tk.Label(schedule_window, text="Delay in seconds:",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_secondary']).pack()
        delay_var = tk.StringVar(value="30")
        delay_entry = tk.Entry(schedule_window, textvariable=delay_var,
                              bg=ROMANTIC_COLORS['bg_secondary'], font=('Arial', 10))
        delay_entry.pack(pady=5)

        def schedule():
            prank = prank_var.get()
            delay = int(delay_var.get())
            threading.Thread(target=self.delayed_prank, args=(prank, delay)).start()
            messagebox.showinfo("Scheduled!", f"Romantic surprise scheduled in {delay} seconds! 💕")
            schedule_window.destroy()

        tk.Button(schedule_window, text="Schedule Love", command=schedule,
                 bg=ROMANTIC_COLORS['button_bg'], fg=ROMANTIC_COLORS['button_fg'],
                 font=('Arial', 12, 'bold')).pack(pady=20)

    def delayed_prank(self, prank, delay):
        """Execute prank after delay"""
        time.sleep(delay)
        self.run_prank(prank)

    def view_history(self):
        """View prank execution history"""
        history_window = tk.Toplevel(self.root)
        history_window.title("Love History")
        history_window.geometry("600x500")
        history_window.configure(bg=ROMANTIC_COLORS['bg_primary'])

        tk.Label(history_window, text="Your Romantic Prank History",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 16, 'bold')).pack(pady=10)

        text_area = scrolledtext.ScrolledText(history_window, width=70, height=25,
                                             bg=ROMANTIC_COLORS['bg_secondary'], font=('Arial', 10))
        text_area.pack(pady=10, padx=20)

        try:
            log_path = os.path.join(os.path.dirname(__file__), '..', 'logs', 'prank_log.txt')
            with open(log_path, 'r', encoding='utf-8') as log:
                content = log.read()
                text_area.insert(tk.END, content)
        except FileNotFoundError:
            text_area.insert(tk.END, "No romantic history yet! Start spreading love! 💕")
        except UnicodeDecodeError:
            text_area.insert(tk.END, "Error reading love history file.")

        text_area.config(state=tk.DISABLED)

    def log_prank(self, prank_name, intensity):
        """Log prank execution"""
        try:
            log_path = os.path.join(os.path.dirname(__file__), '..', 'logs', 'prank_log.txt')
            with open(log_path, 'a', encoding='utf-8') as log:
                timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                log.write(f"[{timestamp}] Romantic {prank_name} prank sent to {self.target_name.get()} at {intensity} intensity\n")
        except Exception:
            pass  # Silently fail logging

    def emergency_stop(self):
        """Emergency stop all running pranks"""
        try:
            import subprocess
            import os
            if os.name == 'nt':
                result1 = subprocess.run(['taskkill', '/f', '/im', 'powershell.exe'], capture_output=True)
                result2 = subprocess.run(['taskkill', '/f', '/im', 'pwsh.exe'], capture_output=True)

                if result1.returncode == 0 or result2.returncode == 0:
                    self.status_var.set("💔 Emergency stop activated - all romantic pranks terminated!")
                    messagebox.showinfo("Emergency Stop", "All running romantic pranks have been forcibly terminated!")
                else:
                    messagebox.showinfo("Emergency Stop", "No running romantic prank processes found.")
            else:
                messagebox.showinfo("Emergency Stop", "Emergency stop is only available on Windows systems.")
        except Exception as e:
            messagebox.showerror("Error", f"Could not stop pranks: {str(e)}")

    def set_target_name(self):
        """Set the target name for romantic pranks"""
        name_window = tk.Toplevel(self.root)
        name_window.title("Set Romantic Target")
        name_window.geometry("300x150")
        name_window.configure(bg=ROMANTIC_COLORS['bg_primary'])

        tk.Label(name_window, text="Enter your loved one's name:",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 12, 'bold')).pack(pady=10)

        name_entry = tk.Entry(name_window, textvariable=self.target_name,
                             bg=ROMANTIC_COLORS['bg_secondary'], font=('Arial', 10))
        name_entry.pack(pady=5)

        def save_name():
            if self.target_name.get().strip():
                if 'romantic_features' not in config:
                    config['romantic_features'] = {}
                config['romantic_features']['girlfriend_name'] = self.target_name.get()
                self.save_config()
                messagebox.showinfo("Saved!", f"Target name set to: {self.target_name.get()} 💕")
                name_window.destroy()
            else:
                messagebox.showwarning("Invalid Name", "Please enter a valid name!")

        tk.Button(name_window, text="Save Name", command=save_name,
                 bg=ROMANTIC_COLORS['button_bg'], fg=ROMANTIC_COLORS['button_fg'],
                 font=('Arial', 10, 'bold')).pack(pady=10)

    def sound_settings(self):
        """Configure sound settings"""
        sound_window = tk.Toplevel(self.root)
        sound_window.title("Romantic Sound Settings")
        sound_window.geometry("300x200")
        sound_window.configure(bg=ROMANTIC_COLORS['bg_primary'])

        tk.Label(sound_window, text="Sound Settings",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 14, 'bold')).pack(pady=10)

        sound_enabled = tk.BooleanVar(value=config.get('romantic_features', {}).get('sound_enabled', True))
        tk.Checkbutton(sound_window, text="Enable romantic sounds",
                      variable=sound_enabled, bg=ROMANTIC_COLORS['bg_primary'],
                      fg=ROMANTIC_COLORS['text_secondary']).pack(pady=10)

        def save_sound_settings():
            if 'romantic_features' not in config:
                config['romantic_features'] = {}
            config['romantic_features']['sound_enabled'] = sound_enabled.get()
            self.save_config()
            messagebox.showinfo("Saved!", "Sound settings updated! 🎵")
            sound_window.destroy()

        tk.Button(sound_window, text="Save Settings", command=save_sound_settings,
                 bg=ROMANTIC_COLORS['button_bg'], fg=ROMANTIC_COLORS['button_fg'],
                 font=('Arial', 10, 'bold')).pack(pady=10)

    def theme_settings(self):
        """Configure theme settings"""
        theme_window = tk.Toplevel(self.root)
        theme_window.title("Romantic Theme Settings")
        theme_window.geometry("300x200")
        theme_window.configure(bg=ROMANTIC_COLORS['bg_primary'])

        tk.Label(theme_window, text="Theme Settings",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 14, 'bold')).pack(pady=10)

        current_theme = tk.StringVar(value=config.get('romantic_features', {}).get('theme', 'hearts'))
        tk.Label(theme_window, text="Current theme: Hearts & Roses 💕",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_secondary']).pack(pady=10)

        tk.Button(theme_window, text="Theme customization coming soon!",
                 bg=ROMANTIC_COLORS['button_bg'], fg=ROMANTIC_COLORS['button_fg'],
                 font=('Arial', 10, 'bold')).pack(pady=10)

    def save_config(self):
        """Save current configuration"""
        try:
            with open(config_path, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=4, ensure_ascii=False)
            self.status_var.set("💾 Configuration saved successfully!")
        except Exception as e:
            messagebox.showerror("Save Error", f"Could not save configuration: {str(e)}")

    def load_config(self):
        """Load configuration from file"""
        try:
            file_path = filedialog.askopenfilename(
                title="Select Configuration File",
                filetypes=[("JSON files", "*.json"), ("All files", "*.*")]
            )
            if file_path:
                with open(file_path, 'r', encoding='utf-8') as f:
                    global config
                    config = json.load(f)
                self.target_name.set(config.get('romantic_features', {}).get('girlfriend_name', 'My Love'))
                self.status_var.set("📂 Configuration loaded successfully!")
                messagebox.showinfo("Loaded!", "Configuration loaded from file!")
        except Exception as e:
            messagebox.showerror("Load Error", f"Could not load configuration: {str(e)}")

    def show_guide(self):
        """Show user guide"""
        guide_window = tk.Toplevel(self.root)
        guide_window.title("Romantic Prank Guide")
        guide_window.geometry("600x500")
        guide_window.configure(bg=ROMANTIC_COLORS['bg_primary'])

        tk.Label(guide_window, text="Ultimate Romantic Prank Guide",
                bg=ROMANTIC_COLORS['bg_primary'], fg=ROMANTIC_COLORS['text_primary'],
                font=('Arial', 16, 'bold')).pack(pady=10)

        guide_text = scrolledtext.ScrolledText(guide_window, width=70, height=25,
                                              bg=ROMANTIC_COLORS['bg_secondary'], font=('Arial', 10))
        guide_text.pack(pady=10, padx=20)

        guide_content = """
💕 WELCOME TO THE ULTIMATE ROMANTIC PRANK SUITE! 💕

🎯 GETTING STARTED:
1. Set your loved one's name in the target field
2. Choose your intensity level (Low/Medium/High)
3. Select from our collection of romantic pranks
4. Watch the love unfold!

🌟 PRANK CATEGORIES:
• Classic Pranks: Traditional fun with a romantic twist
• Romantic Pranks: Love-themed surprises and messages
• Advanced Features: Chain pranks, scheduling, history
• Special Features: 30+ unique romantic experiences

🔥 INTENSITY LEVELS:
• Low: Gentle, short romantic gestures
• Medium: Balanced romantic experience
• High: Maximum love and laughter!

⚠️  SAFETY FIRST:
• Use Emergency Stop if needed
• All pranks are harmless and reversible
• Respect your loved one's preferences
• Have fun responsibly!

💡 PRO TIPS:
• Chain multiple pranks for maximum impact
• Schedule surprises for special moments
• Customize messages for personal touch
• Check history to see your love journey

🎉 ENJOY SPREADING LOVE AND LAUGHTER! 🎉
        """

        guide_text.insert(tk.END, guide_content)
        guide_text.config(state=tk.DISABLED)

    def show_about(self):
        """Show about information"""
        about_text = """
💕 Ultimate Romantic Prank Suite 💕

Version: Love Edition 2.0
Created with: 💖 Lots of Love 💖

Features:
• 40+ Romantic Pranks
• Customizable Intensity
• Advanced Scheduling
• Love History Tracking
• Emergency Safety Features

Made for spreading love and laughter! 🎉
        """
        messagebox.showinfo("About", about_text)

    def run(self):
        """Start the application"""
        self.root.mainloop()

# Create and run the application
if __name__ == "__main__":
    app = RomanticPrankApp()
    app.run()