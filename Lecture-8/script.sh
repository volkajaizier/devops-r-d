#!/bin/bash

# Function to detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then  #condition -f show if file exists
        . /etc/os-release            #this command load the environmental variables from /etc/release like $ID and $VERSION, we need only ID
        DISTRO=$ID
    else
        echo "Cannot detect distribution."
        exit 1
    fi
}

# Function to install packages based on distribution

install_packages() {
    local packages=("$@")  # $@ - all arguments that we will pass to the function 
                           # create a local array variable
    case "$DISTRO" in      # base on variable DISTRO value execute specific case
        ubuntu)
            echo "Detected $DISTRO"
            sudo apt-get update -y
            sudo apt-get install -y "${packages[@]}"
            ;;
        fedora)
            echo "Detected Fedora"
            sudo dnf update -y
            sudo dnf install -y "${packages[@]}"
            ;;
        centos)
            echo "Detected CentOS."
            sudo yum update -y
            sudo yum install -y "${packages[@]}"
            ;;
        *)
            echo "Don't know what to do with this distro : $DISTRO"
            exit 1
            ;;
    esac
}

install_base_packages() {
    local base_packages=("apache2" "mariadb-server" "firewalld" "docker") # define packages to install
    
    install_packages "${base_packages[@]}" # call the function install_packages and pass bass_packages array as an argument
}

# Main Script Execution
detect_distro

# Install base packages
echo "Installing base packages..."
install_base_packages

if [ "$#" -gt 0 ]; then   # $# - represent variable the number of arguments we can pass to script, gt0 - more than 0
    echo "Installing additional packages: $@"  # show in console what additional packages we are going to install
    install_packages "$@" # call function install_packages
fi