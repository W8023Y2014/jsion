#if NET1
#else

using System;
using System.Collections.Generic;
using System.Text;

namespace Sjs.Common.Generic
{
    /// <summary>
    /// ���з�����
    /// </summary>
    /// <typeparam name="T">ռλ��(��ͬ)</typeparam>
    [Serializable]
    public class Deque<T> : System.Collections.Generic.Queue<T>, ISjsCollection<T>
    {
        /// <summary>
        /// ���г���
        /// </summary>
        private int _fixedsize = default(int);

        public Deque() : base() { }

        public Deque(IEnumerable<T> collection) : base(collection) { }

        public Deque(int capacity) : base(capacity) { }

        /// <summary>
        /// ���ص�ǰʵ��
        /// </summary>
        public object SyncRoot
        {
            get
            {
                return this;
            }
        }

        /// <summary>
        /// �Ƿ�Ϊ��
        /// </summary>
        public bool IsEmpty
        {
            get
            {
                return this.Count == 0;
            }
        }


        public int FixedSize
        {
            get
            {
                return _fixedsize;
            }
            set
            {
                _fixedsize = value;
            }
        }

        /// <summary>
        /// ��ǰ�����Ƿ�����
        /// </summary>
        public bool IsFull
        {
            get
            {
                if ((FixedSize != default(int)) && (this.Count >= FixedSize))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        /// <summary>
        /// �汾
        /// </summary>
        public string Version
        {
            get
            {
                return "1.0";
            }
        }

        /// <summary>
        /// ����
        /// </summary>
        public string Author
        {
            get
            {
                return "Sjs";
            }
        }

        /// <summary>
        /// ����ָ���ķ��ʷ�ʽ(������ģʽ)
        /// </summary>
        /// <param name="visitor"></param>
        public void Accept(ISjsVisitor<T> visitor)
        {
            if (visitor == null)
            {
                throw new ArgumentNullException("���ʶ���Ϊ��");
            }

            System.Collections.Generic.Queue<T>.Enumerator enumerator = this.GetEnumerator();

            while (enumerator.MoveNext())
            {
                visitor.Visit(enumerator.Current);

                if (visitor.HasDone)
                {
                    return;
                }

            }
        }

        /// <summary>
        /// ׷��Ԫ��
        /// </summary>
        /// <param name="value"></param>
        public new void Enqueue(T value)
        {
            if (!this.IsFull)
            {
                base.Enqueue(value);
            }
        }


        bool ICollection<T>.Remove(T item)
        {
            throw new NotSupportedException();
        }

        void ICollection<T>.Add(T item)
        {
            throw new NotSupportedException();
        }

        public int CompareTo(object obj)
        {
            if (obj == null)
            {
                throw new ArgumentNullException("�Ƚ϶���Ϊ��");
            }

            if (obj.GetType() == this.GetType())
            {
                Deque<T> d = obj as Deque<T>;

                return this.Count.CompareTo(d.Count);
            }
            else
            {
                return this.GetType().FullName.CompareTo(obj.GetType().FullName);
            }
        }

        public bool IsReadOnly
        {
            get
            {
                return false;
            }
        }
    }
}
#endif