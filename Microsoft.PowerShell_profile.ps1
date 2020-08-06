Import-Module Get-ChildItemColor

$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding =
                    New-Object System.Text.UTF8Encoding
$global:forePromptColor = 0
$global:leftArrow = [char]0xe0b2
$global:rightArrow = [char]0xe0b0
$global:esc = "$([char]27)"
$global:fore = "$esc[38;5"
$global:back = "$esc[48;5"
$global:prompt = ''
$global:name = Translate-ToRunes "sam" $true


[System.Collections.Generic.List[ScriptBlock]]$global:PromptRight = @(
    # right aligned
    { "$fore;${errorColor}m{0}" -f $leftArrow }
    { "$fore;${forePromptColor}m$back;${errorColor}m{0}" -f $(if (@(get-history).Count -gt 0) {(get-history)[-1] | % { "{0:c}" -f (new-timespan $_.StartExecutionTime $_.EndExecutionTime)}}else {'00:00:00.0000000'}) }

    { "$fore;8m$back;${errorColor}m{0}" -f $leftArrow }
    { "$fore;0m$back;8m{0}" -f $(get-date -format "hh:mm:ss tt") }
)

[System.Collections.Generic.List[ScriptBlock]]$global:PromptLeft = @(
    # left aligned
    { "$fore;${forePromptColor}m$back;${global:platformColor}m{0}" -f $('{0:d4}' -f $name) }
    { "$back;22m$fore;${global:platformColor}m{0}" -f $rightArrow }

    { "$back;22m$fore;${forePromptColor}m{0}" -f $(if ($pushd = (Get-Location -Stack).count) { "$([char]187)" + $pushd }) }
    { "$fore;22m$back;5m{0}" -f $rightArrow }

    { "$back;5m$fore;${forePromptColor}m{0}" -f $($pwd.Drive.Name) }
    { "$back;14m$fore;5m{0}" -f $rightArrow }

    { "$back;14m$fore;${forePromptColor}m{0}$esc[0m" -f $(Split-Path $pwd -leaf) }
)
