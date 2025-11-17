#!/bin/bash

# Script para fechar todos os programas em todos os workspaces do Hyprland

# Obtém a lista de todos os clientes (janelas) abertos
clients=$(hyprctl clients -j | jq -r '.[].address')

# Verifica se há clientes abertos
if [ -z "$clients" ]; then
    echo "Nenhuma janela aberta encontrada."
    exit 0
fi

# Contador de janelas fechadas
count=0

# Itera sobre cada cliente e fecha
for client in $clients; do
    hyprctl dispatch closewindow address:$client
    ((count++))
    sleep 0.1  # Pequeno delay para evitar sobrecarga
done

echo "Total de janelas fechadas: $count"
