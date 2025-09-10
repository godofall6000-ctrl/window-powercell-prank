import tkinter as tk
from tkinter import messagebox, ttk
import subprocess
import os
import json

# Load config with error handling
config = {}
config_path = os.path.join(os.path.dirname(__file__), '..', 'config', 'prank_config.json')
try:
    with open(config_path, 'r', encoding='utf-8') as f:
        config = json.load(f)
except FileNotFoundError:
    messagebox.showwarning("Config Warning", "Configuration file not found. Using default settings.")
    config = {
        "pranks": {},
        "advanced_features": {
            "intensity_levels": {
                "low": {"duration_multiplier": 0.5},
                "medium": {"duration_multiplier": 1.0},
                "high": {"duration_multiplier": 2.0}
            }
        }
    }
except json.JSONDecodeError:
    messagebox.showerror("Config Error", "Configuration file is corrupted. Using default settings.")
    config = {
        "pranks": {},
        "advanced_features": {
            "intensity_levels": {
                "low": {"duration_multiplier": 0.5},
                "medium": {"duration_multiplier": 1.0},
                "high": {"duration_multiplier": 2.0}
            }
        }
    }
except Exception as e:
    messagebox.showerror("Config Error", f"Failed to load configuration: {str(e)}")
    config = {
        "pranks": {},
        "advanced_features": {
            "intensity_levels": {
                "low": {"duration_multiplier": 0.5},
                "medium": {"duration_multiplier": 1.0},
                "high": {"duration_multiplier": 2.0}
            }
        }
    }

