param (
    [string]$keyword,
    [switch]$link
)

# Open IE object and position on screen
$iexplore = New-Object -ComObject internetExplorer.application 
$iexplore.visible = $true
$iexplore.width = 640
$iexplore.Height = 480


function Search {
    # Exec search on IE 
    
    switch (1..5|Get-Random) {
        1 {$search="https://www.google.ca/#q=" + $keyword}
        2 {$search="https://www.youtube.com/results?search_query=" + $keyword}
        3 {$search="https://search.yahoo.com/search?p="+ $keyword}
        4 {$Search="http://www.bing.com/search?q=" + $keyword}
        5 {$search="https://www.amazon.com/s/field-keywords=" + $keyword}

    }
    
    $iexplore.navigate($search)
    while ($iexplore.busy) {start-sleep -m 200}; Start-Sleep (3..7|Get-Random)
}

function Navigation {
    # Dumb loop for stupidly clicking around on a page

    for ($i = 0; $i -lt (1..3|Get-random); $i ++) {
        Write-Verbose "Click $i start..." -Verbose

        # Select <a href> randomly, from search results. Click it. 
        $elements = $iexplore.Document.getElementsByTagName("A") 
        $target =  ($elements | ? {$_.host -notlike "*google*" -and $_.href -like "http*"} | select -Index (10..20|Get-Random))

        try { $target.click() } 
        catch { Write-Warning "Click failed! Retrying..." }

        # 50% chance of hitting a subpage...
        if($true,$false|Get-random) {
            while ($iexplore.busy) {start-sleep -m 200}
            Start-Sleep (4..10|Get-Random)
            Write-Verbose "Browsing subpage..." -Verbose

            $elements = $iexplore.Document.getElementsByTagName("A") 
            $target =  ($elements | ? {$_.host -notlike "*google*" -and $_.href -like "http*"} | select -Index (10..20|Get-Random))
            
            try { $target.click() } 
            catch { Write-Warning "Click failed! Retrying..." }

            while ($iexplore.busy) {start-sleep -m 200}
            Start-Sleep (4..10|Get-Random)
            
            try { $iexplore.GoBack() }
            catch {Write-Verbose "Back failed!"}
        }

        #go back to search results...
        while ($iexplore.busy) {start-sleep -m 200}
        Start-Sleep (4..10|Get-Random)
        try { $iexplore.GoBack() }
        catch {Write-Verbose "Back failed!"}

        
        
        while ($iexplore.busy) {start-sleep -m 200}
        Start-Sleep (4..10|Get-Random)
    }
}

# -- -- -- -- -- -- -- -- -- -- -- -- -- --
 

# Start search 
Search


# execute clicks on page
Navigation

