#!/bin/bash

PROTON_GE_DIR="$HOME/.steam/root/compatibilitytools.d"
PROTON_GE_VERSION_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"

echo "by LimonTH:)"

command -v jq >/dev/null 2>&1 || { echo >&2 "jq не установлен. Установите jq и повторите попытку."; exit 1; }
command -v wget >/dev/null 2>&1 || { echo >&2 "wget не установлен. Установите wget и повторите попытку."; exit 1; }

if [ ! -d "$PROTON_GE_DIR" ]; then
    echo "Директория $PROTON_GE_DIR не найдена. Создание директории..."
    mkdir -p "$PROTON_GE_DIR"
fi

if [ ! -d "$PROTON_GE_DIR" ]; then
    echo "Ошибка: Не удалось создать директорию $PROTON_GE_DIR."
    exit 1
fi

# Получение последней версии и URL для загрузки
LATEST_VERSION_INFO=$(curl -s $PROTON_GE_VERSION_URL)

LATEST_VERSION=$(echo "$LATEST_VERSION_INFO" | jq -r '.tag_name')

DOWNLOAD_URL=$(echo "$LATEST_VERSION_INFO" | jq -r '.assets[] | select(.name == "GE-Proton10-12.tar.gz") | .browser_download_url')

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Ошибка: Не удалось извлечь URL для загрузки."
    echo "Проверьте, существует ли файл с именем GE-Proton10-12.tar.gz в списке активов github: https://github.com/GloriousEggroll/proton-ge-custom/releases/"
    exit 1
fi

LATEST_VERSION_FILE="$PROTON_GE_DIR/${LATEST_VERSION}.tar.gz"

download_proton_ge() {
    echo "Загрузка и установка последней версии GE-Proton..."
    if ! wget -qO "$LATEST_VERSION_FILE" "$DOWNLOAD_URL"; then
        echo "Ошибка: Не удалось загрузить файл $LATEST_VERSION_FILE."
        exit 1
    fi
}

# Проверка наличия ProtonGE
CURRENT_VERSION=$(ls "$PROTON_GE_DIR" | grep '^GE-Proton' | sort -V | tail -n 1)

if [ -n "$CURRENT_VERSION" ]; then
    echo "Найдена установленная версия GE-Proton: $CURRENT_VERSION. Проверка наличия обновлений..."
    if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
    echo "Найдено обновление для GE-Proton, последняя версия на данный момент: $LATEST_VERSION"
    echo "Обновление GE-Proton до версии $LATEST_VERSION..."
    
    echo "Удаление старой версии GE-Proton: $CURRENT_VERSION"
    rm -rf "$PROTON_GE_DIR/$CURRENT_VERSION"
    else
    echo "У вас новейшая версия $LATEST_VERSION, возвращайтесь позже. =)"
    exit
    fi
else
    echo "GE-Proton не найден в директории compatibilitytools.d, начинаю установку новейшей версии..."
fi

download_proton_ge
mkdir "$PROTON_GE_DIR/$LATEST_VERSION"
tar -xzf "$LATEST_VERSION_FILE" -C "$PROTON_GE_DIR/$LATEST_VERSION" --strip-components=1
echo "GE-Proton обновлен до версии $LATEST_VERSION."

echo "Удаление temp файлов..."
rm -f "$LATEST_VERSION_FILE"
echo "Удаление завершено! До встречи."
