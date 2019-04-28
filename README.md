**NOTE: This is early stage software.  You are encouraged to try it, adapt it to
your needs and contribute back to the project.**

# About

Setting up Dragon, [NatLink](https://qh.antenna.nl/unimacro/),
[Dragonfly](https://github.com/dictation-toolbox/dragonfly) and
[Aenea](https://github.com/dictation-toolbox/aenea) is a non-trivial process
and can be time-consuming and error-prone.

This project tries to address this by:
- Automating as many aspects of the process as possible
- Employing version pinning whenever possible

The setup is based on:

- Vagrant / VirtualBox
- Windows 10
- Dragon Professional Individual 14 (contributions to support other versions are welcome)
- NatLink
- Dragonfly
- Aenea

# Getting started

1. Follow the instructions under ["Prepare your
   system"](https://github.com/sol/aenea-box#prepare-your-system).

1. Copy `ansible/config.yml.example` to `ansible/config.yml` and adjust it as
   needed.

1. Place your Dragon installer into `windows/dragon/`.

1. Dragon user profiles are stored in `dragon-profiles/`.  If you have an
   existing user profile that you want to use then place it into this
   directory.

1. Install Ansible with:
   ```
   poetry install
   ```

1. Create the VM and start Aenea with:
   ```
   make start_x11
   ```

Before you do any of this make sure that you read the `Makefile`,
`ansible/bootstrap.yaml` and `ansible/playbook.yaml` so that you have an
overview of what steps are involved.

Other make targets that can be useful during development or debugging are:

```
make start_x11    # create the VM if needed and start the Aenea X11 server process

make create       # bootstrap, attach the USB mic, provision and isolate the VM

make bootstrap    # disable automatic Windows updates and enable auto logon

make provision    # install Python, Dragon, NatLink and dragonfly into the VM

make server_x11   # start the Aenea X11 server process

make isolate      # isolate the VM from internet access by removing the NAT interface

make destroy      # destroy the VM
```

# Using the setup

Running `C:\vagrant\windows\scripts\dragon-admin.bat` allows you to disable
things like "updates at startup", "Accuracy Tuning" and "Data Collection"
globally.  I don't know of a way to automate this; contributions are welcome!

To test the setup say "test hello world remote grammar" as described in the
[Aenea README](https://github.com/dictation-toolbox/aenea#readme).

Delete `grammars/_hello_world_*` and place your own grammars into `grammars/`.

NOTE: You will see a "Microsoft Visual C++ Runtime Library" error (R6034) when
you start Dragon.  It's safe to ignore this error, just click "OK".  One way to
fix this may be to swith to Windows 7 x86, e.g. from
https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/.

# Prepare your system

The instructions given here are for Ubuntu 18.04 LTS.

## Aenea dependencies

```
sudo apt install xdotool
```

## Install VirtualBox 6.0.6

```
wget https://download.virtualbox.org/virtualbox/6.0.6/virtualbox-6.0_6.0.6-130049~Ubuntu~bionic_amd64.deb
sudo apt install ./virtualbox-6.0_6.0.6-130049~Ubuntu~bionic_amd64.deb

wget https://download.virtualbox.org/virtualbox/6.0.6/Oracle_VM_VirtualBox_Extension_Pack-6.0.6.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.0.6.vbox-extpack
```

If you experience issues with audio or USB devices inside the VM then you may
also need some or all of these:

```
sudo adduser $USER vboxusers
sudo adduser $USER pulse
sudo adduser $USER audio
```

(make sure to logout+login after)

## Install Vagrant 2.2.4

```
wget https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.deb
sudo apt install ./vagrant_2.2.4_x86_64.deb
```

## Install Poetry

```
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
```

## Create a Windows 10 VirtualBox base image

```
sudo apt install packer
git clone https://github.com/joefitzgerald/packer-windows
cd packer-windows
packer build -only=virtualbox-iso windows_10.json
vagrant box add aenea-base windows_10_virtualbox.box
```


# Contribute

You are encouraged to adapt the setup to your needs and contribute back to the
project.

Avoid adding new abstractions initially.  Produce a commit with the minimal set
of changes required for your setup and open a PR as early as possible.

## Add support for other versions of Dragon

The current setup assumes that you are using Dragon 14.  If you want to add
support for other versions of Dragon then the following commands can be useful:

```
# Run the Dragon installer with logging enabled:
msiexec /log dragon.log /i "Dragon 14.msi"

# Run the Dragon installer in unattended mode with custom options:
msiexec /qn /log dragon.log /i "Dragon 14.msi" SERIALNUMBER=XXXXX-XXX-XXXX-XXXX-XX

# Uninstall in unattended mode:
msiexec /x {FEAB6184-0560-4EBF-A26B-C3F2B11FE9E1} /q
```

1. The install log can provide hints on what custom options are supported by a
   particular `.msi` installer.
1. The GUID needed for uninstalling can be grep from the install log
   (`SourcedirProduct`).
