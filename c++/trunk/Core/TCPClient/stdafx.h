// stdafx.h : ��׼ϵͳ�����ļ��İ����ļ���
// ���Ǿ���ʹ�õ��������ĵ�
// �ض�����Ŀ�İ����ļ�
//

#pragma once

#include "targetver.h"

#include <stdio.h>
#include <tchar.h>



// TODO: �ڴ˴����ó�����Ҫ������ͷ�ļ�
#pragma comment(lib, "../Debug/TCPIOCP.lib")


#include <conio.h>
#include "../TCPIOCP/TCPIOCP.h"


class TestPackage : public CPackageBase
{
public:
	TestPackage();
	~TestPackage();
public:
	int id;
	long long tLong;
	char account[20];
};