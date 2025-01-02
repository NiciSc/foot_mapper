import threading
import tkinter as tk
from tkinter import ttk, messagebox
from pynput import keyboard, mouse
from pynput.mouse import Button
import ttkbootstrap as ttkb
from ttkbootstrap.constants import *
import logging
import os
import json
from datetime import datetime
import csv
import time
import pyautogui
import pystray
from PIL import Image
import requests
#import webbrowser

# main code of the study
# potentially with questionnaire when the system is exited

tray_icon = None
logging_active = True
user_id = None
csv_file = None
base_dir = os.path.dirname(os.path.abspath(__file__))
csv_dir = os.path.join(base_dir, "csv_archive")
upload_url = 'https://pro.mi.ur.de/footmapper/upload'
json_file = os.path.join(base_dir, "inputs.json")
image_path = os.path.join(base_dir, "foot.png")
icon_path = os.path.join(base_dir,"foot_icon_left.ico")
#questionnaire_url = "https://forms.gle/iPvC1TWeTHRZHk3WA"

upload_index = 1
upload_interval = 3600 # aka n hour

# counting all key interactions
key_counter = 0

# mouse controller for simulating mouse clicks
mouse_controller = mouse.Controller()

# flags for keeping modifier keys pressed
press_states = {
    0: False, #f22
    1: False, #f23
    2: False #f24
}

# key mappings for only tracking my keys and index
key_mappings = {
            keyboard.Key.f22 : 0,                                                                                           
            keyboard.Key.f23 : 1,
            keyboard.Key.f24 : 2 }

#keyboard_listener = None

# modifier keys, these need to be treated differently, as the user should be able to press and hold them, while pressing additional keys on the keyboard
mod_keys = ['Alt', 'Ctrl', 'Shift']


# using input fields for the key selections -> setting them writable and readonly so the user wont fuck with my configurations, is used in every operation with the input fields (also for automated setting of the input fields (maybe because nici dumb, you will never know))
def set_writable(entry):
    entry.config(state='normal')

def set_readonly(entry):
    entry.config(state='readonly')

# setting the user id, notifying the user, also setting the also existing user id in the input field if available.
def set_user_id():
    global user_id, csv_file
        
    entered_id = id_entry.get()
    if entered_id and not user_id:
        id_button.config(state='normal')
        id_entry.config(state='normal')
        user_id = entered_id
        id_entry.config(state='readonly', background='lightgrey')
        
        initialise_csv(user_id)
        messagebox.showinfo("User-ID", "User-ID gespeichert!")
    else:
        messagebox.showinfo("Obacht", "Bitte User-ID eingeben!")    


def set_csv_filename(user_id):
    current_date = datetime.now().strftime('%Y%m%d_%H%M%S')
    return f"{user_id}_{current_date}_key_events.csv"

# setting up the csv for logging
def initialise_csv(user_id):
    global csv_file
    if user_id != "":
        
        csv_file = set_csv_filename(user_id)
        
        try:
            if not os.path.isfile(csv_file):
                with open(csv_file, mode='w', newline='') as file:
                    writer = csv.writer(file)
                    writer.writerow(["User Id", "Timestamp", "Key", "Mapped to", "Event Type"])
        except Exception as e:
            log_events(user_id, 'exception', 'initialize csv', e)
            logging.error(f"Error initializing CSV file: {e}")

# handles uploading the csv-logs, renames the logs for keeping interval generated backups        
def upload_csv_file(file_path, index):
    global key_counter
    try:
        file_name_with_index = f"{os.path.splitext(file_path)[0]}_{index}{os.path.splitext(file_path)[1]}"
        
        with open(file_path, 'rb') as file:
            files = {"file" : (file_name_with_index, file)}
            response = requests.post(upload_url, files=files)
            response.raise_for_status()
            
            log_events(user_id, 'key_count', 'upload_csv_files', key_counter)
            key_counter = 0
            logging.info('successful upload')
            log_events(user_id, 'success', 'upload_csv_file', file_name_with_index)
   
    except Exception as e:    
        log_events(user_id, 'exception', 'upload_csv_file', e)
        logging.error(f"Error uploading file {file_path}: {e}")

