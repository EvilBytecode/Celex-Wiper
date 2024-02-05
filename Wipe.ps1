if (-not ([Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}

function CelexPrefetch {
    $celexprefetcj = Get-ChildItem -Path "C:\Windows\Prefetch" -Filter "*CELEX.EXE*.pf"

    if ($celexprefetcj) {
        $celexprefetcj | ForEach-Object {
            Write-Host -ForegroundColor Green "[+] Found in Prefetch: Celex Trace Deleting It : $($_.FullName)" 
            Remove-Item $_.FullName -Force
        }
    } else {
        Write-Host -ForegroundColor Red "[-] No Celex Trace in Prefetch."
    }
}

function CelexAppData {
    $celexappdat = "C:\Users\$env:USERNAME\AppData\Roaming\celex-v2"

    if (Test-Path $celexappdat) {
        Write-Host -ForegroundColor Green "[+] Detected: celex-v2 folder. Deleting..."
        Remove-Item $celexappdat -Recurse -Force
    } else {
        Write-Host -ForegroundColor Red "[-] celex-v2 folder not found."
    }
}

CelexPrefetch
CelexAppData

Start-Sleep -Seconds 10
