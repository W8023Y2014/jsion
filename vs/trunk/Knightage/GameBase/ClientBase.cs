﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using log4net;
using System.Reflection;
using GameBase.Net;
using Net;

namespace GameBase
{
    public class ClientBase
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected GameSocket m_socket;

        public event ReceiveDelegate ReceivedPacket;

        public event DisconnectDelegate Disconnected;

        public virtual uint BuffSize { get { return 2048; } }

        #region 构造函数初始化

        public ClientBase()
        {
            Initialize();
        }

        public ClientBase(Socket socket)
            : this()
        {
            Accept(socket);
        }

        public ClientBase(Socket socket, byte[] sBuff, byte[] rBuff)
            : this()
        {
            Accept(socket, sBuff, rBuff);
        }

        protected virtual void Initialize()
        {
        }

        #endregion

        #region Accept Socket

        public virtual void Accept(Socket socket)
        {
            Accept(socket, null, null);
        }

        public virtual void Accept(Socket socket, byte[] sBuff, byte[] rBuff)
        {
            if (m_socket != null || socket == null) return;

            if (sBuff == null) sBuff = new byte[BuffSize];
            if (rBuff == null) rBuff = new byte[BuffSize];

            m_socket = new GameSocket(sBuff, rBuff);
            m_socket.Accept(socket);

            m_socket.Received += new ReceivePacketDelegate(m_socket_Received);
            m_socket.Disconnected += new DisconnectSocketDelegate(m_socket_Disconnected);
        }

        void m_socket_Received(Packet packet)
        {
            GamePacket pkg = packet as GamePacket;
            if (ReceivedPacket != null)
            {
                try
                {
                    ReceivedPacket(pkg);
                }
                catch (Exception ex)
                {
                    log.Error("Handle packet error!", ex);
                }
            }

            try
            {
                OnReceivePacket(pkg);
            }
            catch (Exception ex)
            {
                log.Error("OnReceivePacket error!", ex);
            }
        }

        void m_socket_Disconnected()
        {
            if (Disconnected != null)
            {
                try
                {
                    Disconnected(this);
                }
                catch (Exception ex)
                {
                    log.Error("Handle disconnect error!", ex);
                }
            }

            try
            {
                OnDisconnected();
            }
            catch (Exception ex)
            {
                log.Error("OnDisconnected error!", ex);
            }
        }

        protected virtual void OnReceivePacket(GamePacket packet)
        {
        }

        protected virtual void OnDisconnected()
        {
        }

        #endregion

        public void SendTcp(GamePacket pkg)
        {
            //if (m_socket == null) return;

            m_socket.SendPacket(pkg);
        }

        public bool Connected
        {
            get
            {
                if (m_socket == null) return false;

                return m_socket.Connected;
            }
        }

        public string RemoteEndPoint
        {
            get
            {
                if (m_socket == null) return "Not connected!";

                return m_socket.RemoteEndPoint;
            }
        }

        public void Disconnect()
        {
            m_socket.Disconnect();
        }
    }
}
