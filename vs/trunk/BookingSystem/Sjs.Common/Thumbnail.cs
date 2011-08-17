using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

namespace Sjs.Common
{
    public class Thumbnail
    {
        private Image srcImage;
        private string srcFileName;


        /// <summary>
        /// ���ڴ��д���Image
        /// ����ɹ��򷵻�True.���򷵻�False
        /// </summary>
        /// <param name="FileName">ԭʼͼƬ·��</param>
        public bool SetImage(string FileName)
        {
            srcFileName = Utils.GetMapPath(FileName);
            try
            {
                srcImage = Image.FromFile(srcFileName);
            }
            catch
            {
                return false;
            }
            return true;

        }

        /// <summary>
        /// �ص�
        /// </summary>
        /// <returns></returns>
        public bool ThumbnailCallback()
        {
            return false;
        }

        /// <summary>
        /// ��������ͼ,��������ͼ��Image����
        /// </summary>
        /// <param name="Width">����ͼ����</param>
        /// <param name="Height">����ͼ�߶�</param>
        /// <returns>����ͼ��Image����</returns>
        public Image GetImage(int Width, int Height)
        {
            Image img;
            Image.GetThumbnailImageAbort callb = new Image.GetThumbnailImageAbort(ThumbnailCallback);
            img = srcImage.GetThumbnailImage(Width, Height, callb, IntPtr.Zero);
            return img;
        }

        /// <summary>
        /// ��������ͼ
        /// </summary>
        /// <param name="Width"></param>
        /// <param name="Height"></param>
        public void SaveThumbnailImage(int Width, int Height)
        {
            switch (Path.GetExtension(srcFileName).ToLower())
            {
                case ".png":
                    SaveImage(Width, Height, ImageFormat.Png);
                    break;
                case ".gif":
                    SaveImage(Width, Height, ImageFormat.Gif);
                    break;
                default:
                    SaveImage(Width, Height, ImageFormat.Jpeg);
                    break;
            }
        }

        /// <summary>
        /// ��������ͼ������
        /// </summary>
        /// <param name="Width">����ͼ�Ŀ���</param>
        /// <param name="Height">����ͼ�ĸ߶�</param>
        /// <param name="imgformat">�����ͼ���ʽ</param>
        /// <returns>����ͼ��Image����</returns>
        public void SaveImage(int Width, int Height, ImageFormat imgformat)
        {
            if ((srcImage.Width > Width) || (srcImage.Height > Height))
            {

                Image img;
                Image.GetThumbnailImageAbort callb = new Image.GetThumbnailImageAbort(ThumbnailCallback);
                img = srcImage.GetThumbnailImage(Width, Height, callb, IntPtr.Zero);
                srcImage.Dispose();
                img.Save(srcFileName, imgformat);
                img.Dispose();
            }
        }

        #region Helper

        /// <summary>
        /// ����ͼƬ
        /// </summary>
        /// <param name="image">Image ����</param>
        /// <param name="savePath">����·��</param>
        /// <param name="ici">ָ����ʽ�ı�������</param>
        private static void SaveImage(Image image, string savePath, ImageCodecInfo ici)
        {
            //���� ԭͼƬ ����� EncoderParameters ����
            EncoderParameters parameters = new EncoderParameters(1);
            parameters.Param[0] = new EncoderParameter(Encoder.Quality, ((long)100));
            image.Save(savePath, ici, parameters);
            parameters.Dispose();
        }

        /// <summary>
        /// ��ȡͼ���������������������Ϣ
        /// </summary>
        /// <param name="mimeType">��������������Ķ���;�����ʼ�����Э�� (MIME) ���͵��ַ���</param>
        /// <returns>����ͼ���������������������Ϣ</returns>
        private static ImageCodecInfo GetCodecInfo(string mimeType)
        {
            ImageCodecInfo[] CodecInfo = ImageCodecInfo.GetImageEncoders();
            foreach (ImageCodecInfo ici in CodecInfo)
            {
                if (ici.MimeType == mimeType) return ici;
            }
            return null;
        }

