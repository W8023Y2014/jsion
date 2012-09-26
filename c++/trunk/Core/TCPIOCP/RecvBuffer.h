#pragma once

class RecvBuffer
{
public:
	RecvBuffer(void);
	RecvBuffer(UINT bufferSize);
	~RecvBuffer(void);


public:
	bool HasBuffer();
	void SetDataSize(size_t ds);
	size_t WriteBuffer(char* buffer, size_t writeLen);
	bool HasCompletePKG();
	void Reset();

public:
	char*							lpDataBuffer;					//������
	size_t							dataSize;						//����д�뻺�������ܴ�С


private:
	size_t							m_writeSize;					//��д�뻺���������ݴ�С
};

