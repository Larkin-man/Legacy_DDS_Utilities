Add-Type -AssemblyName System.Drawing

$inputFile = $args[0]
$outputFile = $args[1]

if (-not $inputFile -or -not $outputFile) {
    Write-Host "Usage: make_alpha.ps1 input.png output.png"
    exit 1
}

$img = [System.Drawing.Image]::FromFile($inputFile)
$bmp = New-Object System.Drawing.Bitmap($img.Width, $img.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.DrawImage($img, 0, 0, $img.Width, $img.Height)

$transparentCount = 0

for ($y = 0; $y -lt $bmp.Height; $y++) {
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        
        # STRICT: only pure black (0,0,0) becomes transparent
        if ($pixel.R -eq 0 -and $pixel.G -eq 0 -and $pixel.B -eq 0) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
            $transparentCount++
        } else {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $pixel.R, $pixel.G, $pixel.B))
        }
    }
}

$bmp.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$img.Dispose()
$g.Dispose()

Write-Host "  Alpha: $transparentCount transparent pixels"