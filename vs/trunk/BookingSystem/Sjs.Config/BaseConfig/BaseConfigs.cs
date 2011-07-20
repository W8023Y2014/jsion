using System;

namespace Sjs.Config
{
    /// <summary>
    /// ����������
    /// </summary>
    public class BaseConfigs
    {
        /// <summary>
        /// ������
        /// </summary>
        private static object lockHelper = new object();

        /// <summary>
        /// ��ʱ��
        /// </summary>
        private static System.Timers.Timer _baseConfigTimer = new System.Timers.Timer(15000);

        private static BaseConfigInfo _configinfo;

        /// <summary>
        /// ��̬���캯����ʼ����Ӧʵ���Ͷ�ʱ��
        /// </summary>
        static BaseConfigs()
        {
            _configinfo = BaseConfigFileManager.LoadConfig();

            _baseConfigTimer.AutoReset = true;
            _baseConfigTimer.Enabled = true;
            _baseConfigTimer.Elapsed += new System.Timers.ElapsedEventHandler(Timer_Elapsed);
        }

        private static void Timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            ResetConfig();
        }

        /// <summary>
        /// ����������ʵ��
        /// </summary>
        public static void ResetConfig()
        {
            _configinfo = BaseConfigFileManager.LoadRealConfig();
        }

        public static BaseConfigInfo GetBaseConfig()
        {
            return _configinfo;
        }

        /// <summary>
        /// �������ݿ����Ӵ�
        /// </summary>
        public static string GetDBConnectString
        {
            get { return GetBaseConfig().Dbconnectstring; }
        }


        /// <summary>
        /// �õ���̳������ID
        /// </summary>
        public static int GetCreatorUid
        {
            get
            {
                return GetBaseConfig().Creatoruid;
            }
        }

        /// <summary>
        /// ������վ·��
        /// </summary>
        public static string GetSitePath
        {
            get
            {
                return GetBaseConfig().Sitepath;
            }
        }

        /// <summary>
        /// �������ݿ�����
        /// </summary>
        public static string GetDbType
        {
            get
            {
                return GetBaseConfig().Dbtype;
            }
        }

        /// <summary>
        /// ����Ӧ�ó���ID
        /// </summary>
        public static int GetAppid
        {
            get
            {
                return GetBaseConfig().Appid;
            }
        }

        /// <summary>
        /// ��������
        /// </summary>
        /// <param name="baseconfiginfo"></param>
        /// <returns></returns>
        public static bool SaveConfig(BaseConfigInfo baseconfiginfo)
        {
            BaseConfigFileManager bcfm = new BaseConfigFileManager();

            // ����
            baseconfiginfo.Dbconnectstring = Sjs.Common.DES.Encode(baseconfiginfo.Dbconnectstring, "sjscanpvvvfb");

            BaseConfigFileManager.ConfigInfo = baseconfiginfo;

            return bcfm.SaveConfig();
        }
    }
}
