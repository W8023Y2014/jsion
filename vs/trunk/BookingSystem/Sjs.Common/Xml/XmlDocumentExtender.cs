using System;
using System.IO;
using System.Data;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;
using Sjs.Common;

namespace Sjs.Common.Xml
{


    /// <summary>
    /// XmlDocument��չ��
    /// 
    /// Ŀ��:�����Ż��ͼ��ٴ�����д��
    /// 
    /// ��ע:Element  ��Ϊ:Ԫ��  
    ///      Document ��Ϊ:�ĵ� 
    ///      Node     ��Ϊ:�ڵ�
    /// </summary>
    public class XmlDocumentExtender : XmlDocument
    {
        public XmlDocumentExtender()
            : base()
        {
        }

        #region ��չ�Ĺ��캯��

#if NET1        
        public XmlDocumentExtender(XmlNameTable nt)
            : base(new XmlImplementation())
        {
        }
#else
        public XmlDocumentExtender(XmlNameTable nt)
            : base(new XmlImplementation(nt))
        {
        }
#endif

        #endregion


        public override void Load(string filename)
        {
            if (Sjs.Common.Utils.FileExists(filename))
            {
                base.Load(filename);
            }
            else
            {
                throw new Exception("�ļ�: " + filename + " ������!");
            }
        }

        /// <summary>
        /// ��ָ����XmlԪ����,�����XmlԪ��
        /// </summary>
        /// <param name="xmlElement">��׷����Ԫ�ص�XmlԪ��</param>
        /// <param name="childElementName">Ҫ��ӵ�XmlԪ������</param>
        /// <param name="childElementValue">Ҫ��ӵ�XmlԪ��ֵ</param>
        /// <returns></returns>
        public bool AppendChildElementByNameValue(ref XmlElement xmlElement, string childElementName, object childElementValue)
        {
            return AppendChildElementByNameValue(ref xmlElement, childElementName, childElementValue, false);
        }

