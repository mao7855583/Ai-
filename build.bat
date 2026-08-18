@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ========================================
echo  Novel Creator - Build ^& Package
echo ========================================

REM --- 前置检查 ---
where node >nul 2>&1
if errorlevel 1 (
    echo [ERR] 未检测到 Node.js，请先安装 Node 18/20/22 LTS
    pause
    exit /b 1
)
where pnpm >nul 2>&1
if errorlevel 1 (
    echo [ERR] 未检测到 pnpm，请先运行 npm i -g pnpm
    pause
    exit /b 1
)

REM --- Step 1: 安装依赖 ---
echo [1/3] 安装依赖 (pnpm install)...
call pnpm install
if errorlevel 1 (
    echo [FAIL] pnpm install 失败
    pause
    exit /b 1
)
echo [OK] 依赖就绪

REM --- Step 2: electron-vite 构建 ---
echo [2/4] 构建渲染/主/预加载进程 (electron-vite build)...
cd 1-novel-shell
call pnpm exec electron-vite build
if errorlevel 1 (
    echo [FAIL] electron-vite build 失败
    pause
    exit /b 1
)
echo [OK] Vite 构建完成

REM --- Step 3: 准备 workspace 包 ---
echo [3/4] 复制 workspace 包到 node_modules...
node scripts/prepare-workspace.js
if errorlevel 1 (
    echo [FAIL] prepare-workspace 失败
    pause
    exit /b 1
)
echo [OK] Workspace 包就绪

REM --- Step 4: electron-builder 打包 nsis 安装包 ---
echo [4/4] 打包安装包 (electron-builder --win nsis)...
set npm_config_build_from_source=false
call pnpm exec electron-builder --win nsis --publish never
if errorlevel 1 (
    echo [FAIL] electron-builder 打包失败
    pause
    exit /b 1
)

echo ========================================
echo  打包完成！
echo  产物: 1-novel-shell\dist\Novel Creator Setup 1.0.0.exe
echo ========================================
pause
endlocal
