﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase.Datas;

namespace GameBase
{
    public partial class Player
    {
        public int PlayerID { get; protected set; }

        public string Account { get; protected set; }

        public string NickName { get; protected set; }

        public ClientBase Client { get; protected set; }

        public LoginInfo LoginInfo { get; protected set; }

        public Player(LoginInfo info, ClientBase client)
        {
            PlayerID = info.PlayerID;
            Account = info.Account;
            NickName = info.NickName;
            Client = client;
        }

        public void SendTcp(GamePacket pkg)
        {
            if (pkg == null) return;

            if (pkg.PlayerID == 0)
            {
                pkg.PlayerID = PlayerID;
            }

            Client.SendTcp(pkg);
        }

        public virtual void Logined()
        {
            //TODO: 加载玩家其他信息
        }

        public virtual void Logout()
        {
            //TODO: 发送被踢下线数据包
        }

        public virtual void OnDisconnect()
        {
        }
    }
}
