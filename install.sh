#!/bin/bash
# shellcheck enable=require-variable-braces

#Section: ----- Global Variables -----

# Colors
readonly cyan='\033[0;36m'        # Title;
readonly red='\033[0;31m'         # Error;
readonly yellow='\033[1;33m'      # Warning;
readonly purple='\033[0;35m'      # Alert;
readonly blue='\033[0;34m'        # Attention;
readonly light_gray='\033[0;37m'  # Option;
readonly green='\033[0;32m'       # Done;
readonly reset='\033[0m'          # No color, end of sentence;

# %b - Print the argument while expanding backslash escape sequences.
# %q - Print the argument shell-quoted, reusable as input.
# %d, %i - Print the argument as a signed decimal integer.
# %s - Print the argument as a string.

#Syntax:
#    printf "'%b' 'TEXT' '%s' '%b'\n" "${color}" "${var}" "${reset}"

readonly sys="${1}"    # "--wsl" "--arch"
readonly operation="${2}"  # "--config-sys" "--check-packages" "--install-packages"

# Sudo
if [ "${sys}" == "--wsl" ]; then
    readonly permit="sudo";
elif [ "${sys}" == "--arch" ]; then
    readonly permit="" ;
fi

# Package list
if [ "${sys}" == "--wsl" ]; then
    readonly file="packages-wsl.txt" ;
elif [ "${sys}" == "--arch" ]; then
    readonly file="packages-arch.txt" ;
fi

#Section: ----- General Functions -----

#OK
function timer() {
    if [ "${#}" == "" ]; then
        printf "%bIncorrect use of 'timer' Function !%b\nSyntax:\vtimer_ 'PHRASE';%b\n" "${purple}" "${light_gray}" "${reset}" 1>&2 ;
        exit 2 ;
    fi

    for run in {10..0}; do
        clear; printf "%b%s%b\nContinuing in: %ss%b\n" "${blue}" "${*}" "${light_gray}" "${run}" "${reset}" ; sleep 1 ;
    done
    return
}

#Section: "--config-sys"

#OK
function config-timezone_() {
    ln --force --symbolic --verbose /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime ;  # Configure Time Zone
}

#OK
function config-hwclock_() {
    hwclock --systohc --verbose ;  # Cofig Hardware Clock
}

#OK
function config-locale_() {
    # Configure Locale
    sed --expression 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' --in-place /etc/locale.gen ;
    sed --expression 's/#pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/g' --in-place /etc/locale.gen ;
    locale-gen ;
    printf "LANG=en_US.UTF-8" | tee --append "/etc/locale.conf" > /dev/null 2>&1 ;
}

#OK
function config-hostname_() {
    # Configure Hostname
    read -r -p "$(printf "\n%bEnter HOSTNAME: %b" "${cyan}" "${reset}")" SET_HOSTNAME ;
    printf "%s" "${SET_HOSTNAME}" | tee --append "/etc/hostname" > /dev/null 2>&1 ;
}

#OK
function config-pretty-hostname_() {
    # Configure Pretty Hostname
    read -r -p "$(printf "\n%bEnter Pretty Hostname: %b" "${cyan}" "${reset}")" SET_PRETTYNAME ;
    SET_ICON_NAME="computer" ;
    while true; do
        read -r -p "$(printf "\n%bIs this machine a '%blaptop%b' or '%bdesktop%b'? %b" "${cyan}" "${light_gray}" "${cyan}" "${light_gray}" "${cyan}" "${reset}")" yn ;
        case "${yn}" in
            'desktop' ) SET_CHASSIS="${yn}" ; break;;
            'laptop' ) SET_CHASSIS="${yn}" ; break;;
            * ) printf "%bPlease answer with '%bdesktop%b' or '%blaptop%b'. %b\n" "${red}" "${light_gray}" "${red}" "${light_gray}" "${red}" "${reset}" ;;
        esac
    done
    SET_DEPLOYMENT="production" ;
    {
        printf "PRETTY_HOSTNAME=\"%s\"" "${SET_PRETTYNAME}" ;
        printf "\nICON_NAME=%s" "${SET_ICON_NAME}" ;
        printf "\nCHASSIS=%s" "${SET_CHASSIS}" ;
        printf "\nDEPLOYMENT=%s" "${SET_DEPLOYMENT}" ;
    } | tee "/etc/machine-info" > /dev/null 2>&1 ;
}