# handles regularly uploading the logs, when exception is thrown the time-interval restarts itself
def interval_upload():
    global upload_index
    while True:
        time.sleep(upload_interval)
        if csv_file:
            try:
                upload_csv_file(csv_file, upload_index)
                upload_index +=1
                
            except Exception as e:
                log_events(user_id, 'exception', 'interval_upload', e)
                logging.error(f'error in interval upload:{e}')

            
# handling of key presses, called by the key listener
def on_key_press(key):
    global key_counter
    try:
        if key in key_mappings:
            event_type = 'down'
            handle_key_input(key_mappings[key], key, event_type)
        else:
            key_counter += 1            
    except Exception as e:
        log_events(user_id, 'exception', 'on_key_press', e)
        logging.error(f'Error handling key presses: {e}')


# handling of key releases, called by the key listener
def on_key_release(key):
    global press_states
    try:
        if key in key_mappings:
            event_type = 'up'
            index = key_mappings[key]
            press_states[index] = True
            handle_key_input(index, key, event_type)       
    except Exception as e:
        log_events(user_id, 'exception', 'on_key_release', e)
        logging.error(f'Error handling key releases: {e}')


# handling key inputs, checking for kind of input keys and distributing the handling between mouse, modifier keys and hotkeys, strings
def handle_key_input(index, solid_key, event_type):
    global press_states
    input_key = entries[index].get()
    
    if input_key:
        if "mouse" in input_key and event_type == 'down':
            map_mouse(input_key) 
            
        elif input_key in mod_keys and not '+' in input_key:            
            if not press_states[index]:                
                pyautogui.keyDown(input_key)
               
            else:                   
                pyautogui.keyUp(input_key)
                press_states[index] = False
                
        elif event_type == 'down':
            # no differentiation between single and several keys as modifier keys also need the autogui
            press_hotkey(input_key)
            
        log_events(user_id, solid_key, input_key, event_type)
        
    else:                                 
        log_events(user_id, solid_key, 'no key', event_type)

# handling key presses of hotkey combinations, single chars, possibly strings, any non-modifier key, that should not be held down
def press_hotkey(input_key):
    hotkey_combination = input_key.split('+')
    hotkey_combination_formatted = []
    for key in hotkey_combination:
        hotkey_combination_formatted.append(str(key).replace("'", ""))
        
    pyautogui.hotkey(*hotkey_combination_formatted)

# handling mouse clicks
def map_mouse(input_key): 
    if 'left' in input_key:
        mouse_controller.click(Button.left)
    elif 'middle' in input_key:
        mouse_controller.press(Button.middle)
    elif 'right' in input_key:
        mouse_controller.click(Button.right)

# handling the replace button in the gui, replacing the prior keys with newly chosen ones
def replace_key(entry, combobox):
    try:
        input_key = combobox.get()
        set_writable(entry)
        entry.delete(0, tk.END)
        entry.insert(0, input_key)
        set_readonly(entry)
    except Exception as e:
        log_events(user_id, 'exception', 'replace_key', e)
        logging.error(f"Error replacing key: {e}")

# handling the append button in the gui, appending the newly chosen key to the prior one, or in case of no key adding this one
def append_key(entry, combobox):
    try:
        input_key = combobox.get()
        current_text = entry.get()
        set_writable(entry)

        if current_text != '' and not current_text.endswith('+') and input_key!= "":
            new_text = current_text + '+' + input_key
        else:
            new_text = input_key

        entry.delete(0, tk.END)
        entry.insert(0, new_text)
        set_readonly(entry)
    
    except Exception as e:
        log_events(user_id, 'exception', 'append_key', e)
        logging.error(f"Error appending key: {e}")
        
# clearing the input fields when the delete button is pressed
def clear_input(entry, combobox, index):
    try:
        set_writable(entry)
        entry.delete(0, tk.END)
        combobox.set('')
        messagebox.showinfo("Gelöscht", f"Eingabe {index} gelöscht!")
        set_readonly(entry)
    
    except Exception as e:
        log_events(user_id, 'exception', 'clear_input', e)
        logging.error(f"Error clearing input: {e}")

# clearing the comboboxes
def clear_comboboxes():
    for combobox in comboboxes:
        combobox.set("")

