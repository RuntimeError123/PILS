function WriteLog
{
    param(
        [Parameter(ParameterSetName="Message",Mandatory=$true)]
        [String]$Message,
        [Parameter(ParameterSetName="Message",Mandatory=$true)][ValidateSet('Information','Warning','Error')]
        [String]$Severity,
        [Parameter(ParameterSetName="CustomMessage",Mandatory=$true)]
        [String]$CustomMessage
    )

    begin 
    {
        $Date = Get-Date
        $DateMessage = $Date | Get-Date -Format "dd-MM-yyyy HH:mm:ss"
        $DateLog = $Date | Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $DateLogFileName = $Date | Get-Date -Format "yyyyMMdd"

        if ($PILSLogFilePrefix)
        {
            $LogFilePrefix = $PILSLogFilePrefix
        }
        else 
        {
            $LogFilePrefix = "PILS"    
        }

        if ($PILSLogFolder)
        {
            $LogFolder = $PILSLogFolder
        }
        else 
        {
            $LogFolder = $env:TEMP
        }

        $LogFilePath = Join-Path -Path $LogFolder -ChildPath ($LogFilePrefix + "-" + $DateLogFileName + ".txt")
    }
    process
    {
        if($Message)
        {
            Write-Host "[$DateMessage] " -NoNewline
            Write-Host "[" -NoNewline
            switch ($Severity)
            {
                "Information"
                {
                    Write-Host -ForegroundColor Cyan "Information" -NoNewline
                }
                "Warning"
                {
                    Write-Host -ForegroundColor Yellow "Warning    " -NoNewline
                }
                "Error"
                {
                    Write-Host -ForegroundColor Red "Error      " -NoNewline
                }
            }
            Write-Host "] " -NoNewline
            Write-Host $Message
            "[$DateLog] - $Severity - $Message" | Out-File -FilePath $LogFilePath -Append
        }
        
        if($CustomMessage)
        {
            Write-Output "[$DateMessage] $CustomMessage
            "[$DateLog] $CustomMessage | Out-File -FilePath $LogFilePath -Append
            
        }
    }
    end {}
}

