@echo off

echo �ر����ط�����...
taskkill /f /t /im GatewayServerApp.exe

echo �ر�ս��������...
taskkill /f /t /im BattleServerApp.exe

echo �ر���Ϸ������...
taskkill /f /t /im GameServerApp.exe

if 1 == 0 (
echo �رջ��������...
taskkill /f /t /im CacheServerApp.exe
)

echo �ر����ķ�����...
taskkill /f /t /im CenterServerApp.exe

@rem pause