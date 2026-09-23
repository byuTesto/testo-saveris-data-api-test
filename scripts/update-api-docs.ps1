param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetScript = Join-Path $ScriptDir "../skills/api-doc-update/scripts/update-api-docs.ps1"
& $TargetScript @Args
exit $LASTEXITCODE
