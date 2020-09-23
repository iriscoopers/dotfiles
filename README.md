### Notes

#### Iterm
* Install [iterm](https://www.iterm2.com/) manually. Import json profile
* Install [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

#### Homebrew, Ruby, Rbenv and Bundler
* Install [Homebrew](https://brew.sh/.) manually
* Install ruby and rbenv

```
$ brew install rbenv
$ rbenv init
$ echo 'eval "$(rbenv init -)"' >> ~/.zshrc
$ source ~/.zshrc
$ rbenv install 2.6.5
$ rbenv local 2.6.5
$ gem install bundler
$ bundle
```

#### Vim, Tmux and other tools
* Get the dotfiles by `git clone git@github.com:irisbune/dotfiles.git`
* Add symlinks to your home folder: `$ ln -s dotfiles/.* ~`
* `brew install vim, tmux, fzf, ripgrep, ctags`
* Run :PluginInstall in Vim
* Install [Powerline fonts](https://github.com/powerline/fonts) `git clone https://github.com/powerline/fonts.git --depth=1`
* Vim uses [FZF](https://github.com/junegunn/fzf) and [Ripgrep](https://github.com/BurntSushi/ripgrep)
* Run `git ctags` and `git init` to use re-index Excurant Ctags [via git hooks](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
