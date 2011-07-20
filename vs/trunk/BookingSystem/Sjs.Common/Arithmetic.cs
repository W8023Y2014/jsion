using System;
using System.Collections;

namespace Sjs.Common
{
    /// <summary>
    /// CalUtility ��ժҪ˵��
    /// ����ʽ��������
    /// </summary>
    public class CalUtility
    {
        System.Text.StringBuilder StrB;
        private int iCurr = 0;
        private int iCount = 0;
        /// <summary>
        /// ���췽��
        /// </summary>
        public CalUtility(string calStr)
        {
            StrB = new System.Text.StringBuilder(calStr.Trim());
            iCount = System.Text.Encoding.Default.GetByteCount(calStr.Trim());
        }

        /// <summary>
        /// ȡ��,�Զ�������ֵ������
        /// </summary>
        /// <returns></returns>\
        public string getItem()
        {
            //������
            if (iCurr == iCount)
                return "";
            char ChTmp = StrB[iCurr];
            bool b = IsNum(ChTmp);
            if (!b)
            {
                iCurr++;
                return ChTmp.ToString();
            }
            string strTmp = "";
            while (IsNum(ChTmp) == b && iCurr < iCount)
            {
                ChTmp = StrB[iCurr];
                if (IsNum(ChTmp) == b)
                    strTmp += ChTmp;
                else
                    break;
                iCurr++;
            }
            return strTmp;
        }

