# JAB - Juusos Arch Bootsrapper

## Preface

Nothing too special. Just another install/bootstrap script for Arch. It's going
to change according to my likings any given time.

I'm going to have trhee section down below. First an simple install guide
followed by a copy-pasta script dump and then an explanation for the scripts.

### Disclaimer

I've done this for mainly my own use so if you follow along and something goes sideways
you'll have to balme yourself.

## Install guide

Boot into the live environment and start installing

### Initial setup

Just some basic stuff we need to get out of the way before we start

#### Load in your keyboard layout

```sh
loadkeys fi
```

#### Check for internet connection with a ping

```sh
ping archlinux.org
```

No response?
If you're on wifi then follow the [wifi instructions](#copy-pasta-installation)
Not on wifi? You be f*cked son.

#### Make sure system clock is in sync

```sh
timedatectl set-ntp true
```

#### Check for EFI

Check whether you're running a legacy BIOS or EFI.

```sh
# Running this will tell you if you're running EFI or not
(ls /sys/firmware/efi/efivars 1>/dev/null 2>&1 && echo Running EFI) ||
echo Running legacy BIOS
```

```sh
# This will print out the conents of /sys/firmware/efi/efivars
# If the output is not an error, you're running EFI
ls /sys/firmware/efi/efivars
```

### Partitioning

#### Find the disk you want to use

First we need to identify the disk we want to use. I'll use `sda` as the exmple drive.

```sh
lsblk

# output
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:16   0 100.0G  0 disk
└─sda1        8:17   0 50.0G  0 part
└─sda2        8:17   0 50.0G  0 part
nvme0n1     259:0    0 232.9G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot
├─nvme0n1p2 259:2    0  32.4G  0 part [SWAP]
├─nvme0n1p3 259:3    0    30G  0 part /
└─nvme0n1p4 259:4    0   170G  0 part /home
```

#### Partition table types and choosing a schema

I've listed most some of the more common partitioning schemas for EFI and
BIOS systems.

#### Partitioning schemas

##### Basic EFI partiton

| Partition | Mount point | Partition type | File system |
|-----------|-------------|----------------|-------------|
| /dev/sda1 | /mnt/boot   | EFI            | FAT32       |
| /dev/sda2 | /mnt        | Linux          | EXT4        |

##### EFI system with swap, no home part

| Partition | Mount point | Partition type | File system |
|-----------|-------------|----------------|-------------|
| /dev/sda1 | /mnt/boot   | EFI            | FAT32       |
| /dev/sda2 | /mnt        | Linux          | EXT4        |
| /dev/sda3 | -           | Swap           | Swap        |

##### EFI system with swap and home part

| Partition | Mount point | Partition type | File system |
|-----------|-------------|----------------|-------------|
| /dev/sda1 | /mnt/boot   | EFI            | FAT32       |
| /dev/sda2 | /mnt        | Linux          | EXT4        |
| /dev/sda3 | /mnt/home   | Linux          | EXT4        |
| /dev/sda4 | -           | Swap           | Swap        |

##### BIOS with MBR and swap

| Partition | Mount point | Partition type | File system |
|-----------|-------------|----------------|-------------|
| /dev/sda1 | /           | Linux$^1$      | EXT4        |
| /dev/sda3 | -           | Swap           | SWAP        |

  1. This needs to be marked as bootable with the partition tool of your choice.

##### BIOS with GPT and swap

| Partition | Mount point | Partition type | File system |
|-----------|-------------|----------------|-------------|
| /dev/sda1 | -           | BIOS boot      |             |
| /dev/sda3 | /           | Linux          | EXT4        |
| /dev/sda4 | -           | Swap           | SWAP        |

#### Creating the partitions

