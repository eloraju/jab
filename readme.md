# JAB - Juusos Arch Bootsrapper

## Preface

Nothing too special. Just another install/bootstrap script for arch. It's going
to change according to my likings any given time.

I'm going to have two section down below. First a section for a copy-paste
install guide and then an explanation for the scripts.

**DISCLAIMER**

I've done this for mainly my own use so if you follow along and something goes sideways
you'll have to balme yourself.

## Copy-pasta installation

Boot into the live environment and start installing

**Load in your keyboard layout**

```shell
loadkeys fi
```

**Check for internet connection with a ping**

```shell
ping archlinux.org
```

No response?
If you're on wifi then follow the [wifi instructions](#copy-pasta-installation)
Not on wifi? You be f*cked son.

**Make sure system clock is in sync**

```shell
timedatectl set-ntp true
```


