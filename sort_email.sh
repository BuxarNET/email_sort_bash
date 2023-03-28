#!/bin/bash

# BuxarNET http://forum.buxarnet.ru/ 
# Telegram @buxarnet_ru
# BitCoin 13DiqXuWkLwThkXQHShtBnwvEcvHHWWAg4
# Ethereum 0x8F3951AF2686a7697aeEce0DfF23d2C1eD0c0f99
# NASHI 3P5nT1a1CAdEPPHTSTaF5Ygj7k5s7KeBnbB

# Очистка старых данных
#rm -f unique_emails.txt
#rm -f report.txt

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

# Получение данных из файла
declare -A emails
while read line; do
    email=$(echo $line | awk '{print $1}')
    # проверка адреса на корректность
    if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        # Добавление email-адреса в словарь и увеличение счётчика
        ((emails["$email"]++))
    fi
done < emails_raw.txt

# Вывод списка email-адресов в файл unique_emails.txt
for email in "${!emails[@]}"; do
    if [[ ${emails[$email]} -eq 1 ]]; then
        echo "$email" >> unique_emails_${timestamp}.txt
    fi
done

# Вывод отчёта на экран и в файл  report.txt
echo "Всего обработано email-адресов: ${#emails[@]}"
echo "Количество уникальных email-адресов: $(wc -l < unique_emails_${timestamp}.txt)" 
echo "Повторяющиеся email-адреса:"
echo "Всего обработано email-адресов: ${#emails[@]}" > report_${timestamp}.txt
echo "Количество уникальных email-адресов: $(wc -l < unique_emails_${timestamp}.txt)" >> report_${timestamp}.txt
echo "Повторяющиеся email-адреса:" >> report_${timestamp}.txt
for email in "${!emails[@]}"; do
    if [[ ${emails[$email]} -gt 1 ]]; then
        echo "$email: ${emails[$email]}"
        echo "$email: ${emails[$email]}" >> report_${timestamp}.txt
    fi
done

echo "Готово!"

# сохранение результатов обработки
#mkdir processed_emails
#timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
#cp emails_raw.txt "processed_emails/emails_processed_${timestamp}.txt"
#cp unique_emails.txt "processed_emails/unique_emails_${timestamp}.txt"
#cp report.txt "processed_emails/report_${timestamp}.txt"
#cp emails_raw.txt "emails_processed_${timestamp}.txt"
#cp unique_emails.txt "unique_emails_${timestamp}.txt"
#cp report.txt "report_${timestamp}.txt"
