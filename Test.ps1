# Ferme Edge proprement
Write-Host "Fermeture d'Edge..." -ForegroundColor Yellow
Stop-Process -Name msedge -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Chemins à nettoyer (SAFE uniquement)
$pathsToClean = @(
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\Cache",
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\Code Cache",
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\GPUCache",
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\DawnCache",
    "$env:LocalAppData\Microsoft\Edge\User Data\ShaderCache",
    "$env:LocalAppData\Microsoft\Edge\User Data\GrShaderCache",
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\Media Cache",
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage",
    "$env:LocalAppData\Microsoft\Edge\User Data\Default\Service Worker\ScriptCache",
    "$env:LocalAppData\Microsoft\Edge\User Data\Crashpad",
    "$env:Temp\MicrosoftEdge*"
)

$totalFreed = 0

foreach ($path in $pathsToClean) {
    if (Test-Path $path) {
        $sizeBefore = (Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue | 
            Measure-Object -Property Length -Sum).Sum / 1MB
        
        Write-Host "Nettoyage: $path" -ForegroundColor Cyan
        # Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        
        $totalFreed += $sizeBefore
        Write-Host "  → $('{0:N2}' -f $sizeBefore) MB libérés" -ForegroundColor Green
    }
}

Write-Host "`nTotal libéré: $('{0:N2}' -f $totalFreed) MB" -ForegroundColor Green
Write-Host "Edge peut être redémarré en toute sécurité!" -ForegroundColor Yellow