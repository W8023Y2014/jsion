// TCPServer.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"

#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>
#include <crtdbg.h>

CTCPIOCP server;

int _tmain(int argc, _TCHAR* argv[])
{
	if (server.Listen(3000))
	{
		printf("�����˿ڣ�%d �ɹ�!\r\n", 3000);
	}

	printf("��������˳�!\r\n");

	_getch();
	_CrtDumpMemoryLeaks();
 	return 1;
}

