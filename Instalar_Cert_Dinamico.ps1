# 1. LISTA DE THUMBPRINTS PARA REMOVER (Certificados antigos/substituídos)
$thumbprintsParaRemover = @(
    #lista de thumbprints dos certificados antigos que devem ser removidos antes da instalação dos novos. Adicione os thumbprints aqui
	"075666631043274B032BCD22E3F10AA27B920505", "7BF9D2D2646C9EA2EE3F40F0F8E16EDBAA64D70A", "DA85F57A20E875AEC612B9AD915F7A65C4F54949", "ACCB7D29CE6CC57B8ED14A8D6A9994B1B71554C3", "E499B429E6945BC679AEE7DE64CC2493A863EB48"
    
)

foreach ($tp in $thumbprintsParaRemover) {
    $certAntigo = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Thumbprint -eq $tp }
    if ($certAntigo) {
        try {
            Remove-Item -Path $certAntigo.PSPath -Force -ErrorAction Stop
            Write-Host "Sucesso: Certificado antigo $tp removido." -ForegroundColor Yellow
        } catch {
            Write-Warning "Não foi possível remover o certificado $tp : $_"
        }
    }
} 
 
# 2. Instalação dos certificados .pfx 

# Lista de possíveis senhas (adicione ou remova conforme necessário)
$listaSenhas = @("czar123", "czar@123")

# Busca todos os arquivos .pfx na pasta
$arquivosPfx = Get-ChildItem -Path ".\certificados" -Filter "*.pfx"

foreach ($pfx in $arquivosPfx) {
    $instalado = $false
    Write-Host "Tentando instalar: $($pfx.Name)" -ForegroundColor Cyan
    
    foreach ($senha in $listaSenhas) {
        try {
            $senhaSegura = ConvertTo-SecureString $senha -AsPlainText -Force
            
            # Tenta importar o certificado
            Import-PfxCertificate -FilePath $pfx.FullName -CertStoreLocation Cert:\CurrentUser\My -Password $senhaSegura -ErrorAction Stop
            
            Write-Host "Sucesso: $($pfx.Name) instalado com a senha correta." -ForegroundColor Green
            $instalado = $true
            break # Se funcionou, para de tentar outras senhas para este arquivo
        } catch {
            # Se falhar, o loop continua para a próxima senha
            continue
        }
    }

    if (-not $instalado) {
        Write-Error "Erro: Nenhuma das senhas fornecidas funcionou para o arquivo $($pfx.Name)."
    }
}