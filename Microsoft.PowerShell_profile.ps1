Import-Module -Name Terminal-Icons
Import-Module Get-ChildItemColor
Import-Module PSReadLine

Set-PSReadLineOption -BellStyle None

function Install-Plugins
{
    winget install starship
    Install-Module -Name PSFzf -RequiredVersion 2.5.22 -Force
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
    Install-Module -Name Get-ChildItemColor -RequiredVersion 2.0.0 -Force
    Install-Module -Name Translate-ToRunes -Force
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}


# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

function YoutubeMusic
{
    & "C:\Program Files\BraveSoftware\Brave-Browser\Application\chrome_proxy.exe" --profile-directory=Default --app-id=cinhimbnkkaeohfgghhklpknlkffjgod  #--profile-directory=Default --app-id=cinhimbnkkaeohfgghhklpknlkffjgod
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Vi

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Key Ctrl+m -ScriptBlock { YoutubeMusic }
Set-PSReadLineKeyHandler -Chord Ctrl+f -ViMode Insert -ScriptBlock {
    Set-Location -Path (Get-ChildItem -Path @("d:\work", "d:\projects") -Directory | ForEach-Object { $_.FullName } | Invoke-Fzf)
}
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward

Set-Alias -Name ytm -Value YoutubeMusic
Set-Alias -Name vim -Value nvim
Clear-Host
Invoke-Expression (&starship init powershell)
