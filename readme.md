# 🤜 JAB 🤛 - Juusos Arch Bootsrapper

A simple Arch linux install script

## Check the scripts!

First and foremost. **Check the scripts**. It's bad practice to trust
strangers on the internet and just run their code on your machine.

Done checking? Good :)

### Current state

If you run the script right now it will install Arch with
the latest kernel, paru as the aur helper and all the software
listed in the `pkgs` file. It will NOT however have a working X session.
This is because I forgot to to add a step to check and install gpu drivers.
That is next up on the todo.

### Usage

Nab a fresh Arch linux iso from [the download page](https://archlinux.org/download/),
boot it up and run `sh < <(curl https://jab.eloraju.xyz)`. This will run the `init`
script. Then make changes in the `jab.conf` and `jab.pkgs` files according to your
likings. Once you're satisfied run `sh jab.sh`. Then just wait for the installation
to finish.

### TODO

- Detect video card and download appropriate drivers
- Find more bugs...

### License

[MIT](https://gitlab.com/eloraju/jab/-/blob/master/LICENSE)
