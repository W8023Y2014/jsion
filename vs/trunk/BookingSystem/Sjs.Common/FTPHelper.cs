using System;
using System.Collections.Generic;
using System.Text;
using System.Net.Sockets;
using System.Net;
using System.IO;
using System.Collections;
using System.Text.RegularExpressions;

namespace Sjs.Common
{
        /// <summary>
    /// FTP��
    /// </summary>
    public class FTPHelper
    {
        #region ��������

        /// <summary>
        /// ���������ӵ�ַ
        /// </summary>
        public string server;

        /// <summary>
        /// ��½�ʺ�
        /// </summary>
        public string user;

        /// <summary>
        /// ��½����
        /// </summary>
        public string pass;

        /// <summary>
        /// �˿ں�
        /// </summary>
        public int port;

        /// <summary>
        /// ����Ӧʱ�䣨FTP��ָ��ʱ��������Ӧ��
        /// </summary>
        public int timeout;

        /// <summary>
        /// ����������״̬��Ϣ
        /// </summary>
        public string errormessage;

   
        /// <summary>
        /// ������״̬������Ϣ
        /// </summary>
        private string messages; 

        /// <summary>
        /// ����������Ӧ��Ϣ
        /// </summary>
        private string responseStr; 

        /// <summary>
        /// ����ģʽ�������򱻶���Ĭ��Ϊ������
        /// </summary>
        private bool passive_mode;        

        /// <summary>
        /// �ϴ���������Ϣ�ֽ���
        /// </summary>
        private long bytes_total; 

        /// <summary>
        /// �ϴ������ص��ļ���С
        /// </summary>
        private long file_size; 

        /// <summary>
        /// ���׽���
        /// </summary>
        private Socket main_sock;

        /// <summary>
        /// Ҫ���ӵ������ַ�ս��
        /// </summary>
        private IPEndPoint main_ipEndPoint;

        /// <summary>
        /// �����׽���
        /// </summary>
        private Socket listening_sock;

        /// <summary>
        /// �����׽���
        /// </summary>
        private Socket data_sock;

        /// <summary>
        /// Ҫ���ӵ��������ݵ�ַ�ս��
        /// </summary>
        private IPEndPoint data_ipEndPoint;

        /// <summary>
        /// �����ϴ������ص��ļ�������
        /// </summary>
        private FileStream file;

        /// <summary>
        /// ��FTP������������״ֵ̬
        /// </summary>
        private int response;

        /// <summary>
        /// ��ȡ�����浱ǰ����ִ�к��FTP�������˷��ص�������Ϣ
        /// </summary>
        private string bucket;

        #endregion

        #region ���캯��

