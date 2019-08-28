
#####################################################################################################
# *****************************PadronizaPassword.ps1*************************************************
#
#Criado por: André Luiz Alves de Souza
#Data: 28/08/2019
#Motivo: Padronização da senha do usuário administrador local via SCCM - Compliance settings
#Versão: 1.0
######################################################################################################



function PadronizaPassword {
    $Computer = [ADSI]"WinNT://$ComputerName,computer"
    $Users = $Computer.psbase.Children | Where-Object {$_.psbase.schemaclassname -eq "user"}
    ForEach ($User in $Users) {
        If ($User.Name -eq "Administrator") {
            net user Administrator FQM@2019 | out-null 
            $out = "True"
            return $out
        } 
        ElseIf ($User.Name -eq "Administrador") {
            net user Administrador FQM@2019 | out-null
            $out = "True"
            return $out
        } 
    
    }
}


$out = "False"
$ComputerName = "localhost"
$retorno = PadronizaPassword
echo $retorno
