﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using System.Net.Sockets;
using GameBase.Packets;
using GameBase.Net;

namespace CenterServer
{
    public class CenterClient : ClientBase
    {
        public int ServerID { get; set; }

        public ServerType Type { get; set; }

        public bool Validated { get; set; }

        public CenterClient()
            : base()
        {
            ServerID = 0;
            Type = ServerType.UnKnowServer;
            Validated = false;
        }

        public override void SendTcp(GamePacket pkg)
        {
            if (Validated) base.SendTcp(pkg);
        }

        public override void HandlePacket(int code, GamePacket packet)
        {
            if (Validated) base.HandlePacket(code, packet);
        }

        public override void HandlePacket(GamePacket packet)
        {
            if (Validated) base.HandlePacket(packet);
        }

        //protected override void Initialize()
        //{
        //    m_handlers = new PacketHandlers(this);
        //}

        protected override void OnDisconnected()
        {
            base.OnDisconnected();

            //switch (Type)
            //{
            //    //case ServerType.UnKnowServer:
            //    //    break;
            //    //case ServerType.CenterServer:
            //    //    break;
            //    case ServerType.LogicServer:
            //        CenterGlobal.GameLogicServerMgr.Remove(this);
            //        break;
            //    case ServerType.BattleServer:
            //        CenterGlobal.BattleServerMgr.Remove(this);
            //        break;
            //    case ServerType.GatewayServer:
            //        CenterGlobal.GatewayServerMgr.Remove(this);
            //        break;
            //    default:
            //        break;
            //}

            //ID = 0;
            //Type = ServerType.UnKnowServer;
            //Validated = false;

        }
    }
}