#OK
function config-hosts_() {
    # Configure Hosts
    {
        printf "127.0.0.1     localhost" ;
        printf "\n::1           localhost" ;
        printf "\n127.0.1.1     %s" "${SET_HOSTNAME}" ;
    } | tee "/etc/hosts" > /dev/null 2>&1 ;
}

#OK
function config-keyboard-layout_() {
    printf "KEYMAP=us" | tee "/etc/vconsole.conf" > /dev/null 2>&1 ;  # Config console keyboard layout
}

#OK
function config-package-manager_() {
    if [ ! "${1}" == "--wsl" ] && [ ! "${1}" == "--arch" ]; then
        printf "\n%bIncorrect use of Function 'config-package-manager_', choose a argument: '--wsl' or '--arch'%b\n" "${red}" "${reset}" 1>&2 ;
        exit 2 ;
    fi

    if [ "${1}" == "--wsl" ]; then
        sudo apt update --yes ;  # update list of available packages
        sudo apt upgrade --yes ;  # update installed packages
    elif [ "${1}" == "--arch" ] ; then
        sed --expression 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' --in-place /etc/pacman.conf ;  # Enable parallel downloads
        sed --expression 's/#Color/Color/g' --in-place /etc/pacman.conf ;  # Enable colors on Pacman
        printf "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | tee --append "/etc/pacman.conf" > /dev/null 2>&1 ;  # Enable multilib on Pacman
        pacman --sync --refresh --refresh --noconfirm ;  # Forcefully update list of available packages
    fi
}

#OK
function config-grub_() {
    # Grub packages
    pacman --sync grub        --noconfirm ;
    pacman --sync efibootmgr  --noconfirm ;
    pacman --sync os-prober   --noconfirm ;
    pacman --sync intel-ucode --noconfirm ;
    # Config Grub
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --recheck ;  # Install Grub
    sed --expression 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0.1/g' --in-place /etc/default/grub ;  # "Remove" delay when booting
    sed --expression 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=true/g' --in-place /etc/default/grub ;  # Enable Probe
    grub-mkconfig --output /boot/grub/grub.cfg ;  # Build grub config file
}

#OK
function config-network_() {
    pacman --sync networkmanager --noconfirm ;  # Download Network Manager
    systemctl enable NetworkManager.service ;  # Enable Network Manager's Service
}

#OK
function config-home-dir_() {
    # Home Library
    ${permit} mkdir --verbose /etc/skel/Desktop ;
    ${permit} mkdir --verbose /etc/skel/Documents ;
    ${permit} mkdir --verbose /etc/skel/Downloads ;
    ${permit} mkdir --verbose /etc/skel/Media ;
    ${permit} mkdir --verbose /etc/skel/Media/Music ;
    ${permit} mkdir --verbose /etc/skel/Media/Pictures ;
    ${permit} mkdir --verbose /etc/skel/Media/Videos ;
    ${permit} mkdir --verbose /etc/skel/Media/Screenshots ;
    ${permit} mkdir --verbose /etc/skel/Media/Wallpapers ;
    ${permit} mkdir --verbose /etc/skel/Projects ;
    ${permit} mkdir --verbose /etc/skel/Video\ Games ;
    ${permit} mkdir --verbose /etc/skel/Repositories ;
    ${permit} mkdir --verbose /etc/skel/Virtual\ Machine ;
}

#OK
function config-users_() {
    # Read Username
    read -r -p "$(printf "\n%bEnter User's Full Name: %b" "${cyan}" "${reset}")" USER_NAME ;
    read -r -p "$(printf "\n%bEnter Username (Login): %b" "${cyan}" "${reset}")" USER_LOGIN ;

    # Create User
    ${permit} useradd --badname --create-home --groups wheel --shell /bin/bash "${USER_LOGIN}" ;
    ${permit} usermod --comment "${USER_NAME}" "${USER_LOGIN}" ;

    # Change Passwd from "${USER_LOGIN}"
    printf "%bSet Password for %b'%s'%b\n" "${cyan}" "${light_gray}" "${USER_LOGIN}" "${reset}" ;
    until ${permit} passwd "${USER_LOGIN}" ;
    do
        printf "%bPasswords do not match. Try again..%b\n" "${red}" "${reset}"
    done
}