        /// <summary>
        /// ���캯��
        /// </summary>
        public FTPHelper()
        {
            server = null;
            user = null;
            pass = null;
            port = 21;
            passive_mode = true;        
            main_sock = null;
            main_ipEndPoint = null;
            listening_sock = null;
            data_sock = null;
            data_ipEndPoint = null;
            file = null;
            bucket = "";
            bytes_total = 0;
            timeout = 10000;    //����Ӧʱ��Ϊ10��
            messages = "";
            errormessage = "";
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="server">������IP������</param>
        /// <param name="user">��½�ʺ�</param>
        /// <param name="pass">��½����</param>
        public FTPHelper(string server, string user, string pass)
        {
            this.server = server;
            this.user = user;
            this.pass = pass;
            port = 21;
            passive_mode = true;    
            main_sock = null;
            main_ipEndPoint = null;
            listening_sock = null;
            data_sock = null;
            data_ipEndPoint = null;
            file = null;
            bucket = "";
            bytes_total = 0;
            timeout = 10000;    //����Ӧʱ��Ϊ10��
            messages = "";
            errormessage = "";
        }
      
        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="server">������IP������</param>
        /// <param name="port">�˿ں�</param>
        /// <param name="user">��½�ʺ�</param>
        /// <param name="pass">��½����</param>
        public FTPHelper(string server, int port, string user, string pass)
        {
            this.server = server;
            this.user = user;
            this.pass = pass;
            this.port = port;
            passive_mode = true;    
            main_sock = null;
            main_ipEndPoint = null;
            listening_sock = null;
            data_sock = null;
            data_ipEndPoint = null;
            file = null;
            bucket = "";
            bytes_total = 0;
            timeout = 10000;    //����Ӧʱ��Ϊ10��
            messages = "";
            errormessage = "";
        }


        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="server">������IP������</param>
        /// <param name="port">�˿ں�</param>
        /// <param name="user">��½�ʺ�</param>
        /// <param name="pass">��½����</param>
        /// <param name="mode">���ӷ�ʽ</param>
        public FTPHelper(string server, int port, string user, string pass, int mode)
        {
            this.server = server;
            this.user = user;
            this.pass = pass;
            this.port = port;
            passive_mode = mode <= 1 ? true : false;
            main_sock = null;
            main_ipEndPoint = null;
            listening_sock = null;
            data_sock = null;
            data_ipEndPoint = null;
            file = null;
            bucket = "";
            bytes_total = 0;
            this.timeout = 10000;    //����Ӧʱ��Ϊ10��
            messages = "";
            errormessage = "";
        }

        /// <summary>
        /// ���캯��
        /// </summary>
        /// <param name="server">������IP������</param>
        /// <param name="port">�˿ں�</param>
        /// <param name="user">��½�ʺ�</param>
        /// <param name="pass">��½����</param>
        /// <param name="mode">���ӷ�ʽ</param>
        /// <param name="timeout">����Ӧʱ��(��ʱ),��λ:�� (С�ڻ����0Ϊ����ʱ������)</param>
        public FTPHelper(string server, int port, string user, string pass, int mode, int timeout_sec)
        {
            this.server = server;
            this.user = user;
            this.pass = pass;
            this.port = port;
            passive_mode = mode <= 1 ? true : false;
            main_sock = null;
            main_ipEndPoint = null;
            listening_sock = null;
            data_sock = null;
            data_ipEndPoint = null;
            file = null;
            bucket = "";
            bytes_total = 0;
            this.timeout = (timeout_sec <= 0) ? int.MaxValue : (timeout_sec * 1000);    //����Ӧʱ��
            messages = "";
            errormessage = "";
        }

        #endregion

        #region ����
        /// <summary>
        /// ��ǰ�Ƿ�������
        /// </summary>
        public bool IsConnected
        {
            get
            {
                if (main_sock != null)
                    return main_sock.Connected;
                return false;
            }
        }

        /// <summary>
        /// ��message�������������򷵻�
        /// </summary>
        public bool MessagesAvailable
        {
            get
            {
                if (messages.Length > 0)
                    return true;
                return false;
            }
        }

        /// <summary>
        /// ��ȡ������״̬������Ϣ, �����messages����
        /// </summary>
        public string Messages
        {
            get
            {
                string tmp = messages;
                messages = "";
                return tmp;
            }
        }
        /// <summary>
        /// ����ָ��������������Ӧ
        /// </summary>
        public string ResponseString
        {
            get
            {
                return responseStr;
            }
        }


        /// <summary>
        ///��һ�δ�����,���ͻ���յ��ֽ���
        /// </summary>
        public long BytesTotal
        {
            get
            {
                return bytes_total;
            }
        }

        /// <summary>
        ///�����ػ��ϴ����ļ���С,���ļ���С��ЧʱΪ0
        /// </summary>
        public long FileSize
        {
            get
            {
                return file_size;
            }
        }

        /// <summary>
        /// ����ģʽ: 
        /// true ����ģʽ [Ĭ��]
        /// false: ����ģʽ
        /// </summary>
        public bool PassiveMode
        {
            get
            {
                return passive_mode;
            }
            set
            {
                passive_mode = value;
            }
        }

        #endregion

        #region ����

        /// <summary>
        /// ����ʧ��
        /// </summary>
        private void Fail()
        {
            Disconnect();
            errormessage += responseStr;
            //throw new Exception(responseStr);
        }


        private void SetBinaryMode(bool mode)
        {
            if (mode)
                SendCommand("TYPE I");
            else
                SendCommand("TYPE A");

            ReadResponse();
            if (response != 200)
                Fail();
        }


        private void SendCommand(string command)
        {
            Byte[] cmd = Encoding.ASCII.GetBytes((command + "\r\n").ToCharArray());

            if (command.Length > 3 && command.Substring(0, 4) == "PASS")
            {
                messages = "\rPASS xxx";
            }
            else
            {
                messages = "\r" + command;
            }

            try
            {
                main_sock.Send(cmd, cmd.Length, 0);
            }
            catch (Exception ex)
            {
                try
                {
                    Disconnect();
                    errormessage += ex.Message;
                    return;
                }
                catch
                {
                    main_sock.Close();
                    file.Close();
                    main_sock = null;
                    main_ipEndPoint = null;
                    file = null;
                }
            }
        }


        private void FillBucket()
        {
            Byte[] bytes = new Byte[512];
            long bytesgot;
            int msecs_passed = 0;

            while (main_sock.Available < 1)
            {
                System.Threading.Thread.Sleep(50);
                msecs_passed += 50;
                //���ȴ�ʱ�䵽,��Ͽ�����
                if (msecs_passed > timeout)
                {
                    Disconnect();
                    errormessage += "Timed out waiting on server to respond.";
                    return;
                }
            }

            while (main_sock.Available > 0)
            {
                bytesgot = main_sock.Receive(bytes, 512, 0);
                bucket += Encoding.ASCII.GetString(bytes, 0, (int)bytesgot);
                System.Threading.Thread.Sleep(50);
            }
        }


        private string GetLineFromBucket()
        {
            int i;
            string buf = "";

            if ((i = bucket.IndexOf('\n')) < 0)
            {
                while (i < 0)
                {
                    FillBucket();
                    i = bucket.IndexOf('\n');
                }
            }

            buf = bucket.Substring(0, i);
            bucket = bucket.Substring(i + 1);

            return buf;
        }


        /// <summary>
        /// ���ط������˷�����Ϣ
        /// </summary>
        private void ReadResponse()
        {
            string buf;
            messages = "";

            while (true)
            {
                buf = GetLineFromBucket();

                if (Regex.Match(buf, "^[0-9]+ ").Success)
                {
                    responseStr = buf;
                    response = int.Parse(buf.Substring(0, 3));
                    break;
                }
                else
                    messages += Regex.Replace(buf, "^[0-9]+-", "") + "\n";
            }
        }


        /// <summary>
        /// �������׽���
        /// </summary>
        private void OpenDataSocket()
        {
            if (passive_mode)
            {
                string[] pasv;
                string server;
                int port;

                Connect();
                SendCommand("PASV");
                ReadResponse();
                if (response != 227)
                    Fail();

                try
                {
                    int i1, i2;

                    i1 = responseStr.IndexOf('(') + 1;
                    i2 = responseStr.IndexOf(')') - i1;
                    pasv = responseStr.Substring(i1, i2).Split(',');
                }
                catch (Exception)
                {
                    Disconnect();
                    errormessage += "Malformed PASV response: " + responseStr;
                    return ;
                }

                if (pasv.Length < 6)
                {
                    Disconnect();
                    errormessage += "Malformed PASV response: " + responseStr;
                    return ;
                }

                server = String.Format("{0}.{1}.{2}.{3}", pasv[0], pasv[1], pasv[2], pasv[3]);
                port = (int.Parse(pasv[4]) << 8) + int.Parse(pasv[5]);

                try
                {
                    CloseDataSocket();

                    data_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

#if NET1
                    data_ipEndPoint = new IPEndPoint(Dns.GetHostByName(server).AddressList[0], port);
#else
                    data_ipEndPoint = new IPEndPoint(System.Net.Dns.GetHostEntry(server).AddressList[0], port);
#endif

                    data_sock.Connect(data_ipEndPoint);

                }
                catch (Exception ex)
                {
                    errormessage += "Failed to connect for data transfer: " + ex.Message;
                    return ;
                }
            }
            else
            {
                Connect();

                try
                {
                    CloseDataSocket();

                    listening_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

                    // ���ڶ˿�,����IP��ַ.��������ȡ��Ӧ��Ϣ
                    string sLocAddr = main_sock.LocalEndPoint.ToString();
                    int ix = sLocAddr.IndexOf(':');
                    if (ix < 0)
                    {
                        errormessage += "Failed to parse the local address: " + sLocAddr;
                        return;
                    }
                    string sIPAddr = sLocAddr.Substring(0, ix);
                    // ϵͳ�Զ���һ���˿ں�(���� port = 0)
                    System.Net.IPEndPoint localEP = new IPEndPoint(IPAddress.Parse(sIPAddr), 0);

                    listening_sock.Bind(localEP);
                    sLocAddr = listening_sock.LocalEndPoint.ToString();
                    ix = sLocAddr.IndexOf(':');
                    if (ix < 0)
                    {
                        errormessage += "Failed to parse the local address: " + sLocAddr;

                    }
                    int nPort = int.Parse(sLocAddr.Substring(ix + 1));

                    // ��ʼ������������
                    listening_sock.Listen(1);
                    string sPortCmd = string.Format("PORT {0},{1},{2}",
                                                    sIPAddr.Replace('.', ','),
                                                    nPort / 256, nPort % 256);
                    SendCommand(sPortCmd);
                    ReadResponse();
                    if (response != 200)
                        Fail();
                }
                catch (Exception ex)
                {
                    errormessage += "Failed to connect for data transfer: " + ex.Message;
                    return;
                }
            }
        }


        private void ConnectDataSocket()
        {
            if (data_sock != null)        // ������
                return;

            try
            {
                data_sock = listening_sock.Accept();    // Accept is blocking
                listening_sock.Close();
                listening_sock = null;

                if (data_sock == null)
                {
                    throw new Exception("Winsock error: " +
                        Convert.ToString(System.Runtime.InteropServices.Marshal.GetLastWin32Error()));
                }
            }
            catch (Exception ex)
            {
                errormessage += "Failed to connect for data transfer: " + ex.Message;
            }
        }


        private void CloseDataSocket()
        {
            if (data_sock != null)
            {
                if (data_sock.Connected)
                {
                    data_sock.Close();
                }
                data_sock = null;
            }

            data_ipEndPoint = null;
        }

        /// <summary>
        /// �ر���������
        /// </summary>
        public void Disconnect()
        {
            CloseDataSocket();

            if (main_sock != null)
            {
                if (main_sock.Connected)
                {
                    SendCommand("QUIT");
                    main_sock.Close();
                }
                main_sock = null;
            }

            if (file != null)
                file.Close();

            main_ipEndPoint = null;
            file = null;
        }

        /// <summary>
        /// ���ӵ�FTP������
        /// </summary>
        /// <param name="server">Ҫ���ӵ�IP��ַ��������</param>
        /// <param name="port">�˿ں�</param>
        /// <param name="user">��½�ʺ�</param>
        /// <param name="pass">��½����</param>
        public void Connect(string server, int port, string user, string pass)
        {
            this.server = server;
            this.user = user;
            this.pass = pass;
            this.port = port;

            Connect();
        }

        /// <summary>
        /// ���ӵ�FTP������
        /// </summary>
        /// <param name="server">Ҫ���ӵ�IP��ַ��������</param>
        /// <param name="user">��½�ʺ�</param>
        /// <param name="pass">��½����</param>
        public void Connect(string server, string user, string pass)
        {
            this.server = server;
            this.user = user;
            this.pass = pass;

            Connect();
        }

        /// <summary>
        /// ���ӵ�FTP������
        /// </summary>
        public bool Connect()
        {
            if (server == null)
            {
                errormessage += "No server has been set.\r\n";
            }
            if (user == null)
            {
                errormessage += "No server has been set.\r\n";
            }

            if (main_sock != null)
                if (main_sock.Connected)
                    return true;

            try
            {
                main_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
#if NET1
                main_ipEndPoint = new IPEndPoint(Dns.GetHostByName(server).AddressList[0], port);
#else
                main_ipEndPoint = new IPEndPoint(System.Net.Dns.GetHostEntry(server).AddressList[0], port);
#endif

                main_sock.Connect(main_ipEndPoint);
            }
            catch (Exception ex)
            {
                errormessage += ex.Message;
                return false;
            }

            ReadResponse();
            if (response != 220)
                Fail();

            SendCommand("USER " + user);
            ReadResponse();

            switch (response)
            {
                case 331:
                    if (pass == null)
                    {
                        Disconnect();
                        errormessage += "No password has been set.";
                        return false;
                    }
                    SendCommand("PASS " + pass);
                    ReadResponse();
                    if (response != 230)
                    {
                        Fail();
                        return false;
                    }
                    break;
                case 230:
                    break;
            }

            return true;
        }

        /// <summary>
        /// ��ȡFTP��ǰ(����)Ŀ¼�µ��ļ��б�
        /// </summary>
        /// <returns>�����ļ��б�����</returns>
        public ArrayList List()
        {
            Byte[] bytes = new Byte[512];
            string file_list = "";
            long bytesgot = 0;
            int msecs_passed = 0;
            ArrayList list = new ArrayList();

            Connect();
            OpenDataSocket();
            SendCommand("LIST");
            ReadResponse();

            switch (response)
            {
                case 125:
                case 150:
                    break;
                default:
                    CloseDataSocket();
                    throw new Exception(responseStr);
            }
            ConnectDataSocket();

            while (data_sock.Available < 1)
            {
                System.Threading.Thread.Sleep(50);
                msecs_passed += 50;

                if (msecs_passed > (timeout / 10))
                {
                    break;
                }
            }

            while (data_sock.Available > 0)
            {
                bytesgot = data_sock.Receive(bytes, bytes.Length, 0);
                file_list += Encoding.ASCII.GetString(bytes, 0, (int)bytesgot);
                System.Threading.Thread.Sleep(50);
            }

            CloseDataSocket();

            ReadResponse();
            if (response != 226)
                throw new Exception(responseStr);

            foreach (string f in file_list.Split('\n'))
            {
                if (f.Length > 0 && !Regex.Match(f, "^total").Success)
                    list.Add(f.Substring(0, f.Length - 1));
            }

            return list;
        }

        /// <summary>
        /// ��ȡ���ļ����б�
        /// </summary>
        /// <returns>�����ļ����б�</returns>
        public ArrayList ListFiles()
        {
            ArrayList list = new ArrayList();

            foreach (string f in List())
            {
                if ((f.Length > 0))
                {
                    if ((f[0] != 'd') && (f.ToUpper().IndexOf("<DIR>") < 0))
                        list.Add(f);
                }
            }

            return list;
        }

        /// <summary>
        /// ��ȡ·���б�
        /// </summary>
        /// <returns>����·���б�</returns>
        public ArrayList ListDirectories()
        {
            ArrayList list = new ArrayList();

            foreach (string f in List())
            {
                if (f.Length > 0)
                {
                    if ((f[0] == 'd') || (f.ToUpper().IndexOf("<DIR>") >= 0))
                        list.Add(f);
                }
            }

            return list;
        }

        /// <summary>
        /// ��ȡԭʼ������Ϣ.
        /// </summary>
        /// <param name="fileName">Զ���ļ���</param>
        /// <returns>����ԭʼ������Ϣ.</returns>
        public string GetFileDateRaw(string fileName)
        {
            Connect();

            SendCommand("MDTM " + fileName);
            ReadResponse();
            if (response != 213)
            {
                errormessage += responseStr;
                return "";
            }

            return (this.responseStr.Substring(4));
        }

        /// <summary>
        /// �õ��ļ�����.
        /// </summary>
        /// <param name="fileName">Զ���ļ���</param>
        /// <returns>����Զ���ļ�����</returns>
        public DateTime GetFileDate(string fileName)
        {
            return ConvertFTPDateToDateTime(GetFileDateRaw(fileName));
        }

        private DateTime ConvertFTPDateToDateTime(string input)
        {
            if (input.Length < 14)
                throw new ArgumentException("Input Value for ConvertFTPDateToDateTime method was too short.");

            //YYYYMMDDhhmmss": 
            int year = Convert.ToInt16(input.Substring(0, 4));
            int month = Convert.ToInt16(input.Substring(4, 2));
            int day = Convert.ToInt16(input.Substring(6, 2));
            int hour = Convert.ToInt16(input.Substring(8, 2));
            int min = Convert.ToInt16(input.Substring(10, 2));
            int sec = Convert.ToInt16(input.Substring(12, 2));

            return new DateTime(year, month, day, hour, min, sec);
        }

        /// <summary>
        /// ��ȡFTP�ϵĵ�ǰ(����)·��
        /// </summary>
        /// <returns>����FTP�ϵĵ�ǰ(����)·��</returns>
        public string GetWorkingDirectory()
        {
            //PWD - ��ʾ����·��
            Connect();
            SendCommand("PWD");
            ReadResponse();

            if (response != 257)
            {
                errormessage += responseStr;
            }

            string pwd;
            try
            {
                pwd = responseStr.Substring(responseStr.IndexOf("\"", 0) + 1);//5);
                pwd = pwd.Substring(0, pwd.LastIndexOf("\""));
                pwd = pwd.Replace("\"\"", "\""); // �滻�����ŵ�·����Ϣ����
            }
            catch (Exception ex)
            {
                errormessage += ex.Message;
                return null;
            }

            return pwd;
        }


        /// <summary>
        /// ��ת�������ϵĵ�ǰ(����)·��
        /// </summary>
        /// <param name="path">Ҫ��ת��·��</param>
        public bool ChangeDir(string path)
        {
            Connect();
            SendCommand("CWD " + path);
            ReadResponse();
            if (response != 250)
            {
                errormessage += responseStr;
                return false;
            }
            return true;
        }

        /// <summary>
        /// ����ָ����Ŀ¼
        /// </summary>
        /// <param name="dir">Ҫ������Ŀ¼</param>
        public void MakeDir(string dir)
        {
            Connect();
            SendCommand("MKD " + dir);
            ReadResponse();

            switch (response)
            {
                case 257:
                case 250:
                    break;
                default:
                    {
                        errormessage += responseStr;
                        break;
                    }
            }
        }

        /// <summary>
        /// �Ƴ�FTP�ϵ�ָ��Ŀ¼
        /// </summary>
        /// <param name="dir">Ҫ�Ƴ���Ŀ¼</param>
        public void RemoveDir(string dir)
        {
            Connect();
            SendCommand("RMD " + dir);
            ReadResponse();
            if (response != 250)
            {
                errormessage += responseStr;
                return; ;
            }
        }

        /// <summary>
        /// �Ƴ�FTP�ϵ�ָ���ļ�
        /// </summary>
        /// <param name="filename">Ҫ�Ƴ����ļ�����</param>
        public void RemoveFile(string filename)
        {
            Connect();
            SendCommand("DELE " + filename);
            ReadResponse();
            if (response != 250)
            {
                errormessage += responseStr;
            }
        }

        /// <summary>
        /// ������FTP�ϵ��ļ�
        /// </summary>
        /// <param name="oldfilename">ԭ�ļ���</param>
        /// <param name="newfilename">���ļ���</param>
        public void RenameFile(string oldfilename, string newfilename)
        {
            Connect();
            SendCommand("RNFR " + oldfilename);
            ReadResponse();
            if (response != 350)
            {
                errormessage += responseStr;
            }
            else
            {
                SendCommand("RNTO " + newfilename);
                ReadResponse();
                if (response != 250)
                {
                    errormessage += responseStr;
                }
            }
        }

        /// <summary>
        /// ���ָ���ļ��Ĵ�С(���FTP֧��)
        /// </summary>
        /// <param name="filename">ָ�����ļ�</param>
        /// <returns>����ָ���ļ��Ĵ�С</returns>
        public long GetFileSize(string filename)
        {
            Connect();
            SendCommand("SIZE " + filename);
            ReadResponse();
            if (response != 213)
            {
                errormessage += responseStr;
            }

            return Int64.Parse(responseStr.Substring(4));
        }

        /// <summary>
        /// �ϴ�ָ�����ļ�
        /// </summary>
        /// <param name="filename">Ҫ�ϴ����ļ�</param>
        public bool OpenUpload(string filename)
        {
            return OpenUpload(filename, filename, false);
        }

        /// <summary>
        /// �ϴ�ָ�����ļ�
        /// </summary>
        /// <param name="filename">�����ļ���</param>
        /// <param name="remotefilename">Զ��Ҫ���ǵ��ļ���</param>
        public bool OpenUpload(string filename, string remotefilename)
        {
            return OpenUpload(filename, remotefilename, false);
        }

        /// <summary>
        /// �ϴ�ָ�����ļ�
        /// </summary>
        /// <param name="filename">�����ļ���</param>
        /// <param name="resume">�������,���Իָ�</param>
        public bool OpenUpload(string filename, bool resume)
        {
            return OpenUpload(filename, filename, resume);
        }

        /// <summary>
        /// �ϴ�ָ�����ļ�
        /// </summary>
        /// <param name="filename">�����ļ���</param>
        /// <param name="remote_filename">Զ��Ҫ���ǵ��ļ���</param>
        /// <param name="resume">�������,���Իָ�</param>
        public bool OpenUpload(string filename, string remote_filename, bool resume)
        {
            Connect();
            SetBinaryMode(true);
            OpenDataSocket();

            bytes_total = 0;

            try
            {
                file = new FileStream(filename, FileMode.Open);
            }
            catch (Exception ex)
            {
                file = null;
                errormessage += ex.Message;
                return false;
            }

            file_size = file.Length;

            if (resume)
            {
                long size = GetFileSize(remote_filename);
                SendCommand("REST " + size);
                ReadResponse();
                if (response == 350)
                    file.Seek(size, SeekOrigin.Begin);
            }

            SendCommand("STOR " + remote_filename);
            ReadResponse();

            switch (response)
            {
                case 125:
                case 150:
                    break;
                default:
                    file.Close();
                    file = null;
                    errormessage += responseStr;
                    return false;
            }
            ConnectDataSocket();

            return true;
        }

        /// <summary>
        /// ����ָ���ļ�
        /// </summary>
        /// <param name="filename">Զ���ļ�����</param>
        public void OpenDownload(string filename)
        {
            OpenDownload(filename, filename, false);
        }

        /// <summary>
        /// ���ز��ָ�ָ���ļ�
        /// </summary>
        /// <param name="filename">Զ���ļ�����</param>
        /// <param name="resume">���ļ�����,���Իָ�</param>
        public void OpenDownload(string filename, bool resume)
        {
            OpenDownload(filename, filename, resume);
        }

        /// <summary>
        /// ����ָ���ļ�
        /// </summary>
        /// <param name="filename">Զ���ļ�����</param>
        /// <param name="localfilename">�����ļ���</param>
        public void OpenDownload(string remote_filename, string localfilename)
        {
            OpenDownload(remote_filename, localfilename, false);
        }

        /// <summary>
        /// �򿪲������ļ�
        /// </summary>
        /// <param name="remote_filename">Զ���ļ�����</param>
        /// <param name="local_filename">�����ļ���</param>
        /// <param name="resume">����ļ�������ָ�</param>
        public void OpenDownload(string remote_filename, string local_filename, bool resume)
        {
            Connect();
            SetBinaryMode(true);

            bytes_total = 0;

            try
            {
                file_size = GetFileSize(remote_filename);
            }
            catch
            {
                file_size = 0;
            }

            if (resume && File.Exists(local_filename))
            {
                try
                {
                    file = new FileStream(local_filename, FileMode.Open);
                }
                catch (Exception ex)
                {
                    file = null;
                    throw new Exception(ex.Message);
                }

                SendCommand("REST " + file.Length);
                ReadResponse();
                if (response != 350)
                    throw new Exception(responseStr);
                file.Seek(file.Length, SeekOrigin.Begin);
                bytes_total = file.Length;
            }
            else
            {
                try
                {
                    file = new FileStream(local_filename, FileMode.Create);
                }
                catch (Exception ex)
                {
                    file = null;
                    throw new Exception(ex.Message);
                }
            }

            OpenDataSocket();
            SendCommand("RETR " + remote_filename);
            ReadResponse();

            switch (response)
            {
                case 125:
                case 150:
                    break;
                default:
                    file.Close();
                    file = null;
                    errormessage += responseStr;
                    return;
            }
            ConnectDataSocket();

            return;
        }

        /// <summary>
        /// �ϴ��ļ�(ѭ������ֱ���ϴ����)
        /// </summary>
        /// <returns>���͵��ֽ���</returns>
        public long DoUpload()
        {
            Byte[] bytes = new Byte[512];
            long bytes_got;

            try
            {
                bytes_got = file.Read(bytes, 0, bytes.Length);
                bytes_total += bytes_got;
                data_sock.Send(bytes, (int)bytes_got, 0);

                if (bytes_got <= 0)
                {
                    //�ϴ���ϻ��д�����
                    file.Close();
                    file = null;

                    CloseDataSocket();
                    ReadResponse();
                    switch (response)
                    {
                        case 226:
                        case 250:
                            break;
                        default: //���ϴ��ж�ʱ
                            {
                                errormessage += responseStr;
                                return -1; 
                            }
                    }

                    SetBinaryMode(false);
                }
            }
            catch (Exception ex)
            {
                file.Close();
                file = null;
                CloseDataSocket();
                ReadResponse();
                SetBinaryMode(false);
                //throw ex;
                //���ϴ��ж�ʱ
                errormessage += ex.Message;
                return -1;
            }

            return bytes_got;
        }

        /// <summary>
        /// �����ļ�(ѭ������ֱ���������)
        /// </summary>
        /// <returns>���յ����ֽڵ�</returns>
        public long DoDownload()
        {
            Byte[] bytes = new Byte[512];
            long bytes_got;

            try
            {
                bytes_got = data_sock.Receive(bytes, bytes.Length, 0);

                if (bytes_got <= 0)
                {
                    //������ϻ��д�����
                    CloseDataSocket();
                    file.Close();
                    file = null;

                    ReadResponse();
                    switch (response)
                    {
                        case 226:
                        case 250:
                            break;
                        default:
                            {
                                errormessage += responseStr;
                                return -1;
                            }
                    }

                    SetBinaryMode(false);

                    return bytes_got;
                }

                file.Write(bytes, 0, (int)bytes_got);
                bytes_total += bytes_got;
            }
            catch (Exception ex)
            {
                CloseDataSocket();
                file.Close();
                file = null;
                ReadResponse();
                SetBinaryMode(false);
                //throw ex;
                //�������ж�ʱ
                errormessage += ex.Message;
                return -1;
            }

            return bytes_got;
        }

        #endregion
    }
}