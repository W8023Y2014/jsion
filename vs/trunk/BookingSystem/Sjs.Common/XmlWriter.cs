using System;
using System.IO;
using System.Xml;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Sjs.Common
{
    public abstract class XMLComponent
    {
        #region �� �� 
        /// <summary>
        /// Դ���ݱ�
        /// </summary>
        private DataTable sourceDT = null;

        /// <summary>
        /// Դ���ݱ�
        /// </summary>
        public DataTable SourceDataTable
        {
            set { sourceDT = value; }
            get { return sourceDT; }
        }

        /// <summary>
        /// �ļ����·��
        /// </summary>
        private string fileOutputPath = @"";

        /// <summary>
        /// �ļ����·��
        /// </summary>
        public string FileOutPath
        {
            set
            {   //��֤·���ַ��������ĺϷ���
                if (value.LastIndexOf("\\") != (value.Length - 1))
                    fileOutputPath = value + "\\";
            }
            get { return fileOutputPath; }
        }

        /// <summary>
        /// �ļ�����
        /// </summary>
        private string fileEncode = "utf-8";

        /// <summary>
        /// �ļ�����
        /// </summary>
        public string FileEncode
        {
            set { fileEncode = value; }
            get { return fileEncode; }
        }

        /// <summary>
        /// �ļ�����
        /// </summary>
        private int indentation = 6;

        /// <summary>
        /// �ļ�����
        /// </summary>
        public int Indentation
        {
            set { indentation = value; }
            get { return indentation; }
        }


        /// <summary>
        /// �汾��
        /// </summary>
        private string version = "2.0";

        /// <summary>
        /// �汾��
        /// </summary>
        public string Version
        {
            set { version = value; }
            get { return version; }
        }

        /// <summary>
        /// ��ʼԪ��
        /// </summary>
        private string startElement = "channel";

        /// <summary>
        /// ��ʼԪ��
        /// </summary>
        public string StartElement
        {
            set { startElement = value; }
            get { return startElement; }
        }

        /// <summary>
        /// XSL����
        /// </summary>
        private string xslLink = null;

        /// <summary>
        /// XSL����
        /// </summary>
        public string XslLink
        {
            set { xslLink = value; }
            get { return xslLink; }
        }

        /// <summary>
        /// �ļ���
        /// </summary>
        private string fileName = "MyFile.xml";

        /// <summary>
        /// �ļ���
        /// </summary>
        public string FileName
        {
            set { fileName = value; }
            get { return fileName; }
        }


        /// <summary>
        /// ����ָ�򸸼�¼���ֶ�����
        /// </summary>
        private string parentField = "Item";

        /// <summary>
        /// ����ָ�򸸼�¼���ֶ�����
        /// </summary>
        public string ParentField
        {
            set { parentField = value; }
            get { return parentField; }
        }

        /// <summary>
        /// ����һ��������ֵ
        /// </summary>
        private string key = "ItemID";

        /// <summary>
        /// ����һ��������ֵ
        /// </summary>
        public string Key
        {
            set { key = value; }
            get { return key; }
        }

        #endregion

        /// <summary>
        /// д���ļ�
        /// </summary>
        /// <returns></returns>
        public abstract string WriteFile();

        /// <summary>
        /// д��StringBuilder����
        /// </summary>
        /// <returns></returns>
        public abstract StringBuilder WriteStringBuilder();


        public XmlDocument xmlDoc_Metone = new XmlDocument();

        #region ��XML��
        protected void BulidXmlTree(XmlElement tempXmlElement, string location)
        {

            DataRow tempRow = this.SourceDataTable.Select(this.Key + "=" + location)[0];
            //����Tree�ڵ�
            XmlElement treeElement = xmlDoc_Metone.CreateElement(this.ParentField);
            tempXmlElement.AppendChild(treeElement);


            foreach (DataColumn c in this.SourceDataTable.Columns)  //�����ҳ���ǰ��¼������������
            {
                if ((c.Caption.ToString().ToLower() != this.ParentField.ToLower()))
                    this.AppendChildElement(c.Caption.ToString().Trim().ToLower(), tempRow[c.Caption.Trim()].ToString().Trim(), treeElement);
            }


            foreach (DataRow dr in this.SourceDataTable.Select(this.ParentField + "=" + location))
            {
                if (this.SourceDataTable.Select("item=" + dr[this.Key].ToString()).Length >= 0)
                {
                    this.BulidXmlTree(treeElement, dr[this.Key].ToString().Trim());
                }
                else continue;
            }

        }
        #endregion



        #region ׷���ӽڵ�
        /// <summary>
        /// ׷���ӽڵ�
        /// </summary>
        /// <param name="strName">�ڵ�����</param>
        /// <param name="strInnerText">�ڵ�����</param>
        /// <param name="parentElement">���ڵ�</param>
        /// <param name="xmlDocument">XmlDocument����</param>
        protected void AppendChildElement(string strName, string strInnerText, XmlElement parentElement, XmlDocument xmlDocument)
        {
            XmlElement xmlElement = xmlDocument.CreateElement(strName);
            xmlElement.InnerText = strInnerText;
            parentElement.AppendChild(xmlElement);
        }



        /// <summary>
        /// ʹ��Ĭ�ϵ�Ƶ��Xml�ĵ�
        /// </summary>
        /// <param name="strName"></param>
        /// <param name="strInnerText"></param>
        /// <param name="parentElement"></param>
        protected void AppendChildElement(string strName, string strInnerText, XmlElement parentElement)
        {
            AppendChildElement(strName, strInnerText, parentElement, xmlDoc_Metone);
        }
        #endregion



        #region �����洢����XML���ļ���
        public void CreatePath()
        {
            if (this.FileOutPath != null)
            {
                string path = this.FileOutPath;  //;Server.MapPath("");
                if (!Directory.Exists(path))
                {
                    Utils.CreateDir(path);
                }
            }
            else
            {
                string path = @"C:\";   //;Server.MapPath("");
                string NowString = DateTime.Now.ToString("yyyy-MM").Trim();
                if (!Directory.Exists(path + NowString))
                {
                    Utils.CreateDir(path + "\\" + NowString);
                }
            }
        }

        #endregion
    }


    //�޵ݹ�ֱ������XML
    class ConcreteComponent : XMLComponent
    {
        private string strName;
        public ConcreteComponent(string s)
        {
            strName = s;
        }


        //д��StringBuilder����
        public override StringBuilder WriteStringBuilder()
        {
            //string xmlData = string.Format("<?xml version='1.0' encoding='{0}'?><?xml-stylesheet type=\"text/xsl\" href=\"{1}\"?><{3} version='{2}'></{3}>",this.FileEncode,this.XslLink,this.Version,this.SourceDataTable.TableName);
            string xmlData = string.Format("<?xml version='1.0' encoding='{0}'?><{3} ></{3}>", this.FileEncode, this.XslLink, this.Version, this.SourceDataTable.TableName);

            this.xmlDoc_Metone.Load(new StringReader(xmlData));
            //д��channel
            foreach (DataRow r in this.SourceDataTable.Rows)   //����ȡ��������
            {
                //��ͨ��ʽ����XML
                XmlElement treeContentElement = this.xmlDoc_Metone.CreateElement(this.StartElement);
                xmlDoc_Metone.DocumentElement.AppendChild(treeContentElement);

                foreach (DataColumn c in this.SourceDataTable.Columns)  //�����ҳ���ǰ��¼������������
                {
                    this.AppendChildElement(c.Caption.ToString().ToLower(), r[c].ToString().Trim(), treeContentElement);
                }

            }

            return new StringBuilder().Append(xmlDoc_Metone.InnerXml);
        }


        public override string WriteFile()
        {

            if (this.SourceDataTable != null)
            {

                DateTime filenamedate = DateTime.Now;

                string filename = this.FileOutPath + this.FileName;
                XmlTextWriter PicXmlWriter = null;
                Encoding encode = Encoding.GetEncoding(this.FileEncode);
                CreatePath();
                PicXmlWriter = new XmlTextWriter(filename, encode);

                try
                {

                    PicXmlWriter.Formatting = Formatting.Indented;
                    PicXmlWriter.Indentation = this.Indentation;
                    PicXmlWriter.Namespaces = false;
                    PicXmlWriter.WriteStartDocument();
                    //PicXmlWriter.WriteDocType("�ĵ�����", null, ".xml", null);
                    //PicXmlWriter.WriteComment("�������ݿ��м�¼��ID���м�¼��д");
                    PicXmlWriter.WriteProcessingInstruction("xml-stylesheet", "type='text/xsl' href='" + this.XslLink + "'");

                    PicXmlWriter.WriteStartElement(this.SourceDataTable.TableName);
                    PicXmlWriter.WriteAttributeString("", "version", null, this.Version);

                    //д��channel
                    foreach (DataRow r in this.SourceDataTable.Rows)   //����ȡ��������
                    {
                        PicXmlWriter.WriteStartElement("", this.StartElement, "");
                        foreach (DataColumn c in this.SourceDataTable.Columns)  //�����ҳ���ǰ��¼������������
                        {
                            PicXmlWriter.WriteStartElement("", c.Caption.ToString().Trim().ToLower(), "");
                            PicXmlWriter.WriteString(r[c].ToString().Trim());
                            PicXmlWriter.WriteEndElement();
                        }
                        PicXmlWriter.WriteEndElement();
                    }

                    PicXmlWriter.WriteEndElement();
                    PicXmlWriter.Flush();
                    this.SourceDataTable.Dispose();
                }
                catch (Exception e) { Console.WriteLine("�쳣��{0}", e.ToString()); }
                finally
                {
                    Console.WriteLine("���ļ� {0} �Ĵ�������ɡ�");
                    if (PicXmlWriter != null)
                        PicXmlWriter.Close();

                }
                return filename;
            }
            else
            {
                Console.WriteLine("���ļ� {0} �Ĵ���δ��ɡ�");
                return "";
            }
        }

    }


    //�޵ݹ�ֱ������XML
    public class TreeNodeComponent : XMLComponent
    {
        private string strName;
        public TreeNodeComponent(string s)
        {
            strName = s;
        }


        //д��StringBuilder����
        public override StringBuilder WriteStringBuilder()
        {
            //string xmlData = string.Format("<?xml version='1.0' encoding='{0}'?><?xml-stylesheet type=\"text/xsl\" href=\"{1}\"?><{3} version='{2}'></{3}>",this.FileEncode,this.XslLink,this.Version,this.SourceDataTable.TableName);
            string xmlData = string.Format("<?xml version='1.0' encoding='{0}'?><{3} ></{3}>", this.FileEncode, this.XslLink, this.Version, this.SourceDataTable.TableName);

            this.xmlDoc_Metone.Load(new StringReader(xmlData));
            //д��channel
            foreach (DataRow r in this.SourceDataTable.Rows)   //����ȡ��������
            {
                //��ͨ��ʽ����XML
                XmlElement treeContentElement = this.xmlDoc_Metone.CreateElement(this.StartElement);
                xmlDoc_Metone.DocumentElement.AppendChild(treeContentElement);

                foreach (DataColumn c in this.SourceDataTable.Columns)  //�����ҳ���ǰ��¼������������
                {
                    this.AppendChildElement(c.Caption.ToString().ToLower(), r[c].ToString().Trim(), treeContentElement);
                }

            }

            return new StringBuilder().Append(xmlDoc_Metone.InnerXml);
        }


        public override string WriteFile()
        {

            if (this.SourceDataTable != null)
            {

                DateTime filenamedate = DateTime.Now;

                string filename = this.FileOutPath + this.FileName;
                XmlTextWriter PicXmlWriter = null;
                Encoding encode = Encoding.GetEncoding(this.FileEncode);
                CreatePath();
                PicXmlWriter = new XmlTextWriter(filename, encode);

                try
                {

                    PicXmlWriter.Formatting = Formatting.Indented;
                    PicXmlWriter.Indentation = this.Indentation;
                    PicXmlWriter.Namespaces = false;
                    PicXmlWriter.WriteStartDocument();
                    //PicXmlWriter.WriteDocType("�ĵ�����", null, ".xml", null);
                    //PicXmlWriter.WriteComment("�������ݿ��м�¼��ID���м�¼��д");

                    PicXmlWriter.WriteStartElement(this.SourceDataTable.TableName);

                    string content = null;

                    //д��channel
                    foreach (DataRow r in this.SourceDataTable.Rows)   //����ȡ��������
                    {

                        content = "  Text=\"" + r[0].ToString().Trim() + "\"   ImageUrl=\"../../editor/images/smilies/" + r[1].ToString().Trim() + "\"";

                        PicXmlWriter.WriteStartElement("", this.StartElement + content, "");

                        PicXmlWriter.WriteEndElement();
                        content = null;
                    }

                    PicXmlWriter.WriteEndElement();
                    PicXmlWriter.Flush();
                    this.SourceDataTable.Dispose();
                }
                catch (Exception e)
                {
                    Console.WriteLine("�쳣��{0}", e.ToString());
                }
                finally
                {
                    Console.WriteLine("���ļ� {0} �Ĵ�������ɡ�");
                    if (PicXmlWriter != null)
                        PicXmlWriter.Close();

                }
                return filename;
            }
            else
            {
                Console.WriteLine("���ļ� {0} �Ĵ���δ��ɡ�");
                return "";
            }
        }

    }


    //RSS����
    public class RssXMLComponent : XMLComponent
    {
        private string strName;

        public RssXMLComponent(string s)
        {
            strName = s;
            FileEncode = "gb2312";
            Version = "2.0";
            StartElement = "channel";

        }

        //д��StringBuilder����
        public override StringBuilder WriteStringBuilder()
        {
            string xmlData = string.Format("<?xml version='1.0' encoding='{0}'?><?xml-stylesheet type=\"text/xsl\" href=\"{1}\"?><rss version='{2}'></rss>", this.FileEncode, this.XslLink, this.Version);
            this.xmlDoc_Metone.Load(new StringReader(xmlData));
            string Key = "-1";
            //д��channel
            foreach (DataRow r in this.SourceDataTable.Rows)   //����ȡ��������
            {
                if ((this.Key != null) && (this.ParentField != null)) //�ݹ����XML����
                {
                    if ((r[this.ParentField].ToString().Trim() == "") || (r[this.ParentField].ToString().Trim() == "0"))
                    {
                        XmlElement treeContentElement = this.xmlDoc_Metone.CreateElement(this.StartElement);
                        xmlDoc_Metone.DocumentElement.AppendChild(treeContentElement);

                        foreach (DataColumn c in this.SourceDataTable.Columns)  //�����ҳ���ǰ��¼������������
                        {
                            if ((c.Caption.ToString().ToLower() == this.ParentField.ToLower()))
                            {
                                Key = r[this.Key].ToString().Trim();
                            }
                            else
                            {
                                if ((r[this.ParentField].ToString().Trim() == "") || (r[this.ParentField].ToString().Trim() == "0"))
                                {
                                    this.AppendChildElement(c.Caption.ToString().ToLower(), r[c].ToString().Trim(), treeContentElement);
                                }
                            }
                        }

                        foreach (DataRow dr in this.SourceDataTable.Select(this.ParentField + "=" + Key))
                        {
                            if (this.SourceDataTable.Select(this.ParentField + "=" + dr[this.Key].ToString()).Length >= 0)
                                this.BulidXmlTree(treeContentElement, dr["ItemID"].ToString().Trim());
                            else
                                continue;
                        }
                    }
                }
                else  //��ͨ��ʽ����XML
                {

                    XmlElement treeContentElement = this.xmlDoc_Metone.CreateElement(this.StartElement);
                    xmlDoc_Metone.DocumentElement.AppendChild(treeContentElement);

                    foreach (DataColumn c in this.SourceDataTable.Columns)  //�����ҳ���ǰ��¼������������
                    {
                        this.AppendChildElement(c.Caption.ToString().ToLower(), r[c].ToString().Trim(), treeContentElement);
                    }
                }
            }

            return new StringBuilder().Append(xmlDoc_Metone.InnerXml);
        }


        public override string WriteFile()
        {

            CreatePath();
            string xmlData = string.Format("<?xml version='1.0' encoding='{0}'?><?xml-stylesheet type=\"text/xsl\" href=\"{1}\"?><rss version='{2}'></rss>", this.FileEncode, this.XslLink, this.Version);
            this.xmlDoc_Metone.Load(new StringReader(xmlData));
            string Key = "-1";
            //д��channel
            foreach (DataRow r in this.SourceDataTable.Rows)   //����ȡ��������
            {
                if ((this.Key != null) && (this.ParentField != null)) //�ݹ����XML����
                {
                    if ((r[this.ParentField].ToString().Trim() == "") || (r[this.ParentField].ToString().Trim() == "0"))
                    {
                        XmlElement treeContentElement = this.xmlDoc_Metone.CreateElement(this.StartElement);
                        xmlDoc_Metone.DocumentElement.AppendChild(treeContentElement);

                        foreach (DataColumn c in this.SourceDataTable.Columns)  //�����ҳ���ǰ��¼������������
                        {
                            if ((c.Caption.ToString().ToLower() == this.ParentField.ToLower()))
                                Key = r[this.Key].ToString().Trim();
                            else
                            {
                                if ((r[this.ParentField].ToString().Trim() == "") || (r[this.ParentField].ToString().Trim() == "0"))
                                {
                                    this.AppendChildElement(c.Caption.ToString().ToLower(), r[c].ToString().Trim(), treeContentElement);
                                }
                            }
                        }

                        foreach (DataRow dr in this.SourceDataTable.Select(this.ParentField + "=" + Key))
                        {
                            if (this.SourceDataTable.Select(this.ParentField + "=" + dr[this.Key].ToString()).Length >= 0)
                                this.BulidXmlTree(treeContentElement, dr["ItemID"].ToString().Trim());
                            else
                                continue;
                        }
                    }
                }
                else  //��ͨ��ʽ����XML
                {

                    XmlElement treeContentElement = this.xmlDoc_Metone.CreateElement(this.StartElement);
                    xmlDoc_Metone.DocumentElement.AppendChild(treeContentElement);

                    foreach (DataColumn c in this.SourceDataTable.Columns)  //�����ҳ���ǰ��¼������������
                    {
                        this.AppendChildElement(c.Caption.ToString().ToLower(), r[c].ToString().Trim(), treeContentElement);
                    }
                }

            }
            string fileName = this.FileOutPath + this.FileName;
            xmlDoc_Metone.Save(fileName);

            return fileName;

        }

    }


    //װ������
    public class XMLDecorator : XMLComponent
    {
        protected XMLComponent ActualXMLComponent;

        private string strDecoratorName;
        public XMLDecorator(string str)
        {
            // how decoration occurs is localized inside this decorator
            // For this demo, we simply print a decorator name
            strDecoratorName = str;
        }


        public void SetXMLComponent(XMLComponent xc)
        {
            ActualXMLComponent = xc;
            //Console.WriteLine("FileEncode - {0}", xc.FileEncode);		
            GetSettingFromComponent(xc);
        }

        //����װ��Ķ����Ĭ������Ϊ��ǰװ���ߵĳ�ʼֵ
        public void GetSettingFromComponent(XMLComponent xc)
        {
            this.FileEncode = xc.FileEncode;
            this.FileOutPath = xc.FileOutPath;
            this.Indentation = xc.Indentation;
            this.SourceDataTable = xc.SourceDataTable;
            this.StartElement = xc.StartElement;
            this.Version = xc.Version;
            this.XslLink = xc.XslLink;
            this.Key = xc.Key;
            this.ParentField = xc.ParentField;
        }


        public override string WriteFile()
        {
            if (ActualXMLComponent != null)
                ActualXMLComponent.WriteFile();

            return null;
        }

        //д��StringBuilder����
        public override StringBuilder WriteStringBuilder()
        {
            if (ActualXMLComponent != null)
                return ActualXMLComponent.WriteStringBuilder();

            return null;
        }
    }


    #region
    /*
	class ConcreteDecorator : XMLDecorator 
	{
		private string strDecoratorName;
		public ConcreteDecorator (string str)
		{
			// how decoration occurs is localized inside this decorator
			// For this demo, we simply print a decorator name
			strDecoratorName = str; 
		}
		public void Draw()
		{
			CustomDecoration();
			base.Draw();
		}
		void CustomDecoration()
		{
			Console.WriteLine("In ConcreteDecorator: decoration goes here");
			Console.WriteLine("{0}", strDecoratorName);
		}
	}
	*/
    #endregion

    #region ���Դ�����(��ע��)

    ///// <summary>
    ///// XmlWrite ���Դ����ժҪ˵����
    ///// </summary>
    //public class XmlWrite
    //{
    //    /* ��ṹ����SQL���
    //    CREATE TABLE [Rss_ChannelItem] (
    //    [ChannelID] [int] NOT NULL ,
    //                          [ItemID] [int] NOT NULL ,
    //                                             [ItemName] [varchar] (50) NULL ,
    //    [ItemDescription] [nvarchar] (4000) NULL ,
    //    [ItemNum] [int] NOT NULL ,
    //                        [Item] [int] NOT NULL ,
    //                                         [ItemLink] [varchar] (50) NULL 
    //                                                                                                 ) ON [PRIMARY]
    //    GO
    //    */


    //    XMLComponent Setup() 
    //    {
    //        ConcreteComponent c = new ConcreteComponent("This is the RSS component");

    //        DataSet ds = new DataSet();
    //        SqlConnection sc = new SqlConnection("server=192.168.2.198;database=RSS;uid=sa;pwd=;");
    //        new SqlDataAdapter("Select  *  From Rss_ChannelItem",sc).Fill(ds);
    //        ds.Tables[0].TableName = "xml";//��Ҫʹ���������������
    //        c.SourceDataTable = ds.Tables[0];
    //        c.FileName = "test.xml";
    //        c.FileOutPath = @"c:\";
    //        //c.Key=null;

    //        //c.FileEncode="2.0";
    //        XMLDecorator d = new XMLDecorator("This is a decorator for the component");

    //        d.SetXMLComponent(c);
    //        // d.FileEncode="2.0";
    //        return d;
    //    }


    //    public XmlWrite()
    //    {
    //        //
    //        // TODO: �ڴ˴���ӹ��캯���߼�
    //        //
    //    }


    //    [STAThread]
    //    public static int Main(string[] args)
    //    {

    //        XmlWrite client = new XmlWrite();
    //        XMLComponent c = client.Setup();    

    //        // The code below will work equally well with the real component, 
    //        // or a decorator for the component

    //        //c.WriteFile();
    //        Console.WriteLine(c.FileEncode);

    //        /*
    //        c.FileOutPath=null;
    //        c.CreatePath();
    //        */



    //        Console.WriteLine(c.WriteFile());
    //        if (c.WriteStringBuilder() != null)
    //            Console.WriteLine(c.WriteStringBuilder().ToString());


    //        return 0;
    //    }

    //}

    #endregion
}