        /// <summary>
        /// ��ָ����XmlԪ����,�����XmlԪ��
        /// </summary>
        /// <param name="xmlElement">��׷����Ԫ�ص�XmlԪ��</param>
        /// <param name="childElementName">Ҫ��ӵ�XmlԪ������</param>
        /// <param name="childElementValue">Ҫ��ӵ�XmlԪ��ֵ</param>
        /// <param name="IsCDataSection">�Ƿ���CDataSection���͵���Ԫ��</param>
        /// <returns></returns>
        public bool AppendChildElementByNameValue(ref XmlElement xmlElement, string childElementName, object childElementValue, bool IsCDataSection)
        {
            if ((xmlElement != null) && (xmlElement.OwnerDocument != null))
            {
                //�Ƿ���CData����XmlԪ��
                if (IsCDataSection)
                {
                    XmlCDataSection tempdata = xmlElement.OwnerDocument.CreateCDataSection(childElementName);
                    tempdata.InnerText = FiltrateControlCharacter(childElementValue.ToString());
                    XmlElement childXmlElement = xmlElement.OwnerDocument.CreateElement(childElementName);
                    childXmlElement.AppendChild(tempdata);
                    xmlElement.AppendChild(childXmlElement);
                }
                else
                {
                    XmlElement childXmlElement = xmlElement.OwnerDocument.CreateElement(childElementName);
                    childXmlElement.InnerText = FiltrateControlCharacter(childElementValue.ToString());
                    xmlElement.AppendChild(childXmlElement);
                }
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// ��ָ����Xml�����,�����XmlԪ��
        /// </summary>
        /// <param name="xmlElement">��׷����Ԫ�ص�Xml�ڵ�</param>
        /// <param name="childElementName">Ҫ��ӵ�XmlԪ������</param>
        /// <param name="childElementValue">Ҫ��ӵ�XmlԪ��ֵ</param>
        /// <returns></returns>
        public bool AppendChildElementByNameValue(ref XmlNode xmlNode, string childElementName, object childElementValue)
        {
            return AppendChildElementByNameValue(ref xmlNode, childElementName, childElementValue, false);
        }

        /// <summary>
        /// ��ָ����Xml�����,�����XmlԪ��
        /// </summary>
        /// <param name="xmlElement">��׷����Ԫ�ص�Xml�ڵ�</param>
        /// <param name="childElementName">Ҫ��ӵ�XmlԪ������</param>
        /// <param name="childElementValue">Ҫ��ӵ�XmlԪ��ֵ</param>
        /// <param name="IsCDataSection">�Ƿ���CDataSection���͵���Ԫ��</param>
        /// <returns></returns>
        public bool AppendChildElementByNameValue(ref XmlNode xmlNode, string childElementName, object childElementValue, bool IsCDataSection)
        {
            if ((xmlNode != null) && (xmlNode.OwnerDocument != null))
            {
                //�Ƿ���CData����Xml���
                if (IsCDataSection)
                {
                    XmlCDataSection tempdata = xmlNode.OwnerDocument.CreateCDataSection(childElementName);
                    tempdata.InnerText = FiltrateControlCharacter(childElementValue.ToString());
                    XmlElement childXmlElement = xmlNode.OwnerDocument.CreateElement(childElementName);
                    childXmlElement.AppendChild(tempdata);
                    xmlNode.AppendChild(childXmlElement);
                }
                else
                {
                    XmlElement childXmlElement = xmlNode.OwnerDocument.CreateElement(childElementName);
                    childXmlElement.InnerText = FiltrateControlCharacter(childElementValue.ToString());
                    xmlNode.AppendChild(childXmlElement);
                }
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// ͨ����������ǰXMLԪ����׷����Ԫ��
        /// </summary>
        /// <param name="xmlElement">��׷����Ԫ�ص�XmlԪ��</param>
        /// <param name="dcc">��ǰ���ݱ��е��м���</param>
        /// <param name="dr">��ǰ������</param>
        /// <returns></returns>
        public bool AppendChildElementByDataRow(ref XmlElement xmlElement, DataColumnCollection dcc, DataRow dr)
        {
            return AppendChildElementByDataRow(ref xmlElement, dcc, dr, null);
        }


        /// <summary>
        /// ͨ����������ǰXMLԪ����׷����Ԫ��
        /// </summary>
        /// <param name="xmlElement">��׷����Ԫ�ص�XmlԪ��</param>
        /// <param name="dcc">��ǰ���ݱ��е��м���</param>
        /// <param name="dr">��ǰ������</param>
        /// <param name="removecols">���ᱻ׷�ӵ�����</param>
        /// <returns></returns>
        public bool AppendChildElementByDataRow(ref XmlElement xmlElement, DataColumnCollection dcc, DataRow dr, string removecols)
        {
            if ((xmlElement != null) && (xmlElement.OwnerDocument != null))
            {
                foreach (DataColumn dc in dcc)
                {
                    if ((removecols == null) ||
                        (removecols == "") ||
                        (("," + removecols + ",").ToLower().IndexOf("," + dc.Caption.ToLower() + ",") < 0))
                    {
                        XmlElement tempElement = xmlElement.OwnerDocument.CreateElement(dc.Caption);
                        tempElement.InnerText = FiltrateControlCharacter(dr[dc.Caption].ToString().Trim());
                        xmlElement.AppendChild(tempElement);
                    }
                }
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// ʵʼ���ڵ�, ���ڵ�����������ǰ·���µ������ӽ��, �粻������ֱ�Ӵ����ý��
        /// </summary>
        /// <param name="xmlpath"></param>
        /// <returns></returns>
        public XmlNode InitializeNode(string xmlpath)
        {
            XmlNode xmlNode = this.SelectSingleNode(xmlpath);
            if (xmlNode != null)
            {
                xmlNode.RemoveAll();
            }
            else
            {
                xmlNode = CreateNode(xmlpath);
            }
            return xmlNode;
        }

        /// <summary>
        /// ɾ��ָ��·������������ӽ�������
        /// </summary>
        /// <param name="xmlpath">ָ��·��</param>
        public void RemoveNodeAndChildNode(string xmlpath)
        {
            XmlNodeList xmlNodeList = this.SelectNodes(xmlpath);
            if (xmlNodeList.Count > 0)
            {
                foreach (XmlNode xn in xmlNodeList)
                {
                    xn.RemoveAll();
                    xn.ParentNode.RemoveChild(xn);
                }
            }
        }

        /// <summary>
        /// ����ָ��·���µĽڵ�
        /// </summary>
        /// <param name="xmlpath">�ڵ�·��</param>
        /// <returns></returns>
        public XmlNode CreateNode(string xmlpath)
        {

            string[] xpathArray = xmlpath.Split('/');
            string root = "";
            XmlNode parentNode = this;
            //������ؽڵ�
            for (int i = 1; i < xpathArray.Length; i++)
            {
                XmlNode node = this.SelectSingleNode(root + "/" + xpathArray[i]);
                // �����ǰ·������������,�������õ�ǰ·����������·����
                if (node == null)
                {
                    XmlElement newElement = this.CreateElement(xpathArray[i]);
                    parentNode.AppendChild(newElement);
                }
                //���õ�һ����·��
                root = root + "/" + xpathArray[i];
                parentNode = this.SelectSingleNode(root);
            }

            return parentNode;
        }

        /// <summary>
        /// �õ�ָ��·���Ľڵ�ֵ
        /// </summary>
        /// <param name="xmlnode">Ҫ���ҽڵ�</param>
        /// <param name="path">ָ��·��</param>
        /// <returns></returns>
        public string GetSingleNodeValue(XmlNode xmlnode, string path)
        {
            if (xmlnode == null)
            {
                return null;
            }

            if (xmlnode.SelectSingleNode(path) != null)
            {
                if (xmlnode.SelectSingleNode(path).LastChild != null)
                {
                    return xmlnode.SelectSingleNode(path).LastChild.Value;
                }
                else
                {
                    return "";
                }
            }
            return null;
        }

        /// <summary>
        /// ���˿����ַ�,����0x00 - 0x08,0x0b - 0x0c,0x0e - 0x1f
        /// </summary>
        /// <param name="content">Ҫ���˵�����</param>
        /// <returns>���˺������</returns>
        private string FiltrateControlCharacter(string content)
        {
            return Regex.Replace(content, "[\x00-\x08|\x0b-\x0c|\x0e-\x1f]", "");
        }

    }
}
