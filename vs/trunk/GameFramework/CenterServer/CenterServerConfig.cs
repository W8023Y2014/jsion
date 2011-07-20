﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion;
using System.Reflection;
using System.IO;
using JsionFramework.Jsion.Attributes;

namespace CenterServer
{
    public class CenterServerConfig : AppConfigAbstract
    {
        #region 配置项

        [AppConfig("Port", "中心服务器监听端口", 7710)]
        public int Port;

        [AppConfig("ServerCountMax", "游戏服务器数量", 8)]
        public int ServerCountMax;

        #endregion
















        public void Refresh()
        {
            Load(typeof(CenterServerConfig));
        }

        public string RootDirectory;

        protected override void Load(Type type)
        {
            if (Assembly.GetEntryAssembly() != null)
            {
                RootDirectory = new FileInfo(Assembly.GetEntryAssembly().Location).DirectoryName;
            }
            else
            {
                RootDirectory = new FileInfo(Assembly.GetAssembly(typeof(CSServer)).Location).DirectoryName;
            }

            base.Load(type);
        }
    }
}
