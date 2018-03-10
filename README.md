# :wrench: .cfg
This repo contains a snapshot of my ([**@siemhermans**](https://twitter.com/siemhermans)) configuration files and a guide for setting up a minimal Arch Linux system based around the `i3` window manager. This **README** provides sources for installing a base system and a step by step build instruction for converting that system into my personally preferred working environment.

## Base system installation
[@HardenedArray](https://github.com/HardenedArray) has provided an excellent `gist` on installing an Arch Linux system with UEFI-booting compatibility and encrypted root and swap filesystems. I highly suggest following the steps outlined in this [**guide**](https://gist.github.com/HardenedArray/31915e3d73a4ae45adc0efa9ba458b07) as the following sections pick up where the user is left off after installing.

## Building a working environment
The following steps set up the correct `env` variables, install essential software packages, plugin managers and fonts, install plugins for `zsh` and `nvim` and clone the dotfiles provided in this repository into the correct directories. Where possible, all configuration files follow the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html). Parts of the software selection for setting up `i3` and `xorg` build on [@erikdubois](https://github.com/erikdubois/Archi3)' installation scripts.

#### Defining `env` variables
To ensure XDG compliance during the installation process, environment variables should temporarily be set up to conform to the XDG specification. These variables will be handled in `/etc/zsh/zshenv` in the final setup, causing them to be loaded when `zsh` starts. As `zsh` will be set as the default shell for the main user, this in turn happens when `$USER` logs in. Additonally, to be able to install Python packages with `pip`, the locale environment variables should be set: 

```bash
[[ -n "$XDG_CONFIG_HOME" ]] || export XDG_CONFIG_HOME=$HOME/.config
[[ -n "$XDG_CACHE_HOME"  ]] || export XDG_CACHE_HOME=$HOME/.cache
[[ -n "$XDG_DATA_HOME"   ]] || export XDG_DATA_HOME=$HOME/.local/share
[[ -n "$LC_ALL" ]] || export LC_ALL="en_US.UTF-8"
[[ -n "$LC_CTYPE" ]] || export LC_CTYPE="en_US.UTF-8"
```

#### Selecting the fastest mirror *(Optional)*
Prior to installing any software it may be beneficial to select the fastest available mirror(s) for `pacman`. This can be done by manually selecting regional mirrors in `/etc/pacman.d/mirrors` to be preferred. Alternatively `reflector` can be used to actively test the available mirrors and select the best ones based on bandwidth and response times.  

```bash
sudo pacman -S --noconfirm --needed reflector
sudo reflector -l 100 -f 50 --sort rate --threads 5 --verbose --save /tmp/mirrorlist.new

# Populate the new mirrorlist
rankmirrors -n 0 /tmp/mirrorlist.new > /tmp/mirrorlistsudo
sudo cp /tmp/mirrorlist /etc/pacman.d
```

#### Enabling multilib repositories
Several of the applications to be installed require additional 32-bit libraries. These can be retrieved after enabling the `multilib` repository in `/etc/pacman.conf`: 

```bash
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Update packages and package lists 
sudo pacman -Syu
```

#### Installing an AUR helper
Some of the packages related to `i3` are only available in the Arch User Repository (AUR). In order to take the strain out of manually keeping these packages up to date we will be installing an AUR helper. Although these helpers come in many shapes and forms I've settled on `trizen` which effectively functions as a drop-in replacement for the now deprecated `pacaur`.

```bash
mkdir `$XDG_CONFIG_HOME/git/`
git clone https://aur.archlinux.org/trizen.git $!
cd `$XDG_CONFIG_HOME/git/` && makepkg -si --noconfirm
```

#### Installing essential utilities
At this point we are ready to install core utilities such as the X Window System, the Window Manager, audio and video drivers, storage drivers and networking tools. The list below includes packages which are referenced or used in the various configuration files in this repository and create a working base install of the environment. All personal `$USER` applications have been omitted as they vary per system installation. Instead, these have been listed under the following 'Additional software packages' section below.

```bash
# Official repositories
sudo pacman -S --noconfirm --needed \  
   acpi acpid alsa-firmware alsa-plugins alsa-utils blueberry bluez-firmware bluez-utils    \
   bridge-utils cifs-utils cmake cups cups-pdf curl dhclient dialog dkms dunst etckeeper    \
   feh ffmpeg ghostscript git gksu gnome-keyring gsfonts gst-plugins-bad gst-plugins-base   \
   gst-plugins-good gst-plugins-ugly gstreamer gvfs gvfs-mtp gvfs-nfs gvfs-smb i3status     \
   imagemagick iperf iperf3 libcups linux-headers lsb-release mousetweaks neovim net-tools  \
   network-manager-applet networkmanager numlockx openssh openssl p7zip pavucontrol polkit  \
   pulseaudio pulseaudio-alsa python python2 python2-pip python-pip rofi ruby sane scrot    \
   simple-scan sshpass system-config-printer tlp tlp-rdw tree udev udisks2 unrar unzip wget \
   x11-ssh-askpass xautolock xclip xdg-user-dirs xf86-input-libinput xf86-video-intel       \
   xorg-apps xorg-server xorg-twm xorg-xinit xss-lock xterm zip zsh 

# AUR
sudo trizen -S --noconfirm --noedit \
   i3blocks i3-gaps-next-git i3lock-color-git j4-dmenu-desktop rxvt-unicode-patched
```

If `zsh` wasn't chosen to be the default shell at the time of creating the user we should set it now. This is needed in order to trigger `.zlogin` and thus the following `.xinitrc` which in turn starts the `X` server.

```bash
sudo chsh $USER -s /bin/zsh
```

Additionally, `zsh` can be made XDG compliant by including the default XDG directories in `/etc/zsh/zshrc`. This way, `zsh` looks for its configuration files in `$XDG_CONFIG_HOME`:

```bash
echo -e "\nif [[ -z "$XDG_CONFIG_HOME" ]]; then\n  export XDG_CONFIG_HOME="$HOME/.config/"\nfi\n\nif [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then\n  export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"\nfi" | sudo tee -a /etc/zsh/zshenv
```

### Installing additional software *(Optional)*

```
# Official repositories
sudo pacman -S --noconfirm --needed \ 
	android-tools ansible arandr baobab bmon cheese compton docker file-roller firefox      \
   flake8 flashplugin gparted hplip htop jre9-openjdk libvirt lm_sensors lxappearance      \
   mtr nftables nmap numix-gtk-theme openconnect openvpn powertop putty ranger redshift    \
   remmina screen screenfetch sslscan syncthing tcpdump thunar thunar-volman thunderbird   \
   tmux traceroute transmission-qt ttf-roboto vagrant virt-manager virtualbox vlc whois    \
   wireshark-cli wireshark-common wireshark-qt xfce4-notes-plugin

# AUR
sudo trizen -S --noconfirm --noedit \
  	arping-th davmail displaylink dropbox eve-ng-integration font-manager foxitreader       \
   gnome-ssh-askpass2 gtk-theme-arc-git hardcode-fixer-git icaclient keepassxc-git         \
   neofetch numix-circle-icon-theme-git numix-icon-theme-git ostinato pkgcacheclean        \
   powerline-fonts-git rar remmina-plugin-teamviewer rxvt-unicode-patched slack-desktop    \
   solaar spotify teamviewer ttf-fantasque-sans-mono ttf-font-awesome-4 universal-ctags-git
```

### Correcting permissions
In order to run `pcap` without root permissions and allow device mounting in `virtualbox` the following groups should be added to the current user:

```bash
sudo usermod -aG wireshark,vboxusers,libvirtd,docker $USER
```

### Setting up plugin manager(s)
`vim-plug` allows for leveraging `nvim`'s asynchronous behavior. `zsh` plugins are handled by `zplug` which is self-contained within `$XDG_CONFIG_HOME/zsh/.zshrc`.
```bash
# vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Clone dotfiles into correct directories
This method is courtesy of `/u/StreakyCobra` and is explained in more detail in the [Atlassian Developer blog]( https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

```bash
# Set up cfg alias and clone the repo
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare https://github.com/siemhermans/cfg $HOME/.cfg

# Backup pre-existing configuration files
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}

# Checkout HEAD and hande UntrackedFiles
cfg checkout
cfg config --local status.showUntrackedFiles no
```
Future configuration files can be added or removed by leveraging the `cfg` alias.

### Install plugins
`nvim` plugins can be installed directly from the command line with the command below. The `zsh` plugins should be automatically installed by `zplug` the first time `zshrc` is read. `urxvt` plugins are handled directly in `$XDG_CONFIG_HOME/X11/Xresources` and are included in the repository. 

```bash
# Install Python related dependencies for Neovim:
pip install neovim flake8 pylint

# Pull down all plugins for Neovim
nvim +PlugInstall +UpdateRemotePlugins

# Zsh
mkdir $XDG_CONFIG_HOME/zsh/plugins/    # Create local plugin repository
zsh && zplug install
```

### Starting default services
```bash
sudo systemctl enable NetworkManager.service
sudo systemctl enable org.cups.cupsd.service
sudo systemctl enable bluetooth.service
sudo systemctl enable sshd.service
```

### Miscellaneous configuration

#### Power button behavior
By modifying the Power Button behavior in `logind`, i3 can handle poweroff behavior. In this instance, the power button is handled in `$mode_system` in i3. Note that this modification can only be performed as a privileged user.
```bash
sudo sed -i '/HandlePowerKey/{s/poweroff/ignore/g;s/#//g}' /etc/systemd/logind.conf
```

#### Modifying banner files
Edit the default message when logging in from the console (`ttyX`). 
```bash
echo -e "Use of this system constitutes consent to monitoring. Monitoring may be\nconducted for the protection against improper or unauthorized use or access.\n\n" | sudo tee /etc/issue
```

#### Fixing audio popping on the Dell E7470
The Dell E7470 suffers from occasional audio popping when running the 4.X kernel branch. As a workaround the loopback device can be disabled by running the command below and navigating to the specific device. 
```bash
alsamixer -c0
```

#### Reverting to normal interface names
By default `systemd-networkd` performs dynamic naming of network interfaces. To revert to a more human-readable scheme of `'ethX'` and `'wlanX'` the following line in `/etc/default/grub` can be changed:

```bash
sed -i '/GRUB_CMDLINE_LINUX/{s/\"\"/\"net\.ifnames\=0\"/g;s/#//g}' /etc/default/grub
```
