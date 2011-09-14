using System;
using System.Text;

// �����������һ������Ϊ2��ʮ�������ֽ����飬
// ʹ��GetString ()����������н���Ϳ��Եõ������ַ��ˡ�
// ���������������ĺ�����֤����˵����Ϊ��15��Ҳ����AF����ǰ��û�к��֣�
// ֻ���������ţ����ֶ��ӵ�16��B0��ʼ�����Ҵ���λD7��ʼ�Ժ�ĺ��ֶ��Ǻͺ��Ѽ����ķ��Ӻ��֣�
// ������Щ��Ҫ�ų���������������ɵĺ���ʮ��������λ���1λ��Χ��B��C��D֮�䣬
// �����1λ��D�Ļ�����2λ��λ��Ͳ�����7�Ժ��ʮ����������
// ����������λ�����ÿ���ĵ�һ��λ�ú����һ��λ�ö��ǿյģ�û�к��֣�
// ���������ɵ���λ���3λ�����A�Ļ�����4λ�Ͳ�����0����3λ�����F�Ļ���
// ��4λ�Ͳ�����F��֪����ԭ������������ĺ��ֵĳ���Ҳ�ͳ����ˣ�


namespace JUtils
{

    /// <summary>
    /// ���¾������ɳ���ΪN���������
    /// </summary>
    public class RandomChinese
    {
        public RandomChinese()
        {
        }

        public static string GetRandomChinese(int strlength)
        {
            // ��ȡGB2312����ҳ���� 
            Encoding gb = Encoding.GetEncoding("gb2312");

            object[] bytes = RandomChinese.CreateRegionCode(strlength);

            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < strlength; i++)
            {
                string temp = gb.GetString((byte[])Convert.ChangeType(bytes[i], typeof(byte[])));
                sb.Append(temp);
            }

            return sb.ToString();
        }

        /// <summary>
        ///   �˺����ں��ֱ��뷶Χ���������������Ԫ�ص�ʮ�������ֽ����飬ÿ���ֽ��������һ�����֣����� 
        ///   �ĸ��ֽ�����洢��object�����С�
        ///   ������strlength��������Ҫ�����ĺ��ָ��� 
        /// </summary>
        /// <param name="strlength"></param>
        /// <returns></returns>
        private static object[] CreateRegionCode(int strlength)
        {
            //����һ���ַ������鴢�溺�ֱ�������Ԫ�� 
            string[] rBase = new String[16] { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" };

            Random rnd = new Random();

            //����һ��object�������� 
            object[] bytes = new object[strlength];

            /**
             ÿѭ��һ�β���һ��������Ԫ�ص�ʮ�������ֽ����飬���������bytes������ 
             ÿ���������ĸ���λ����� 
             ��λ���1λ����λ���2λ��Ϊ�ֽ������һ��Ԫ�� 
             ��λ���3λ����λ���4λ��Ϊ�ֽ�����ڶ���Ԫ�� 
            **/
            for (int i = 0; i < strlength; i++)
            {
                //��λ���1λ 
                int r1 = rnd.Next(11, 14);
                string str_r1 = rBase[r1].Trim();

                //��λ���2λ 
                rnd = new Random(r1 * unchecked((int)DateTime.Now.Ticks) + i); // ����������������� ���ӱ�������ظ�ֵ 
                int r2;
                if (r1 == 13)
                {
                    r2 = rnd.Next(0, 7);
                }
                else
                {
                    r2 = rnd.Next(0, 16);
                }
                string str_r2 = rBase[r2].Trim();

                //��λ���3λ 
                rnd = new Random(r2 * unchecked((int)DateTime.Now.Ticks) + i);
                int r3 = rnd.Next(10, 16);
                string str_r3 = rBase[r3].Trim();

                //��λ���4λ 
                rnd = new Random(r3 * unchecked((int)DateTime.Now.Ticks) + i);
                int r4;
                if (r3 == 10)
                {
                    r4 = rnd.Next(1, 16);
                }
                else if (r3 == 15)
                {
                    r4 = rnd.Next(0, 15);
                }
                else
                {
                    r4 = rnd.Next(0, 16);
                }
                string str_r4 = rBase[r4].Trim();

                // ���������ֽڱ����洢���������������λ�� 
                byte byte1 = Convert.ToByte(str_r1 + str_r2, 16);
                byte byte2 = Convert.ToByte(str_r3 + str_r4, 16);
                // �������ֽڱ����洢���ֽ������� 
                byte[] str_r = new byte[] { byte1, byte2 };

                // ��������һ�����ֵ��ֽ��������object������ 
                bytes.SetValue(str_r, i);
            }

            return bytes;
        }
    }
}