You can use [`fdisk`](#using-fdisk), [`cfdisk`](#using-cfdisk)
or [`sfdisk`](#using-sfdisk) on the default Arch installation medium to create
the partitions. Consult the tables above if you're unsure how you should
partition your drive. I'll use an imagenary 100GB `/dev/sda` as an exmple drive
and create three partitions for it. One for `/boot` one for `root` (or `/`) and
one for `swap`.

If you use a brand spanking new hard drive you might be prompted to pick
a partition table for the disk. If so just pick

- `GPT` if you're running an `UEFI` system
- `MBR/DOS/MSDOS` with a `BIOS` system.

 __These will affect the partition type values!__

|     | EFI system | Linux filesystem | Linux Swap | BIOS boot |
|-----|------------|------------------|------------|-----------|
| GPT | 1          | 20               | 19         | 4         |
| MBR | -          | 83               | 82         | -         |

##### Using `fdisk`

Run `fdisk  /dev/sda` to select the drive for partitioning. You can press
`m` for help to read up on what you can do or you can just read the most relevant
commands here:

- `d` to delete existing partition
- `n` to add a new partition
- `t` switch partition type
- `w` to write the partition table

`cfdisk` is a `curses` based program that has similiar inputs to `fdisk` so you
should be able to apply this example to that as well.

Bear in mind that `MBR` and `GPT` disks have slightly different inputs but the
general gist is the same.

Example of `fdisk` commands.

```sh
# select the disk to partition
fdisk /dev/sda
# delete old partitions
Command (m for help): d <cr>
Partition number (1-n, default n): <cr>

# Create new partition
# Use defaults for the first two prompts, but in the third one you should define
# the size unless you want to allocate rest of the disk to that partition
# Here we create 512M partition
# Once the partition has been created. Switch the type if needed. Consult the tables.
Command (m for help): n <cr>
Partition number (n-128, default n): <cr>
First sector (yyyyyyyy-xxxxxxxx, default yyyyyyyy): <cr>
Last sector, +/-sectors or +/-size{K,M,G,T,P} (yyyyyyyy-xxxxxxxx): +512M <cr>
Created a new patition n of type 'Linux filesystem'
# After the partition has been created you might have to switch the partition type
Command (m for help): t <cr>
Partition number (1-n, default n): <cr>
# This is supposed to be the EFI partition of a GPT system
Partition type (type L to list all types): 1<cr>

# Last but not least you need to write the changes
Command (m for help): w<cr>
```

If you're installing a `BIOS` system with `MBR` table you'll also need to mark
the root partition bootable.

```sh
#in fdisk
Command (m for help): a <cr>
Partition number (1-n, default n): 1<cr>
```

##### Using `sfdisk`

In my opinion `sfdisk` is the simplest to use. When you know what you're doing.
This is also the program used with the installer script.

Perhaps the easiest and cleanest way of using `sfdisk` is to use heredoc
and lay out the whole partition table you wish to create.

Here we add a new `GPT` partition talbe to `/dev/sda` create three partitions:

- 512M EFI boot partition type EFI
- 10G Swap partition type Linux Swap
- 89.5G root partition type Linux filesystem

 `sfdisk` inputs are:

- start
  - Start sector, not interesting in this case
- size
  - The same as with `fdisk` but no need to supply the +
- type
  - Can be supplied as a single letter and `sfdisk` will convert it
  to a regocnisable value for the partition table
    - L = Linux filesystem
    - S = Linux Swap
    - U = EFI system
- bootable
  - `*` === true
  - `-` === false (default)

 So arguments `,3G,19`
 would mean:
 Start from the first free sector
 Mark the next 3G to be a new partition of type S (swap)

```sh
sfdisk /dev/sda -X gpt<<EOF
# 512M EFI boot partition
,512M,U
# 10G Swap partition
,10G,S
# Rest of the disk for root partition
,,L
EOF
```

```sh
lsblk
sda         259:0    0   100G  0 disk
├─/dev/sda1 259:1    0   512M  0
├─/dev/sda2 259:2    0    10G  0
├─/dev/sda3 259:3    0  89.5G  0
```

#### Adding filesystems to the partitions

I'll use the partitions created in the `sfdisk` example.

```sh
# Create a fat32 filesystem for the boot partition
mkfs.fat -F32 /dev/sda1
# ext4 goodness
mkfs.ext4 /dev/sda3
# swapity swap
mkswap /dev/sda2
swapon /dev/sda2
```

### Mount the drives

```sh
mount /dev/sda3 /mnt
# create mount point for the boot folder/efi
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

### Set pacman mirrors
You can use your favourite text editor to move the mirrors physically closest to
you at the top the file at `/etc/pacman.d/mirrorlist` or you can use this little
snippet to move certain lines to the top

```sh
# Finland is the closest to me so I'll use that
MATCH=Finland
LIST=/etc/pacman.d/mirrorlist
(grep $MATCH $LIST -A1; grep -v $MATCH $LIST)> /temp/list
cp /tmp/list $LIST
```

##### TODO: Creating variables for partitions (for scripts)
