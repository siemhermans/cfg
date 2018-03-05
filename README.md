# :wrench: .cfg
This repo contains a snapshot of my ([**@siemhermans**](https://twitter.com/siemhermans)) configuration files. This README provides sources for installing a base Arch Linux system and a step by step build instruction for converting the system into my preferred working environment.

# System installation
[@HardenedArray](https://github.com/HardenedArray) has provided an excellent `gist` on installing an Arch Linux system with encrypted root and swap filesystems and UEFI-booting compatibility. I highly suggest following the steps outlined in this [**guide**](https://gist.github.com/HardenedArray/31915e3d73a4ae45adc0efa9ba458b07).


# Environment setup
The following steps set up the correct `env` variables, install essential software packages, plugin managers and fonts, install plugins for `zsh` and `nvim` and clone the dotfiles provided in this repository into the correct directories. Where possible, all configuration files follow the XDG Base Directory Specification. Parts of the software selection for setting up `i3` and `xorg` build on [@erikdubois](https://github.com/erikdubois/Archi3)' installation scripts.

### Defining `env` variables
To ensure XDG compliance environment variables should be set up to conform to the XDG Base Directory Specification. Additonally, manually set the locale environment variables for installing plugins with `pip` (These variables are handled in `zshenv` later on):
```
[[ -n "$XDG_CONFIG_HOME" ]] || export XDG_CONFIG_HOME=$HOME/.config
[[ -n "$XDG_CACHE_HOME"  ]] || export XDG_CACHE_HOME=$HOME/.cache
[[ -n "$XDG_DATA_HOME"   ]] || export XDG_DATA_HOME=$HOME/.local/share
[[ -n "$LC_ALL" ]] || export LC_ALL="en_US.UTF-8"
[[ -n "$LC_CTYPE" ]] || export LC_CTYPE="en_US.UTF-8"
```

### Enabling multilib repositories
Several applications require 32-bit libraries. These can be retrieved after enabling the `multilib` repository in `/etc/pacman.conf`. 

### Selecting the fastest mirror

```
sudo pacman -S --noconfirm --needed reflector
sudo reflector -l 100 -f 50 --sort rate --threads 5 --verbose --save /tmp/mirrorlist.new
rankmirrors -n 0 /tmp/mirrorlist.new > /tmp/mirrorlistsudo 
cp /tmp/mirrorlist /etc/pacman.d && sudo pacman -Syu
```

### Install XOrg and video driver(s)

```
sudo pacman -S --noconfirm --needed \
   xorg-server xorg-apps xorg-xinit xorg-twm xterm xf86-video-intel
```

### Install essential software
The list below includes packages which are referenced or used in the various configuration files in this repository and create a working base install of the environment. All personal `$USER` applications have been omitted as they vary per system installation. Instead, these have been listed under the section 'Optional software packages' below. 

```
sudo pacman -S --noconfirm --needed \   
   acpi acpid alsa-firmware alsa-plugins alsa-utils android-tools ansible arandr baobab blueberry bluez-firmware bluez-utils bmon bridge-utils cheese cifs-utils cmake compton cups cups-pdf curl dhclient dialog dkms docker dunst etckeeper feh ffmpeg file-roller firefox flake8 flashplugin ghostscript gksu gnome-keyring gparted gsfonts gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer gvfs gvfs-mtp gvfs-nfs gvfs-smb hplip htop i3status imagemagick iperf iperf3 jre9-openjdk libcups libvirt linux-headers lm_sensors lsb-release lxappearance minicom mousetweaks mtr neovim net-tools networkmanager network-manager-applet nftables nmap numix-gtk-theme numlockx openconnect openssh openssl openvpn p7zip pavucontrol polkit powertop pulseaudio pulseaudio-alsa putty python python-pip python2 python2-pip ranger redshift remmina rofi ruby sane screen screenfetch scrot sshpass simple-scan sslscan xf86-input-libinput syncthing system-config-printer tcpdump thunar thunar-volman thunderbird tlp tlp-rdw tmux traceroute transmission-qt tree ttf-roboto udev udisks2 unrar unzip vagrant virt-manager virtualbox vlc wget whois wireshark-cli wireshark-common wireshark-qt x11-ssh-askpass xautolock xclip xdg-user-dirs xfce4-notes-plugin xss-lock zip zsh    

```
In order to trigger `.zlogin` (and thus the following `.xinitrc`), `zsh` should be made the default login shell for the current user:
```
sudo chsh $USER -s /bin/zsh
```
Additionally, `zsh` can be made XDG compliant by including the default XDG directories in `/etc/zsh/zshrc`. This way, `zsh` looks for its configuration files in `$XDG_CONFIG_HOME`: 
```
echo -e "\nif [[ -z "$XDG_CONFIG_HOME" ]]; then\n  export XDG_CONFIG_HOME="$HOME/.config/"\nfi\n\nif [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then\n  export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"\nfi" | sudo tee -a /etc/zsh/zshenv
```
### Install AUR helper `pacaur` 
```
curl -Ls https://goo.gl/cF2iJy | bash
```
### Installing additional software
```
pacaur -S --noconfirm --noedit universal-ctags-git rxvt-unicode-patched arping-th ostinato solaar gnome-ssh-askpass2 rar font-manager hardcode-fixer-git dropbox foxitreader numix-icon-theme-git numix-circle-icon-theme-git neofetch pkgcacheclean slack-desktop spotify keepassxc-git davmail ttf-fantasque-sans-mono powerline-fonts-git ttf-font-awesome-4 gtk-theme-arc-git icaclient eve-ng-integration i3lock-color-git j4-dmenu-desktop i3blocks i3-gaps-next-git teamviewer remmina-plugin-teamviewer displaylink
```

### Setting up plugin manager(s)
`vim-plug` allows for leveraging `nvim`'s asynchronous behavior. `zsh` plugins are handled by `zplug` which is self-contained within `$XDG_CONFIG_HOME/zsh/.zshrc`.
```
# vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Enable services
```
sudo systemctl enable NetworkManager.service
sudo systemctl enable org.cups.cupsd.service
sudo systemctl enable bluetooth.service
sudo systemctl enable sshd.service
```

### Clone dotfiles into correct directories
This method is courtesy of `/u/StreakyCobra` and is explained in more detail in https://goo.gl/hToRQZ. 
```
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

```
# Install Python related dependencies for Neovim:
pip3 install neovim flake8 pylint

# Pull down all plugins for Neovim
nvim +PlugInstall +UpdateRemotePlugins

# Zsh
mkdir $XDG_CONFIG_HOME/zsh/plugins/    # Create local plugin repository
zsh && zplug install
```

### Miscellaneous configuration

#### Power button behavior
By modifying the Power Button behavior in `logind`, i3 can handle poweroff behavior. In this instance, the power button is handled in `$mode_system` in i3. Note that this modification can only be performed as a privileged user.
```
sudo sed -i '/HandlePowerKey/{s/poweroff/ignore/g;s/#//g}' /etc/systemd/logind.conf
```

#### Disabling Optimus
Given a notebook with an Optimus configuration on which the official NVIDIA drivers have been installed, including the following command in `/etc/rc.local` allows for automatically switching to the Intel GPU when booting (thus prolonging battery life).
```
sudo sed -i '$i prime-switch' /etc/rc.local
```

#### Modifying banner files
Edit the default message when logging in from the console (`ttyX`). 
```
echo -e "Use of this system constitutes consent to monitoring. Monitoring may be\nconducted for the protection against improper or unauthorized use or access.\n\n" | sudo tee /etc/issue
```

#### Fixing audio popping on the Dell E7470
The Dell E7470 suffers from occasional audio popping when running the 4.X kernel branch. As a workaround the loopback device can be disabled by running the command below and navigating to the specific device. 
```
alsamixer -c0
```

#### Reverting to normal interface names
By default Ubuntu performs dynamic naming of network interfaces. To revert to a more human-readable scheme of `'ethX'` and `'wlanX'` the following line in `/etc/default/grub` can be changed:

```
sed -i '/GRUB_CMDLINE_LINUX/{s/\"\"/\"net\.ifnames\=0\"/g;s/#//g}' /etc/default/grub
```
### Correcting permissions
In order to run `minicom`, `pcap` without root permissions and allow device mounting in `virtualbox` the following groups should be added to the current user:

```
sudo usermod -aG dialout,wireshark,virtualbox $USER
```
