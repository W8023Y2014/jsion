using System;
using System.IO;
using System.Text;
using System.Xml.Serialization;

namespace Sjs.Config
{
    public class DefaultConfigFileManager
    {
        /// <summary>
        /// �ļ�����·������
        /// </summary>
        private static string _configfilepath;

        /// <summary>
        /// ��ʱ���ö������
        /// </summary>
        private static IConfigInfo _configinfo = null;

        /// <summary>
        /// ������
        /// </summary>
        private static object lockHelper = new object();

        /// <summary>
        /// �ļ�����·������
        /// </summary>
        public static string ConfigFilePath
        {
            get { return _configfilepath; }
            set { _configfilepath = value; }
        }

        /// <summary>
        /// ��ʱ���ö������
        /// </summary>
        public static IConfigInfo ConfigInfo
        {
            get { return _configinfo; }
            set { _configinfo = value; }
        }

        /// <summary>
        /// ����(�����л�)ָ���������͵����ö���
        /// </summary>
        /// <param name="fileoldchange">�ļ�����ʱ��</param>
        /// <param name="configFilePath">�����ļ�����·��</param>
        /// <param name="configinfo">��Ӧ�ı��� ע:�ò�����Ҫ��������m_configinfo���� �� ��ȡ����.GetType()</param>
        /// <returns></returns>
        protected static IConfigInfo LoadConfig(ref DateTime fileoldchange, string configFilePath, IConfigInfo configinfo)
        {
            return LoadConfig(ref fileoldchange, configFilePath, configinfo, true);
        }

        /// <summary>
        /// ����(�����л�)ָ���������͵����ö���
        /// </summary>
        /// <param name="fileoldchange">�ļ�����ʱ��</param>
        /// <param name="configFilePath">�����ļ�����·��(�����ļ���)</param>
        /// <param name="configinfo">��Ӧ�ı��� ע:�ò�����Ҫ��������m_configinfo���� �� ��ȡ����.GetType()</param>
        /// <param name="p">�Ƿ��鲢���´��ݽ�����"�ļ�����ʱ��"����</param>
        /// <returns></returns>
        protected static IConfigInfo LoadConfig(ref DateTime fileoldchange, string configFilePath, IConfigInfo configinfo, bool checkTime)
        {
            _configfilepath = configFilePath;
            _configinfo = configinfo;
            if (checkTime)
            {
                DateTime filenewchange = System.IO.File.GetLastWriteTime(configFilePath);

                //������������config�ļ������仯ʱ���config���¸�ֵ
                if (fileoldchange != filenewchange)
                {
                    fileoldchange = filenewchange;
                    lock (lockHelper)
                    {
                        _configinfo = DeserializeInfo(configFilePath, configinfo.GetType());
                    }
                }
            }
            else
            {
                lock (lockHelper)
                {
                    _configinfo = DeserializeInfo(configFilePath, configinfo.GetType());
                }
            }

            return _configinfo;
        }

        /// <summary>
        /// �����л�ָ������
        /// </summary>
        /// <param name="configfilepath">config �ļ���·��</param>
        /// <param name="configtype">��Ӧ������</param>
        /// <returns></returns>
        public static IConfigInfo DeserializeInfo(string configfilepath, Type configtype)
        {
            IConfigInfo iconfiginfo;
            FileStream fs = null;
            
            try
            {
                fs = new FileStream(configfilepath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
                XmlSerializer serializer = new XmlSerializer(configtype);
                iconfiginfo = (IConfigInfo)serializer.Deserialize(fs);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }
            }
            return iconfiginfo;
        }

        /// <summary>
        /// ��������ʵ��(�鷽����̳�)
        /// </summary>
        /// <returns></returns>
        public virtual bool SaveConfig()
        {
            return true;
        }

        /// <summary>
        /// ����(���л�)ָ��·���µ������ļ�
        /// </summary>
        /// <param name="configFilePath">ָ���������ļ����ڵ�·��(�����ļ���)</param>
        /// <param name="configinfo">������(���л�)�Ķ���</param>
        /// <returns></returns>
        public bool SaveConfig(string configFilePath,IConfigInfo configinfo)
        {
            bool succeed = false;

            FileStream fs = null;

            try
            {
                fs = new FileStream(configFilePath, FileMode.Create, FileAccess.Write, FileShare.ReadWrite);

                XmlSerializer serializer = new XmlSerializer(configinfo.GetType());

                serializer.Serialize(fs, configinfo);

                //�ɹ��򽫻᷵��true
                succeed = true;
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                if (fs != null)
                {
                    fs.Close();
                }
            }

            return succeed;
        }
    }
}