# disabling the add button when the input is empty
def update_add_button(entry, combobox, button):
    if combobox.get() == "" or entry == "":
        button.config(state=tk.DISABLED)
    else:
        button.config(state= tk.NORMAL)

# this happens when the gui is closed
def on_closing():
    clear_comboboxes()
    root.withdraw()
    #os._exit(0)

# this happens when the system is exited
def on_exit():
    if tray_icon:
        tray_icon.stop()
    upload_csv_file(csv_file, 'exited')
    os._exit(0)

# for saving the user id and inputs into the json
def save_all_inputs():
    global user_id
    if not user_id:
        messagebox.showerror("Obacht", "Bitte zuerst die Benutzer-ID eingeben.")
        return
    data = {'user_id': user_id}

    for i, entry in enumerate(entries):

        input_value = entry.get()
        if validate_input(input_value):
            data[f"input_{i+1}"] = input_value
        else:
            messagebox.showerror("Ungültige Eingabe", f"Die Eingabe '{input_value}' in Feld {i+1} ist nicht erlaubt.")
            return
    try:
        with open(json_file, "w") as file:
            json.dump(data, file)
        
        clear_comboboxes()
        
        messagebox.showinfo("Gespeichert", "Alles gespeichert!")
        log_new_inputs(data)
    except Exception as e:
        log_events(user_id, 'exception', 'save_all_inputs', e)
        logging.error(f"Error saving inputs to JSON: {e}")

# validating whether the input ends with '+' (should not do this), should be prevented but better double save than sorry
def validate_input(input_key):
    if input_key.endswith('+'):
        return False
    return True

# logging key mappings
def log_new_inputs(data):
    global user_id
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open(csv_file, mode='a', newline='') as file:
        writer = csv.writer(file)
        for simulated_key, input_key in data.items():
            writer.writerow([user_id, timestamp, simulated_key, input_key, 'mapping'])
    

# loading inputs (id, keys) from json into the gui and logging the mappings
def load_inputs():
    try:
        with open(json_file, "r") as file:
            data = json.load(file)
            global user_id

            user_id = data.get("user_id", "")

            if user_id:
                set_writable(id_entry)
                id_entry.insert(0, user_id)
                id_entry.config(state='readonly', background='lightgrey')
                set_csv_filename(user_id)
            
            for i, entry in enumerate(entries):
                set_writable(entry)
                entry.insert(0, data.get(f"input_{i+1}", ""))
                set_readonly(entry)

            #log_new_inputs(data)
    except FileNotFoundError:
        log_events(user_id, 'error', 'load_inputs', 'json not found')
        logging.warning('json not found')
    except json.JSONDecodeError:
        log_events(user_id, 'error', 'load_inputs', 'json cannot load')
        logging.warning('cannot load json')
    except Exception as e:
        log_events(user_id, 'exception', 'load_inputs', e)
        logging.error(f"Unexpected error loading inputs: {e}")

# logging events into the csv logging
def log_events(user_id, solid_key, mapped_key, event_type):
    global csv_file
    if user_id:
        if not csv_file:
            csv_file = set_csv_filename(user_id)
        try:                                                            
            with open(csv_file, mode='a', newline='') as file:
                writer = csv.writer(file)
                timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                writer.writerow([user_id, timestamp, solid_key, mapped_key, event_type])
                logging.debug(f'Timestamp: {timestamp}, Key: {solid_key}, Mapped to: {mapped_key}, Event Type: {event_type}')
        except Exception as e:
            log_events(user_id, 'exception', 'log_events', e)
            logging.error(f'Error:{e}') 
    else:
        messagebox.showerror('fail', 'user id not set')
                    

# function to create system tray icon
def create_tray_icon():
    try:
        def show_window(tray_icon, item):
            root.deiconify()  # Hauptfenster anzeigen
        
        def on_exit(tray_icon, item):
            tray_icon.stop()  
            keyboard_listener.stop()
            upload_csv_file(csv_file, 'exited')
            #webbrowser.open(questionnaire_url)
            time.sleep(1)
            root.quit()  
            os._exit(0)
        
        try:
            image = Image.open(image_path)
        except Exception as e:
            log_events(user_id, 'exception', 'create_tray_icon', e)
            return

        menu = pystray.Menu(
            pystray.MenuItem("show", show_window),
            pystray.MenuItem("exit", on_exit)
        )

        tray_icon = pystray.Icon("footmapper", image, "Foot Mapper", menu)
        tray_icon.run()
        
    except Exception as e:
        log_events(user_id, 'exception', 'create_tray_icon', e)
        logging.error(f"Error creating tray icon: {e}")

