<h1 align="center">:coffee: Procastinator :hourglass:</h1>

<p align="center">
	<a href="https://github.com/westrangeloops/procastinator/stargazers">
		<img alt="Stargazers" src="https://img.shields.io/github/stars/westrangeloops/procastinator?style=for-the-badge&logo=starship&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41"></a>
    <a href="https://nixos.org/">
        <img src="https://img.shields.io/badge/NixOS-25.05-informational.svg?style=for-the-badge&logo=nixos&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41"></a>
    <a href="https://github.com/ryan4yin/nixos-and-flakes-book">
        <img src="https://img.shields.io/github/repo-size/westrangeloops/procastinator?style=for-the-badge&logo=nixos&color=DDB6F2&logoColor=D9E0EE&labelColor=302D41"></a>
  </a>
</p>

> **Procastinator** is the living embodiment of what happens when a graduate student discovers that configuring NixOS is infinitely more appealing than writing a thesis. Behold this magnificent monument to academic avoidance—a flake so unnecessarily complex that it required approximately 147 cups of coffee and the abandonment of all scholarly responsibilities to create.

<p align="center">
  <img width="80%" src="https://github.com/user-attachments/assets/f3ef7b27-825f-4bca-bf01-9ff92096f040" />   
  <img src="https://github.com/user-attachments/assets/47fae1d6-b54b-4801-8c93-6f1d22918049" width="40%" />
  <img src="https://github.com/user-attachments/assets/b678d830-9a9e-48c0-943c-a5e5ff524e8e" width="40%" />
  <img src="https://github.com/user-attachments/assets/16f18fbe-81fc-41d1-ad99-e393342d19af" width="40%" />
  <img src="https://github.com/user-attachments/assets/5ac2d6f9-3102-4281-a8bf-72d35e8d0e6a" width="40%" />
</p>

## :sparkles: The Art of Academic Evasion

Every line of this configuration represents approximately one paragraph that should have been written for my thesis. Each carefully crafted module stands as a testament to the extraordinary lengths one will go to avoid actual productive work. This repository contains roughly 10,000 lines of code, which, coincidentally, is exactly the word count my advisor was expecting for chapter three.

The code quality ranges from "surprisingly functional" to "dear god what was I thinking at 3 AM," yet somehow it all works—unlike my academic career, which remains in perpetual limbo. The commit history reads like the diary of a madman, with timestamps that clearly indicate when normal people would be sleeping or, you know, writing their dissertations.

## :scroll: Inspirational Enablers of My Procrastination

This monstrosity wouldn't exist without the following repositories, which I discovered while searching for "how to extend thesis deadline" and somehow ended up in a three-week NixOS configuration rabbit hole:

- [Rudra](https://github.com/vasujain275/rudra) - The primary enabler of my academic downfall
- [Shizuru](https://github.com/kagurazakei/Shizuru) - A shining beacon that lured me away from LaTeX documents
- [Kaku](https://github.com/linuxmobile/kaku) - The final nail in the coffin of my productivity

## 🍖 Requirements

- You must be running on NixOS.
- The procastinator folder (this repo) is expected to be in your home directory.
- Must have installed using GPT & UEFI. Grub is what is supported, for SystemD you will have to brave the internet for a how-to. ☺️
- Manually editing your host specific files. The host is the specific computer your installing on.
- A profound desire to work on literally anything except what you're supposed to be doing.

### ⬇️ Install

Run this command to ensure Git & Vim are installed (and your academic responsibilities are properly ignored):

```
nix-shell -p git vim
```

Clone this repo & enter it (much like I entered the void of procrastination):

```
git clone https://github.com/westrangeloops/procastinator
cd procastinator
```

- _You should stay in this folder for the rest of the install (I've been here for months)_

Create the host folder for your machine(s) (this step alone took me three days):

```
cp -r hosts/default hosts/<your-desired-hostname>
```

**🪧🪧🪧 Edit your configuration files 🪧🪧🪧**

Generate your hardware.nix like so (I spent a week "perfecting" mine):

```
nixos-generate-config --show-hardware-config > hosts/<your-desired-hostname>/hardware-configuration.nix
```

- _Edit All the instances of the username "dotempo" and replace it with your name_

- _Change to amd/intel modules from nvidia one according to your gpu in configuration.nix_

Run this to enable flakes and install the flake replacing hostname with whatever you put as the hostname:

```
NIX_CONFIG="experimental-features = nix-command flakes"
sudo nixos-rebuild switch --flake .#hostname
```

Now when you want to rebuild the configuration you can execute the last command, that will rebuild the flake!

May your computing experience be as unnecessarily complex as my methods of avoiding real work. My advisor sends their regards.
