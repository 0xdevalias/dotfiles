# devalias does dotfiles

(Originally forked from [holman/dotfiles](https://github.com/holman/dotfiles.git))

Your dotfiles are how you personalize your system. These are mine.

I was a little tired of having long alias files and everything strewn about
(which is extremely common on other dotfiles projects, too). That led to this
project being much more topic-centric. I realized I could split a lot of things
up into the main areas I used (Ruby, git, system libraries, and so on), so I
structured the project accordingly.

If you're interested in the philosophy behind why projects like these are
awesome, you might want to [read my post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## Topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## What's inside?

A lot of stuff. Seriously, a lot of stuff. Check them out in the file browser
above and see what components may mesh up with you.
[Fork it](https://github.com/holman/dotfiles/fork), remove what you don't
use, and build on what you do use.

## Components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **Brewfile**: This is a list of applications for [Homebrew Cask](http://caskroom.io) to install: things like Chrome and 1Password and Adium and stuff. Might want to edit this file before running any initial setup.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.
- **topic/\*.anti** files will be bundled during antigen startup

## What about my environment vars?

- Stash your environment variables in `~/.localrc`. This means they'll stay out of your main dotfiles repository (which may be public, like this one), but you'll have access to them in your scripts.

## Install

Run this:

```sh
git clone https://github.com/holman/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

Then you may want to run `~/.dotfiles/script/install`, or manually run appropriate install scripts, I tend to like to start with:

```
# Check latest python/ruby/node versions + update appropriate vars, then run these
~/.dotfiles/ruby/install.sh
~/.dotfiles/python/install.sh
~/.dotfiles/node/install.sh
```

You might want to setup GPG commit signing for git.. this isn't automated yet..

* https://github.com/pstadler/keybase-gpg-github
* https://confluence.atlassian.com/sourcetreekb/setup-gpg-to-sign-commits-within-sourcetree-765397791.html
* https://community.atlassian.com/t5/Sourcetree-questions/Why-is-quot-Enable-GPG-key-signing-for-commit-quot-is-greyed-out/qaq-p/249852

## Improvements

* Could see what is done in https://github.com/thoughtbot/laptop
* Ability to install 'feature sets' (eg. dev machine)
* Checkout asdf instead of rbenv/etc?
	* https://github.com/asdf-vm/asdf
	* https://github.com/asdf-vm/asdf-ruby
	* https://github.com/asdf-vm/asdf-nodejs
	* https://github.com/danhper/asdf-python
* https://github.com/tj/n ?

## Bugs

I want this to work for everyone; that means when you clone it down it should
work for you even though you may not have `rbenv` installed, for example. That
said, I do use this as *my* dotfiles, so there's a good chance I may break
something if I forget to make a check for a dependency.

If you're brand-new to the project and run into any blockers, please
[open an issue](https://github.com/0xdevalias/dotfiles/issues) on this repository
and I'd love to get it fixed for you!

## Thanks

I forked [Ryan Bates](http://github.com/ryanb)' excellent
[dotfiles](http://github.com/ryanb/dotfiles) for a couple years before the
weight of my changes and tweaks inspired me to finally roll my own. But Ryan's
dotfiles were an easy way to get into bash customization, and then to jump ship
to zsh a bit later. A decent amount of the code in these dotfiles stem or are
inspired from Ryan's original project.
