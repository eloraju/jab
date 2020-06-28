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
(ls /sys/firmware/efi/efivars 1>/dev/null 2>&1 && echo Running EFI) || echo Running legacy BIOS
```

```sh
# This will print out the conents of /sys/firmware/efi/efivars
# If the output is not an error, you're running EFI
ls /sys/firmware/efi/efivars
```

### Partitioning

#### Disk preparation

##### Find the disk you want to use

First we need to identify the disk we want to use. I'll use `sda` as the exmple drive.

```sh
lsblk

# output
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:16   0 111.8G  0 disk
└─sda1        8:17   0 111.8G  0 part
sdb           8:0    0   3.7T  0 disk
├─sdb1        8:1    0    16M  0 part
└─sdb2        8:2    0   3.7T  0 part
sdc           8:32   0 232.9G  0 disk
└─sdc1        8:33   0 232.9G  0 part
nvme0n1     259:0    0 232.9G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot
├─nvme0n1p2 259:2    0  32.4G  0 part [SWAP]
├─nvme0n1p3 259:3    0    30G  0 part /
└─nvme0n1p4 259:4    0   170G  0 part /home
```

##### EFI Partition schemas

Three most common partition schemas listed below. I usually go with just a swap
and no home part.

###### Basic EFI partiton

| Partition | Mount point | Partition type | File system | Size   |
|-----------|-------------|----------------|-------------|--------|
| /dev/sda1 | /mnt/boot   | EFI            | FAT32       | ~512mb |
| /dev/sda2 | /mnt        | Linux          | EXT4        |        |

###### EFI system with swap, no home part

| Partition | Mount point | Partition type | File system | Size   |
|-----------|-------------|----------------|-------------|--------|
| /dev/sda1 | /mnt/boot   | EFI            | FAT32       | ~512mb |
| /dev/sda2 | /mnt        | Linux          | EXT4        |        |
| /dev/sda3 | -           | Swap           | Swap        |        |

###### EFI system with swap and home part

| Partition | Mount point | Partition type | File system | Size    |
|-----------|-------------|----------------|-------------|---------|
| /dev/sda1 | /mnt/boot   | EFI            | FAT32       | ~ 512mb |
| /dev/sda2 | /mnt        | Linux          | EXT4        |         |
| /dev/sda3 | /mnt/home   | Linux          | EXT4        |         |
| /dev/sda4 | -           | Swap           | Swap        |         |

#### Creating the partitions

You can use `fdisk`, `cfdisk` or `parted` on the defailt Arch installation medium
to create the partitions. Consult the tables above.

##### TODO: Creating variables for partitions (for scripts)

##### Using `sfdisk`

```sh

# <start>, <size>, <type>, <bootable>
# Types:
# 82 = Linux Swap
# 83 = Linux
# ef = EFI System

sfdisk $SELECTED_DISK <<EOF
# 512M EFI boot partition
,512M, ef
# 3G Swap partition
,3G, 82
# Rest of the disk for root partition
,, 83
EOF
```

Here we create three partitions for disk `/dev/sda`:

- 512M EFI boot partition
- 3G Swap partition
- 6.5G root partition

```sh
sda         259:0    0    10G  0 disk
├─/dev/sda1 259:1    0   512M  0
├─/dev/sda2 259:2    0     3G  0
├─/dev/sda3 259:3    0   6.5G  0
```
