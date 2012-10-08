// TCPIOCP.h

#pragma once

#ifndef JSION_TCP_IOCP
#define JSION_TCP_IOCP

#pragma comment(lib, "ws2_32.lib")

#include <queue>
#include <stdio.h>
#include <tchar.h>
#include <WinSock2.h>


#include "Stdafx.h"
#include "RecvBuffer.h"
#include "PackageBase.h"



//////////////////////////////////////////////////////////////////////////
//							��ɶ˿�ʵ����
//////////////////////////////////////////////////////////////////////////
class CTCPIOCP
{
public:
	CTCPIOCP(void);																	//���캯����
	~CTCPIOCP(void);																//����������

public:
	bool Listen(int port);															//�������ض˿ڡ�
	bool Connect(char* ip, int port);												//���ӵ�ָ����Զ�������յ㡣

	bool SendTCP(CPackageBase* pkg);												//����Ϊ�ͻ���ȥ����Զ�̷����ʱ���á�
	bool SendTCP2();																//����Ϊ�ͻ���ȥ����Զ�̷����ʱ���á�

	void StopTCP();																	//ֹͣTCP��

public:
	virtual void OnAccept(LPACCEPT_DATA lpAcceptData);								//�յ������������õķ�����
	virtual void OnConnectER(char* ip, int port, DWORD errid);						//����ʧ�ܣ����� errid Ϊͨ�� GetLastError() ȡ�á�
	virtual void OnConnectOK(LPACCEPT_DATA lpAcceptData);							//���ӳɹ���
	virtual void OnRecvData(LPIOCP_DATA lpIOCPData, int bytesTransferred);			//���յ��ͻ������ݡ�
	virtual void HandlePackage(char* pkg, LPIOCP_DATA lpIOCPData);					//�������ݰ���
	virtual void OnDisconnected(LPACCEPT_DATA lpAcceptData);						//�ͻ��˶Ͽ����ӡ�

public:
	static CTCPIOCP* Listener;
	static bool WINAPI SendTCPImp(CTCPIOCP* lpCTCPIOCP, LPACCEPT_DATA lpAcceptData, CPackageBase* pkg);			//�������ݰ�ʵ�ַ�����
	static void StopAcceptData(LPACCEPT_DATA lpAcceptData);							//ֹͣ�ͻ������ӡ�
	static void DeleteAcceptData(LPACCEPT_DATA lpAcceptData);						//�رղ��ͷ����ӡ�

private:
	static DWORD WINAPI	IOCPThreadProc(LPVOID CompletionPort);						//I/O���������֪ͨ�̳߳ع���������
	static DWORD WINAPI ListenThreadProc(LPVOID val);								//�����̹߳���������

private:
	bool _InitIOCP();																//������ɶ˿ھ�������Ҵ���2����CPU���������̳߳�(������һ����ɶ˿ںͶ�Ӧ���̳߳�)��
	void _RecvAsync(LPACCEPT_DATA lpAcceptData);									//�����첽�������ݡ�
	void _SendAsync(LPACCEPT_DATA lpAcceptData);									//�����첽�������ݡ�

private:
	WORD m_wVersionRequested;														//һ��WORD��˫�ֽڣ�����ֵ��ָ����Ӧ�ó�����Ҫʹ�õ�Winsock�淶����߰汾��
	WSADATA m_WSAData;																//��������Windows Socketsʵ�ֵ�ϸ�ڡ�
	SOCKET m_socket;																//�����׽��־����
	SOCKADDR_IN m_addr;																//����˵㡣
	HANDLE m_listenThreadHandle;													//�����߳̾����
	HANDLE m_completionPort;														//����ָ��Socket����ɶ˿ھ����
	bool m_isConnector;																//�Ƿ���Ϊ�ͻ���ȥ����Զ�̷���ˡ�
	LPACCEPT_DATA m_lpAcceptData;													//��Ϊ�ͻ���ȥ����Զ�̷����ʱ��Ч��

	//std::queue<LPVOID> m_recvPackagesList;											//ȫ�ִ��������ݰ����С�
	CRITICAL_SECTION m_recvPackagesListLok;											//ȫ�ִ��������ݰ����л����źš�
};

#endif