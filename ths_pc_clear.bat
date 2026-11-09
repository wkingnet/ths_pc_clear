@echo off
:: 设置编码为UTF-8防乱码
chcp 65001 >nul
clear
title 同花顺PC端一键优化与安全清理工具

echo ===================================================
echo        同花顺PC端一键优化与安全清理工具
echo ===================================================
echo 提示：本脚本仅清理无用缓存，不会删除自选股与指标公式！

echo ---------------------------------------------------
set "THS_DIR=%~dp0"
echo [+] 成功识别同花顺路径: %THS_DIR%

echo ---------------------------------------------------
echo 正在关闭同花顺所有进程...

for %%i in (
    hexin.exe
    xiadan.exe
    UserGuide.exe
    updater.exe
    ths_service.exe
    ThsWebFrame.exe
    hxdaemonprocess.exe
    hxperformance.exe
    hexinhelper.exe
    HxDataService.exe
) do (
    taskkill /f /im "%%i" >nul 2>&1
)

REM 等待 2 秒，确保所有残留进程彻底释放
timeout /t 2 /nobreak >nul

echo ---------------------------------------------------
echo 正在全力清理中，请稍候...

:: 1. 清理升级遗留的安装包和临时日志文件
if exist "%THS_DIR%\system\upgrade" (
    del /f /s /q "%THS_DIR%\system\upgrade\*.*" >nul 2>&1
    echo [✓] 升级遗留安装包清理完毕
)
if exist "%THS_DIR%\log" (
    rd /s /q "%THS_DIR%\log" >nul 2>&1
    echo [✓] 系统运行日志清理完毕
)

:: 2. 清理F10、资讯、热点及广告弹窗缓存
if exist "%THS_DIR%\history\f10" (
    rd /s /q "%THS_DIR%\history\f10" >nul 2>&1
    echo [✓] 历史F10资讯数据清理完毕
)
if exist "%THS_DIR%\history\info" (
    rd /s /q "%THS_DIR%\history\info" >nul 2>&1
    echo [✓] 历史财联社/资讯缓存清理完毕
)

:: 3. 清理内置浏览器缓存（ThsWebFrame常驻占用的垃圾）
if exist "%THS_DIR%\system\ThsWebFrame\Cache" (
    rd /s /q "%THS_DIR%\system\ThsWebFrame\Cache" >nul 2>&1
    echo [✓] 内置浏览器网页缓存清理完毕
)
if exist "%THS_DIR%\system\ThsWebFrame\cookies" (
    del /f /q "%THS_DIR%\system\ThsWebFrame\cookies\*.*" >nul 2>&1
    echo [✓] 浏览器Cookie清理完毕
)

:: 4. 清理诊断和诊股相关的AI及图片缓存
if exist "%THS_DIR%\history\diagnosis" (
    rd /s /q "%THS_DIR%\history\diagnosis" >nul 2>&1
    echo [✓] 智能诊股缓存清理完毕
)

:: 5. 清理历史分时和日线缓存（非核心，下次开盘会自动重新下载最新数据）
if exist "%THS_DIR%\history\min" (
    rd /s /q "%THS_DIR%\history\min" >nul 2>&1
    echo [✓] 历史分时缓存清理完毕
)

echo ---------------------------------------------------
echo 禁用不必要进程的权限，防止运行

for %%i in (
    UserGuide.exe
    hexinhelper.exe
    HxDataService.exe
    hxexternal.exe
    updateworking
    hxdaemonprocess
    performance
    cef84
) do (
    icacls %%i /inheritance:r >nul 2>&1
    icacls %%i /remove Everyone >nul 2>&1
)

echo ===================================================
echo [★] 同花顺优化清理完成！重新启动软件即可享受流畅体验。
echo ===================================================
pause
