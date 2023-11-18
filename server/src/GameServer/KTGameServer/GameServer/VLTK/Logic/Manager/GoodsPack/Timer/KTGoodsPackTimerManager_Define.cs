﻿using GameServer.Logic;
using System;

namespace GameServer.KiemThe.Logic
{
    /// <summary>
    /// Quản lý luồng vật phẩm rơi
    /// </summary>
    public partial class KTGoodsPackTimerManager
    {
        #region Define
        /// <summary>
        /// Thông tin yêu cầu
        /// </summary>
        private class QueueItem
        {
            /// <summary>
            /// Loại yêu cầu
            /// <para>1: Thêm, 0: Xóa</para>
            /// </summary>
            public int Type { get; set; }

            /// <summary>
            /// Dữ liệu
            /// </summary>
            public object Data { get; set; }
        }

        /// <summary>
        /// Luồng quản lý
        /// </summary>
        private class GoodsPackTimer
        {
            /// <summary>
            /// Đối tượng tương ứng
            /// </summary>
            public KGoodsPack RefObject { get; set; }

            /// <summary>
            /// Thời điểm tạo ra
            /// </summary>
            public long InitTicks { get; set; }

            /// <summary>
            /// Thời điểm lần trước thực hiện hàm Tick
            /// </summary>
            public long LastTick { get; set; }

            /// <summary>
            /// Tick
            /// </summary>
            public int TickTime { get; set; }

            /// <summary>
            /// Thời gian tồn tại
            /// </summary>
            public long LifeTime { get; set; }

            /// <summary>
            /// Đã đến thời điểm Tick chưa
            /// </summary>
            public bool IsTickTime
            {
                get
                {
                    return KTGlobal.GetCurrentTimeMilis() - this.LastTick >= TickTime;
                }
            }

            /// <summary>
            /// Đã hết thời gian tồn tại chưa
            /// </summary>
            public bool IsOver
            {
                get
                {
                    return KTGlobal.GetCurrentTimeMilis() - this.InitTicks >= this.LifeTime;
                }
            }
        }
        #endregion
    }
}
