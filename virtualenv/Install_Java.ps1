# Set path to hats
$path_to_hats = "$env:APPDATA\hats"

echo "Create JDK folder in $path_to_hats"
If(!(test-path $path_to_hats))
{
	New-Item -ItemType Directory -Force -Path $path_to_hats
}

echo "Preparing to download JDK 8"
$client = new-object System.Net.WebClient;
$cookie = "oraclelicense=accept-securebackup-cookie"
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie) 

if ([System.IntPtr]::Size -eq 4) 
{
	echo "Your system is 32-bit - Downloading..." 
	$client.DownloadFile("https://downloads.sourceforge.net/project/portableapps/Java%20Portable/jPortable_8_Update_131.paf.exe","$path_to_hats\jdk.exe");
}	
else 
{
	echo "Your system is 64-bit - Downloading..."
	$client.DownloadFile("https://downloads.sourceforge.net/project/portableapps/Java%20Portable/jPortable64_8_Update_131.paf.exe","$path_to_hats\jdk.exe");

}

echo "Downloaded JDK 8"

echo "Downloading 7-Zip"
$client.DownloadFile("http://www.7-zip.org/a/7z1700.msi","$path_to_hats\7z.msi");

echo "Installing 7-Zip"
Start-Process msiexec.exe -ArgumentList "/a $path_to_hats\7z.msi /qn TargetDir=$path_to_hats\7-Zip PrependPath=0 Include_test=0 DefaultFeature=1" -NoNewWindow -Wait;

echo "Unzipping JDK 8"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"jdk.exe"', '-o"jdk"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"

echo "Completed unzipping JDK 8"

echo "Set path to JDK for this session"
$env:Path = "$env:Path:$path_to_hats\jdk\bin";
