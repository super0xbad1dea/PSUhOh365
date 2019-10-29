<#
  .SYNOPSIS
    Shout out to @raikiasec. Convert his Python Script "UhOh365" to PowerShell

  .DESCRIPTION
    A script that can see if an email address is valid in Office365 (user/email enumeration). This does not perform any login attempts, is unthrottled, and is incredibly useful for social engineering assessments to find which emails exist and which don't.

  .PARAMETER email
    Define a single email address

  .PARAMETER list
    Path to a file with one email address per line
    
  .EXAMPLE
    # Check the availability of a single S3Bucket
    PS  > .\UhOh365.ps1 -email joe.doe@example.com
    Valid O365 email address found:  joe.doe@example.com
   
  .EXAMPLE
    # Check the availability of a list of S3Buckets
    PS  > .\UhOh365.ps1 -emaillist .\email.txt
    Valid O365 email address found:  joe.doe@example.com
    Email addresses processed:  2
#>

param(
    [string]$email,
    [string]$emaillist
    )


function checkemail ([string] $femail){
    $request = 'https://outlook.office365.com/autodiscover/autodiscover.json/v1.0/'+ $femail +'?Protocol=Autodiscoverv1'
    $status = (Invoke-WebRequest -UserAgent "Microsoft Office/16.0 (Windows NT 10.0; Microsoft Outlook 16.0.12026; Pro)" -Headers @{'Accept'='application/json'} -MaximumRedirection 0 -URI $request -ErrorAction Ignore).StatusCode
    if($status -eq 200){
        Write-Host "Valid O365 email address found: " $femail
    }
}

function processlist ([string] $femaillist){
    $list=(Get-Content -Path $femaillist)
    $counter=0
    foreach($address in $list){
        checkemail($address)
        $counter++
    }
    Write-Host "Email addresses processed: "$counter
}



## MAIN
if($email){
    checkemail($email)    
}
if($emaillist){
    processlist($emaillist)
}