        /// <summary>
        /// �����³ߴ�
        /// </summary>
        /// <param name="width">ԭʼ����</param>
        /// <param name="height">ԭʼ�߶�</param>
        /// <param name="maxWidth">����¿���</param>
        /// <param name="maxHeight">����¸߶�</param>
        /// <returns></returns>
        private static Size ResizeImage(int width, int height, int maxWidth, int maxHeight)
        {
            decimal MAX_WIDTH = (decimal)maxWidth;
            decimal MAX_HEIGHT = (decimal)maxHeight;
            decimal ASPECT_RATIO = MAX_WIDTH / MAX_HEIGHT;

            int newWidth, newHeight;

            decimal originalWidth = (decimal)width;
            decimal originalHeight = (decimal)height;

            if (originalWidth > MAX_WIDTH || originalHeight > MAX_HEIGHT)
            {
                decimal factor;
                // determine the largest factor 
                if (originalWidth / originalHeight > ASPECT_RATIO)
                {
                    factor = originalWidth / MAX_WIDTH;
                    newWidth = Convert.ToInt32(originalWidth / factor);
                    newHeight = Convert.ToInt32(originalHeight / factor);
                }
                else
                {
                    factor = originalHeight / MAX_HEIGHT;
                    newWidth = Convert.ToInt32(originalWidth / factor);
                    newHeight = Convert.ToInt32(originalHeight / factor);
                }
            }
            else
            {
                newWidth = width;
                newHeight = height;
            }

            return new Size(newWidth, newHeight);

        }

        /// <summary>
        /// �õ�ͼƬ��ʽ
        /// </summary>
        /// <param name="name">�ļ�����</param>
        /// <returns></returns>
        public static ImageFormat GetFormat(string name)
        {
            string ext = name.Substring(name.LastIndexOf(".") + 1);
            switch (ext.ToLower())
            {
                case "jpg":
                case "jpeg":
                    return ImageFormat.Jpeg;
                case "bmp":
                    return ImageFormat.Bmp;
                case "png":
                    return ImageFormat.Png;
                case "gif":
                    return ImageFormat.Gif;
                default:
                    return ImageFormat.Jpeg;
            }
        }
        #endregion

        /// <summary>
        /// ����С������
        /// </summary>
        /// <param name="fileName">ԭͼ���ļ�·��</param>
        /// <param name="newFileName">�µ�ַ</param>
        /// <param name="newSize">���Ȼ����</param>
        public static void MakeSquareImage(string fileName, string newFileName, int newSize)
        {
            Image image = Image.FromFile(fileName);

            int i = 0;
            int width = image.Width;
            int height = image.Height;
            if (width > height)
            {
                i = height;
            }
            else
            {
                i = width;
            }
            Bitmap b = new Bitmap(newSize, newSize);

            try
            {
                Graphics g = Graphics.FromImage(b);
                g.InterpolationMode = InterpolationMode.High;
                g.SmoothingMode = SmoothingMode.HighQuality;

                //���������ͼ�沢��͸������ɫ���
                g.Clear(Color.Transparent);
                if (width < height)
                {
                    g.DrawImage(image, new Rectangle(0, 0, newSize, newSize), new Rectangle(0, (height - width) / 2, width, width), GraphicsUnit.Pixel);
                }
                else
                {
                    g.DrawImage(image, new Rectangle(0, 0, newSize, newSize), new Rectangle((width - height) / 2, 0, height, height), GraphicsUnit.Pixel);
                }

                SaveImage(b, newFileName, GetCodecInfo("image/" + GetFormat(fileName).ToString().ToLower()));
            }
            finally
            {
                image.Dispose();
                b.Dispose();
            }

        }


        /// <summary>
        /// ��������ͼ
        /// </summary>
        /// <param name="fileName">ԭͼ·��</param>
        /// <param name="newFileName">��ͼ·��</param>
        /// <param name="maxWidth">������</param>
        /// <param name="maxHeight">���߶�</param>
        public static void MakeThumbnailImage(string fileName, string newFileName, int maxWidth, int maxHeight)
        {
            Image original = Image.FromFile(fileName);

            Size _newSize = ResizeImage(original.Width, original.Height, maxWidth, maxHeight);
            //_image.Height = _newSize.Height;
            //_image.Width = _newSize.Width;
            Image displayImage = new Bitmap(original, _newSize);
            //original.Dispose();

            try
            {
                displayImage.Save(newFileName, GetFormat(fileName));
            }
            finally
            {
                original.Dispose();
            }

        }




    }
}