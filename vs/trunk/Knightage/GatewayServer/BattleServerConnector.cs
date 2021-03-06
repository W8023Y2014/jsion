﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Reflection;
using log4net;
using GameBase.Net;

namespace GatewayServer
{
    public class BattleServerConnector : ServerConnector
    {
        //private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public int ID { get; protected set; }

        public BattleServerConnector(int id)
            : base()
        {
            ID = id;

            GatewayGlobal.ConnectingMgr.Add(ID, this);
        }

        public override string ServerName
        {
            get
            {
                return "战斗服务器";
            }
        }

        protected override void OnConnected(bool successed)
        {
            base.OnConnected(successed);

            if (successed)
            {
                GatewayGlobal.ConnectingMgr.Remove(ID);
                GatewayGlobal.BattleServerMgr.Add(ID, this);
            }
            else
            {
                GatewayGlobal.ConnectingMgr.Remove(ID);
            }
        }

        protected override void OnDisconnect()
        {
            base.OnDisconnect();

            if (GatewayGlobal.BattleServerMgr[ID] == this)
            {
                GatewayGlobal.BattleServerMgr.Remove(ID);
            }
        }
    }
}
