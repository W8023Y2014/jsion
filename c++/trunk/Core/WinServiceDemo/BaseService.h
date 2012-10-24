#pragma once
class BaseService
{
public:
	BaseService(void);
	~BaseService(void);

public:
	//************************************
	// Method:    Create
	// FullName:  BaseService::Create
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: �������� 
	// Parameter: SC_HANDLE schSCManager SCM��� 
	// Parameter: LPTSTR szPath ��������·�� 
	// Parameter: LPSTR szServiceName ������ 
	//************************************
	BOOL Create(LPTSTR szPath, LPSTR szServiceName);
	//************************************
	// Method:    Delete
	// FullName:  BaseService::Delete
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: ɾ������
	// Parameter: LPTSTR szNameOfService ������
	//************************************
	BOOL Delete(LPTSTR szServiceName);

	//************************************
	// Method:    Start
	// FullName:  BaseService::Start
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: ��������
	// Parameter: LPSTR szServiceName ������
	//************************************
	BOOL Start(LPSTR szServiceName);

	//************************************
	// Method:    Stop
	// FullName:  BaseService::Stop
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: ֹͣ����
	// Parameter: LPSTR szServiceName ������
	//************************************
	BOOL Stop(LPSTR szServiceName);

	//************************************
	// Method:    ExecServiceMain
	// FullName:  BaseService::ExecServiceMain
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: ִ�з���������
	// Parameter: LPSTR szServiceName
	//************************************
	BOOL ExecServiceMain(LPSTR szServiceName);

public:
	SC_HANDLE				schService;
	SC_HANDLE				schSCManager;
	SERVICE_STATUS          ssServiceStatus;
};

