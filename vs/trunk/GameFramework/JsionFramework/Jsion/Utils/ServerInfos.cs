using System;
using System.Collections.Generic;
using System.Text;

using System.Web;

namespace Jsion.Utils
{
    public class ServerInfos
    {
        /// <summary>
        /// ����ϵͳ
        /// </summary>
        /// <returns></returns>
        public static string ServerOS()
        {
            return Environment.OSVersion.ToString();
        }
        /// <summary>
        /// CPU����
        /// </summary>
        /// <returns></returns>
        public static string CpuSum()
        {
            return Environment.GetEnvironmentVariable("NUMBER_OF_PROCESSORS");
        }
        /// <summary>
        /// CPU����
        /// </summary>
        /// <returns></returns>
        public static string CpuType()
        {
            return Environment.GetEnvironmentVariable("PROCESSOR_IDENTIFIER");
        }
        /// <summary>
        /// DotNET �汾
        /// </summary>
        /// <returns></returns>
        public static string ServerNet()
        {
            return ".NET CLR " + Environment.Version.ToString(); // DotNET �汾
        }
        /// <summary>
        /// ������ʱ��
        /// </summary>
        /// <returns></returns>
        public static string ServerArea()
        {
            return (DateTime.Now - DateTime.UtcNow).TotalHours > 0 ? "+" + (DateTime.Now - DateTime.UtcNow).TotalHours.ToString() : (DateTime.Now - DateTime.UtcNow).TotalHours.ToString();// ������ʱ��
        }
        /// <summary>
        /// ��������ʱ��
        /// </summary>
        /// <returns></returns>
        public static string ServerStart()
        {
            return ((Double)System.Environment.TickCount / 3600000).ToString("N2");// ��������ʱ��
        }
        /// <summary>
        /// ������Hostname
        /// </summary>
        /// <returns></returns>
        public static string ServerHostname()
        {
            return System.Net.Dns.GetHostName();
        }
        /// <summary>
        /// ������IP
        /// </summary>
        /// <returns></returns>
        public static string ServerIP()
        {
            string hostname = System.Net.Dns.GetHostName();

            System.Net.IPHostEntry ip = System.Net.Dns.GetHostEntry(hostname);

            string ipaddress = "";

            foreach (System.Net.IPAddress ipA in ip.AddressList)
            {
                ipaddress = ipaddress + ipA.ToString() + "\n";
            }

            return ipaddress;
        }
    }
}
