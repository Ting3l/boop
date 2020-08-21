function replace-ping($in){
    return $in -creplace "ping","boop" `
               -creplace "Ping","Boop" `
               -creplace "-R ","-RH" `
               -creplace "-R]","-RH]" `
               -creplace "-S srcaddr  ","-src srcaddr" `
               -creplace "-S srcaddr]","-src srcaddr]" 
}
function boop{
    param(
        [parameter(Position=0)]
        [String]$ip,

        [parameter()]
        [switch]$t,

        [parameter()]
        [switch]$a,

        [parameter()]
        [int]$n=4,

        [parameter()]
        [int]$l=32,

        [parameter()]
        [switch]$f,

        [parameter()]
        [int]$i=127,

        [parameter()]
        [int]$v=0,

        [parameter()]
        [int]$r=-1,

        [parameter()]
        [int]$s=-1,

        [parameter()]
        [string]$j="",

        [parameter()]
        [string]$k="",

        [parameter()]
        [switch]$RH,

        [parameter()]
        [string]$src="",

        [parameter()]
        [string]$c="",

        [parameter()]
        [switch]$p,

        [parameter()]
        [switch]$4,

        [parameter()]
        [switch]$6,

        [parameter()]
        [switch]$help
    )
    try{
        $paramStr = ""
        if($t){$paramStr+="-t "}
        if($a){$paramStr+="-a "}
        if($f){$paramStr+="-f "}
        if($RH){$paramStr+="-R "}
        if($p){$paramStr+="-p "}
        if($4){$paramStr+="-4 "}
        if($6){$paramStr+="-6 "}
        if($help -or ($ip -eq "")){$paramStr+="-? "}
        
        if($r -ne -1){$paramStr+="-r $r "}
        if($s -ne -1){$paramStr+="-s $s "}
        if($j -ne ""){$paramStr+="-j $j "}
        if($k -ne ""){$paramStr+="-k $k "}
        if($src -ne ""){$paramStr+="-S $src "}
        if($c -ne ""){$paramStr+="-c $c "}
    
        $paramStr = $paramStr.Trim()

        Start-Job -Name Boop -ScriptBlock {ping $args[0] $args[1] -n $args[2] -l $args[3] -i $args[4] -v $args[5]} -ArgumentList $ip,$paramStr,$n,$l,$i,$v | Out-Null
    
        do{
            (Receive-Job -Name Boop) | foreach{replace-ping $_}
        }while((Get-Job -Name Boop).State -eq "Running")
        Start-Sleep -Milliseconds 100
        (Receive-Job -Name Boop) | foreach{replace-ping $_}
    }
    catch{}
    finally{Remove-Job -Name Boop -Force | Out-Null}
}

# Inspired by
# https://twitter.com/jessica_schalz/status/1292973216634372097

# Written by @Ting3l
# V 1.2


# Changelog
###############
#
# Ting3l    V1.0    Initial
# Ting3l    V1.1    case-sensitive replacing to correct output "booboop" to "booping"
# Ting3l    V1.2    Made $ip non-mandatory to show help when no param is given.
#                   Added "-help" parameter
#                   Replacing now a function
#                   Made the receive-job-loop from while to do-while & added a sleep after ending to compensate slow output
#                   Added changelog
