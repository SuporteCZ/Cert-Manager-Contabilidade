# 🔐 Gerenciador de Certificados - Departamento Contábil

Este repositório contém uma solução de automação em PowerShell e Batch desenvolvida para simplificar a gestão de certificados digitais (.pfx) nas estações de trabalho. O sistema realiza a limpeza de certificados antigos e a instalação em lote de novos certificados.

---

## 📂 Estrutura do Repositório

- **Instalar_Cert_Dinamico.ps1**: Script principal em PowerShell que gerencia a lógica de remoção e instalação.
    
- **Instalar_Certificados.bat**: Executável de suporte que contorna as restrições de segurança (Execution Policy) do Windows.
    
- **certificados/**: Pasta recomendada para organizar os arquivos `.pfx` (os certificados não devem ser submetidos ao Git).
    
- **.gitignore**: Configuração para evitar o upload acidental de certificados reais para o GitHub.
    

---

## ⚙️ Funcionalidades

1. **Remoção por Thumbprint**: O script busca e remove certificados específicos (antigos ou substituidos) antes de iniciar a nova instalação, evitando duplicidade.
    
2. **Instalação em Lote**: Processa todos os arquivos `.pfx` presentes no diretório de uma só vez.
    
3. **Senhas Dinâmicas**: Testa automaticamente uma lista de senhas pré-definidas para cada certificado, facilitando a instalação em máquinas onde múltiplos certificados A1 são necessários.
    
4. **Contexto de Usuário**: Os certificados são instalados no repositório "Pessoal" do usuário atual (`Cert:\CurrentUser\My`).
    

---

## 🚀 Como Utilizar

Para garantir que o script funcione mesmo em máquinas com restrições de script do PowerShell, siga estes passos:

1. Coloque os certificados `.pfx` na pasta certificados/.
    
2. Localize o arquivo `Instalar_Certificados.bat`.
    
3. Execute o arquivo com um **clique duplo**.
    
4. O console abrirá e mostrará o progresso:
    
    - 🟡 **Amarelo**: Certificados antigos removidos.
        
    - 🟢 **Verde**: Novos certificados instalados com sucesso.
        
    - 🔴 **Vermelho**: Alertas ou falhas de senha.
        
5. Ao final, pressione qualquer tecla para fechar a janela.
    

---

## 🛠️ Guia de Customização

Para adaptar o script às necessidades do departamento:

### Atualizar Certificados para Remoção

No arquivo `Instalar_Cert_Dinamico.ps1`, localize a lista `$thumbprintsParaRemover` e adicione os códigos Thumbprint dos certificados que deseja deletar automaticamente.

### Atualizar Lista de Senhas

No arquivo `Instalar_Cert_Dinamico.ps1`, localize a variável `$listaSenhas` e insira as senhas padrão fornecidas pela contabilidade.

---

## 🖥️ Instalação no Nível da Máquina (Local Machine)

Por padrão, o script instala os certificados apenas para o **Usuário Atual**. Caso precise que o certificado fique disponível para todos os usuários do computador, siga os passos abaixo para alterar o script:

### 1. Alteração no Script PowerShell
Abra o arquivo `Instalar_Cert_Dinamico.ps1` e substitua todas as ocorrências de:
`Cert:\CurrentUser\My` 
por:
`Cert:\LocalMachine\My`

### 2. Execução como Administrador
Instalações no repositório da Máquina Local exigem privilégios elevados. 
* **Para rodar via terminal**: Abra o PowerShell como Administrador antes de executar.
* **Para rodar via interface**: Clique com o botão direito no arquivo `Instalar_Certificados.bat` e selecione **"Executar como Administrador"**.

---

## ⚠️ Diferença entre CurrentUser e LocalMachine

* **CurrentUser (Padrão)**: O certificado só é visível para quem o instalou. É o mais seguro e comum para certificados A1 de uso pessoal/contábil.
* **LocalMachine**: O certificado fica instalado no hardware. Útil para servidores ou máquinas onde vários colaboradores precisam acessar o mesmo certificado sem precisar reinstalar em cada perfil.

---

## ⚠️ Notas de Segurança (Importante)

- **Privacidade**: Nunca faça `git push` de arquivos `.pfx` reais. Este repositório deve conter apenas a lógica de instalação.
    
- **Bypass de Execução**: O arquivo `.bat` utiliza o parâmetro `-ExecutionPolicy Bypass`. Isso é seguro pois altera a política apenas para esta sessão específica, sem comprometer a segurança global da máquina.

---

## 📝 Notas de Infraestrutura

Este projeto visa reduzir o tempo de suporte técnico em chamados de "Certificado não encontrado" ou "Erro na assinatura digital", garantindo que a estação tenha apenas os certificados válidos instalados.