#OK
function config-sudoers_() {
    printf "\n%%wheel ALL=(ALL:ALL) ALL\n" | ${permit} tee "/etc/sudoers.d/wheel" > /dev/null 2>&1 ;
    printf "\nDefaults insults" | ${permit} tee --append "/etc/sudoers.d/wheel" > /dev/null 2>&1 ;
    printf "\nDefaults timestamp_timeout=10" | ${permit} tee --append "/etc/sudoers.d/wheel" > /dev/null 2>&1 ;
    printf "\nDefaults lecture = always" | ${permit} tee --append "/etc/sudoers.d/wheel" > /dev/null 2>&1 ;
}

#OK
function config-wsl-sys_() {
    config-package-manager_ --wsl ;
    config-home-dir_ ;
    config-users_ ;
    config-sudoers_ ;
}

#OK
function config-arch-sys_() {
    config-timezone_ ;
    config-hwclock_ ;
    config-locale_ ;
    config-hostname_ ;
    config-pretty-hostname_ ;
    config-hosts_ ;
    config-keyboard-layout_ ;
    config-package-manager_ --arch;
    config-grub_ ;
    config-network_ ;
    config-home-dir_ ;
    config-users_ ;
    config-sudoers_ ;
}

#Section: "--check-packages"

#OK
function check-installed-packages_() {
    if [ ! "${1}" == "--wsl" ] && [ ! "${1}" == "--arch" ]; then
        printf "\n%bIncorrect use of Function 'check-installed-packages_', choose a argument: '--wsl' or '--arch'%b\n" "${red}" "${reset}" 1>&2 ;
        exit 2 ;
    fi

    # Check if packages from "packages.txt" or "packages-wsl.txt" are installed
    printf "\n%bChecking if Packages from '/%s' are installed... %b\n\n" "${blue}" "${file}" "${reset}" ; sleep 2 ;
    if [ "${1}" == "--wsl" ]; then
        while IFS="" read -r p || [ -n "${p}" ]; do
            if sudo dpkg --list "${p}" > /dev/null 2>&1 ; then
                printf "%bThe package '%s' is installed%b\n" "${green}" "${p}" "${reset}" ; sleep 0.05 ;
            # It is neither a Group nor a Package and is not installed
            else
                printf "%bThe package '%s' is not installed%b\n" "${red}" "${p}" "${reset}" ; sleep 0.5 ;
            fi
        done < "${file}"
    elif [ "${1}" == "--arch" ]; then
        while IFS="" read -r p || [ -n "${p}" ]; do
            # It is a Group and not a Package and is installed
            if pacman --query --groups "${p}" > /dev/null 2>&1 && ! pacman --query --info "${p}" > /dev/null 2>&1; then
                printf "%bThe package '%s' is installed%b\n" "${green}" "${p}" "${reset}" ; sleep 0.05 ;
            # It is not a Group, but a package and is installed
            elif ! pacman --query --groups "${p}" > /dev/null 2>&1 && pacman --query --info "${p}" > /dev/null 2>&1; then
                printf "%bThe package '%s' is installed%b\n" "${green}" "${p}" "${reset}" ; sleep 0.05 ;
            # It is neither a Group nor a Package and is not installed
            else
                printf "%bThe package '%s' is not installed%b\n" "${red}" "${p}" "${reset}" ; sleep 0.5 ;
            fi
        done < "${file}"
    fi
}

#Section: "--install-packages"

