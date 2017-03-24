# ** ** ** ** ** ** ** ** ** ** **
# make my browsing data useless ::
# holla ya boi yabones 2017     ::
# .. .. .. .. .. .. .. .. .. .. ::

param (
    [switch]$useSERP = $false
)
    

# Load wordlist from Git page...
if ($useSERP) {
    [System.Collections.ArrayList]$wordList = (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yabona/obfuscator/master/SERP_top).content.split("`n")
    Write-Warning "This may be slower on devices that can't handle 50k..." 
} else {
    [System.Collections.ArrayList]$wordList = (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yabona/obfuscator/master/topsearches.txt).content.split("`n")
}

# add top sites to list
$wordList += (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yabona/obfuscator/master/top500sites).content.split("`n")

function clickLink 
{
    $elements = $iexplore.Document.getElementsByTagName("A") 
    $target =  ($elements | ? {$_.host -notlike "*google*" -and $_.href -like "http*"} | select -Index (10..20|Get-Random))
    Write-Verbose "$($target.href)" -Verbose
    try { $target.click() } 
    catch { Write-Warning "Click failed! Retrying..." }
}

# loop main
while ($true) 
{   # todo: add more search engines... Meh, another day old lad. 
   
    # Keyword add
    $search = "https://google.com/search?q=" +  [string]($wordlist[(Get-random -Maximum $wordlist.count)]).replace(' ','%20')
     
    # Open IE object and position on screen
    $iexplore = New-Object -ComObject internetExplorer.application 
    $iexplore.visible = $true
    $iexplore.width = 640
    $iexplore.Height = 480

    Write-Verbose "Goto: $search" -Verbose
    $iexplore.navigate($search)
    while ($iexplore.busy) {start-sleep -m 200}; Start-Sleep (3..7|Get-Random)

    # Click links within search results, between 1 and 3 times
    for ($i = 0; $i -lt (1..3|Get-random); $i ++) {
        Write-Verbose "Click $i start..." -Verbose

        # Select <a href> randomly, from search results. Click it. 
        clickLink 

        # 50% chance of hitting a subpage...
        if($true,$false|Get-random) {
            while ($iexplore.busy) {start-sleep -m 200}
            Start-Sleep (4..10|Get-Random)
            Write-Verbose "Browsing subpage..." -Verbose

            clickLink 

            while ($iexplore.busy) {start-sleep -m 200}
            Start-Sleep (4..10|Get-Random)
            Write-Verbose "Back..." -Verbose
            try { $iexplore.GoBack() }
            catch {Write-Verbose "Back failed!"}
        }

        #go back to search results...
        while ($iexplore.busy) {start-sleep -m 200}
        Start-Sleep (4..10|Get-Random)
        try { $iexplore.GoBack() }
        catch {Write-Verbose "Back failed!"}

        Write-Verbose "click $i done;" -Verbose
        
        while ($iexplore.busy) {start-sleep -m 200}
        Start-Sleep (4..10|Get-Random)
    }
    Write-Output "Done. Proceeding to next search...`n" -Verbose

    $iexplore.quit
    Get-Process iexplore | % { $_.CloseMainWindow() }
}
