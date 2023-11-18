﻿using GameServer.KiemThe;
using ProtoBuf;

namespace Server.Data
{
    /// <summary>
    /// Thông tin người chơi bị Ban
    /// </summary>
    [ProtoContract]
    public class BanUser
    {
        /// <summary>
        /// ID nhân vật
        /// </summary>
        [ProtoMember(1)]
        public int RoleID { get; set; }

        /// <summary>
        /// Thời điểm bị Ban
        /// </summary>
        [ProtoMember(2)]
        public long StartTime { get; set; }

        /// <summary>
        /// Thời hạn Ban
        /// </summary>
        [ProtoMember(3)]
        public long Duration { get; set; }

        /// <summary>
        /// Lý do bị Ban
        /// </summary>
        [ProtoMember(4)]
        public string Reason { get; set; }

        /// <summary>
        /// Người Ban
        /// </summary>
        [ProtoMember(5)]
        public string BannedBy { get; set; }

        /// <summary>
        /// Đã quá thời gian Ban chưa
        /// </summary>
        public bool IsOver
        {
            get
            {
                /// Nếu bị Ban vĩnh viễn
                if (this.Duration == -1)
                {
                    /// Toác
                    return false;
                }
                /// Trả về kết quả
                return KTGlobal.GetCurrentTimeMilis() - this.StartTime >= this.Duration;
            }
        }
    }
}