#OK
function install-packages_() {
    if [ ! "${1}" == "--wsl" ] && [ ! "${1}" == "--arch" ]; then
        printf "\n%bIncorrect use of Function 'install-packages_', choose a argument: '--wsl' or '--arch'%b\n" "${red}" "${reset}" 1>&2 ;
        exit 2 ;
    fi

    # Package Manager
    if [ "${1}" == "--wsl" ]; then
        appmanager="apt install";
        noconfirm="--yes";
    elif [ "${1}" == "--arch" ]; then
        appmanager="pacman --sync";
        noconfirm="--noconfirm";
    fi

    printf "\n%bInstalling Packages from '/%s'%b\n" "${yellow}" "${file}" "${reset}" ; sleep 2 ;
    while IFS="" read -r p || [ -n "${p}" ]; do
            printf "%bInstalling %s...%b\n" "${yellow}" "${p}" "${reset}" ;
            sudo ${appmanager} ${p} ${noconfirm} ;  # Word globbing is necessary, aka don't quote the variables
    done < "${file}"
}

#OK
function install-others_() {
    # Chrome driver
    wget --continue --directory-prefix "${PWD}"/Downloads/ https://chromedriver.storage.googleapis.com/LATEST_RELEASE ;
    LATEST_RELEASE=$( cat "${PWD}"/Downloads/LATEST_RELEASE ) ;
    wget --continue --directory-prefix "${PWD}"/Downloads/ https://chromedriver.storage.googleapis.com/"${LATEST_RELEASE}"/chromedriver_linux64.zip ;
    unzip "${PWD}"/Downloads/'chromedriver_linux64.zip' -d "${HOME}"/.local/.bin/ ;

    # NVM (NodeJS Version Manager)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash ;
    export NVM_DIR="${HOME}/.nvm" ;
    [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"                    ; # This loads nvm;
    [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"  ; # This loads nvm bash_completion;
    nvm install --lts ;
    nvm use --lts ;
}

#OK
function install-fonts_() {
    # Fonts
    mkdir --parents --verbose "${PWD}"/Downloads/Fonts ;

    # Icons (Material Design Fonts)
    git clone https://github.com/Templarian/MaterialDesign-Font.git "${HOME}"/.local/share/fonts/MaterialDesign-Font/ ;

    # Nerd Fonts (Hack)
    wget --continue --directory-prefix "${PWD}"/Downloads/Fonts/ https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip ;
    mkdir --parents --verbose "${HOME}"/.local/share/fonts/Hack/ ;
    unzip "${PWD}"/Downloads/Fonts/'Hack.zip' -d "${HOME}"/.local/share/fonts/Hack/ ;

    # Nerd Fonts (FiraCode)
    wget --continue --directory-prefix "${PWD}"/Downloads/Fonts/ https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip ;
    mkdir --parents --verbose "${HOME}"/.local/share/fonts/FiraCode/ ;
    unzip "${PWD}"/Downloads/Fonts/'FiraCode.zip' -d "${HOME}"/.local/share/fonts/FiraCode/ ;

    # Refresh Fonts Cache
    fc-cache --really-force ;
}

#OK
function install-others-packages_() {
    # Arch User Repository
    mkdir --parents --verbose "${PWD}"/Downloads/Packages ;

    (
        cd "${PWD}"/Downloads/Packages || exit ;

        # ly
        printf "\n%bCloning LY (GitHub Fork)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        git clone --recurse-submodules https://github.com/gnsbriel/ly-display-manager.git ;

        # Spotify
        printf "\n%bCloning Spotify (AUR)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --import - ;
        git clone https://aur.archlinux.org/spotify.git ;

        # Picom
        printf "\n%bCloning Picom (AUR)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        git clone https://aur.archlinux.org/picom-jonaburg-git.git ;

        VSCode
        printf "\n%bCloning VSCode (AUR)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        git clone https://aur.archlinux.org/visual-studio-code-bin.git ;

        # Only Office
        printf "\n%bCloning Only Office (AUR)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        git clone https://aur.archlinux.org/onlyoffice-bin.git ;
    )

    (
        # ly
        cd "${PWD}"/Downloads/Packages/ly-display-manager || exit ;
        printf "\n%bInstalling LY (GitHub Fork)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        make ;
        sudo make install installsystemd ;
    )

    (
        # Spotify
        cd "${PWD}"/Downloads/Packages/spotify || exit ;
        printf "\n%bInstalling Spotify (AUR)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        makepkg -si --noconfirm ;
    )

    (
        # Picom
        cd "${PWD}"/Downloads/Packages/picom-jonaburg-git || exit ;
        printf "\n%bInstalling Picom (AUR)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        makepkg -si --noconfirm ;
    )

    (
        # VSCode
        cd "${PWD}"/Downloads/Packages/visual-studio-code-bin || exit ;
        printf "\n%bInstalling VSCode (AUR)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        makepkg -si --noconfirm ;
    )

    (
        # Only Office
        cd "${PWD}"/Downloads/Packages/onlyoffice-bin || exit ;
        printf "\n%bInstalling Only Office (AUR)...%b\n" "${yellow}" "${reset}" ; sleep 2 ;
        makepkg -si --noconfirm ;
    )
}

#OK
function install-config-files_() {
    if [ ! "${1}" == "--wsl" ] && [ ! "${1}" == "--arch" ]; then
        printf "\n%bIncorrect use of Function 'install-config-files_', choose a argument: '--wsl' or '--arch'%b\n" "${red}" "${reset}" 1>&2 ;
        exit 2 ;
    fi

    # Setup Config Files
    if [ "${1}" == "--wsl" ]; then
        sudo cp --verbose "${PWD}"/etc/pam.d/login /etc/pam.d/login ;
    elif [ "${1}" == "--arch" ]; then
        source "/etc/machine-info" ;
        mkdir --verbose "${PWD}"/Ignored ;
        if [ "${CHASSIS}" == "desktop" ]; then
            mv --verbose "${PWD}"/etc/X11/xorg.conf.d/30-libinput.conf "${PWD}"/Ignored/ ;
        elif [ "${CHASSIS}" == "laptop" ]; then
            mv --verbose "${PWD}"/etc/X11/xorg.conf.d/10-monitor.conf "${PWD}"/Ignored/ ;
            mv --verbose "${PWD}"/etc/X11/xorg.conf.d/20-amdgpu.conf "${PWD}"/Ignored/ ;
        fi
        sudo cp --recursive --verbose "${PWD}"/etc / ;
        sudo cp --recursive --verbose "${PWD}"/usr / ;
    fi
}

#OK
function install-dotfiles_() {
    rm --force --recursive "${HOME}"/.dotfiles ;
    git clone https://github.com/gnsbriel/.dotfiles.git "${HOME}"/.dotfiles ;
    if [ "${1}" == "--wsl" ]; then
        (
            cd "${HOME}"/.dotfiles || exit 1 ;
            bash install.sh --wsl ;
        )
    elif [ "${1}" == "--arch" ] ; then
        (
            cd "${HOME}"/.dotfiles || exit 1 ;
            bash install.sh --arch ;
        )
    fi
}

#OK
function setup-Wallpapers_() {
    git clone https://gitlab.com/dwt1/wallpapers.git "${HOME}"/Media/Wallpapers
}

#OK
function enable-services_() {
    sudo systemctl enable ufw.service          ; # Enable firewall Service;
    sudo systemctl enable ly.service           ; # Enable Ly Service;
    sudo systemctl disable getty@tty2.service  ; # Disable getty on Ly's tty to prevent "login" from spawning on top of it
    sudo systemctl enable numlock.service      ; # Enable Numlock Service;
    sudo ufw enable                            ; # Enable firewall.
}

#OK
function install-wsl-packages_() {
    install-packages_ --wsl;
    install-others_ ;
    install-fonts_ ;
    install-config-files_ --wsl ;
    install-dotfiles_ --wsl ;
    check-installed-packages_ --wsl;
}

#OK
function install-arch-packages_() {
    install-packages_ --arch;
    install-others_ ;
    install-fonts_ ;
    install-others-packages_ ;
    install-config-files_ --arch ;
    enable-services_ ;
    install-dotfiles_ --arch ;
    setup-Wallpapers_
    check-installed-packages_ --arch;
}

#Section: "selection_"

#OK
function selection_() {
    clear ;
    printf "\n%b[1]%b: Configure arch linux..\n" "${yellow}" "${reset}" ;
    printf "%b[2]%b: Install packages for arch linux..\n" "${yellow}" "${reset}" ;
    printf "%b[3]%b: Check if packages for arch linux are installed..\n" "${yellow}" "${reset}" ;
    printf "%b[4]%b: Configure wsl..\n" "${yellow}" "${reset}" ;
    printf "%b[5]%b: Install packages for wsl..\n" "${yellow}" "${reset}" ;
    printf "%b[6]%b: Check if packages for wsl are installed..\n" "${yellow}" "${reset}" ;
    printf "%b[7]%b: Quit\n" "${yellow}" "${reset}" ;
    while true; do
        read -r -p "$(printf "\n%binstall.sh - Choose an option:%b " "${cyan}" "${yellow}")" option ; printf "%b" "${reset}" ;
        case "${option}" in
            [1]* )
                # CONFIG ARCH SYS
                timer "$(printf "%bWarning: You chose to configure Arch Linux..\n%bMake sure you're in 'arch-chroot'...%b" "${yellow}" "${blue}" "${reset}")" ;\
                config-arch-sys_ ; printf "\n%bOperation \"--config-sys\" Completed !%b\n" "${green}" "${reset}" >&1 ; exit 1 ;;
            [2]* )
                # INSTALL ARCH PACKAGES
                timer "$(printf "%bWarning: You chose to install packages for Arch Linux..\n%bMake sure you're not in 'arch-chroot'...%b" "${yellow}" "${blue}" "${reset}")" ;
                install-arch-packages_ ; printf "\n%bOperation \"--install-packages\" Completed !%b\n" "${green}" "${reset}" >&1 ; exit 1 ;;
            [3]* )
                # CHECK IF ARCH PACKAGES ARE INSTALLED
                timer "$(printf "%bWarning: You chose to check if packages for arch linux are installed..\n%bMake sure you're not in 'arch-chroot'...%b" "${yellow}" "${blue}" "${reset}")" ;
                check-installed-packages_ "--arch" ; printf "\n%bOperation \"--check-packages\" Completed !%b\n" "${green}" "${reset}" >&1 ; exit 1 ;;
            [4]* )
                # CONFIG WSL SYS
                permit="sudo";
                timer "$(printf "%bWarning: You chose to configure WSL..\n%bMake sure you're in a Windows Subsystem for Linux...%b" "${yellow}" "${blue}" "${reset}")" ;
                config-wsl-sys_ ; printf "\n%bOperation \"--config-sys\" Completed !%b\n" "${green}" "${reset}" >&1 ; exit 1 ;;
            [5]* )
                # INSTALL WSL PACKAGES
                permit="sudo";
                timer "$(printf "%bWarning: You chose to install packages for WSL..\n%bMake sure you're in a Windows Subsystem for Linux...%b" "${yellow}" "${blue}" "${reset}")" ;
                install-wsl-packages_ ; printf "\n%bOperation \"--install-packages\" Completed !%b\n" "${green}" "${reset}" >&1 ; exit 1 ;;
            [6]* )
                # CHECK IF WSL PACKAGES ARE INSTALLED
                permit="sudo";
                timer "$(printf "%bWarning: You chose to check if packages for wsl are installed..\n%bMake sure you're in a Windows Subsystem for Linux...%b" "${yellow}" "${blue}" "${reset}")" ;
                check-installed-packages_ "--wsl" ; printf "\n%bOperation \"--check-packages\" Completed !%b\n" "${green}" "${reset}" >&1 ; exit 1 ;;
            [7Qq]* )
                clear ; printf "\n%bQuit%b\n" "${green}" "${reset}" >&1 ; sleep 1; exit 1 ;;
            * ) selection_ ; break ;;
        esac
    done
}