# for showing the help information window and its contents
def show_info():
    info_window = tk.Toplevel(root)
    root.iconbitmap(icon_path)
    try:
        info_window.iconbitmap(icon_path)
    except Exception as e:
            log_events(user_id, 'exception', 'show_info', e)
            return
        
    info_window.title("Infos für dich")
    info_window.update_idletasks()
    info_window.geometry("500x300")
    
    slides_contents = [
        "Hallo! Danke, dass du bei meiner Studie mitmachst.\nIm Folgenden hab ich dir ein paar Infos zum Nutzen der Pedale zusammengestellt! In dieser Anwendung kannst du Tasten und Tastenkombinationen für deine Pedale auswählen.",
        "Die Tastenkombinationen kannst du dir selbst zusammenfügen. Wähle dafür die Tasten im jeweiligen Dropdown aus und füge diese über 'replace' oder 'add' hinzu.\nMehrere Tasten werden vom System mit einem '+' für dich verbunden.\nDrücke 'save' zum Speichern der Tasten/-kombi und 'delete' um ein jeweiliges Pedal zurückzusetzen. Du musst auch nicht jedes Pedal belegen.", 
        "Die Tasten sind analog zum echten Pedal aufgebaut, das linke links, das mittlere in der Mitte und das rechte rechts.\nDu kannst natürlich auch Text zusammenstellen, der beim Drücken der Pedale für dich geschrieben wird. Da mein System aber loggt welche Tasten du auf die Pedale setzt und wann du diese drückst, würde ich aus datenschutztechnischen Gründen davon abraten.",
        "Ich logge außerdem mit, wie oft du generell Tasten drückst. Hier wird nur eine Anzahl gespeichert. Das hilft mir einen Überblick zu bekommen wann und wie kombiniert die Pedale genutzt werden.",
        "Wenn du bestimmte Tasten im Dropdown nicht finden kannst, dann lässt das System diese leider nicht zu. Auch bestimmte Tastenkombinationen werden vom System leider nicht unterstützt.\nAus wissenschaftlicher Sicht interessiert mich aber, was du vermisst, ich freu mich also, wenn du dir merkst was fehlt.",
        "In deiner Taskleiste wird dir ein kleines Fuß-Icon angezeigt, wenn mein System läuft.\nDieses kannst du durch einen Rechtsklick beenden ('exit') oder das Fenster zum auswählen der Tasten wieder aufmachen ('show').\nDeine User-ID haben wir am Anfang gemeinsam eingetragen und ändert sich bis zum Ende der Studie auch nicht.",
        "Ich würde dich bitten am Ende vom Tag, oder wenn du aufhörst das Pedal zu nutzen, mit einem Rechtsklick auf das Fuß-Icon und 'exit' das System zu beenden. Du wirst dann auf einen kleinen Fragebogen im Browser weitergeleitet.",
        "Danke für deine Teilnahme!"
    ]
    
    slides= []
    for content in slides_contents:
        slide = tk.Frame(info_window)
        slide.pack_propagate(False)
        label = tk.Label(slide, text=content, wraplength=400, justify='left', anchor='w', padx=20)
        label.pack(pady=20, padx=20)
        slides.append(slide)
  
    current_slide = 0
    
    def show_slide(slide_num):
        nonlocal current_slide
        if 0 <= slide_num < len(slides):
            slides[current_slide].pack_forget()
            current_slide = slide_num
            slides[current_slide].pack(fill=tk.BOTH, expand=True)
    
    nav_bar = tk.Frame(info_window)
    nav_bar.pack(side=tk.BOTTOM, fill=tk.X, pady=10)
    
    back_button = ttk.Button(nav_bar, text="←", command=lambda: show_slide(current_slide - 1), style=(DANGER, SUCCESS))
    next_button = ttk.Button(nav_bar, text="→", command=lambda: show_slide(current_slide + 1), style=(DANGER, SUCCESS))
    ok_button = ttk.Button(nav_bar, text="verstanden", command=info_window.destroy, style=(DANGER, SUCCESS))
    
    
    back_button.pack(side=tk.LEFT, padx=85)
    ok_button.pack(side=tk.LEFT)
    next_button.pack(side=tk.LEFT, padx=80)
    
    show_slide(0)
    


