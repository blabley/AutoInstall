$dlPath = "$($Env:LOCALAPPDATA)\Wallpaper"
$serviceUrl = 'https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-GB'

Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
namespace Wallpaper { 
    public enum Style : int
    { 
        Fill, Fit, Span, Tile, Center, Stretch, NoChange
    }

    public class Setter {
        public const int SetDesktopWallpaper = 20;
        public const int UpdateIniFile = 0x01;
        public const int SendWinIniChange = 0x02;

        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
        
        public static void SetWallpaper (string path, Wallpaper.Style style) {
            SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
            RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
            switch(style) {
                    case Style.Fill :
                    key.SetValue(@"WallpaperStyle", 10.ToString());
                    key.SetValue(@"TileWallpaper", 0.ToString());
                    break;

                    case Style.Fit :
                    key.SetValue(@"WallpaperStyle", 6.ToString());
                    key.SetValue(@"TileWallpaper", 0.ToString());
                    break;
                    
                    case Style.Span :
                    key.SetValue(@"WallpaperStyle", 22.ToString());
                    key.SetValue(@"TileWallpaper", 0.ToString());
                    break;

                    case Style.Stretch :
                    key.SetValue(@"WallpaperStyle", "2") ;
                    key.SetValue(@"TileWallpaper", "0") ;
                    break;

                    case Style.Center :
                    key.SetValue(@"WallpaperStyle", "1") ;
                    key.SetValue(@"TileWallpaper", "0") ;
                    break;

                    case Style.Tile :
                    key.SetValue(@"WallpaperStyle", "1") ;
                    key.SetValue(@"TileWallpaper", "1") ;
                    break;

                    case Style.NoChange :
                    break;
				}
                key.Close();
            }
        }
    }
"@

if(!(Test-Path -Path $dlPath)) {
    New-Item -ItemType Directory -Path $dlPath
    New-Item -ItemType File -Path "$($dlPath)\check.ini"
}

$hsh = Get-Content "$($dlPath)\check.ini"
$result = Invoke-RestMethod -Uri $serviceUrl -Method Get

if(!($hsh -eq $result.images.hsh))
{
    $imgUrl = "https://www.bing.com" + $result.images.url
    Invoke-WebRequest -Uri $imgUrl -OutFile "$($dlPath)\desktop.jpg"
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'Wallpaper' -Value "$($dlPath)\desktop.jpg"
    $result.images.hsh | Out-File "$($dlPath)\check.ini"
    [Wallpaper.Setter]::SetWallpaper("$($dlPath)\desktop.jpg", [Wallpaper.Style]::Fill)
}