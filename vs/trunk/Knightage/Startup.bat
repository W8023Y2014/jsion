@echo off

@rem echo ��ǰ������·����%~dp0

%~d0
cd %~dp0CenterServerApp\bin\Debug
echo �������ķ�����...
start CenterServerApp.exe

cd %~dp0GameServerApp\bin\Debug
echo ������Ϸ������...
start GameServerApp.exe


cd %~dp0BattleServerApp\bin\Debug
echo ����ս��������...
start BattleServerApp.exe

cd %~dp0GatewayServerApp\bin\Debug
echo �������ط�����...
start GatewayServerApp.exe

@rem pause