param(
    [ValidateSet("all", "data", "real-time", "realtime", "stomp", "rest")]
    [string]$Target = "all"
)

$BaseUrl = "https://api-docs.eu.p.savr.saveris.net"
$SkillDir = Split-Path -Parent $PSScriptRoot
$ReferencesDir = Join-Path $SkillDir "references"
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
    $Pattern = "{0}-*.{1}" -f $FileName, $Extension.TrimStart('.')

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

    $Directory = Split-Path -Parent $Destination
    if (-not (Test-Path $Directory)) {
        New-Item -ItemType Directory -Path $Directory -Force | Out-Null
    }

    Invoke-WebRequest -Uri $Url -OutFile $Destination
}

function Sanitize-DocFile {
    param(
        [string]$FilePath
    )

    if (-not (Test-Path $FilePath)) {
        return
    }

    $Content = Get-Content -Path $FilePath -Raw -Encoding UTF8

    $Content = $Content.Replace("REGION.ENV", "{testo_env}")
    $Content = $Content.Replace("eu.i", "{testo_env}")
    $Content = $Content.Replace("eu.p", "{testo_env}")
    $Content = $Content.Replace("{region}.{stage}", "{testo_env}")
    $Content = [System.Text.RegularExpressions.Regex]::Replace(
        $Content,
        ",\s*\{\s*\"url\":\s*\"https://data-api\.eu\.smartconnect\.testo\.com/\",\s*\"description\":\s*\"Smart Connect API\"\s*\}",
        "",
        [System.Text.RegularExpressions.RegexOptions]::Singleline
    )
    $Content = [System.Text.RegularExpressions.Regex]::Replace(
        $Content,
        "\{\s*\"url\":\s*\"https://data-api\.eu\.smartconnect\.testo\.com/\",\s*\"description\":\s*\"Smart Connect API\"\s*\}",
        "",
        [System.Text.RegularExpressions.RegexOptions]::Singleline
    )

    Set-Content -Path $FilePath -Value $Content -Encoding UTF8
}

function Sync-DatedDoc {
    param(
        [string]$Url,
        [string]$Directory,
        [string]$BaseName
    )

    if (-not (Test-Path $Directory)) {
        New-Item -ItemType Directory -Path $Directory -Force | Out-Null
    }

    $FileName = [System.IO.Path]::GetFileNameWithoutExtension($BaseName)
    $Extension = [System.IO.Path]::GetExtension($BaseName)
    $DatedPath = Join-Path $Directory ("{0}-{1}{2}" -f $FileName, $DateSuffix, $Extension)

    if (Test-Path $DatedPath) {
        Sanitize-DocFile -FilePath $DatedPath
        Cleanup-LegacyVersions -Directory $Directory -BaseName $BaseName -KeepPath $DatedPath
        Write-Host "Already up to date: $DatedPath"
        return
    }

    Download-File -Url $Url -Destination $DatedPath
    Sanitize-DocFile -FilePath $DatedPath
    Cleanup-LegacyVersions -Directory $Directory -BaseName $BaseName -KeepPath $DatedPath
}

function Update-DataApi {
    $Url = "$BaseUrl/data-api/data-api-docs.json"
    $Directory = Join-Path $ReferencesDir "data-api"

    Sync-DatedDoc -Url $Url -Directory $Directory -BaseName "data-api-docs.json"
}

function Update-RealTimeApi {
    $AsyncUrl = "$BaseUrl/real-time-api/async-api.yaml"
    $OpenApiUrl = "$BaseUrl/real-time-api/openapi/openapi.yaml"
    $Directory = Join-Path $ReferencesDir "real-time-api"

    Sync-DatedDoc -Url $AsyncUrl -Directory $Directory -BaseName "async-api.yaml"
    Sync-DatedDoc -Url $OpenApiUrl -Directory $Directory -BaseName "openapi.yaml"
}

switch ($Target) {
    "data" { Update-DataApi }
    "real-time" { Update-RealTimeApi }
    "realtime" { Update-RealTimeApi }
    "stomp" { Update-RealTimeApi }
    "rest" { Update-RealTimeApi }
    default { Update-DataApi; Update-RealTimeApi }
}

Write-Host "Processed API docs using base URL: $BaseUrl"
