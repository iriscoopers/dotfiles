### Notes

* Clone the dotfiles
* Install [iterm](https://www.iterm2.com/) manually. Import json profile.
* `chmod u+x install.sh`
* Run `./install.sh`

#### Updating an existing machine

After pulling new commits, re-sync the symlinks:

```sh
./scripts/update.sh --dry-run   # show what would change
./scripts/update.sh             # apply
```

It creates symlinks that are missing, repoints ones aiming at the wrong file,
and removes obsolete ones left behind by files that were deleted from the repo.
Only symlinks that point back into this repo are ever removed, so anything else
in `$HOME` is left alone. A real file sitting where a symlink belongs is moved
aside to `<name>.bak` rather than deleted.

#### Vim

* Run `:PluginInstall` in Vim
* Vim uses [FZF](https://github.com/junegunn/fzf) and [Ripgrep](https://github.com/BurntSushi/ripgrep)

