// TCPClient.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"


CTCPIOCP client;


int _tmain(int argc, _TCHAR* argv[])
{
	if(client.Connect("127.0.0.1", 3000))
	{
		printf("���ӷ������ɹ���");
	}

	TestPackage* pkg = new TestPackage;

	client.SendTCP(pkg);

	printf("��������˳�!\r\n");

	_getch();

	return 1;
}

