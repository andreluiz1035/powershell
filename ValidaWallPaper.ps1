#####################################################################################################
# *****************************ValidaWallPaper.ps1**************************************************
#
#Criado por: André Luiz Alves de Souza
#Data: 20/08/2019
#Motivo: Verifica se o papel de parede n máquina local é o mesmo de um compartilhamento de rede via
#SCCM - Compliance settings
#Versão: 1.0
######################################################################################################


#Valida se o papel de parede aplicado na máquina local é o mais recente em um compartilhamento de rede.
function ValidaWP {

    $wpdc = get-childitem "\\dc\Papel_de_parede" | Where {$_.LastWriteTime} | select -last 1
    $wp=Get-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper
    $img = $wp.Wallpaper  -replace '.*\\'
    if ($img -like $wpdc.name) {
        return "True"
    }
    else {
        return "False"
    }
}

$out = "False"
$retorno = ValidaWP
echo $retorno


