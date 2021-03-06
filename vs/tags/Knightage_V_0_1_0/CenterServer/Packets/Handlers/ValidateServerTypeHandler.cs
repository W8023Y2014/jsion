﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase;
using GameBase.Net;
using GameBase.Packets.OutPackets;
using GameBase.ServerConfigs;

namespace CenterServer.Packets.Handlers
{
    [PacketHandler((int)BasePacketCode.ValidateServer, "验证服务器类型和有效性")]
    public class ValidateServerTypeHandler : IPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            CenterClient center = client as CenterClient;

            ServerType type = (ServerType)packet.ReadUnsignedByte();

            string ip = packet.ReadUTF();

            int port = packet.ReadInt();

            uint id = 0;

            switch (type)
            {
                //case ServerType.UnKnowServer:
                //    break;
                //case ServerType.CenterServer:
                //    break;
                case ServerType.CacheServer:
                    id = 1;
                    if (CenterServerConfig.Configuration.CacheIP == ip && CenterServerConfig.Configuration.CachePort == port)
                    {
                        CenterGlobal.CacheServer = center;

                        CenterGlobal.GatewayServerMgr.ForEach((c) =>
                        {
                            ConnectCacheServerPacket pkg = new ConnectCacheServerPacket();
                            pkg.IP = ip;
                            pkg.Port = port;
                            c.SendTcp(pkg);
                        });
                    }
                    break;
                case ServerType.LogicServer:
                    id = GameGlobal.GameLogicMgr.GetID(info => info.IP == ip && info.Port == port);
                    if (id > 0)
                    {
                        CenterGlobal.GameLogicServerMgr.Add(id, center);
                        CenterGlobal.GatewayServerMgr.ForEach((c) => {
                            ConnectLogicServerPacket pkg = new ConnectLogicServerPacket();
                            pkg.ID = id;
                            pkg.IP = ip;
                            pkg.Port = port;
                            c.SendTcp(pkg);
                        });
                    }
                    break;
                case ServerType.BattleServer:
                    id = GameGlobal.BattleMgr.GetID(info => info.IP == ip && info.Port == port);
                    if (id > 0)
                    {
                        CenterGlobal.BattleServerMgr.Add(id, center);
                        CenterGlobal.GatewayServerMgr.ForEach((c) =>
                        {
                            ConnectBattleServerPacket pkg = new ConnectBattleServerPacket();
                            pkg.ID = id;
                            pkg.IP = ip;
                            pkg.Port = port;
                            c.SendTcp(pkg);
                        });
                    }
                    break;
                case ServerType.GatewayServer:
                    id = GameGlobal.GatewayMgr.GetID(info => info.IP == ip && info.Port == port);

                    UpdateServerIDPacket pkt = new UpdateServerIDPacket();
                    pkt.ID = (byte)id;
                    center.SendTcp(pkt);

                    if (id > 0)
                    {
                        CenterGlobal.GatewayServerMgr.Add(id, center);

                        uint[] keys = CenterGlobal.GameLogicServerMgr.GetKeys();

                        foreach (uint key in keys)
                        {
                            GameLogicInfo info = GameGlobal.GameLogicMgr.FindTemplate(key);
                            ConnectLogicServerPacket pkg = new ConnectLogicServerPacket();
                            pkg.ID = key;
                            pkg.IP = info.IP;
                            pkg.Port = info.Port;
                            center.SendTcp(pkg);
                        }

                        keys = CenterGlobal.BattleServerMgr.GetKeys();
                        foreach (uint key in keys)
                        {
                            BattleInfo info = GameGlobal.BattleMgr.FindTemplate(key);
                            ConnectBattleServerPacket pkg = new ConnectBattleServerPacket();
                            pkg.ID = key;
                            pkg.IP = info.IP;
                            pkg.Port = info.Port;
                            center.SendTcp(pkg);
                        }

                        if (CenterGlobal.CacheServer != null && CenterGlobal.CacheServer.Connected)
                        {
                            ConnectCacheServerPacket cachePacket = new ConnectCacheServerPacket();
                            cachePacket.IP = CenterServerConfig.Configuration.CacheIP;
                            cachePacket.Port = CenterServerConfig.Configuration.CachePort;
                            center.SendTcp(cachePacket);
                        }
                    }
                    break;
                default:
                    center.Disconnect();
                    return 0;
            }

            if (id > 0)
            {
                center.ID = id;
                center.Type = type;
                center.Validated = true;
            }
            else
            {
                center.Disconnect();
            }

            return 0;
        }
    }
}
