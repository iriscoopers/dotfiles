### Notes

* Get the dotfiles by `git clone git@github.com:irisbune/dotfiles.git`
* Add symlinks to your home folder: `$ ln -s ~/dotfiles/.* ~ && ln -s dotfiles/git_template .git_template`
* Rename the global gitignore file: `mv ~/dotfiles/gitignore_global ~/.gitignore

#### Terminal
* Install [iterm](https://www.iterm2.com/) manually. Import json profile.
* Install [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

#### Homebrew
* Install [Homebrew](https://brew.sh/.) manually
* Run either or both:
  * `xargs brew install < dotfiles/ruby.txt`
  * `xargs brew install < dotfiles/kotlin.txt`

#### Ruby and Bundler

`rbenv` is already automatically loaded in `.zshrc` via `eval "$(rbenv init -)`

```
$ rbenv install <ruby version>
$ rbenv local <ruby version>
$ gem install bundler
$ bundle
```

#### Gradle and Kotlin

* Check java's version (see [instructions](https://gradle.org/install/))
* `brew install gradle`

#### Vim and Tmux

* Install Vim's plugin manager, [Vundle](https://github.com/VundleVim/Vundle.vim): `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
* Run `:PluginInstall` in Vim
* Install [Powerline fonts](https://github.com/powerline/fonts) `git clone https://github.com/powerline/fonts.git --depth=1`
* Vim uses [FZF](https://github.com/junegunn/fzf) and [Ripgrep](https://github.com/BurntSushi/ripgrep)

#### Ctags

* Inside a repo, run `git ctags` and `git init` to use re-index [Universal Ctags](https://github.com/universal-ctags/ctags)
  [via git hooks](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)

#### Git
* Set global `.git_ignore`: `git config --global core.excludesfile ~/.gitignore`
