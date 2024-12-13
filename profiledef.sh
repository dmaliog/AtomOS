#!/usr/bin/env bash
# shellcheck disable=SC2034

set -e
trap 'echo "Ошибка на строке $LINENO"; exit 1' ERR

debug="n"
[[ $debug == "y" ]] && set -x

iso_name="AtomicOS_ISO"
iso_label="EOS_$(date +%Y%m)"
iso_publisher="AtomicOS <http://vk.com/linux2>"
iso_application="AtomicOS Live/Rescue CD"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
quiet="n"
work_dir="work"
out_dir="out"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="${1:-x86_64}"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M' '-processors' "$(nproc)")
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/g_wheel"]="0:0:440"
  ["/usr/bin/GPU-Intel-installer"]="0:0:755"
)

required_tools=("mkarchiso" "mksquashfs" "date")
for tool in "${required_tools[@]}"; do
  if ! command -v "$tool" &>/dev/null; then
    echo "Ошибка: $tool не найден. Установите его и повторите попытку." >&2
    exit 1
  fi
done

if [[ $EUID -ne 0 ]]; then
  echo "Ошибка: скрипт должен выполняться с правами суперпользователя." >&2
  exit 1
fi

log_file="aiso_$(date -u +'%Y.%m.%d-%H:%M').log"
echo "Лог будет записан в файл: $log_file"
echo "Начинаю сборку ISO-образа: $iso_name"
echo "Рабочая директория: $work_dir"
echo "Выходная директория: $out_dir"

# Команда сборки с логированием
sudo ./mkarchiso -v "." 2>&1 | tee "$log_file"

echo "Сборка завершена. Лог сохранён в $log_file"
