﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace GatewayServer
{
    public class GatewayClient : ClientBase
    {
        public int ClientID { get; set; }

        public GatewayClient()
            : base()
        { }

        protected override void OnDisconnected()
        {
            base.OnDisconnected();

            GatewayGlobal.PlayerClientMgr.Remove(ClientID);
        }
    }
}
