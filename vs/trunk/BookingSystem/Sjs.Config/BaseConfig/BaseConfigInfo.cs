using System;

namespace Sjs.Config
{
    /// <summary>
    /// ��������������, ��[Serializable]���Ϊ�����л�
    /// </summary>
    [Serializable]
    public class BaseConfigInfo : IConfigInfo
    {

        #region ˽���ֶ�

        /// <summary>
        /// ���ݿ����Ӵ�-��ʽ(����Ϊ�û��޸ĵ�����)��
        /// Data Source=���ݿ��������ַ;
        /// User ID=�������ݿ��û���;
        /// Password=�������ݿ��û�����;
        /// Initial Catalog=���ݿ�����;
        /// Pooling=true
        /// 
        /// Ĭ��ֵ:Data Source=;User ID=sjs;Password=sjscan;Initial Catalog=;Pool=true
        /// </summary>
        private string _dbconnectionstring = "Data Source=;User ID=sjs;Password=sjscan;Initial Catalog=;Pool=true";

        /// <summary>
        /// վ���ڵ�·��
        /// Ĭ��ֵ:/
        /// </summary>
        private string _sitepath = "/";

        /// <summary>
        /// ���ݿ�����
        /// Ĭ��: string.Empty
        /// </summary>
        private string _dbtype = string.Empty;

        /// <summary>
        /// ��ʼ��ID
        /// Ĭ��ֵ: 0
        /// </summary>
        private int _creatoruid = 0;

        /// <summary>
        /// Ӧ�ó���ID
        /// </summary>
        private int _appid = 0;

        #endregion

        #region ����

        /// <summary>
        /// ���ݿ����Ӵ�
        /// ��ʽ(����Ϊ�û��޸ĵ�����)��
        ///    Data Source=���ݿ��������ַ;
        ///    User ID=�������ݿ��û���;
        ///    Password=�������ݿ��û�����;
        ///    Initial Catalog=���ݿ�����;Pooling=true
        ///    Ĭ��ֵ:Data Source=;User ID=sjs;Password=gmyyvke;Initial Catalog=;Pool=true
        /// </summary>
        public string Dbconnectstring
        {
            get { return _dbconnectionstring; }
            set { _dbconnectionstring = value; }
        }

        /// <summary>
        /// վ���ڵ�·��
        /// Ĭ��ֵ:/
        /// </summary>
        public string Sitepath
        {
            get { return _sitepath; }
            set { _sitepath = value; }
        }

        /// <summary>
        /// ���ݿ�����
        /// Ĭ��: string.Empty
        /// </summary>
        public string Dbtype
        {
            get { return _dbtype; }
            set { _dbtype = value; }
        }

        /// <summary>
        /// ��ʼ��ID
        /// Ĭ��ֵ:0
        /// </summary>
        public int Creatoruid
        {
            get { return _creatoruid; }
            set { _creatoruid = value; }
        }

        /// <summary>
        /// Ӧ�ó���ID
        /// </summary>
        public int Appid
        {
            get { return _appid; }
            set { _appid = value; }
        }

        #endregion

    }
}
