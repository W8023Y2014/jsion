using System;
using System.IO;
using System.Xml.Serialization;
using System.Xml;
using System.Text;
using log4net;
using System.Reflection;

namespace JUtils
{
    /// <summary>
    /// SerializationHelper ��ժҪ˵����
    /// </summary>
    public class SerializationUtil
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// ���ͷ�����ָ���������л����浽�ļ���
        /// </summary>
        /// <typeparam name="T">Ҫ���л�������</typeparam>
        /// <param name="obj">Ҫ���л��Ķ���</param>
        /// <param name="filename">����·��</param>
        public static void SaveXmlFromObj<T>(T obj, string filename)
        {
            if (obj == null) return;

            using (FileStream fs = new FileStream(filename, FileMode.OpenOrCreate, FileAccess.Write))
            {
                MemoryStream ms = new MemoryStream();
                XmlTextWriter xtw = new XmlTextWriter(ms, Encoding.UTF8);
                xtw.Formatting = Formatting.Indented;

                XmlSerializer xs = new XmlSerializer(typeof(T));

                try
                {
                    xs.Serialize(ms, obj);

                    byte[] bytes = ms.ToArray();

                    fs.Write(bytes, 0, bytes.Length);

                    fs.Flush();
                }
                catch (Exception ex)
                {
                    log.Error("���л�ʧ��!", ex);
                }
            }
        }

        /// <summary>
        /// ���ͷ�����ָ��Xml�ַ������ݷ����л�Ϊָ������
        /// </summary>
        /// <typeparam name="T">�����л��������</typeparam>
        /// <param name="xmlStr">Xml�ַ�������</param>
        /// <returns></returns>
        public static T LoadObjFromXml<T>(string xmlStr)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                using (StreamWriter sw = new StreamWriter(ms, Encoding.UTF8))
                {
                    sw.Write(xmlStr);
                    sw.Flush();
                    ms.Seek(0, SeekOrigin.Begin);

                    XmlSerializer xs = new XmlSerializer(typeof(T));

                    try
                    {
                        return ((T)xs.Deserialize(ms));
                    }
                    catch (Exception ex)
                    {
                        log.Error("�����л�ʧ��!", ex);

                        return default(T);
                    }
                }
            }
        }

        /// <summary>
        /// ���ͷ�����ָ��XmlNode�������л�Ϊָ������
        /// </summary>
        /// <typeparam name="T">�����л��������</typeparam>
        /// <param name="node">XmlNode����</param>
        /// <returns></returns>
        public static T LoadObjFromXml<T>(XmlNode node)
        {
            if (node == null) return default(T);

            return LoadObjFromXml<T>(node.OuterXml);
        }

        ///// <summary>
        ///// �����л�
        ///// </summary>
        ///// <param name="type">��������</param>
        ///// <param name="filename">�ļ�·��</param>
        ///// <returns></returns>
        //public static object Load(Type type, string filename)
        //{
        //    FileStream fs = null;
        //    try
        //    {
        //        // open the stream...
        //        fs = new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
        //        XmlSerializer serializer = new XmlSerializer(type);
        //        return serializer.Deserialize(fs);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        if (fs != null)
        //            fs.Close();
        //    }
        //}


        ///// <summary>
        ///// ���л�
        ///// </summary>
        ///// <param name="obj">����</param>
        ///// <param name="filename">�ļ�·��</param>
        //public static void Save(object obj, string filename)
        //{
        //    FileStream fs = null;
        //    // serialize it...
        //    try
        //    {
        //        fs = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.ReadWrite);
        //        XmlSerializer serializer = new XmlSerializer(obj.GetType());
        //        serializer.Serialize(fs, obj);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        if (fs != null)
        //            fs.Close();
        //    }

        //}
    }
}
