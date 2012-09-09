// stdafx.h : ��׼ϵͳ�����ļ��İ����ļ���
// ���Ǿ���ʹ�õ��������ĵ�
// �ض�����Ŀ�İ����ļ�

#pragma once


#ifndef _DEFINE_IO_DATA
#define _DEFINE_IO_DATA

#pragma comment(lib, "ws2_32.lib")

#define BUFF_SIZE					1024


#include <queue>
#include <WinSock2.h>

#include "PackageBase.h"
#include "CryptorBase.h"

//////////////////////////////////////////////////////////////////////////
//						��ɶ˿�����
//////////////////////////////////////////////////////////////////////////
struct _ACCEPT_DATA;

typedef enum
{
	RECVED = 1,
	SENDED = 2
}OP_TYPE;

typedef struct _IOCP_DATA
{
	WSAOVERLAPPED					WSAOverLapped;									//�ص�I/O����
	WSABUF							WSABuf;											//�ֽڻ�������
	char							Buffer[BUFF_SIZE];								//�����ֽڻ�������
	_ACCEPT_DATA*					LPAcceptData;									//�ͻ��˶���
	OP_TYPE							OPType;											//�������͡�
}IOCP_DATA, *LPIOCP_DATA;

typedef struct _ACCEPT_DATA
{
	LPIOCP_DATA						Sender;											//���ݷ����ص�I/O����
	LPIOCP_DATA						Recver;											//���ݽ����ص�I/O����
	CCryptorBase*					SenderCryptor;									//�������ݼ�������
	CCryptorBase*					RecverCryptor;									//�������ݽ�������
	SOCKET							Socket;											//�����ӵ�Զ�������׽��֡�
	SOCKADDR_IN						SockAddr;										//�����ӵ�Զ������˵㡣
	std::queue<CPackageBase*>		SendPKGList;									//�������ݰ����С�
	CRITICAL_SECTION				SendPKGListLok;									//�������ݰ����л����źš�
	size_t							SendDataLeft;									//���ݰ����е�һ�����ݰ��ѷ��͵��ֽ�����
	CRITICAL_SECTION				SendLok;										//�������ݻ����źš�
	bool							Sending;										//�Ƿ����ڷ��͡�
	size_t							sendBytesTotal;									//��ǰ��Ҫ���͵����ֽ�����
	size_t							sendBytesTransferred;							//��ǰ�ѷ��͵��ֽ�����
}ACCEPT_DATA, *LPACCEPT_DATA;

#endif