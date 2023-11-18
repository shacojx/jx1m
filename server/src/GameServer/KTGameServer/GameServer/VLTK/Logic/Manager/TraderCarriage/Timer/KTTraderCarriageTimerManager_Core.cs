﻿using GameServer.KiemThe.Logic.Manager.Skill.PoisonTimer;
using GameServer.Logic;
using Server.Tools;
using System;
using System.ComponentModel;

namespace GameServer.KiemThe.Logic
{
    /// <summary>
    /// Các hàm cơ bản
    /// </summary>
    public partial class KTTraderCarriageTimerManager
    {
        #region Core
        /// <summary>
        /// Đánh dấu buộc xóa toàn bộ Timer của quái
        /// </summary>
        private bool forceClearAllTimers = false;

        /// <summary>
        /// Sự kiện khi Background Worker hoàn tất công việc
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Worker_Completed(object sender, RunWorkerCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                LogManager.WriteLog(LogTypes.Exception, e.Error.ToString());
            }
        }

        /// <summary>
		/// Thực thi sự kiện gì đó
		/// </summary>
		/// <param name="work"></param>
		/// <param name="onError"></param>
		private void ExecuteAction(Action work, Action<Exception> onError)
        {
            try
            {
                work?.Invoke();
            }
            catch (Exception ex)
            {
                LogManager.WriteLog(LogTypes.Exception, ex.ToString());
                onError?.Invoke(ex);
            }
        }

        /// <summary>
        /// Xóa rỗng toàn bộ luồng quái
        /// </summary>
        public void ClearTimers()
        {
            this.forceClearAllTimers = true;
        }
        #endregion

        #region API
        /// <summary>
        /// Thêm đối tượng vào danh sách quản lý
        /// </summary>
        /// <param name="obj"></param>
        public void Add(TraderCarriage obj)
        {
            /// Toác
            if (obj == null)
            {
                return;
            }

            /// Tạo mới
            TraderCarriageTimer timer = new TraderCarriageTimer()
            {
                TickTime = 500,
                RefObject = obj,
                IsStarted = false,
                LastTick = 0,
                LifeTime = obj.DurationTicks,
                InitTicks = obj.CreateTicks,
                Start = () => {
                    /// Thực thi sự kiện
                    this.ProcessStart(obj);
                },
                HasCompletedLastTick = true,
            };
            timer.Tick = () => {
                /// Thực thi sự kiện
                this.ProcessTick(obj);

                /// Đánh dấu đã hoàn thành Tick lần trước
                timer.HasCompletedLastTick = true;
            };
            timer.Timeout = () =>
            {
                /// Thực thi sự kiện
                this.ProcessTimeout(obj);
            };

            /// Thêm vào danh sách cần tải
            this.waitingQueue.Enqueue(new QueueItem()
            {
                Type = 1,
                Data = timer,
            });
        }

        /// <summary>
        /// Dừng và xóa đối tượng khỏi luồng thực thi
        /// </summary>
        /// <param name="obj"></param>
        public void Remove(TraderCarriage obj)
        {
            if (obj == null)
            {
                return;
            }

            /// Thêm vào danh sách cần tải
            this.waitingQueue.Enqueue(new QueueItem()
            {
                Type = 0,
                Data = obj,
            });
        }
        #endregion
    }
}
