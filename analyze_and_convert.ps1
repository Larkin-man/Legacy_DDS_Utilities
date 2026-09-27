Add-Type -AssemblyName System.Drawing

$outFolder = "Out"
if (-not (Test-Path $outFolder)) {
    New-Item -ItemType Directory -Path $outFolder | Out-Null
}

$logFile = "convert_log.txt"
"============================================================" | Out-File $logFile -Encoding UTF8
" Automatic DXT3 to DXT1 Conversion" | Out-File $logFile -Append -Encoding UTF8
"============================================================" | Out-File $logFile -Append -Encoding UTF8
"" | Out-File $logFile -Append -Encoding UTF8

$safeCount = 0
$unsafeCount = 0
$errorCount = 0

Write-Host "Starting analysis and conversion..." -ForegroundColor Cyan
Write-Host ""

$pngFiles = Get-ChildItem -Path $outFolder -Filter "*.png"
foreach ($file in $pngFiles) {
    try {
        # 1. Analyze alpha channel
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        $ms = New-Object System.IO.MemoryStream(,$bytes)
        $bmp = New-Object System.Drawing.Bitmap($ms)
        $allOpaque = $true
        
        for ($y = 0; $y -lt $bmp.Height -and $allOpaque; $y++) {
            for ($x = 0; $x -lt $bmp.Width -and $allOpaque; $x++) {
                if ($bmp.GetPixel($x, $y).A -lt 255) {
                    $allOpaque = $false
                }
            }
        }
        
        $bmp.Dispose()
        $ms.Dispose()
        
        # Get original DDS filename
        $ddsName = $file.BaseName + ".dds"
        
        # 2. Act based on result
        if ($allOpaque) {
            Write-Host "[$ddsName] SAFE. Converting to DXT1..." -ForegroundColor Green
            
            if (Test-Path $ddsName) {
                # Call texconv.exe directly with proper array syntax
                $texconvArgs = "-nologo", "-f", "BC1_UNORM", "-o", $outFolder, $ddsName
                & .\texconv.exe $texconvArgs | Out-Null
                
                if ($LASTEXITCODE -eq 0) {
                    "File: $ddsName" | Out-File $logFile -Append -Encoding UTF8
                    "  [OK] Converted to DXT1 (BC1) in Out folder" | Out-File $logFile -Append -Encoding UTF8
                    "" | Out-File $logFile -Append -Encoding UTF8
                    $safeCount++
                } else {
                    "File: $ddsName" | Out-File $logFile -Append -Encoding UTF8
                    "  [ERROR] texconv failed to convert the file" | Out-File $logFile -Append -Encoding UTF8
                    "" | Out-File $logFile -Append -Encoding UTF8
                    $errorCount++
                }
            } else {
                "File: $ddsName" | Out-File $logFile -Append -Encoding UTF8
                "  [ERROR] Original DDS file not found in current folder" | Out-File $logFile -Append -Encoding UTF8
                "" | Out-File $logFile -Append -Encoding UTF8
                $errorCount++
            }
        } else {
            Write-Host "[$ddsName] UNSAFE (has transparency). Skipping." -ForegroundColor Yellow
            $unsafeCount++
        }
    }
    catch {
        Write-Host "[$($file.Name)] ANALYSIS ERROR: $_" -ForegroundColor Red
        $errorCount++
    }
}

# 3. Summary
"============================================================" | Out-File $logFile -Append -Encoding UTF8
" SUMMARY:" | Out-File $logFile -Append -Encoding UTF8
" Converted safely: $safeCount" | Out-File $logFile -Append -Encoding UTF8
" Skipped (has transparency): $unsafeCount" | Out-File $logFile -Append -Encoding UTF8
" Errors: $errorCount" | Out-File $logFile -Append -Encoding UTF8
"============================================================" | Out-File $logFile -Append -Encoding UTF8

Write-Host ""
Write-Host "Done! Log saved to $logFile" -ForegroundColor Cyan