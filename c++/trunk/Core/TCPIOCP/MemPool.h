#pragma once


#ifndef _MEMORY_POOL
#define _MEMORY_POOL


#define MAX_MEMORY_SIZE			1024 * 4				//�����ڴ�ռ��С��׼ֵ
#define ALIGN_SIZE				8						//�ڴ�ռ�����С
#define MIN_ALLOC_COUNT			5						//�ڴ��������ռ���С����


class CMemPool
{
private:
	typedef struct _MEMORY_BLOCK
	{
		size_t						Size;
		union
		{
			_MEMORY_BLOCK*			Next;
			char					Data[1];
		};
	}MEMORY_BLOCK, *LPMEMORY_BLOCK;

public:
	CMemPool(void);
	~CMemPool(void);


public:
	static CMemPool* GetInstance();
	void* Allocate(size_t allocaLen);					//��ȡָ����С���ֽڿռ�
	void Free(void* pData);								//�ͷ�ָ���ռ䵽�����

private:
	void _AllocateMemory(size_t s);						//���ֽڶ�������ڴ�ռ�

private:
	static CMemPool	s_instance;
	CRITICAL_SECTION m_lok;
	LPMEMORY_BLOCK* m_lpMemoryPool;
};





#endif

