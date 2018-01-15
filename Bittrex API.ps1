param(
$APIKey,
$APISecret
)

$ReadInfoKey = ""
#API secret is given by bittrex, I had to get a new api key to get my secret
$apisecret=''

$nonce= [int][double]::Parse((Get-Date -UFormat %s))
#Invoke-WebRequest "https://bittrex.com/api/v1.1/account/getbalances?apikey=$ReadInfoKey"&currency=BTC



function hmac($message, $secret) {
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA512
    $hmacsha.key = [Text.Encoding]::ASCII.GetBytes($secret)
    $signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($message))
    $signature = -join($signature |ForEach-Object ToString X2).ToLower()
    return $signature
}


$URI = "https://bittrex.com/api/v1.1/account/getdepositaddress?apikey=$ReadInfoKey&currency=ETH&nonce=$nonce"

$sig = hmac -message $uri -secret $apisecret

$header = @{
        "apisign" = $sig
    }

$USDTBCC = (invoke-webrequest "https://bittrex.com/api/v1.1/public/getticker?market=USDT-BCC").content | ConvertFrom-Json
if ($USDTBCC.success -eq "true")
{
"Bid $($USDTBCC.result.bid)"
"Ask $($USDTBCC.result.Ask)"
"Last $($USDTBCC.result.Last)"
}

$result = Invoke-WebRequest "$URI" -Headers $header