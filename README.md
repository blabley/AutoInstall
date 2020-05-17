# AutoInstall
Scripted install for Windows

## History
For many years now I've been creating my own Automated Windows install's. This started with a need for a client to deploy Windows XP to many different machines, due to the hardware differance the SysPrep method wasn't going to cut it. So WINNT.SIF was editied, and the journey started.

As I've always turned to batch files the auto install scripts started.

## Usage
Copy the below into your autounattened.xml which is on the root of your install.
If you don't have one, check out [my Unattened Install files](https://github.com/blabley/AutoUnattend).

```xml
     <SynchronousCommand wcm:action="add">
      <CommandLine>powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "New-Item “$env:systemroot\Install” -ItemType directory"</CommandLine>
      <Order>95</Order>
     </SynchronousCommand>
     <SynchronousCommand wcm:action="add">
      <CommandLine>powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-WebRequest -UseBasicParsing "https://github.com/blabley/AutoInstall/archive/master.zip" -OutFile "$env:systemroot\Install\AutoInstall.zip" -PassThru"</CommandLine>
      <Order>96</Order>
     </SynchronousCommand>
     <SynchronousCommand wcm:action="add">
      <CommandLine>powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Expand-Archive -Path $env:systemroot\Install\AutoInstall.zip -DestinationPath $env:systemroot\Install -Force"</CommandLine>
      <Order>97</Order>
     </SynchronousCommand>
     <SynchronousCommand wcm:action="add">
      <CommandLine>powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Move-Item -LiteralPath $env:systemroot\Install\AutoInstall-master -Destination $env:systemdrive\Install -Force"</CommandLine>
      <Order>98</Order>
     </SynchronousCommand>
     <SynchronousCommand wcm:action="add">
      <CommandLine>cmd /c "%systemdrive%\Install\AutoInstall"</CommandLine>
      <Order>99</Order>
     </SynchronousCommand>
```
_I know it's not the cleanest way to do it, it is version 1 of the above... Feel free to let me know the better way_

## License
[MIT](https://choosealicense.com/licenses/mit/), I guess ;-)
