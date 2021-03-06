﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Managers;
using GameBase;
using GameBase.Net;
using GatewayServer.Packets.OutClientPackets;
using GatewayServer.Packets.OutServerPackets;
using System.Timers;
using System.Reflection;
using log4net;
using GameBase.Packets.OutPackets;

namespace GatewayServer
{
    public class GatewayGlobal
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static int GatewayID = 0;

        public static int ClientCount = 0;

        public static readonly CenterServerConnector CenterServer = new CenterServerConnector(ServerType.GatewayServer, GatewayServerConfig.Configuration.Port);

        public static readonly ObjectMgr<int, BattleServerConnector> ConnectingMgr = new ObjectMgr<int, BattleServerConnector>();

        public static readonly ObjectMgr<int, BattleServerConnector> BattleServerMgr = new ObjectMgr<int, BattleServerConnector>();

        public static readonly ObjectMgr<int, LogicServerConnector> LogicConnectingMgr = new ObjectMgr<int, LogicServerConnector>();

        public static readonly ObjectMgr<int, LogicServerConnector> LogicServerMgr = new ObjectMgr<int, LogicServerConnector>();



        public static readonly ObjectMgr<int, GatewayClient> Clients = new ObjectMgr<int, GatewayClient>();
        public static readonly ObjectMgr<int, GatewayPlayer> Players = new ObjectMgr<int, GatewayPlayer>();


        public static void Send2Center(GamePacket pkg, ClientBase client)
        {
            if (CenterServer.Socket.Connected)
            {
                CenterServer.SendTCP(pkg);
            }
            else
            {
                //TODO: 通知客户端无可用中心服务器

                if (client != null)
                {
                    ClientMsgPacket p = new ClientMsgPacket();

                    p.MsgFlag = MsgFlag.NoneCenter;

                    client.SendTcp(p);
                }
            }
        }



        //当前网关相关状态

        private static bool Fulled = false;

        private static readonly object m_syncRoot = new object();

        private static Timer m_timer = new Timer();

        public static void CheckMaxClientCount(GatewayClient client)
        {
            lock (m_syncRoot)
            {
                if (Fulled)
                {
                    //TODO: 服务器已满 请求中心服务器更换网关

                    ChangeGatewayPacket pkg = new ChangeGatewayPacket();

                    pkg.ClientID = client.ClientID;

                    GatewayGlobal.Send2Center(pkg, client);

                    return;
                }
            }

            if (ClientMgr.Instance.ClientCount >= GatewayServerConfig.Configuration.MaxClients)
            {
                lock (m_syncRoot)
                {
                    Fulled = true;

                    //TODO: 通知中心服务器此网关已满 并N分钟后重置为未满

                    UpdateServerFullPacket pkg = new UpdateServerFullPacket();

                    pkg.ClientID = client.ClientID;

                    GatewayGlobal.Send2Center(pkg, client);

                    m_timer.Interval = 300 * 1000;
                    m_timer.Elapsed += new ElapsedEventHandler(m_timer_Elapsed);
                    m_timer.AutoReset = true;
                    m_timer.Start();
                }
            }
            else
            {
                //TODO: 通知客户端登陆

                NoticeLoginPacket pkg = new NoticeLoginPacket();

                client.SendTcp(pkg);
            }
        }

        static void m_timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            lock (m_syncRoot)
            {
                Fulled = false;

                UpdateServerNormalPacket pkg = new UpdateServerNormalPacket();

                GatewayGlobal.Send2Center(pkg, null);

                m_timer.Elapsed -= m_timer_Elapsed;

                m_timer.Stop();
            }
        }



        //逻辑服务器相关

        private static int m_freeID;

        public static LogicServerConnector GetFreeLogicServer(GatewayClient client)
        {
            LogicServerConnector connector = LogicServerMgr[m_freeID];

            if (connector != null && connector.Fulled == false)
            {
                return connector;
            }

            LogicServerConnector connect = LogicServerMgr.SelectSingle(conn => conn.Fulled == false);

            if (connect != null)
            {
                m_freeID = connect.ID;

                connector = connect;

                return connect;
            }
            else if(connector == null)
            {
                //TODO: 通知客户端逻辑服务器已满 稍候登陆

                ClientMsgPacket pkg = new ClientMsgPacket();

                pkg.MsgFlag = MsgFlag.NoneLogic;

                client.SendTcp(pkg);

                log.Warn("所有逻辑服务器满载 请增开新的逻辑服务器");
            }

            return connector;
        }
    }
}
