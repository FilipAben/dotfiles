## general

- generate ssh key & put in flab server and github.
- install zsh (apt)
- install oh-my-zsh (from url in repo)
- install git

```bash
git config --global user.email "filip@aben.be"
git config --global user.name "Filip Aben"

```

- `ln -s dotfiles/zshrc-linux .zshrc`
- install fd from binary releases repo (do not use i686 but x86_64), extract & move to ~/bin + symlink

## neovim

- clone dotfiles repo
- Install neovim from binary release, extract in ~/bin and put nvim, vim symlinks in ~/bin to executable
- symlink config from ~/dotfiles
- Download fzf binary release, extract and put in ~/bin
- install `gh` tool (apt) and make it log into github

## xremap

- download xremap binary release and put in ~/bin
- add user to input and fix udev for xremap

    ```sh
    sudo gpasswd -a filip input
    echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules
    ```
- Install xremap service

```bash
mkdir -p .config/systemd/user
cp ~/dotfiles/xremap.service ~/.config/systemd/user/
cp ~/dotfiles/xremap.desktop ~/.config/autostart/
```
## shortcuts config

- In keyboard app, clear most shortcuts involving `super`
- Set 'Cycle through open windows' to Super+Tab
- In the menubar panel configuration (alt-click on menu icon) remove the `super` shortcuts
- In `system settings`, go to Applets -> Grouped window list and disable hotkey toggle for super+<number> keybinding

## install tig

- download source from github repo

```bash
sudo apt install ncurses-dev
make
make install
```
installs in ~/bin


