ln -sf /usr/share/zoneinfo/$jab_tz
hwclock --systohc

# locale-gen call is missing
echo $jab_locale >> /etc/locale.gen
locale-gen

echo "KEYMAP=$jab_keyboard" > /etc/vconsole.conf
echo "LANG=$jab_locale" > /etc/locale.conf
echo $jab_hostname > /etc/hostname
cat <<-EOF > /etc/hosts
127.0.0.1   localhost
::1   localhost
127.0.1.1   $jab_hostname.localdomain $jab_hostname
EOF
mkinitcpio -P
groups="wheel,libvirt,kvm,docker"

useradd --create-home -G $groups -s /bin/$jab_shell $jab_username

echo "root:$jab_password" | chpasswd
echo "$jab_username:$jab_password" | chpasswd

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=JAB-GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable docker NetworkManager

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
