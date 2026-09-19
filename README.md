# MintBuddy for Linux Mint

MintBuddy is a small local app for students using Linux Mint.
It opens in your web browser and stays on your computer.

**GitHub:** https://github.com/ahamdmurad02-dev/mintbuddy  
**Releases:** https://github.com/ahamdmurad02-dev/mintbuddy/releases

## What it does

- Home page with Linux Mint tips
- Study timer (25 / 15 / 5 minutes)
- Notes that save in the browser
- Beginner Linux command list
- This-PC information (name, memory, free disk)

No extra packages are required. It uses Python 3, which Linux Mint already has.

## Fast install (.sh)

```bash
curl -fsSL https://raw.githubusercontent.com/ahamdmurad02-dev/mintbuddy/main/install-mintbuddy.sh | bash
```

Or download `install-mintbuddy.sh` from Releases, then:

```bash
chmod +x install-mintbuddy.sh
./install-mintbuddy.sh
```

## Get the project from GitHub

```bash
sudo apt update
sudo apt install -y git python3
git clone https://github.com/ahamdmurad02-dev/mintbuddy.git
cd mintbuddy
chmod +x install.sh mintbuddy.sh mintbuddy.py
./install.sh
```

Then open the Mint Menu and search for **MintBuddy**.

Start without the menu:

```bash
./mintbuddy.sh
```

## Run without installing

```bash
cd mintbuddy
python3 mintbuddy.py
```

Your browser should open `http://127.0.0.1:8765/`.
Leave the terminal open while you use the app. Press `Ctrl+C` to stop it.

## Uninstall

```bash
rm -rf ~/.local/share/mintbuddy
rm -f ~/.local/share/applications/mintbuddy.desktop
rm -f ~/.local/bin/mintbuddy
```

## Notes

- The app only listens on your own computer (`127.0.0.1`).
- Notes are stored in the browser, not uploaded anywhere.
- Works on Linux Mint Cinnamon, MATE, and XFCE, and also on Ubuntu.
