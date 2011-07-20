using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using SJSCAN.Entity;
using System.Data.Common;

namespace Sjs.Data
{
    public interface IDataProvider
    {
        #region ��������

        /// <summary>
        /// ��ȡ�ܼ�¼����(����)
        /// </summary>
        /// <param name="tablename">���ݱ���</param>
        /// <param name="strwhere">��������</param>
        /// <returns></returns>
        int GetRecordCount(string tablename, string strwhere);

        /// <summary>
        /// ��ȡ�ܼ�¼����
        /// </summary>
        /// <param name="tablename"></param>
        /// <returns></returns>
        int GetRecordCount(string tablename);
        
        /// <summary>
        /// ��ҳ��ȡ�б�
        /// </summary>
        /// <param name="pageSize">ÿҳ����ʾ��(��ѡ)</param>
        /// <param name="currentPage">��ǰҳ��(��ѡ)</param>
        /// <param name="tab1">���ݿ��(��ѡ)</param>
        /// <param name="tab2">��ѡ���ݿ����û�оʹ����ַ���ֵ</param>
        /// <param name="strWhere">�ӣѣ̵�where����������ҪҪ���ؼ���where����Ϊ���ϲ�ѯ����һ�������Ϊa,�ڶ���Ϊb���磺a.id=1</param>
        /// <param name="byPage">��ҳʱ�ĸ����ֶ�</param>
        /// <param name="relateCol">���ϲ�ѯʱ�Ĺ����ֶΣ��磺a.groupid=b.id</param>
        /// <returns></returns>
        IDataReader GetListByPage(int pageSize, int currentPage, string tab1, string tab2, string strWhere, string byPage, string relateCol);

        #endregion

        #region ��������������

        int AddApp(App app);

        int DelApp(int id);

        int UpdateApp(App app);

        System.Data.IDataReader GetApp(int id);

        System.Data.IDataReader GetApp();

        System.Data.IDataReader GetApp(int pageSize, int currentPage);

        int AddUser(User user);

        int DelUser(int id);

        int UpdateUser(User user);

        System.Data.IDataReader GetUser(int id);

        System.Data.IDataReader GetUser();

        System.Data.IDataReader GetUser(int pageSize, int currentPage);


        int AddBalance(Balance balance);

        int DelBalance(int id);

        int UpdateBalance(Balance balance);

        System.Data.IDataReader GetBalance(int id);

        System.Data.IDataReader GetBalance();

        System.Data.IDataReader GetBalance(int pageSize, int currentPage);


        int AddTrade(Trade trade);

        int DelTrade(int id);

        int UpdateTrade(Trade trade);

        System.Data.IDataReader GetTrade(int id);

        System.Data.IDataReader GetTrade();

        System.Data.IDataReader GetTrade(int pageSize, int currentPage);


        int AddShop(Shop shop);

        int DelShop(int id);

        int UpdateShop(Shop shop);

        System.Data.IDataReader GetShop(int id);

        System.Data.IDataReader GetShop();

        System.Data.IDataReader GetShop(int pageSize, int currentPage);


        int AddBooking(Booking booking);

        int DelBooking(int id);

        int UpdateBooking(Booking booking);

        System.Data.IDataReader GetBooking(int id);

        System.Data.IDataReader GetBooking();

        System.Data.IDataReader GetBooking(int pageSize, int currentPage);


        int AddBookingshop(Bookingshop bookingshop);

        int DelBookingshop(int id);

        int UpdateBookingshop(Bookingshop bookingshop);

        System.Data.IDataReader GetBookingshop(int id);

        System.Data.IDataReader GetBookingshop();

        System.Data.IDataReader GetBookingshop(int pageSize, int currentPage);


        int AddBookingtrade(Bookingtrade bookingtrade);

        int DelBookingtrade(int id);

        int UpdateBookingtrade(Bookingtrade bookingtrade);

        System.Data.IDataReader GetBookingtrade(int id);

        System.Data.IDataReader GetBookingtrade();

        System.Data.IDataReader GetBookingtrade(int pageSize, int currentPage);


