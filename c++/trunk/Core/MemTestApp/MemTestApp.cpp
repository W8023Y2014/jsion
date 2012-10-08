// MemTestApp.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include <queue>

void memTest()
{
	std::queue<char*> list;

	printf("������������ڴ�...\r\n");
	_getch();

	for (int i = 0; i < 1000; i++)
	{
		list.push(new char[1024]);
	}

	printf("������������ڴ�...\r\n");
	_getch();

	for (int i = 0; i < 1000; i++)
	{
		char* c = list.front();

		list.pop();

		delete[] c;
	}
}

int _tmain(int argc, _TCHAR* argv[])
{
	for (int i = 0; i < 100; i++)
	{
		memTest();

		printf("�����������һ��...\r\n");
		_getch();
	}

	return 0;
}

