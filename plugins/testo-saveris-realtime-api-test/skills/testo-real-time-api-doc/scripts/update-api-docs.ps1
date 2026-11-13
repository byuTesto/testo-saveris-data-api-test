$ErrorActionPreference = "Stop"

$BaseUrl = "https://api-docs.eu.p.savr.saveris.net"

$SkillName = "testo-real-time-api-doc"
$SkillDir = Split-Path -Parent $PSScriptRoot
$ReferencesDir = Join-Path $SkillDir "references"

# Refuse to write anywhere other than the testo-real-time-api-doc skill's references folder.
$SkillFile = Join-Path $SkillDir "SKILL.md"
if (-not ((Test-Path $SkillFile) -and (Select-String -Path $SkillFile -Pattern "^name:\s*$SkillName\s*$" -Quiet))) {
    Write-Error "$SkillDir is not the $SkillName skill directory; refusing to download."
    exit 1
}

$DateSuffix = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")

function Cleanup-LegacyVersions {
    param(
        [string]$Directory,
        [string]$BaseName,
        [string]$KeepPath
    )

    $FileName = [System.IO.Path]::GetFileNameWithoutExtension($BaseName)
    $Extension = [System.IO.Path]::GetExtension($BaseName)
    $LegacyPath = Join-Path $Directory $BaseName
    $Pattern = "{0}-*{1}" -f $FileName, $Extension

    if (Test-Path $LegacyPath) {
        Remove-Item -Path $LegacyPath -Force
    }

    $Archives = Get-ChildItem -Path $Directory -Filter $Pattern -File -ErrorAction SilentlyContinue
    foreach ($Archive in $Archives) {
        if ($Archive.FullName -ne $KeepPath) {
            Remove-Item -Path $Archive.FullName -Force
        }
    }
}

function Download-File {
    param(
        [string]$Url,
        [string]$Destination
    )

    $TmpFile = "$Destination.tmp"
    try {
        Invoke-WebRequest -Uri $Url -OutFile $TmpFile -UseBasicParsing
        Move-Item -Path $TmpFile -Destination $Destination -Force
    }
    finally {
        if (Test-Path $TmpFile) {
            Remove-Item -Path $TmpFile -Force
        }
    }
}

function Sanitize-DocFile {
    param(
        [string]$FilePath
    )

    $Content = Get-Content -Path $FilePath -Raw -Encoding UTF8

    $Content = $Content.Replace("REGION.ENV", "{testo_env}")
    $Content = $Content.Replace("eu.i", "{testo_env}")
    $Content = $Content.Replace("eu.p", "{testo_env}")
    $Content = $Content.Replace("{region}.{stage}", "{testo_env}")

    [System.IO.File]::WriteAllText($FilePath, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

function Sync-DatedDoc {
    param(
        [string]$Url,
        [string]$BaseName
    )

    if (-not (Test-Path $ReferencesDir)) {
        New-Item -ItemType Directory -Path $ReferencesDir -Force | Out-Null
    }

    $FileName = [System.IO.Path]::GetFileNameWithoutExtension($BaseName)
    $Extension = [System.IO.Path]::GetExtension($BaseName)
    $DatedPath = Join-Path $ReferencesDir ("{0}-{1}{2}" -f $FileName, $DateSuffix, $Extension)

    if (Test-Path $DatedPath) {
        Write-Host "Already up to date: $DatedPath"
    }
    else {
        Download-File -Url $Url -Destination $DatedPath
        Write-Host "Downloaded: $DatedPath"
    }

    Sanitize-DocFile -FilePath $DatedPath
    Cleanup-LegacyVersions -Directory $ReferencesDir -BaseName $BaseName -KeepPath $DatedPath
}

Sync-DatedDoc -Url "$BaseUrl/real-time-api/async-api.yaml" -BaseName "async-api.yaml"
Sync-DatedDoc -Url "$BaseUrl/real-time-api/openapi/openapi.yaml" -BaseName "openapi.yaml"

Write-Host "Processed Real-Time API docs using base URL: $BaseUrl"
