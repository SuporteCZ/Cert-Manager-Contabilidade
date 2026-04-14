@echo off
:: Navega para a pasta onde este arquivo .bat está salvo, não importa o caminho 
cd /d "%~dp0"

echo ======================================================
echo    INSTALADOR AUTOMATICO DE CERTIFICADOS - CONTABILIDADE
echo ======================================================
echo.

:: Executa o PowerShell ignorando a política de execução local 
Powershell -ExecutionPolicy Bypass -File ".\Instalar_Cert_Dinamico.ps1"

echo.
echo ======================================================
echo    Processo concluido. Verifique as mensagens acima.
echo ======================================================
pause [cite: 3]