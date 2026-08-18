@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ========================================
echo  Novel Creator - Dev Run
echo ========================================

REM --- 检查 .env ---
if not exist "1-novel-shell\.env" (
    echo [INFO] 未找到 .env，已从 .env.example 复制模板
    copy "1-novel-shell\.env.example" "1-novel-shell\.env" >nul
    echo [WARN] 请编辑 1-novel-shell\.env 填入 LLM_API_KEY 后再用
)

REM --- 创建日志目录 ---
if not exist "workspace-data\logs" mkdir "workspace-data\logs"

REM --- 启动开发模式 ---
echo [RUN] 启动 Electron 开发窗口 (electron-vite dev)...
cd 1-novel-shell
start "" explorer "workspace-data\logs"
call pnpm exec electron-vite dev

endlocal