        int AddDeduction(Deduction deduction);

        int DelDeduction(int id);

        int UpdateDeduction(Deduction deduction);

        System.Data.IDataReader GetDeduction(int id);

        System.Data.IDataReader GetDeduction();

        System.Data.IDataReader GetDeduction(int pageSize, int currentPage);

        #endregion





        int DelBookingshop(int bookingid, bool notUseThisParam);
        int DelBookingtrade(int bookingid, bool notUseThisParam);
        int DelBookingtrade(int bookingid, int bookingshopid, bool notUseThisParam);

        int DisableUser(int uid, bool disable);
        int UpdateUser(int uid, double balance);
        int UpdateUserBalance(int uid, double tradevalue);
        int UpdateBookingtrade(int bookingid, bool isbooking);


        int GetBookingshop(int id, bool isover, bool shopidOrTradeid);
        System.Data.IDataReader GetUser(string account);
        System.Data.IDataReader GetUser(string account, string passwd);
        System.Data.IDataReader GetBalance(int uid, bool notUseThisParam);
        System.Data.IDataReader GetTrade(int shopid, bool notUseThisParam);
        System.Data.IDataReader GetBooking(DateTime specifiedDate, int uid);
        System.Data.IDataReader GetBooking(bool isbooking, DateTime specifiedDate);
        System.Data.IDataReader GetBooking(bool isbooking, int uid, DateTime minDateTime);
        System.Data.IDataReader GetBookingshop(DateTime minDate);
        System.Data.IDataReader GetBookingshop(DateTime minDate, bool isOver);
        System.Data.IDataReader GetBookingshop(DateTime specifiedDate, int uid);
        System.Data.IDataReader GetBookingshop(int bookingId, int shopId, int uid);
        System.Data.IDataReader GetBookingshop(int bookingId, bool notUseThisParam);
        System.Data.IDataReader GetBookingshop(int bookingId, int uid, bool notUseThisParam);
        System.Data.IDataReader GetBookingtrade(int bookingshopid, int uid, int notUseThisParam);
        System.Data.IDataReader GetBookingtrade(int bookingshopid, int tradeid, bool notUseThisParam);
        System.Data.IDataReader GetBookingtrade(int uid, DateTime minDate);
        System.Data.IDataReader GetBookingtrade(int bookingid, bool notUseThisParam);
        System.Data.IDataReader GetBookingtrade(int uid, uint unUsedThisParam);
        System.Data.IDataReader GetDeduction(int uid, bool unUsedThisParam);

        int GetBookingtradeCountByUid(int uid);
        System.Data.IDataReader GetBookingtrade(int uid, int pageSize, int currentPage, uint unUsedThisParam);

        int GetDeductionCount(int uid);
        System.Data.IDataReader GetDeduction(int uid, int pageSize, int currentPage);


        int AddUser(User user, DbTransaction trans);
        int AddShop(Shop shop, DbTransaction trans);
        int AddTrade(Trade trade, DbTransaction trans);
        int AddBalance(Balance balances, DbTransaction trans);
        int AddBookingtrade(Bookingtrade bookingtrade, DbTransaction trans);
        int AddDeduction(Deduction deduction, DbTransaction trans);


        int DelShop(int id, DbTransaction trans);
        int DelTrade(int shopid, DbTransaction trans);
        int DelBooking(int id, DbTransaction trans);
        int DelBookingshop(int id, DbTransaction trans);
        int DelBookingshop(int bookingid, bool notUseThisParam, DbTransaction trans);
        int DelBookingtrade(int id, DbTransaction trans);


        int UpdateUser(int uid, double balance, DbTransaction trans);
        int UpdateUserBalance(int uid, double tradevalue, DbTransaction trans);
        int UpdateBookingtrade(Bookingtrade bookingtrade, DbTransaction trans);


        IDataReader GetUser(int uid, DbTransaction trans);
        IDataReader GetBookingtrade(int bookingshopid, DbTransaction trans);
        IDataReader GetBookingtrade(int bookingid, DbTransaction trans, bool notUseThisParam);
    }
}
