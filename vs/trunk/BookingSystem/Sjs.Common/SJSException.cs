using System;
using System.Collections.Generic;
using System.Text;

namespace Sjs.Common
{
    /// <summary>
    /// SJS�Զ����쳣��
    /// </summary>
    public class SJSException : Exception
    {
        public SJSException()
        {
            //
        }

        public SJSException(string msg)
            : base(msg)
        {
            //
        }
    }
}
