using System;
using System.Collections.Generic;
using System.Text;
using Sjs.Config;

namespace Sjs.Data
{
    /// <summary>
    /// �ṩȫ��һ��ҵ������ʵ��
    /// ���ģʽ,����ģʽ,ȫ�ֹ���һ��ʵ��
    /// </summary>
    public class DatabaseProvider
    {
        private DatabaseProvider()
        {}

        private static IDataProvider _instance = null;

        private static object lockHelper = new object();

        static DatabaseProvider()
        {
            GetProvider();
        }

        private static void GetProvider()
        {
            try
            {
                _instance = (IDataProvider)Activator.CreateInstance(Type.GetType(string.Format("Sjs.Data.{0}.DataProvider,Sjs.Data.{0}", BaseConfigs.GetDbType), false, true));
            }
            catch
            {
                throw new Exception("����SJS.config��Dbtype�ڵ����ݿ������Ƿ���ȷ�����磺SqlServer��Access��MySql");
            }
        }

        public static IDataProvider GetInstance()
        {
            if (_instance==null)
            {
                lock (lockHelper)
                {
                    if (_instance==null)
                    {
                        GetProvider();
                    }
                }
            }

            return _instance;
        }

        public static void ResetDbProvider()
        {
            _instance = null;
        }
    }
}
