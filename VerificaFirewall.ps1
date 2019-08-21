#####################################################################################################
# *****************************VerificaFirewall.ps1**************************************************
#
#Criado por: André Luiz Alves de Souza
#Data: 20/08/2019
#Motivo: Verificação da configuração do Firewall das máuinas através do SCCM - Compliance settings
#Versão: 1.0
######################################################################################################

#Verifica os tres perfis de firewall e retorna True caso todos estejam desabilitados.
function VerificaFW {
    
    $fw = get-netfirewallprofile | Where-Object {$_.enabled -like "True"} | fl Name

    if (!$fw) {
        $out = "True"
        return $out
    }
    else {
        $out = "False"
        return $out 
     }
}

$retorno = VerificaFW
echo $retorno
