﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Packets;
using GameBase.Net;
using GameBase;

namespace GameServer.Packets.PacketHandlers
{
    [PacketHandler((int)BasePacketCode.Logic_Code, "处理逻辑服务器的数据包")]
    public class ProgressLogicPacketHandler : IPacketHandler, IServerPacketHandler
    {
        public int HandlePacket(ClientBase client, GamePacket packet)
        {
            client.HandlePacket(packet.Code, packet);

            return 0;
        }

        public int HandlePacket(ServerConnector connector, GamePacket packet)
        {
            connector.HandlePacket(packet.Code, packet);

            return 0;
        }
    }
}
