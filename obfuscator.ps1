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

# Open IE object and position on screen
$iexplore = New-Object -ComObject internetExplorer.application 
$iexplore.visible = $true
#$iexplore.fullscreen = $true
$iexplore.width = 640
$iexplore.Height = 480

while ($true) {
   
   # todo: add more search engines... Meh, another day old lad. 
   
    # Keyword add
    $search = "https://google.com/search?q=" +  [string]($wordlist[(Get-random -Maximum $wordlist.count)]).replace(' ','%20')
    
    # open IE and start search 
    $iexplore.navigate($search)
    Write-Verbose "Goto: $search" -Verbose
    while ($iexplore.busy) {start-sleep -m 200}
    Start-Sleep (3..7|Get-Random)


    # Click links within search results, between 1 and 3 times
    for ($i = 0; $i -lt (1..3|Get-random); $i ++) {
        Write-Verbose "Click $i start..." -Verbose

        # Select <a href> randomly, from search results. Click it. 
        $elements = $iexplore.Document.getElementsByTagName("A") 
        $target =  ($elements | ? {$_.host -notlike "*google*"} | select -Index (10..20|Get-Random))
        $target.click()

        # 50% chance of hitting a subpage...
        if($true,$false|Get-random) {
            while ($iexplore.busy) {start-sleep -m 200}
            Start-Sleep (4..10|Get-Random)
            Write-Verbose "Browsing subpage..." -Verbose

            $elements = $iexplore.Document.getElementsByTagName("A") 
            $target = ($elements | ? {$_.href -like "http*"})| select -index (2..15|Get-Random)
            $Target.click()

            while ($iexplore.busy) {start-sleep -m 200}
            Start-Sleep (4..10|Get-Random)
            Write-Verbose "Back..." -Verbose
            $iexplore.GoBack()
        }

        #go back to search results...
        while ($iexplore.busy) {start-sleep -m 200}
        Start-Sleep (4..10|Get-Random)
        $iexplore.GoBack()

        Write-Verbose "click $i done;" -Verbose
        
        while ($iexplore.busy) {start-sleep -m 200}
        Start-Sleep (4..10|Get-Random)
    }
    Write-Output "Done. Proceeding to next search...`n" -Verbose
    Start-Sleep (4..9|Get-Random)
}

#unreacable, hahahahaha
$iexplore.quit
Get-Process iexplore | % { $_.CloseMainWindow() }
