#if NET1
#else

using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Sjs.Common.Generic
{
    /// <summary>
    /// LinkedList������
    /// </summary>
    /// <typeparam name="T">ռλ��(��ͬ)</typeparam>
    [Serializable]
    public class LinkedList<T> : System.Collections.Generic.LinkedList<T>, ISjsCollection<T>
    {
        
    
      
        public LinkedList() : base() { }

        public LinkedList(IEnumerable<T> collection) : base(collection) { }

        private LinkedList(SerializationInfo info, StreamingContext context) : base(info, context) { }

        public object SyncRoot
        {
            get
            {
                return this;
            }
        }

        public bool IsEmpty
        {
            get
            {
                return this.Count == 0;
            }
        }

        private int _fixedsize = default(int);
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


        public string Version
        {
            get
            {
                return "1.0";
            }
        }

        public string Author
        {
            get
            {
                return "Discuz!NT";
            }
        }

        public new void AddFirst(T value)
        {
            if (!this.IsFull)
            {
                base.AddFirst(value);
            }
        }


        public void Accept(ISjsVisitor<T> visitor)
        {
            if (visitor == null)
            {
                throw new ArgumentNullException("������Ϊ��");
            }

            System.Collections.Generic.LinkedList<T>.Enumerator enumerator = this.GetEnumerator();

            while (enumerator.MoveNext())
            {
                visitor.Visit(enumerator.Current);

                if (visitor.HasDone)
                {
                    return;
                }
            }
        }


        public int CompareTo(object obj)
        {
            if (obj == null)
            {
                throw new ArgumentNullException("obj");
            }

            if (obj.GetType() == this.GetType())
            {
                LinkedList<T> l = obj as LinkedList<T>;

                return this.Count.CompareTo(l.Count);
            }
            else
            {
                return this.GetType().FullName.CompareTo(obj.GetType().FullName);
            }
        }
  
    
    }
}
#endif