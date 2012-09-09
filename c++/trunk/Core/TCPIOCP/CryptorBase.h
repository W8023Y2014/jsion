#pragma once

#ifndef _CRYPTOR_BASE
#define _CRYPTOR_BASE


class CCryptorBase
{
public:
	CCryptorBase(void);
	~CCryptorBase(void);

public:
	virtual void Encrypt(const char* source, size_t& sourceOffset, size_t sourceSize, char* dest, size_t& destOffset, size_t destSize);
	virtual void Decrypt(const char* source, size_t& sourceOffset, size_t sourceSize, char* dest, size_t& destOffset, size_t destSize);
	virtual void UpdateCryptKey();
};


class NoneCryptor : public CCryptorBase
{
	void Encrypt(const char* source, size_t& sourceOffset, size_t sourceSize, char* dest, size_t& destOffset, size_t destSize);

	void Decrypt(const char* source, size_t& sourceOffset, size_t sourceSize, char* dest, size_t& destOffset, size_t destSize);

	void UpdateCryptKey();
};

#endif