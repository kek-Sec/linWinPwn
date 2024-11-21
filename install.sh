#!/bin/bash
#
# Author: lefayjey
# GNU/Linux Distro and Rust detection: ReK2, Hispagatos
#

RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m'

scripts_dir="/opt/lwp-scripts"

# Detect Linux Distribution
if command -v apt-get >/dev/null; then
    PKG_MANAGER="apt-get"
    PACKAGES="python3 python3-dev python3-pip python3-venv nmap smbmap john libsasl2-dev libldap2-dev libkrb5-dev ntpdate wget zip unzip systemd-timesyncd pipx git swig curl jq openssl rlwrap"
elif command -v pacman >/dev/null; then
    PKG_MANAGER="pacman"
    PACKAGES="python python-pip python-virtualenv nmap smbmap john libsasl openldap krb5 ntp wget zip unzip systemd python-pipx git swig curl jq openssl"
else
    echo -e "${RED}[Error]${NC} Unsupported Linux distribution"
    exit 1
fi

install_tools() {
    if [[ "$PKG_MANAGER" == "apt-get" ]]; then
        echo -e "${BLUE}Installing tools using apt...${NC}"
        sudo apt-get update && sudo apt-get install -y "$PACKAGES"
    elif [[ "$PKG_MANAGER" == "pacman" ]]; then
        echo -e "${BLUE}Installing tools using pacman...${NC}"
        sudo pacman -Sy --needed --noconfirm "$PACKAGES"
    fi

    echo -e ""
    # Ensure `pipx` path is set up
    pipx ensurepath

    # Check if Rust is installed, and install if it's missing
    if ! command -v rustc >/dev/null; then
        echo -e "${BLUE}Rust not found, installing Rust...${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source ~/.cargo/env
        echo -e "${GREEN}Rust installed successfully.${NC}"
    else
        echo -e "${GREEN}Rust is already installed.${NC}"
    fi 

    echo -e ""
    echo -e "${BLUE}Installing python tools using pip and pipx...${NC}"
    # Install necessary Python tools using pipx
    pipx install git+https://github.com/dirkjanm/ldapdomaindump.git --force
    pipx install git+https://github.com/Pennyw0rth/NetExec.git --force
    pipx install git+https://github.com/fortra/impacket.git --force
    pipx install git+https://github.com/dirkjanm/adidnsdump.git --force
    pipx install git+https://github.com/zer1t0/certi.git --force
    pipx install git+https://github.com/ly4k/Certipy.git --force
    pipx install git+https://github.com/dirkjanm/Bloodhound.py --force
    pipx install "git+https://github.com/dirkjanm/BloodHound.py@bloodhound-ce" --force --suffix '_ce'
    pipx install git+https://github.com/franc-pentest/ldeep.git --force
    pipx install git+https://github.com/garrettfoster13/pre2k.git --force
    pipx install git+https://github.com/zblurx/certsync.git --force
    pipx install hekatomb --force
    pipx install git+https://github.com/blacklanternsecurity/MANSPIDER --force
    pipx install git+https://github.com/p0dalirius/Coercer --force
    pipx install git+https://github.com/CravateRouge/bloodyAD --force
    pipx install git+https://github.com/login-securite/DonPAPI --force
    pipx install git+https://github.com/p0dalirius/RDWAtool --force
    pipx install git+https://github.com/almandin/krbjack --force
    pipx install git+https://github.com/CompassSecurity/mssqlrelay.git --force
    pipx install git+https://github.com/CobblePot59/ADcheck.git --force
    pipx install git+https://github.com/ajm4n/adPEAS --force
    pipx install git+https://github.com/oppsec/breads.git --force
    pipx install git+https://github.com/p0dalirius/smbclient-ng --force
    pipx install 'git+https://github.com/ScorpionesLabs/MSSqlPwner.git' --force

    echo -e ""
    echo -e "${BLUE}Downloading tools and scripts using wget and unzipping...${NC}"
    sudo mkdir -p ${scripts_dir}
    sudo mkdir -p ${scripts_dir}/ldapper
    sudo mkdir -p ${scripts_dir}/Responder
    sudo chown -R "$(whoami)":"$(whoami)" ${scripts_dir}
    python3 -m venv "${scripts_dir}/.venv"
    source "${scripts_dir}/.venv/bin/activate"
    pip3 install PyYAML alive-progress xlsxwriter sectools typer colorama impacket tabulate arc4 msldap pandas requests requests_ntlm requests_toolbelt cmd2 pycryptodome --upgrade
    deactivate

    # Additional download and setup commands (omitted here for brevity)
}

install_tools
