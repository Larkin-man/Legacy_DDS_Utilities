$pngFiles = Get-ChildItem -Path "Out" -Filter "*.png" 
foreach ($file in $pngFiles) 
{
	$bytes = [System.IO.File]::ReadAllBytes($file.FullName) 
	$ms = New-Object System.IO.MemoryStream(,$bytes) 
	$bmp = New-Object System.Drawing.Bitmap($ms) 
	$allOpaque = $true 
	for($y=0; $y -lt $bmp.Height -and $allOpaque; $y++) 
	{ 
		for($x=0; $x -lt $bmp.Width -and $allOpaque; $x++) 
		{ 
			if($bmp.GetPixel($x,$y).A -lt 255) 
				{ $allOpaque = $false } 
		}
	}
	$bmp.Dispose() 
	$ms.Dispose() 
	if($allOpaque) 
		{ Write-Output "$($file.Name):SAFE" } 
	else 
		{ Write-Output "$($file.Name):UNSAFE" } 
} 
