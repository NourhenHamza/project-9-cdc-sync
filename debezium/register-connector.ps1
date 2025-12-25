Write-Host "Waiting for Kafka Connect to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

Write-Host "`nRegistering PostgreSQL connector..." -ForegroundColor Green
$body = Get-Content -Path "postgres-connector.json" -Raw

$response = Invoke-RestMethod -Uri "http://localhost:8083/connectors/" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body

Write-Host "`nConnector registered successfully!" -ForegroundColor Green
Write-Host ($response | ConvertTo-Json -Depth 10)

Write-Host "`nChecking connector status..." -ForegroundColor Yellow
$status = Invoke-RestMethod -Uri "http://localhost:8083/connectors/postgres-products-connector/status"
Write-Host ($status | ConvertTo-Json -Depth 10)