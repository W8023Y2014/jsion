using System;
using System.Text;
using System.Web;
using System.IO;
using Sjs.Common;

namespace Sjs.Config
{
    /// <summary>
    /// �ļ����ù������
    /// </summary>
    class BaseConfigFileManager : DefaultConfigFileManager
    {
        private static BaseConfigInfo _configinfo;

        /// <summary>
        /// ������
        /// </summary>
        private static object lockHelper = new object();

        /// <summary>
        /// �ļ��޸�ʱ��
        /// </summary>
        private static DateTime _fileoldchange;

        static BaseConfigFileManager()
        {
            _fileoldchange = System.IO.File.GetLastWriteTime(ConfigFilePath);

            _configinfo = (BaseConfigInfo)DefaultConfigFileManager.DeserializeInfo(ConfigFilePath, typeof(BaseConfigInfo));

            _configinfo.Dbconnectstring = Sjs.Common.DES.Decode(_configinfo.Dbconnectstring, "sjscanpvvvfb");
        }

        public new static IConfigInfo ConfigInfo
        {
            get { return _configinfo; }
            set { _configinfo = (BaseConfigInfo)value; }
        }

        /// <summary>
        /// �����ļ�����·��
        /// 
        /// Ĭ��ֵ:null
        /// </summary>
        public static string filename = null;

        /// <summary>
        /// ��ȡ�����ļ�����·��
        /// 
        /// Ĭ���ļ�:/SJS.config
        /// </summary>
        public new static string ConfigFilePath
        {
            get 
            {
                if (filename==null)
                {
                    HttpContext context = HttpContext.Current;

                    if (context!=null)
                    {
                        filename = context.Server.MapPath("/SJS.config");
                    }
                    else
                    {
                        filename = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "SJS.config");
                    }

                    if (!File.Exists(filename))
                    {
                        throw new SJSException("��������: ��վ��Ŀ¼��û����ȷ��SJS.config�ļ�");
                    }
                }

                return filename;
            }
        }

        /// <summary>
        /// ����������(����ļ��޸�ʱ��)
        /// </summary>
        /// <returns></returns>
        public static BaseConfigInfo LoadConfig()
        {
            ConfigInfo = DefaultConfigFileManager.LoadConfig(ref _fileoldchange, ConfigFilePath, ConfigInfo);

            BaseConfigInfo rtnConfigInfo = ConfigInfo as BaseConfigInfo;

            if (rtnConfigInfo == null)
            {
                return null;
            }

            // ����
            rtnConfigInfo.Dbconnectstring = Sjs.Common.DES.Decode(rtnConfigInfo.Dbconnectstring, "sjscanpvvvfb");

            return rtnConfigInfo;       //���ת��ʧ���򷵻�null
        }

        /// <summary>
        /// ����������Ч��������(������ļ��޸�ʱ�䣬ǿ�Ƹ���������Ϣ)
        /// </summary>
        /// <returns></returns>
        public static BaseConfigInfo LoadRealConfig()
        {
            ConfigInfo = DefaultConfigFileManager.LoadConfig(ref _fileoldchange, ConfigFilePath, ConfigInfo, false);

            BaseConfigInfo rtnConfigInfo = ConfigInfo as BaseConfigInfo;

            if (rtnConfigInfo == null)
            {
                return null;
            }

            // ����
            rtnConfigInfo.Dbconnectstring = Sjs.Common.DES.Decode(rtnConfigInfo.Dbconnectstring, "sjscanpvvvfb");

            return rtnConfigInfo;       //���ת��ʧ���򷵻�null
        }

        /// <summary>
        /// ��������
        /// </summary>
        /// <returns></returns>
        public override bool SaveConfig()
        {
            return base.SaveConfig(ConfigFilePath, ConfigInfo);
        }
    }
}
