// TCPServer.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"


CTCPIOCP server;

int _tmain(int argc, _TCHAR* argv[])
{
	if (server.Listen(3000))
	{
		printf("�����˿ڣ�%d �ɹ�!\r\n", 3000);
	}

	printf("��������˳�!\r\n");

	_getch();

	return 1;
}

