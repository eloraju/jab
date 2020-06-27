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

**Create partitions**

Here Be some exmpales on how to partition and mount your drives. The values are nothing more than guidelines.
The commands are after the tables. Remember that you can't mount `/mnt/boot` beore you've mounted
`/mnt` (:

<table>
<tr>
<th colspan=5 style="text-align: center;background: #cccccc">Basic EFI system</th>
</tr>
<tr>
<th>Mount point</th>
<th>Partition</th>
<th>Partition type</th>
<th>File system type</th>
<th>Size</th>
</tr>
<tr>
<td>/mnt/boot</td>
<td>/dev/sda1</td>
<td>EFI</td>
<td>FAT32</td>
<td>~ 512mb</td>
</tr>
<tr>
<td>/mnt</td>
<td>/dev/sda2</td>
<td>Linux</td>
<td>ext4</td>
<td>~> 30Gb</td>
</tr>
</table>

<table>
<tr>
<th colspan=5 style="text-align: center;background: #cccccc">EFI System with swap, no home part</th>
</tr>
<tr>
<th>Mount point</th>
<th>Partition</th>
<th>Partition type</th>
<th>File system type</th>
<th>Size</th>
</tr>
<tr>
<td>/mnt/boot</td>
<td>/dev/sda1</td>
<td>EFI</td>
<td>FAT32</td>
<td>~ 512mb</td>
</tr>
<tr>
<td>/mnt</td>
<td>/dev/sda2</td>
<td>Linux</td>
<td>ext4</td>
<td>~> 30Gb</td>
</tr>
<tr>
<td>-</td>
<td>/dev/sda3</td>
<td>Swap</td>
<td>-</td>
<td>~> 1Gb</td>
</tr>
</table>

<table>
<tr>
<th colspan=5 style="text-align: center;background: #cccccc">EFI System with swap AND home</th>
</tr>
<tr>
<th>Mount point</th>
<th>Partition</th>
<th>Partition type</th>
<th>File system type</th>
<th>Size</th>
</tr>
<tr>
<td>/mnt/boot</td>
<td>/dev/sda1</td>
<td>EFI</td>
<td>FAT32</td>
<td>~ 512mb</td>
</tr>
<tr>
<td>/mnt</td>
<td>/dev/sda2</td>
<td>Linux</td>
<td>ext4</td>
<td>~< 30Gb</td>
</tr>
<tr>
<td>/mnt/home</td>
<td>/dev/sda3</td>
<td>Linux</td>
<td>ext4</td>
<td>~< 10Gb</td>
</tr>
<tr>
<td>-</td>
<td>/dev/sda4</td>
<td>Swap</td>
<td>-</td>
<td>~< 1Gb</td>
</tr>
</table
