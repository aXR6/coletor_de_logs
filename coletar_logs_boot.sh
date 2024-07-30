#!/bin/bash

# Criar diretório principal para armazenar todos os logs
MAIN_LOG_DIR="$HOME/logs_boot_collection"
mkdir -p "$MAIN_LOG_DIR"

# Diretórios específicos dentro da pasta principal
LOG_DIR="$MAIN_LOG_DIR/logs"
PROBLEM_DIR="$MAIN_LOG_DIR/problemas"
SUMMARY_LOG="$MAIN_LOG_DIR/summary.log"

mkdir -p "$LOG_DIR"
mkdir -p "$PROBLEM_DIR"

# Coletar logs do dmesg
dmesg > "$LOG_DIR/dmesg.log"

# Coletar logs do journalctl relacionados ao boot atual
journalctl -b > "$LOG_DIR/journal_boot.log"

# Categorização de logs
SOFTWARE_LOG="$LOG_DIR/software.log"
HARDWARE_LOG="$LOG_DIR/hardware.log"
PROBLEMS_LOG="$PROBLEM_DIR/problems.log"

# Filtrar logs relacionados a hardware (exemplos comuns)
grep -E "PCI|USB|ACPI|CPU|Memory|Hardware|SATA|disk|nvme" "$LOG_DIR/dmesg.log" > "$HARDWARE_LOG"
grep -E "PCI|USB|ACPI|CPU|Memory|Hardware|SATA|disk|nvme" "$LOG_DIR/journal_boot.log" >> "$HARDWARE_LOG"

# Filtrar logs relacionados a software (exemplos comuns)
grep -E "systemd|kernel|service|daemon|network|driver|module|software" "$LOG_DIR/dmesg.log" > "$SOFTWARE_LOG"
grep -E "systemd|kernel|service|daemon|network|driver|module|software" "$LOG_DIR/journal_boot.log" >> "$SOFTWARE_LOG"

# Verificação de problemas e pontos de observação
grep -iE "error|fail|critical|warn|bug|corrupt|missing|denied" "$LOG_DIR/dmesg.log" > "$PROBLEMS_LOG"
grep -iE "error|fail|critical|warn|bug|corrupt|missing|denied" "$LOG_DIR/journal_boot.log" >> "$PROBLEMS_LOG"

# Verifica se o arquivo de problemas está vazio
if [ ! -s "$PROBLEMS_LOG" ]; then
    echo "Nenhum problema ou ponto de observação encontrado nos logs."
    rmdir "$PROBLEM_DIR"
else
    echo "Problemas ou pontos de observação encontrados. Verifique os logs em $PROBLEM_DIR."
fi

# Criar um resumo dos logs coletados
echo "Resumo dos Logs de Boot" > "$SUMMARY_LOG"
echo "=======================" >> "$SUMMARY_LOG"
echo "Total de linhas em dmesg.log: $(wc -l < "$LOG_DIR/dmesg.log")" >> "$SUMMARY_LOG"
echo "Total de linhas em journal_boot.log: $(wc -l < "$LOG_DIR/journal_boot.log")" >> "$SUMMARY_LOG"
echo "" >> "$SUMMARY_LOG"
echo "Total de entradas relacionadas a hardware: $(wc -l < "$HARDWARE_LOG")" >> "$SUMMARY_LOG"
echo "Total de entradas relacionadas a software: $(wc -l < "$SOFTWARE_LOG")" >> "$SUMMARY_LOG"

echo "" >> "$SUMMARY_LOG"
echo "Localização dos logs coletados: $LOG_DIR" >> "$SUMMARY_LOG"

# Adiciona resumo dos problemas, se existirem
if [ -d "$PROBLEM_DIR" ]; then
    echo "" >> "$SUMMARY_LOG"
    echo "Problemas ou pontos de observação foram encontrados. Verifique os logs em $PROBLEM_DIR." >> "$SUMMARY_LOG"
    echo "Total de problemas ou pontos de observação: $(wc -l < "$PROBLEMS_LOG")" >> "$SUMMARY_LOG"
fi

# Exibir resumo na tela
cat "$SUMMARY_LOG"

echo "Logs de boot coletados e categorizados com sucesso."
echo "Verifique o diretório $MAIN_LOG_DIR para mais detalhes."

if [ -d "$PROBLEM_DIR" ]; then
    echo "Verifique o diretório $PROBLEM_DIR para problemas ou pontos de observação."
fi