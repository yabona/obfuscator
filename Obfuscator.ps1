# ** ** ** ** ** ** ** ** ** ** **
# make my browsing data useless ::
# holla ya boi yabones 2017     ::
# .. .. .. .. .. .. .. .. .. .. ::

param (
    [switch]$useSERP = $false, 
    [switch]$useEchelon = $false, 
    [switch]$useTopSites = $true
)
    

# Load wordlist from Git page...
if ($useSERP) {
    [System.Collections.ArrayList]$wordList = (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yabona/obfuscator/master/SERP_top).content.split("`n")
    Write-Warning "This may be slower on devices that can't handle 50k..." 
} else {
    [System.Collections.ArrayList]$wordList = (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yabona/obfuscator/master/topsearches.txt).content.split("`n")
}

# Add Echelon keylist to search 
if($useEchelon) {
    $wordlist += (Invoke-Webrequest -Uri https://raw.githubusercontent.com/yabona/obfuscator/master/echelon).content.split(',').trim() 
}

# populate top site
if($useTopSites) {
    $wordList += (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yabona/obfuscator/master/top500sites).content.split("`n").trim()
}

# main loop start: 
while($true) {
    $keyword = [string]($wordlist[(Get-random -Maximum $wordlist.count)]).replace(' ','%20')
    
    Write-Verbose "$keyword" -Verbose
    start-job -FilePath $PSScriptRoot\searchBot.ps1 -ArgumentList $keyword -name $keyword
     
    Get-Job | Wait-Job -Timeout 90

    Get-Process iexplore | % {stop-process -force -id $_.id }

    Get-job | Remove-Job -force
}

