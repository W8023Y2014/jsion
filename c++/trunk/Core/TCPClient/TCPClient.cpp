// TCPClient.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"


CTCPIOCP client;

void testConnect()
{
	CSmartPtr<CPackageBase> pkg = new TestPackage();

	TestPackage* p = (TestPackage*)pkg.Get();
	p->id = 1;

	for (int i = 0; i < 10; i++)
	{
		CTCPIOCP* lpClient = new CTCPIOCP;

		if(lpClient->Connect("127.0.0.1", 3000))
		{
			printf("���ӷ������ɹ���\r\n");
		}

		for (int i = 0; i < 1; i++)
		{
			//TestPackage* pkg = new TestPackage;
			//p->id = i + 1;
			//printf("�������ݰ���\r\n");
			lpClient->SendTCP(pkg);
			lpClient->SendTCP(pkg);
		}

		//client.SendTCP2();

		//client.StopTCP();
	}
}


int _tmain(int argc, _TCHAR* argv[])
{
	testConnect();

	printf("��������˳�!\r\n");

	_getch();

	return 1;
}

