@echo off
setlocal enabledelayedexpansion
rem 将活动代码页更改为 UTF-8（65001），以支持显示特殊字符
chcp 65001 > nul

rem 将变量 `prefix` 的值设置为 "clash.meta"
set "prefix=clash.meta"

rem 1. 重命名需要切换的内核
for %%F in (%prefix%*) do (
    set "filename=%%~nF"
    set "extension=%%~xF"
    ren "%%F" "!prefix!!extension!"
)

rem 2. 结束Clash进程
taskkill /F /IM "Clash for Windows.exe" > nul 2>&1

rem 3. 交换内核文件名
set "var1=clash.meta.exe"
set "var2=clash-win64.exe"
set "tempfile=temp.exe"

rename "!var1!" "!tempfile!"
rename "!var2!" "!var1!"
rename "!tempfile!" "!var2!"

rem 4. 获取内核大小
for %%F in ("!var1!") do set "size_var1=%%~zF"
for %%F in ("!var2!") do set "size_var2=%%~zF"

rem 5. 比较内核大小，输出切换信息
if !size_var2! lss !size_var1! (
    msg * 切换Premium内核成功！
) else if !size_var2! gtr !size_var1! (
    msg * 切换Meta内核成功！
)

rem 6. 启动Clash应用程序
start "" "%LocalAppData%\Programs\Clash for Windows\Clash for Windows.exe"