# main gui
root = tk.Tk()
root.title("Foot Mapper")
root.update_idletasks()
root.geometry("") 

entries = []
comboboxes = []
keys = [
    'Tab', 'Enter', 'Shift', 'Ctrl', 'Alt', 'Esc', 'win', 'Space', 'Left', 'Up', 'Right', 'Down', 'backspace', 'delete', 'print', 'volumeup', 'volumedown', 'volumemute', 'playpause', 'nexttrack', 'fn', 'mouse_left', 'mouse_middle', 'mouse_right', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '^', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', ',', '.', '-', '>'
]



# description how the ui is working
description = ttkb.Label(root, text= "Hier kannst du Tasten und Tastenkombinationen für deine Pedale auswählen. Mehrere Tasten kannst du einfach mit 'add' zusammenfügen. Die Reihenfolge der Tasten ist analog zum physischen Gerät. Speichern nicht vergessen!"                         
                                  , wraplength=550, justify="left")
description.grid(row=1, columnspan=3, padx=10, pady=10)

# entry field (id and input), buttons (set user id, add, replace, delete), comboboxes 
id_entry = ttk.Entry(root, width=7)
id_entry.grid(row=0, column=0,  sticky='e', padx=0, pady=5)

id_button = ttk.Button(root, text="Set ID", command=set_user_id, style=(DANGER, SUCCESS))
id_button.grid(row=0, column=1,  sticky='w', padx=0, pady=5)

info_button = ttk.Button(root, text="?", command=show_info, style=(DANGER, SUCCESS))

info_button.grid(row=0, column=2,  sticky='e', padx=5, pady=5)

for i in range(3):
    entry = ttk.Entry(root, width=18, font=(8), state='readonly')
    entry.grid(row=3, column=i, padx=5, pady=5)             
    #entry.bind("<KeyPress>", on_key_press)
    entries.append(entry)

    combobox = ttk.Combobox(root, values=keys, state='readonly')
    combobox.grid(row=4, column=i, padx=5, pady=5)
    comboboxes.append(combobox)

    replace_button = ttk.Button(root, text="replace", command=lambda e=entry, c=combobox: replace_key(e, c), width=15, style=(DARK,OUTLINE))
    replace_button.grid(row=5, column=i, padx=5, pady=2)

    append_button = ttk.Button(root, text="add", command=lambda e=entry, c=combobox: append_key(e, c), width=15, style=(DARK,OUTLINE))
    append_button.grid(row=6, column=i, padx=5, pady=2)

    clear_button = ttk.Button(root, text="delete", command=lambda e=entry, c=combobox, idx=i+1: clear_input(e, c, idx), width=15, style=(DARK,OUTLINE))
    clear_button.grid(row=7, column=i, padx=5, pady=2)

    entry.bind("<KeyRelease>", lambda event, e=entry, c=combobox, b=append_button: update_add_button(e, c, b))
    #combobox.bind("<<ComboboxSelected>>", lambda event, e=entry, c=combobox, b=append_button: update_add_button(e, c, b))


save_button = ttk.Button(root, text="save", command=save_all_inputs, width=20, style=(DANGER, SUCCESS))
save_button.grid(row=10, columnspan=3, padx=5, pady=10)


# in the following the main functions of the system are called
load_inputs()
initialise_csv(user_id)

#brauch keinen Controller, das mach ich mit autogui
keyboard_listener = keyboard.Listener(on_press=on_key_press, on_release=on_key_release)

tray_thread = threading.Thread(target=create_tray_icon, daemon=True)
tray_thread.start()

upload_thread = threading.Thread(target = interval_upload, daemon=True)
upload_thread.start()

keyboard_listener.start()
root.protocol("WM_DELETE_WINDOW", on_closing)

root.mainloop()