# Sobre: Script que coleta logs do sistema gerados durante o boot e organiza essas informações de forma categorizada por software e hardware. <br>
# Explicação do Script:

1. Criação de Diretório: Cria um diretório chamado logs_boot no diretório home do usuário para armazenar os logs coletados.
2. Coleta de Logs: Coleta logs do kernel com dmesg e logs do sistema atual com journalctl -b.
3. Categorização de Logs:
 - Filtra e categoriza logs relacionados a hardware (como PCI, USB, ACPI, CPU, etc.) e software (como systemd, kernel, service, daemon, etc.).
4. Resumo de Logs: Cria um resumo dos logs coletados, mostrando o total de linhas em cada log e a localização dos logs.
5. Exibição de Resumo: Exibe o resumo na tela para o usuário.

# Como Usar o Script:
1. Salvar o Script: Salve o script em um arquivo, por exemplo, coletar_logs_boot.sh.
2. Tornar o Script Executável: Execute o comando abaixo para tornar o script executável:
```
chmod +x coletar_logs_boot.sh
```
3. Executar o Script: Execute o script com privilégios de superusuário para garantir que ele tenha permissão para acessar todos os logs necessários:
```
sudo ./coletar_logs_boot.sh
```

<img src="(https://prnt.sc/W-uTtwg9iRLv)" alt="Imagem 1">

<img src="(https://prnt.sc/hM5W-1SSgIA-)" alt="Imagem 2">

# O script coletará os logs de inicialização, os categorizará e os salvará no diretório $HOME/logs_boot, fornecendo um resumo das informações coletadas.