#Section: "Parameters"

#OK
# Use Selection Menu
if [ "${sys}" == "" ] && [ "${operation}" == "" ]; then
    selection_ ;
# CONFIG WSL SYS
elif [ "${sys}" == "--wsl" ] && [ "${operation}" == "--config-sys" ]; then
    timer "$(printf "%bWarning: You chose to configure WSL..\n%bMake sure you're in a Windows Subsystem for Linux...%b" "${yellow}" "${blue}" "${reset}")" ;
    config-wsl-sys_ ; printf "\n%bOperation \"%s\" Completed !%b\n" "${green}" "${operation}" "${reset}" >&1 ; exit 1 ;
# CONFIG ARCH SYS
elif [ "${sys}" == "--arch" ] && [ "${operation}" == "--config-sys" ]; then
    timer "$(printf "%bWarning: You chose to configure Arch Linux..\n%bMake sure you're in 'arch-chroot'...%b" "${yellow}" "${blue}" "${reset}")" ;\
    config-arch-sys_ ; printf "\n%bOperation \"%s\" Completed !%b\n" "${green}" "${operation}" "${reset}" >&1 ; exit 1 ;
# INSTALL WSL PACKAGES
elif [ "${sys}" == "--wsl" ] && [ "${operation}" == "--install-packages" ]; then
    timer "$(printf "%bWarning: You chose to install packages for WSL..\n%bMake sure you're in a Windows Subsystem for Linux...%b" "${yellow}" "${blue}" "${reset}")" ;
    install-wsl-packages_ ; printf "\n%bOperation \"%s\" Completed !%b\n" "${green}" "${operation}" "${reset}" >&1 ; exit 1 ;
