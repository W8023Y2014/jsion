﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameBase
{
    /// <summary>
    /// 0-100为Code2预留协议号
    /// 101-200为服务器间的预留协议号
    /// 200以上为游戏逻辑协议号
    /// </summary>
    public enum BasePacketCode
    {
        None_Code = 0,

        /// <summary>
        /// 转发给中心服务器处理
        /// </summary>
        Center_Code = 1,

        /// <summary>
        /// 转发给战斗服务器处理
        /// </summary>
        Battle_Code = 2,

        /// <summary>
        /// 转发给逻辑服务器处理
        /// </summary>
        Logic_Code = 3,

        /// <summary>
        /// 转发给网关服务器处理
        /// </summary>
        Gateway_Code = 4,

        /// <summary>
        /// 转发给客户端
        /// </summary>
        Client_Code = 6,



        /// <summary>
        /// 验证服务器IP、端口、类型
        /// </summary>
        ValidateServer = 101,

        /// <summary>
        /// 连接逻辑服务器
        /// </summary>
        ConnectLogicServer = 102,

        /// <summary>
        /// 连接战斗服务器
        /// </summary>
        ConnectBattleServer = 103,

        /// <summary>
        /// 更新网关服务器ID
        /// </summary>
        UpdateServerID = 105,

        /// <summary>
        /// 更新网关服务器为满载状态
        /// </summary>
        UpdateServerFull = 106,

        /// <summary>
        /// 更新网关服务器为正常状态
        /// </summary>
        UpdateServerNormal = 107,

        /// <summary>
        /// 在中心服务器查找并通知客户端重定向到其他网关
        /// </summary>
        ChangeGateway = 108,

        /// <summary>
        /// 角色注册
        /// </summary>
        ValidateRegiste = 109,

        /// <summary>
        /// 验证登陆
        /// </summary>
        ValidateLogin = 110,

        /// <summary>
        /// 旧客户端踢下线后的登陆
        /// </summary>
        LoginAfterKit = 111,

        /// <summary>
        /// 玩家退出
        /// </summary>
        LoginOut = 120,

        /// <summary>
        /// 客户端断开连接
        /// </summary>
        ClientDisconnect = 130,




        /// <summary>
        /// 通知客户端重新连接其他网关
        /// </summary>
        ReConnectGateway = 1001,

        /// <summary>
        /// 服务器繁忙
        /// </summary>
        ServerBusies = 1002,

        /// <summary>
        /// 通知客户端登陆
        /// </summary>
        NoticeLogin = 1011,

        /// <summary>
        /// 玩家登陆
        /// </summary>
        Login = 1012,

        /// <summary>
        /// 通知玩家注册
        /// </summary>
        NoticeRegiste = 1013,

        /// <summary>
        /// 玩家注册
        /// </summary>
        Registe = 1014,

        /// <summary>
        /// 踢玩家下线
        /// </summary>
        KitPlayer = 1015,

        /// <summary>
        /// 消息提示包
        /// </summary>
        Msg = 10000
    }
}
