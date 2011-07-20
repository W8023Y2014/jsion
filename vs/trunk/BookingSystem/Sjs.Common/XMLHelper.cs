using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Data;
using System.IO;

namespace Sjs.Common
{
    /// <summary>
    /// Xml������
    /// </summary>
    public class XMLHelper
    {
        /// <summary>
        /// Xml�ļ���·��
        /// </summary>
        protected string strXmlFile;
        /// <summary>
        /// Xml�ĵ���
        /// </summary>
        protected XmlDocument objXmlDoc = new XmlDocument();

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="XmlFile">Xml�ļ�·��</param>
        public XMLHelper(string XmlFile)
        {
            try
            {
                objXmlDoc.Load(XmlFile);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            strXmlFile = XmlFile;
        }

        /// <summary>
        /// ��ȡXml�ļ���DataView��ʾ
        /// </summary>
        /// <param name="XmlPathNode"></param>
        /// <returns></returns>
        public DataView GetData(string XmlPathNode)
        {
            // ��������,����һ��DataView

            DataSet ds = new DataSet();

            StringReader read = new StringReader(objXmlDoc.SelectSingleNode(XmlPathNode).OuterXml);

            ds.ReadXml(read);

            return ds.Tables[0].DefaultView;
        }

        /// <summary>
        /// �滻ָ����Xml·��������
        /// </summary>
        /// <param name="XmlPathNode"></param>
        /// <param name="Content"></param>
        public void SetXmlNodeContent(string XmlPathNode, string Content)
        {
            objXmlDoc.SelectSingleNode(XmlPathNode).InnerText = Content;
        }

        /// <summary>
        /// ɾ��ָ���ڵ�
        /// </summary>
        /// <param name="Node"></param>
        public void DeleteNode(string Node)
        {
            string mainNode = Node.Substring(0, Node.LastIndexOf("/"));

            objXmlDoc.SelectSingleNode(mainNode).RemoveChild(objXmlDoc.SelectSingleNode(Node));
        }

        /// <summary>
        /// ����һ�ڵ�ʹ˽ڵ��һ�ӽڵ�
        /// </summary>
        /// <param name="MainNode">����ڵ�ĸ��ڵ�·��</param>
        /// <param name="ChildNode">����ڵ������</param>
        /// <param name="Element">����ڵ���ӽڵ������</param>
        /// <param name="Content">����ڵ���ӽڵ��ֵ</param>
        public void InsertNode(string MainNode, string ChildNode, string Element, string Content)
        {
            // ����һ�ڵ�ʹ˽ڵ��һ�ӽڵ�
            InsertNode(MainNode, ChildNode, new string[1] { Element }, new string[1] { Content });
        }

        /// <summary>
        /// ����һ�ڵ�ʹ˽ڵ�������ӽڵ�,�ӽڵ����ɲ���Elements����ĸ�������
        /// </summary>
        /// <param name="MainNode">����ڵ�ĸ��ڵ�·��</param>
        /// <param name="ChildNode">����ڵ������</param>
        /// <param name="Elements">����ڵ���ӽڵ����������(��Contents����һһ��Ӧ)</param>
        /// <param name="Contents">����ڵ���ӽڵ��ֵ����(��Elements����һһ��Ӧ)</param>
        public void InsertNode(string MainNode, string ChildNode, string[] Elements, string[] Contents)
        {
            if ((Elements.Length <= 0) || (Contents.Length <= 0) || (Elements.Length != Contents.Length))
            {
                //throw new ArgumentException("Elements �� Contents ����Ϊ�ջ� Elements �� Contents ����������һ��");
                return;
            }

            XmlNode objRootNode = objXmlDoc.SelectSingleNode(MainNode);

            XmlElement objChildNode = objXmlDoc.CreateElement(ChildNode);
            objRootNode.AppendChild(objChildNode);

            for (int i = 0; i < Elements.Length; i++)
            {
                XmlElement element = objXmlDoc.CreateElement(Elements[i]);
                element.InnerText = Contents[i];
                objChildNode.AppendChild(element);
            }
        }

        /// <summary>
        /// ����һ���ڵ�
        /// </summary>
        /// <param name="XmlNode">�ڵ�����</param>
        /// <returns>���ؽڵ�Ԫ��</returns>
        public XmlElement CreaterElement(string XmlNode)
        {
            return objXmlDoc.CreateElement(XmlNode);
        }

        /// <summary>
        /// ����һ���ڵ�,��һ����
        /// </summary>
        /// <param name="MainNode">����ڵ�ĸ��ڵ�·��</param>
        /// <param name="Element">����ڵ������</param>
        /// <param name="Attrib">����ڵ����������</param>
        /// <param name="AttribContent">����ڵ������ֵ</param>
        /// <param name="Content">����ڵ��ֵ</param>
        public void InsertElement(string MainNode, string Element, string Attrib, string AttribContent, string Content)
        {
            // ����һ���ڵ�,��һ����
            XmlNode objNode = objXmlDoc.SelectSingleNode(MainNode);

            XmlElement objElement = objXmlDoc.CreateElement(Element);
            objElement.SetAttribute(Attrib, AttribContent);
            objElement.InnerText = Content;
            objNode.AppendChild(objElement);
        }

        /// <summary>
        /// ����һ���ڵ�,����������
        /// </summary>
        /// <param name="MainNode">����ڵ�ĸ��ڵ�·��</param>
        /// <param name="Element">����ڵ������</param>
        /// <param name="Content">����ڵ��ֵ</param>
        public void InsertElement(string MainNode, string Element, string Content)
        {
            // ����һ���ڵ�,������
            XmlNode objNode = objXmlDoc.SelectSingleNode(MainNode);

            XmlElement objElement = objXmlDoc.CreateElement(Element);
            objElement.InnerText = Content;
            objNode.AppendChild(objElement);
        }

        /// <summary>
        /// ��ȡһ��ָ����Xml�ڵ�
        /// </summary>
        /// <param name="XmlNode">Xml�ڵ�·��</param>
        /// <returns>Xml�ڵ�</returns>
        public XmlNode GetXmlNode(string XmlNode)
        {
            return objXmlDoc.SelectSingleNode(XmlNode);
        }

        /// <summary>
        /// ��ȡ���ڵ�
        /// </summary>
        /// <returns>���ڵ�</returns>
        public XmlNode GetRootNode()
        {
            return objXmlDoc.FirstChild.NextSibling;
        }

        /// <summary>
        /// ���Xml
        /// </summary>
        public void Clear()
        {
            this.GetRootNode().RemoveAll();
        }

        /// <summary>
        /// �����ĵ�
        /// </summary>
        public void Save()
        {
            // �����ĵ�
            try
            {
                objXmlDoc.Save(strXmlFile);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