# INSTALL ARCH PACKAGES
elif [ "${sys}" == "--arch" ] && [ "${operation}" == "--install-packages" ]; then
    timer "$(printf "%bWarning: You chose to install packages for Arch Linux..\n%bMake sure you're not in 'arch-chroot'...%b" "${yellow}" "${blue}" "${reset}")" ;
    install-arch-packages_ ; printf "\n%bOperation \"%s\" Completed !%b\n" "${green}" "${operation}" "${reset}" >&1 ; exit 1 ;
# CHECK IF WSL PACKAGES ARE INSTALLED
elif [ "${sys}" == "--wsl" ] && [ "${operation}" == "--check-packages" ]; then
    timer "$(printf "%bWarning: You chose to check if packages for wsl are installed..\n%bMake sure you're in a Windows Subsystem for Linux...%b" "${yellow}" "${blue}" "${reset}")" ;
    check-installed-packages_ "${sys}" ; printf "\n%bOperation \"%s\" Completed !%b\n" "${green}" "${operation}" "${reset}" >&1 ; exit 1 ;
# CHECK IF ARCH PACKAGES ARE INSTALLED
elif [ "${sys}" == "--arch" ] && [ "${operation}" == "--check-packages" ]; then
    timer "$(printf "%bWarning: You chose to check if packages for arch linux are installed..\n%bMake sure you're not in 'arch-chroot'...%b" "${yellow}" "${blue}" "${reset}")" ;
    check-installed-packages_ "${sys}" ; printf "\n%bOperation \"%s\" Completed !%b\n" "${green}" "${operation}" "${reset}" >&1 ; exit 1 ;
