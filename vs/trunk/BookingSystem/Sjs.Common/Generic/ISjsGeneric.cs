#if NET1
#else

using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace Sjs.Common.Generic
{
    public interface ISjsCollection<T> : ICollection<T>, IComparable
    {
        /// <summary>
        /// �̶���С
        /// </summary>
        int FixedSize { get;}

        /// <summary>
        /// �������Ƿ�Ϊ��
        /// </summary>
        bool IsEmpty { get;}

        /// <summary>
        /// �������Ƿ�����
        /// </summary>
        bool IsFull { get;}

        /// <summary>
        /// �汾
        /// </summary>
        string Version { get;}

        /// <summary>
        /// ����
        /// </summary>
        string Author { get;}
    }

    public interface ISjsVisitor<T>
    {
        /// <summary>
        /// �Ƿ�������
        /// </summary>
        bool HasDone { get; }

        /// <summary>
        /// ����ָ���Ķ���
        /// </summary>
        void Visit(T obj);
    }
}
#endif