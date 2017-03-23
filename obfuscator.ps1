# ** ** ** ** ** ** ** ** ** ** **
# make my browsing data useless ::
# holla ya boi yabones 2017     ::
# .. .. .. .. .. .. .. .. .. .. ::

# license: free as in freedom SHOUT OUT to muh boi Stallman GPL3 Biii--ch

# Load wordlist from Git page...
[System.Collections.ArrayList]$wordList = (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yabona/obfuscator/master/topsearches.txt).content.split("`n")

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


    # Click links within search results, between 1 and 3 times
    for ($i = 0; $i -lt (1..3|Get-random); $i ++) {
        Write-Verbose "Click $i start..." -Verbose

        # Select <a href> randomly, from search results. Click it. 
        $elements = $iexplore.Document.getElementsByTagName("A") 
        $target =  ($elements | ? {$_.host -notlike "*google*"} | select -Index (10..20|Get-Random))
        $target.click()
        while ($iexplore.busy) {start-sleep -m 200}
        
        # wait, then go back to search results...
        Start-Sleep (3..10|Get-Random)
        $iexplore.GoBack()
        while ($iexplore.busy) {start-sleep -m 200}

       Write-Verbose "click $i done;" -Verbose
    }
    Write-Output "Done. Proceeding to next search...`n" -Verbose
}

#unreacable, hahahahaha
$iexplore.quit
Get-Process iexplore | % { $_.CloseMainWindow() }