else
    printf "%bWARNING: you must choose an argument from the list !%b\n" "${red}" "${reset}" 1>&2 ;
    printf "\n%b    install.sh -- Shell Script for configuring Arch Linux or WSL.%b\n" "${light_gray}" "${reset}" ;
    printf "\n%bSynopsis%b\n" "${light_gray}" "${reset}" ;
    printf "\n%b    ./install.sh { --arch --config-sys } # Config Arch Linux.%b\n" "${light_gray}" "${reset}" ;
    printf "\n%b    ./install.sh { --arch --install-packages } # Install arch linux packages.%b\n" "${light_gray}" "${reset}" ;
    printf "\n%b    ./install.sh { --arch --check-packages } # Check if arch linux packages from the list are installed.%b\n" "${light_gray}" "${reset}" ;
    printf "\n%b    ./install.sh { --wsl --config-sys } # Config wsl.%b\n" "${light_gray}" "${reset}" ;
    printf "\n%b    ./install.sh { --wsl --install-packages } # Install wsl packages.%b\n" "${light_gray}" "${reset}" ;
    printf "\n%b    ./install.sh { --wsl --check-packages } # Check if wsl packages from the list are installed.%b\n" "${light_gray}" "${reset}" ;
    printf "\n%b    ./install.sh { } # Use none to use the selection.%b\n" "${light_gray}" "${reset}" ;
    exit 2 ;
fi
