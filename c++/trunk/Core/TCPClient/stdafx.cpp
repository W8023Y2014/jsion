// stdafx.cpp : ֻ������׼�����ļ���Դ�ļ�
// TCPClient.pch ����ΪԤ����ͷ
// stdafx.obj ������Ԥ����������Ϣ

#include "stdafx.h"

// TODO: �� STDAFX.H ��
// �����κ�����ĸ���ͷ�ļ����������ڴ��ļ�������

TestPackage::TestPackage()
{
	PSize = sizeof(TestPackage);

	//id = 223;
	tLong = 4300000000;
	strcpy_s(account, "jsion");
}

TestPackage::~TestPackage()
{

}
