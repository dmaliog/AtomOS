# AtomicOS-ISO
Приемущства:
- Русский язык по умолчанию
- Репозитории стран BRICS
- Более современный интерфейс

[![Maintenance](https://img.shields.io/maintenance/yes/2024.svg)]()

Этот ISO основан на сильно модифицированном EndeavourOS-ISO, который обеспечивает среду установки для AtomicOS. 


## Ресурсы:

<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/KDE-LiveSession.png" alt="Installer LiveSession" width="600"/>

- [сообщество](https://vk.com/linux2)

### Источник разработки

- [EndeavourOS-ISO source](https://github.com/endeavouros-team/EndeavourOS-ISO) (Среда с KDE-Desktop)
- [Calamares {EndeavourOS fork}](https://github.com/endeavouros-team/calamares) (фреймворк установщика)
- Темы Goldy
- Курсоры Bibata-Modern-Ice
- Иконки Papirus


### Базовый источник

- [Arch-ISO](https://gitlab.archlinux.org/archlinux/archiso)
- [Calamares](https://github.com/calamares/calamares)



# Параметры загрузки

Systemd-загрузка для систем UEFI:

<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/Apollo/apollo-systemdboot.png" alt="drawing" width="600"/>

Bios-загрузка (syslinux) для устаревших систем:

<img src="https://raw.githubusercontent.com/endeavouros-team/screenshots/master/Apollo/apollo-syslinux.png" alt="drawing" width="600"/>



# Как создать ISO

Вам необходимо использовать установленную систему AtomicOS или любую систему на базе архива с включенным [репозиторием] AtomicOS (https://github.com/endeavouros-team/mirrors).
Поскольку установочные пакеты и необходимые зависимости будут установлены из репозитория AtomicOS.

Основная информация:
https://endeavouros-team.github.io/EndeavourOS-Development/

Прежде чем приступить к ознакомлению с последними изменениями, ознакомьтесь с списком изменений:
https://github.com/endeavouros-team/EndeavourOS-ISO/blob/main/CHANGELOG.md

### Установить зависимости сборки

```
sudo pacman -S archiso git squashfs-tools --needed
```
После этих изменений рекомендуется перезагрузиться.

### Сборка

##### 1. Подготовка

** Внимание:** не используйте архиватор zip, если это вызовет проблемы с символическими ссылками.
```
./prepare.sh
```
##### 2. Сборка

~~~
sudo ./mkarchiso -v "."
~~~

**или с помощью журнала:**

~~~
sudo ./mkarchiso -v "." 2>&1 | tee "aiso_$(date -u +'%Y.%m.%d-%H:%M').log"
~~~

##### 3. ISO-файл появится в каталоге "out"...


## Остальное

Чтобы установить локально созданные пакеты на ISO, поместите их в следующий каталог:

~~~
airootfs/root/packages
~~~

Пакеты будут установлены, и после этого каталог будет очищен.


## Общее обозначение ISO:

Пример:

~~~
AtomicOS_Atom-2024.01.25.iso
~~~

**AtomicOS_НАЗВАНИЕ-РЕЛИЗА-YYYY.MM.DD.iso**
* ГГГГ.ММ.ДД: дата выпуска
