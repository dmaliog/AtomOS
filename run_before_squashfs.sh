#!/usr/bin/env bash

# Сделано Фернандо "maroto"
# Выполняет любые действия в файловой системе перед тем, как будет создан "mksquashed"

script_path=$(readlink -f "${0%/*}")
work_dir="work"

arch_chroot() {
    arch-chroot "${script_path}/${work_dir}/x86_64/airootfs" /bin/bash -c "${1}"
}

run_in_chroot() {
    arch_chroot "$(cat << EOF
    
echo "##############################"
echo "# начало списка команд в chroot #"
echo "##############################"

cd "/root"

# Инициализация и заполнение ключей
sudo pacman-key --init
sudo pacman-key --populate archlinux endeavouros chaotic
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB

# Синхронизация репозиториев
sudo pacman -Syy

# Резервное копирование конфигураций bash из skel
mkdir -p "/root/filebackups/"
cp -af "/etc/skel/"{".bashrc",".bash_profile"} "/root/filebackups/"

# Установка skel для liveuser
pacman -U --noconfirm --overwrite "/etc/skel/.bash_profile","/etc/skel/.bashrc" -- "/root/atomicos-skel-liveuser/"*".pkg.tar.zst"

# Подготовка настроек для живой сессии
locale-gen
ln -sf "/usr/share/zoneinfo/UTC" "/etc/localtime"

# Установка прав и оболочки для root
usermod -s /usr/bin/bash root

# Создание пользователя liveuser
useradd -m -p "" -g 'liveuser' -G 'sys,rfkill,wheel,uucp,nopasswdlogin,adm,tty' -s /bin/bash liveuser
cp "/root/liveuser.png" "/var/lib/AccountsService/icons/liveuser"
rm "/root/liveuser.png"

# Удаление skel для liveuser
pacman -Rns --noconfirm -- "atomicos-skel-liveuser"
rm -rf "/root/atomicos-skel-liveuser"

# Настройка темы для root
cp -a "/root/root-theme" "/root/.config"
rm -R "/root/root-theme"

# Добавление даты сборки в motd
cat "/usr/lib/endeavouros-release" >> "/etc/motd"
echo "------------------" >> "/etc/motd"

# Установка пакетов на ISO
pacman -U --noconfirm --needed -- "/root/packages/"*".pkg.tar.zst"
rm -rf "/root/packages/"

# Включение сервисов systemd
systemctl set-default multi-user.target

# Установка обоев для живой сессии
mv "livewall.png" "/etc/calamares/files/livewall.png"
mv "/root/livewall.png" "/usr/share/endeavouros/backgrounds/livewall.png"
chmod 644 "/usr/share/endeavouros/backgrounds/"*".png"

# Восстановление конфигураций bash в /etc/skel для оффлайн установки
cp -af "/root/filebackups/"{".bashrc",".bash_profile"} "/etc/skel/"

# Перемещение черного списка nouveau из ISO
mv "/usr/lib/modprobe.d/nvidia-utils.conf" "/etc/calamares/files/nv-modprobe"
mv "/usr/lib/modules-load.d/nvidia-utils.conf" "/etc/calamares/files/nv-modules-load"

# Установка пакетов для оффлайн установок
mkdir -p "/usr/share/packages"
pacman -Syy
pacman -Sw --noconfirm --cachedir "/usr/share/packages" grub eos-dracut kernel-install-for-dracut os-prober xf86-video-intel

# Очистка логов pacman и кеша пакетов
rm "/var/log/pacman.log"
rm -rf "/var/cache/pacman/pkg/"

# Создание файла версий пакетов
pacman -Qs | grep "/calamares " | cut -c7- > iso_package_versions
pacman -Qs | grep "/firefox " | cut -c7- >> iso_package_versions
pacman -Qs | grep "/linux " | cut -c7- >> iso_package_versions
pacman -Qs | grep "/mesa " | cut -c7- >> iso_package_versions
pacman -Qs | grep "/xorg-server " | cut -c7- >> iso_package_versions
pacman -Qs | grep "/nvidia " | cut -c7- >> iso_package_versions
mv "iso_package_versions" "/home/liveuser/"

echo "############################"
echo "# конец списка команд в chroot #"
echo "############################"
EOF
)"
}

run_in_chroot
