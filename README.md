# My Dotfiles

This directory contains my dotfiles for Linux and macOS.

## Requirements

Ensure you have the following tools installed in your system:

### Git 

```
apt-get install git 
```

### Stow

```
apt-get install stow
```

## Installation

Make sure that you clone this repo in your $HOME directory.

```
git clone https://github.com/maenard/dotfiles.git
cd dotfiles
```

Use stow to create a symlink in your $HOME directory.

```
stow .
```