        /// <summary>
        /// �Ƿ�������
        /// </summary>
        /// <param name="c">����</param>
        /// <returns></returns>
        public bool IsNum(char c)
        {
            if ((c >= '0' && c <= '9') || c == '.')
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        /// <summary>
        /// �Ƿ�������
        /// </summary>
        /// <param name="c">����</param>
        /// <returns></returns>
        public bool IsNum(string c)
        {
            if (c.Equals(""))
                return false;
            if ((c[0] >= '0' && c[0] <= '9') || c[0] == '.')
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// �Ƚ�str1��str2��������������ȼ�,ture��ʾstr1����str2,false��ʾstr1����str2
        /// </summary>
        /// <param name="str1">�����1</param>
        /// <param name="str2">�����2</param>
        /// <returns></returns>
        public bool Compare(string str1, string str2)
        {
            return getPriority(str1) >= getPriority(str2);
        }


        /// <summary>
        /// ȡ�ü�����ŵ����ȼ�
        /// </summary>
        /// <param name="str">�����</param>
        /// <returns></returns>	
        public int getPriority(string str)
        {
            if (str.Equals(""))
            {
                return -1;
            }
            if (str.Equals("("))
            {
                return 0;
            }
            if (str.Equals("+") || str.Equals("-"))
            {
                return 1;
            }
            if (str.Equals("*") || str.Equals("/"))
            {
                return 2;
            }
            if (str.Equals(")"))
            {
                return 0;
            }
            return 0;
        }
    }


    /// <summary>
    /// IOper ��ժҪ˵��
    /// ������ӿ�
    /// </summary>	
    public interface IOper
    {
        /// <summary>
        /// ���������ӿڼ��㷽��
        /// </summary>
        /// <param name="o1">����1</param>
        /// <param name="o2">����2</param>
        /// <returns></returns>
        object Oper(object o1, object o2);
    }

    /// <summary>
    /// Opers ��ժҪ˵��
    /// ���������Ľӿ�ʵ��,�Ӽ��˳�
    /// </summary>
    public class OperAdd : IOper
    {
        public OperAdd()
        {
        }
        #region IOper ��Ա
        public object Oper(object o1, object o2)
        {
            Decimal d1 = Decimal.Parse(o1.ToString());
            Decimal d2 = Decimal.Parse(o2.ToString());
            return d1 + d2;
        }
        #endregion
    }

    public class OperDec : IOper
    {
        public OperDec()
        {
        }
        #region IOper ��Ա

        public object Oper(object o1, object o2)
        {
            Decimal d1 = Decimal.Parse(o1.ToString());
            Decimal d2 = Decimal.Parse(o2.ToString());
            return d1 - d2;
        }
        #endregion
    }


    public class OperRide : IOper
    {
        public OperRide()
        {
            //
            // TODO: �ڴ˴���ӹ��캯���߼�
            //
        }
        #region IOper ��Ա

        public object Oper(object o1, object o2)
        {
            Decimal d1 = Decimal.Parse(o1.ToString());
            Decimal d2 = Decimal.Parse(o2.ToString());
            return d1 * d2;
        }
        #endregion
    }

    public class OperDiv : IOper
    {
        public OperDiv()
        {
        }
        #region IOper ��Ա

        public object Oper(object o1, object o2)
        {
            Decimal d1 = Decimal.Parse(o1.ToString());
            Decimal d2 = Decimal.Parse(o2.ToString());
            return d1 / d2;
        }

        #endregion
    }



    /// <summary>
    /// OperFactory ��ժҪ˵����
    /// ������ӿڹ���
    /// </summary>
    public class OperFactory
    {
        public OperFactory()
        {
        }
        public IOper CreateOper(string Oper)
        {
            if (Oper.Equals("+"))
            {
                IOper p = new OperAdd();
                return p;
            }
            if (Oper.Equals("-"))
            {
                IOper p = new OperDec();
                return p;
            }
            if (Oper.Equals("*"))
            {
                IOper p = new OperRide();
                return p;
            }
            if (Oper.Equals("/"))
            {
                IOper p = new OperDiv();
                return p;
            }
            return null;
        }
    }


    /// <summary>
    /// Arithmetic ��ժҪ˵��
    /// ����ʵ������
    /// </summary>
    public class Arithmetic
    {
        /// <summary>
        /// ������ջ
        /// </summary>
        private ArrayList HList;
        /// <summary>
        /// ��ֵջ
        /// </summary>
        public ArrayList Vlist;
        /// <summary>
        /// �����Թ���
        /// </summary>
        private CalUtility cu;
        /// <summary>
        /// �������������
        /// </summary>
        private OperFactory of;
        /// <summary>
        /// ���췽��
        /// </summary>
        /// <param name="str">��ʽ</param>
        public Arithmetic(string str)
        {
            //
            // TODO: �ڴ˴���ӹ��캯���߼�
            //
            HList = new ArrayList();
            Vlist = new ArrayList();
            of = new OperFactory();
            cu = new CalUtility(str);
        }


        /// <summary>
        /// ��ʼ����
        /// </summary>
        public object DoCal()
        {
            string strTmp = cu.getItem();
            while (true)
            {
                if (cu.IsNum(strTmp))
                {
                    //�������ֵ,��д������ջ
                    Vlist.Add(strTmp);
                }
                else
                {
                    //��ֵ
                    Cal(strTmp);
                }
                if (strTmp.Equals(""))
                    break;
                strTmp = cu.getItem();
            }
            return Vlist[0];
        }


        /// <summary>
        /// ����
        /// </summary>
        /// <param name="str">�����</param>
        /// 
        private void Cal(string str)
        {
            //���ű�Ϊ��,���ҵ�ǰ����Ϊ"",����Ϊ�Ѿ��������
            if (str.Equals("") && HList.Count == 0)
                return;
            if (HList.Count > 0 && Vlist.Count > 1)
            {
                //�����Ƿ���Զ�����
                if (HList[HList.Count - 1].ToString().Equals("(") && str.Equals(")"))
                {
                    HList.RemoveAt(HList.Count - 1);
                    if (HList.Count > 0)
                    {
                        str = HList[HList.Count - 1].ToString();
                        //HList.RemoveAt(HList.Count-1);
                        Cal(str);
                    }
                    return;
                }
                //�Ƚ����ȼ�
                if (cu.Compare(HList[HList.Count - 1].ToString(), str))
                {
                    //�������,�����
                    IOper p = of.CreateOper(HList[HList.Count - 1].ToString());
                    if (p != null)
                    {
                        Vlist[Vlist.Count - 2] = p.Oper(Vlist[Vlist.Count - 2], Vlist[Vlist.Count - 1]);
                        HList.RemoveAt(HList.Count - 1);
                        Vlist.RemoveAt(Vlist.Count - 1);
                        Cal(str);
                    }
                    return;
                }
                if (!str.Equals(""))
                    HList.Add(str);
            }
            else
            {
                if (!str.Equals(""))
                    HList.Add(str);
            }
        }
    }



}