def run_prank(script_name):
    try:
        script_path = os.path.join(os.path.dirname(__file__), '..', 'pranks', f"{script_name}.ps1")
        if os.path.exists(script_path):
            # Get current intensity level with error handling
            intensity = intensity_var.get()
            intensity_multiplier = 1.0  # Default value

            try:
                if 'advanced_features' in config and 'intensity_levels' in config['advanced_features']:
                    intensity_config = config['advanced_features']['intensity_levels']
                    if intensity in intensity_config and 'duration_multiplier' in intensity_config[intensity]:
                        intensity_multiplier = intensity_config[intensity]['duration_multiplier']
            except (KeyError, TypeError):
                # Use default multiplier if config structure is unexpected
                intensity_multiplier = 1.0

            # Pass intensity as environment variable to PowerShell script
            env = os.environ.copy()
            env['PRANK_INTENSITY'] = intensity
            env['INTENSITY_MULTIPLIER'] = str(intensity_multiplier)

            subprocess.Popen(["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path], env=env)
            messagebox.showinfo("Prank Launched", f"{script_name} prank launched at {intensity} intensity!")
            # Log the prank
            log_path = os.path.join(os.path.dirname(__file__), '..', 'logs', 'prank_log.txt')
            with open(log_path, 'a', encoding='utf-8') as log:
                from datetime import datetime
                log.write(f"[{datetime.now()}] {script_name} prank initiated at {intensity} intensity\n")
        else:
            messagebox.showerror("Error", f"Script {script_name}.ps1 not found!")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to launch prank: {str(e)}")

# Create main window with romantic theme
root = tk.Tk()
root.title("Prank Admin Panel")
root.geometry("600x700")
root.attributes('-topmost', True)  # Keep window on top
root.deiconify()  # Ensure window is not minimized
root.focus_force()  # Force focus on the window

# Romantic theme colors
root.configure(bg='#FFE6E6')  # Light pink background

# Create notebook (tabs)
notebook = ttk.Notebook(root)
notebook.pack(fill='both', expand=True, padx=10, pady=10)

# Romantic Pranks Tab
romantic_frame = tk.Frame(notebook, bg='#FFE6E6')
notebook.add(romantic_frame, text='Romantic')

# Classic Pranks Tab
classic_frame = tk.Frame(notebook, bg='#FFE6E6')
notebook.add(classic_frame, text='Classic')

# Advanced Tab
advanced_frame = tk.Frame(notebook, bg='#FFE6E6')
notebook.add(advanced_frame, text='Advanced')

# Title
title_label = tk.Label(root, text="Prank Admin Panel", font=("Arial", 18, "bold"), bg='#FFE6E6', fg='#FF1493')
title_label.pack(pady=10)

# Emergency Stop Section
emergency_frame = tk.Frame(root, bg='#FFE6E6', relief='ridge', borderwidth=2)
emergency_frame.pack(pady=10, fill='x', padx=20)

emergency_label = tk.Label(emergency_frame, text="WARNING: Use Emergency Stop to terminate all running pranks",
                          bg='#FFE6E6', fg='#8B0000', font=("Arial", 10, "bold"))
emergency_label.pack(pady=5)

def emergency_stop():
    try:
        import subprocess
        import os

        # Kill all PowerShell processes that might be running pranks
        if os.name == 'nt':  # Windows
            result1 = subprocess.run(['taskkill', '/f', '/im', 'powershell.exe'], capture_output=True)
            result2 = subprocess.run(['taskkill', '/f', '/im', 'pwsh.exe'], capture_output=True)

            if result1.returncode == 0 or result2.returncode == 0:
                messagebox.showinfo("Emergency Stop", "All running pranks have been forcibly terminated!")
            else:
                messagebox.showinfo("Emergency Stop", "No running prank processes found to terminate.")
        else:
            messagebox.showinfo("Emergency Stop", "Emergency stop is only available on Windows systems.")
    except Exception as e:
        messagebox.showerror("Error", f"Could not stop pranks: {str(e)}")

emergency_button = tk.Button(emergency_frame, text="EMERGENCY STOP", command=emergency_stop,
                           bg='#FF0000', fg='#FFFFFF', font=("Arial", 12, "bold"),
                           height=2, relief='raised', borderwidth=3)
emergency_button.pack(pady=5, fill='x', padx=10)

# Romantic pranks
romantic_pranks = [
    ("Romantic Confession", "romantic_confession"),
    ("Fake Love Note", "fake_love_note"),
    ("Fake Love Letter Browser", "fake_love_letter_browser"),
    ("Romantic Popup Storm", "romantic_popup_storm"),
    ("Romantic Sounds", "romantic_sounds"),
    ("Girlfriend Surprise", "girlfriend_surprise"),
    ("Girlfriend Notification", "girlfriend_notification"),
    ("Romantic Escalation", "romantic_escalation"),
    ("Ultimate MessageBox Prank", "ultimate_messagebox")
]

tk.Label(romantic_frame, text="Romantic Pranks", font=("Arial", 14, "bold"), bg='#FFE6E6', fg='#FF1493').pack(pady=10)
for prank_name, script in romantic_pranks:
    button = tk.Button(romantic_frame, text=f"Love {prank_name}", command=lambda s=script: run_prank(s),
                      bg='#FFB6C1', fg='#8B0000', font=("Arial", 10, "bold"))
    button.pack(pady=3, fill='x', padx=20)

# Classic pranks
classic_pranks = [
    ("Virus Prank", "prank"),
    ("Fake BSOD", "fake_bsod"),
    ("Mouse Prank", "mouse_prank"),
    ("Keyboard Prank", "keyboard_prank"),
    ("Fake Update", "fake_update"),
    ("System Overload Icons", "system_overload_icons"),
    ("Ghost Typing", "ghost_typing")
]

tk.Label(classic_frame, text="Classic Pranks", font=("Arial", 14, "bold"), bg='#FFE6E6', fg='#FF1493').pack(pady=10)
for prank_name, script in classic_pranks:
    button = tk.Button(classic_frame, text=f"Classic {prank_name}", command=lambda s=script: run_prank(s),
                      bg='#FFB6C1', fg='#8B0000', font=("Arial", 10, "bold"))
    button.pack(pady=3, fill='x', padx=20)

# Advanced features in Advanced tab
tk.Label(advanced_frame, text="Advanced Features", font=("Arial", 14, "bold"), bg='#FFE6E6', fg='#FF1493').pack(pady=10)

# Prank Chaining
def chain_pranks():
    chain_window = tk.Toplevel(root)
    chain_window.title("Prank Chaining")
    chain_window.geometry("400x400")
    chain_window.configure(bg='#FFE6E6')

    tk.Label(chain_window, text="Select pranks to chain:", bg='#FFE6E6', fg='#FF1493', font=("Arial", 12, "bold")).pack(pady=5)

    all_pranks = romantic_pranks + classic_pranks
    prank_vars = {}
    for prank_name, script in all_pranks:
        var = tk.BooleanVar()
        tk.Checkbutton(chain_window, text=prank_name, variable=var, bg='#FFE6E6', fg='#8B0000').pack(anchor='w', padx=20)
        prank_vars[script] = var

    def run_chain():
        selected_pranks = [script for script, var in prank_vars.items() if var.get()]
        if selected_pranks:
            for prank in selected_pranks:
                run_prank(prank)
                import time
                time.sleep(2)  # Delay between pranks
            messagebox.showinfo("Chain Complete", "Prank chain executed!")
        chain_window.destroy()

    tk.Button(chain_window, text="Run Chain", command=run_chain, bg='#FFB6C1', fg='#8B0000').pack(pady=10)

chain_button = tk.Button(advanced_frame, text="Chain Pranks", command=chain_pranks, bg='#FFB6C1', fg='#8B0000', font=("Arial", 10, "bold"))
chain_button.pack(pady=5, fill='x', padx=20)

# Prank Scheduling
def schedule_prank():
    schedule_window = tk.Toplevel(root)
    schedule_window.title("Schedule Prank")
    schedule_window.geometry("400x250")
    schedule_window.configure(bg='#FFE6E6')

    tk.Label(schedule_window, text="Select prank:", bg='#FFE6E6', fg='#FF1493', font=("Arial", 12, "bold")).pack(pady=5)
    all_pranks = romantic_pranks + classic_pranks
    prank_var = tk.StringVar(value="romantic_confession")
    prank_menu = tk.OptionMenu(schedule_window, prank_var, *[script for _, script in all_pranks])
    prank_menu.pack(pady=5)

    tk.Label(schedule_window, text="Delay in seconds:", bg='#FFE6E6', fg='#FF1493').pack(pady=5)
    delay_entry = tk.Entry(schedule_window)
    delay_entry.insert(0, "5")
    delay_entry.pack(pady=5)

    def schedule():
        prank = prank_var.get()
        delay = int(delay_entry.get())
        import threading
        import time

        def delayed_run():
            time.sleep(delay)
            run_prank(prank)

        threading.Thread(target=delayed_run).start()
        messagebox.showinfo("Scheduled", f"{prank} scheduled in {delay} seconds!")
        schedule_window.destroy()

    tk.Button(schedule_window, text="Schedule", command=schedule, bg='#FFB6C1', fg='#8B0000').pack(pady=10)

schedule_button = tk.Button(advanced_frame, text="Schedule Prank", command=schedule_prank, bg='#FFB6C1', fg='#8B0000', font=("Arial", 10, "bold"))
schedule_button.pack(pady=5, fill='x', padx=20)

# History Viewer
def view_history():
    history_window = tk.Toplevel(root)
    history_window.title("Prank History")
    history_window.geometry("600x500")
    history_window.configure(bg='#FFE6E6')

    tk.Label(history_window, text="Prank Execution History:", bg='#FFE6E6', fg='#FF1493', font=("Arial", 12, "bold")).pack(pady=5)

    text_area = tk.Text(history_window, height=25, width=70, bg='#FFF8DC')
    text_area.pack(pady=5, padx=10)

    try:
        log_path = os.path.join(os.path.dirname(__file__), '..', 'logs', 'prank_log.txt')
        with open(log_path, 'r', encoding='utf-8') as log:
            content = log.read()
            text_area.insert(tk.END, content)
    except FileNotFoundError:
        text_area.insert(tk.END, "No history found.")
    except UnicodeDecodeError:
        text_area.insert(tk.END, "Error reading log file (encoding issue).")

    text_area.config(state=tk.DISABLED)

history_button = tk.Button(advanced_frame, text="View History", command=view_history, bg='#FFB6C1', fg='#8B0000', font=("Arial", 10, "bold"))
history_button.pack(pady=5, fill='x', padx=20)

# Intensity Level Selector
intensity_var = tk.StringVar(value="medium")
tk.Label(advanced_frame, text="Prank Intensity:", bg='#FFE6E6', fg='#FF1493', font=("Arial", 12, "bold")).pack(pady=5)
intensity_menu = tk.OptionMenu(advanced_frame, intensity_var, "low", "medium", "high")
intensity_menu.pack(pady=5)

# Customize button in Advanced tab
def customize_prank():
    customize_window = tk.Toplevel(root)
    customize_window.title("Customize Pranks")
    customize_window.geometry("450x350")
    customize_window.configure(bg='#FFE6E6')

    tk.Label(customize_window, text="Select prank to customize:", bg='#FFE6E6', fg='#FF1493', font=("Arial", 12, "bold")).pack(pady=5)

    prank_var = tk.StringVar(value="romantic_confession")
    prank_menu = tk.OptionMenu(customize_window, prank_var, "romantic_confession", "fake_love_note", "ghost_typing", "romantic_popup_storm", "romantic_sounds", "girlfriend_surprise", "girlfriend_notification", "romantic_escalation", "ultimate_messagebox")
    prank_menu.pack(pady=5)

    tk.Label(customize_window, text="New message/text:", bg='#FFE6E6', fg='#FF1493').pack(pady=5)
    message_entry = tk.Entry(customize_window, width=50, bg='#FFF8DC')
    message_entry.pack(pady=5)

    def save_customization():
        prank = prank_var.get()
        new_message = message_entry.get()
        if new_message:
            if prank in ['girlfriend_surprise', 'girlfriend_notification', 'romantic_escalation']:
                # For girlfriend-targeted pranks, update the message field
                config['pranks'][prank]['message'] = new_message
            elif prank == 'ghost_typing':
                config['pranks'][prank]['messages'] = [new_message]
            else:
                config['pranks'][prank]['message'] = new_message
            config_path = os.path.join(os.path.dirname(__file__), '..', 'config', 'prank_config.json')
            with open(config_path, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=4, ensure_ascii=False)
            messagebox.showinfo("Success", f"{prank} customized!")
            customize_window.destroy()
        else:
            messagebox.showerror("Error", "Please enter a message")

    save_button = tk.Button(customize_window, text="Save", command=save_customization, bg='#FFB6C1', fg='#8B0000')
    save_button.pack(pady=10)

customize_button = tk.Button(advanced_frame, text="Customize Pranks", command=customize_prank, bg='#FFB6C1', fg='#8B0000', font=("Arial", 10, "bold"))
customize_button.pack(pady=5, fill='x', padx=20)

# Exit button
exit_button = tk.Button(root, text="Exit", command=root.quit)
exit_button.pack(pady=20)

root.mainloop()