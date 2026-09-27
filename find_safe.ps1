$lines = Get-Content -Path "conversion_report.txt" -Encoding UTF8
$currentFile = ""
foreach ($line in $lines) {
    if ($line -match "^Файл:\s*(.+)$") {
        $currentFile = $Matches[1].Trim()
    }
    if ($line -match "БЕЗОПАСНО" -and $currentFile -ne "") {
        Write-Output $currentFile
        $currentFile = ""
    }
}