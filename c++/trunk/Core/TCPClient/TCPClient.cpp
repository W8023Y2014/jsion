// TCPClient.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"


CTCPIOCP client;


int _tmain(int argc, _TCHAR* argv[])
{
	for (int i = 0; i < 1; i++)
	{
		CTCPIOCP* lpClient = new CTCPIOCP;

		if(lpClient->Connect("127.0.0.1", 3000))
		{
			printf("���ӷ������ɹ���\r\n");
		}

		//TestPackage* pkg = new TestPackage;

		//for (int i = 0; i < 100; i++)
		//{
		//	//TestPackage* pkg = new TestPackage;
		//	//pkg->id = i + 1;
		//	//printf("�������ݰ���\r\n");
		//	client.SendTCP(pkg);
		//}

		//client.SendTCP2();

		//client.StopTCP();
	}

	printf("��������˳�!\r\n");

	_getch();

	return 1;
}

