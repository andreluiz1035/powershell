################################################################
###--------------  Cria e instala conta MSA ----------------####
#Desenvolvido por: André Luiz Alves de Souza                   #
#Para:                                                         #
#Em: 05/06/2019                                                #
#Versão: 1.0                                                   #
#                                                              #
#Motivo: Foi solicitado  pela área de segurança que            #
#não sejam mais utilizadas contas de usuário para a execução   #
#de serviços. As contas serão subtituídas por contas MSA.      #
#Objetivo: Criar uma conta MSA no AD e instalá-la em um        #
#computador do domínio.                                        #
#Requisitos: Powershell 5.1, RSAT do AD, demais requisitos MSA.#
#                                                              #
################################################################          




#Varia global com o nome da conta a ser criada
$Global:Msa = ""

#Verifica se o múdulo Active Directory está carregado. Caso não 
#Esteja, faz o carregamento do múdulo. Caso o múdulo não esteja
#instalado, pede ao usuário para instalá-lo.
function Load-ADModule {

    $Admodule = Get-Module | where {$_.name -like "activedirectory"}

    if ($Admodule.name -notlike "activedirectory") {
        Import-Module -Name ActiveDirectory
        if ($LASTEXITCODE -eq "1") {
            write-host "Por favor instale o RSAT para AD"
        }
        else {
            write-host "Modulo do Active Directory importado com sucesso"
        }
}

    
}

#Pede ao usuário para digitar o nome da conta, e a cria no AD.
function CreateMSA {
    $Global:Msa = Read-Host -Prompt "Por favor digite o nome da conta MSA"
    $Createdmsa = Get-ADServiceAccount -Filter *  | where {$_.name -eq $Global:Msa} | Select-Object -Property Name
    if ($Createdmsa.name -eq $Msa) {
    write-host "Já existe uma conta com esse nome."
    Read-Host "Digite Enter para finalizar..."
    exit
    }
    new-ADServiceAccount -Name $Global:Msa -Enabled $true -RestrictToSingleComputer
    $Createdmsa = Get-ADServiceAccount -Filter *  | where {$_.name -eq $Global:Msa} | Select-Object -Property Name
    if ($Createdmsa.name -eq $Msa) {
    write-host "Conta MSA criada com sucesso"
}
    else {
    write-host "Falha ao criar conta MSA."
    Read-Host "Digite Enter para finalizar..."
    exit    
}
}

#Instala a conta MSA no computador, cujo nome será digitado pelo usuário.
function InstallMSA {
    $ComputerAccount = Read-Host -Prompt "Por favor digite o nome do computador para vincular esta conta."
    Add-ADComputerServiceAccount -Identity $ComputerAccount -ServiceAccount $Global:Msa
    Install-ADServiceAccount -Identity $Global:Msa

    $Test = Test-ADServiceAccount $Global:Msa
    if ($Test -like "True" ) {
    write-host "Conta vinculada com sucesso."
    get-date
    }
    else {
    write-host "Houve um problema na vinculacao da conta."
   }
}

Load-ADModule
CreateMSA
InstallMSA
Read-Host "Digita Enter para finalizar."
