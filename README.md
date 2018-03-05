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

### Installing software
The list below includes packages which are referenced or used in the various configuration files in this repository and create a working base install of the environment. All personal `$USER` applications have been omitted as they vary per system installation. Instead, these have been listed under the section 'Optional software packages' below. 
```
sudo apt install \
   cmake compton curl dkms exuberant-ctags feh flake8 gvfs gvfs-backends i3 i3blocks i3lock    \
   i3status imagemagick libssl-dev lxappearance numlockx pavucontrol policykit-1 pulseaudio    \
   python-dev python-pip python3-dev python3-pip rofi rxvt-unicode-256color scrot thunar       \
   thunar-volman tmux udisks2 x11-apps x11-session-utils x11-utils x11-xserver-utils xautolock \
   xbacklight xfonts-base xinit xinput xorg xserver-xorg xserver-xorg-core                     \
   xserver-xorg-input-synaptics xss-lock zsh
```
In order to trigger `.zlogin` (and thus the following `.xinitrc`), `zsh` should be made the default login shell for the current user:
```
sudo chsh $USER -s /bin/zsh
```
Additionally, `zsh` can be made XDG compliant by including the default XDG directories in `/etc/zsh/zshrc`. This way, `zsh` looks for its configuration files in `$XDG_CONFIG_HOME`: 
```
echo -e "\nif [[ -z "$XDG_CONFIG_HOME" ]]; then\n  export XDG_CONFIG_HOME="$HOME/.config/"\nfi\n\nif [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then\n  export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"\nfi" | sudo tee -a /etc/zsh/zshenv
```

Neovim is currently not included in the default Ubuntu repositories but can be installed from `nvim`'s unstable PPA's:
```
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update -y && sudo apt-get install -y neovim
```

### Set up plugin manager(s)
`vim-plug` allows for leveraging `nvim`'s asynchronous behavior. `zsh` plugins are handled by `zplug` which is self-contained within `$XDG_CONFIG_HOME/zsh/.zshrc`.
```
# vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Install custom fonts
The fonts below are referenced in the `rofi`, `i3` and `rxvt-unicode` configuration files.
```
# Powerline fonts
git clone https://github.com/powerline/fonts
mkdir -p $XDG_DATA_HOME/fonts/ && chmod +x fonts/install.sh && sudo fonts/install.sh
rm -rf ~/fonts/

# FantasqueSansMono
wget https://github.com/belluzj/fantasque-sans/releases/download/v1.7.1/FantasqueSansMono.tar.gz
mkdir -p $XDG_DATA_HOME/fonts && tar -xzf FantasqueSansMono.tar.gz --wildcards '*.ttf' && mv ~/*.ttf $XDG_DATA_HOME/fonts/
rm FantasqueSansMono.tar.gz

# Roboto
git clone https://github.com/google/fonts/
mkdir -p $XDG_DATA_HOME/fonts && cp ~/fonts/apache/roboto/*.ttf $XDG_DATA_HOME/fonts
rm -rf ~/fonts/

# Font-Awesome
git clone https://github.com/FortAwesome/Font-Awesome/
mv ~/Font-Awesome/fonts/fontawesome-webfont.ttf $XDG_DATA_HOME/fonts/ && rm -rf ~/Font-Awesome/

# Update font-cache
fc-cache -f -v
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
Prevent scripts in /etc/update-motd.d/ from executing to remove the default messages:
```
sudo chmod -x /etc/update-motd.d/*
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

### Optional software packages

#### Environment themes
Add the theme repositories:

`numix-icon-theme` & `arc-theme`

```
wget -nv http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
sudo add-apt-repository -y ppa:numix/ppa
sudo apt update && sudo apt install arc-theme numix-icon-theme
```
Note that themes still have to be applied with `lxappearance`.

#### Workflow software packages
Enable the partner repository in `/etc/apt/sources.list`:
```
sudo sed -i.bak "/^# deb .*partner/ s/^# //" /etc/apt/sources.list && sudo apt update
```
The software packages below add on to the base install to create a workable environment:
```
sudo snap install keepassxc
sudo apt install \
   adobe-flashplugin android-tools-adb android-tools-fastboot arandr arping bmon bridge-utils    \
   cheese cifs-utils default-jre etckeeper ffmpeg file-roller firefox gnome-keyring gnupg2       \
   gparted htop iperf iperf3 lm-sensors minicom mousetweaks mtr network-manager nftables         \
   network-manager-gnome nmap numix-gtk-theme openconnect openvpn ostinato p7zip-full putty      \
   powertop ranger redshift remmina remmina-plugin-rdp remmina-plugin-vnc screenfetch solaar     \
   ssh-askpass ssh-askpass-gnome thunderbird tlp tlp-rdw traceroute transmission-gtk tree        \
   tshark udev unrar unzip virt-manager virtualbox vlc whois wireshark wpasupplicant xfce4-notes
```
In order to run `minicom`, `pcap` without root permissions and allow device mounting in `virtualbox` the following groups should be added to the current user:

```
sudo usermod -a -G dialout,wireshark,virtualbox $USER
```

The software packages below require manual installation:

+ [`davmail`](http://davmail.sourceforge.net/download.html)
+ [`syncthing`](https://apt.syncthing.net)
+ [`hplip`](http://hplipopensource.com/hplip-web/downloads.html)
+ [`spotify`](https://www.spotify.com/nl/download/linux/)
+ [`teamviewer`](https://www.teamviewer.com/en/download/linux/)

#### DisplayLink driver 
The easiest way to install the DisplayLink driver for Debian based distributions is by using `/u/AdnanHodzic`'s install script:
```
git clone https://github.com/AdnanHodzic/displaylink-debian && cd displaylink-debian
sudo ./displaylink-debian.sh
```
