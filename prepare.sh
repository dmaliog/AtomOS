#!/usr/bin/env bash

# Делаем скрипты исполняемыми
chmod +x "./"{"mkarchiso","run_before_squashfs.sh"}

# Вычисляем абсолютный путь к скрипту и определяем ROOT_DIR
SCRIPT_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR="$SCRIPT_DIR/airootfs/root"
PACKAGE_DIR="$ROOT_DIR/packages"

get_pkg() {
    local pkg_name="$1"
    local cache_dir="$HOME/.cache/yay/$pkg_name"

    # Попытка скачать пакет с помощью yay
    yay -Syw "$pkg_name" --noconfirm --cachedir "$PACKAGE_DIR"
    
    if [[ $? -ne 0 || -z "$(ls "$PACKAGE_DIR"/*.pkg.tar.* 2>/dev/null)" ]]; then
        echo "Пакет $pkg_name не скачался. Проверим, если есть PKGBUILD в кешах yay."

        # Проверка наличия PKGBUILD в кешах yay
        if [[ -d "$cache_dir" && -f "$cache_dir/PKGBUILD" ]]; then
            echo "Найден PKGBUILD для $pkg_name. Начинаем сборку."
            
            # Сборка пакета
            cd "$cache_dir" || exit
            makepkg -sf --noconfirm  # Параметр -f принудительно пересобирает пакет

            # Перемещение готового пакета в целевую директорию
            mv *.pkg.tar.* "$PACKAGE_DIR/"
        else
            echo "PKGBUILD для $pkg_name не найден в кешах yay. Не удается собрать пакет."
            exit 1
        fi
    else
        echo "Пакет $pkg_name успешно скачан."
    fi

    # Используем универсальную маску для поиска пакетов
    sudo chown "$USER:$USER" "$PACKAGE_DIR"/*.pkg.tar.*
}

get_pkg "yandex-browser"

# Собираем liveuser skel
cd "$ROOT_DIR/endeavouros-skel-liveuser"
makepkg -f
