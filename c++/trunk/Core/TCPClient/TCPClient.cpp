// TCPClient.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"


CTCPIOCP client;


int _tmain(int argc, _TCHAR* argv[])
{
	if(client.Connect("127.0.0.1", 3000))
	{
		printf("���ӷ������ɹ���\r\n");
	}

	TestPackage* pkg = new TestPackage;

	for (int i = 0; i < 100; i++)
	{
		//printf("�������ݰ���\r\n");
		client.SendTCP(pkg);
	}

	client.SendTCP2();

	printf("��������˳�!\r\n");

	_getch();

	return 1;
}

