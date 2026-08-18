@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ========================================
echo  Novel Creator - Init Setup
echo ========================================

REM --- 检查 Node ---
where node >nul 2>&1
if errorlevel 1 (
    echo [ERR] 未检测到 Node.js，请安装 Node 18/20/22 LTS（勿用 24）
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('node -v') do echo [OK] Node: %%v

REM --- 检查 pnpm ---
where pnpm >nul 2>&1
if errorlevel 1 (
    echo [INFO] 未检测到 pnpm，尝试安装...
    call npm i -g pnpm
    if errorlevel 1 (
        echo [ERR] pnpm 安装失败，请手动安装
        pause
        exit /b 1
    )
)
for /f "tokens=*" %%v in ('pnpm -v') do echo [OK] pnpm: %%v

REM --- 创建 E:\skill 目录（SkillLoader 运行时真读此处）---
if not exist "E:\skill" (
    mkdir "E:\skill"
    echo [OK] 已创建 E:\skill
) else (
    echo [OK] E:\skill 已存在
)

REM --- 安装依赖 ---
echo [RUN] pnpm install...
call pnpm install --ignore-scripts
if errorlevel 1 (
    echo [FAIL] pnpm install 失败
    pause
    exit /b 1
)

REM --- 批准原生模块构建（better-sqlite3 / electron）---
echo [RUN] 批准原生模块构建（approve-builds）...
echo y | pnpm approve-builds 2>nul

REM --- 创建数据目录 ---
if not exist "workspace-data\logs" mkdir "workspace-data\logs"
echo [OK] 已创建 workspace-data\logs

REM --- 复制 .env 模板 ---
if not exist "1-novel-shell\.env" (
    copy "1-novel-shell\.env.example" "1-novel-shell\.env" >nul
    echo [OK] 已生成 1-novel-shell\.env（请填入 LLM_API_KEY）
)

echo ========================================
echo  初始化完成！
echo  下一步:
echo    运行 build.bat  打包安装包
echo    运行 run.bat    启动开发窗口
echo ========================================
pause
endlocal
