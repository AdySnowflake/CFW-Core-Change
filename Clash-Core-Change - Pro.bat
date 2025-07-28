@echo off
setlocal enabledelayedexpansion
rem 将活动代码页更改为 UTF-8（65001），以支持显示特殊字符
chcp 65001 > nul

rem 1. 重命名需要切换的内核，包括以 "clash." 和 "mihomo" 开头的文件
for %%F in (clash.* mihomo*) do (
    set "newfilename=newkernel"
    set "extension=%%~xF"
    ren "%%F" "!newfilename!!extension!"
)

rem 2. 结束Clash进程
taskkill /F /IM "Clash for Windows.exe" > nul 2>&1

rem 3. 获取内核大小
set NewKernel=newkernel.exe
set OriginalKernel=clash-win64.exe

for %%F in ("!NewKernel!") do set "size_NewKernel=%%~zF"
for %%F in ("!OriginalKernel!") do set "size_OriginalKernel=%%~zF"

rem 4. 比较内核大小&切换内核并输出切换信息
set "tempfile=temp.exe" 
rename "!NewKernel!" "%tempfile%"

if !size_NewKernel! lss !size_OriginalKernel! (
    rename "!OriginalKernel!" "clash.meta.exe"
    msg * 切换Premium内核成功！
) else if !size_NewKernel! gtr !size_OriginalKernel! (
    rename "!OriginalKernel!" "clash.premium.exe"
    msg * 切换Meta内核成功！
)
rename "%tempfile%" "!OriginalKernel!"

rem 5. 启动Clash应用程序
start "" "%LocalAppData%\Programs\Clash for Windows\Clash for Windows.exe"