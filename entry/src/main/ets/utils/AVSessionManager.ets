import { SongItemType } from '../models';
import AVPlayerManager from './AVPlayerManager';

import { avSession } from '@kit.AVSessionKit';
export default class AVSessionManager {
  static session: avSession.AVSession;
  static context: Context;
  static async init(context?: Context) {
    if (context) {
      AVSessionManager.context = context;
    }
    AVSessionManager.session = await avSession.createAVSession(AVSessionManager.context, 'bgPlay', 'audio');
    AVSessionManager.registerEvent();
  }

  // 设置歌曲信息
  static setAVMetadata(song: SongItemType) {
    AVSessionManager.session.setAVMetadata({
      assetId: song.id,									// 歌曲id
      title: song.title,									// 歌曲名称
      artist: song.artist,								// 艺术家
      duration: AVPlayerManager.currentSong.duration,		// 歌曲时长
      mediaImage: song.img								// 封面图
    });
  }
  // 设置播放信息
  static setAVPlaybackState() {
    AVSessionManager.session.setAVPlaybackState({
      state: AVPlayerManager.currentSong.isPlay ? avSession.PlaybackState.PLAYBACK_STATE_PLAY : avSession.PlaybackState.PLAYBACK_STATE_PAUSE, // 播放状态
      position: {
        elapsedTime: AVPlayerManager.currentSong.time,	// 播放时间
        updateTime: Date.now(),   							// 更新时间
      },
      duration: AVPlayerManager.currentSong.duration,		// 歌曲时长
    });
  }
  // 注册事件
  static registerEvent() {
    // 激活会话
    AVSessionManager.session.activate();
    // 跳转播放位置事件
    AVSessionManager.session.on('seek', time => {
      AVPlayerManager.player.seek(time);
    });
    // 播放事件
    AVSessionManager.session.on('play', () => {
      AVPlayerManager.singPlay(AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex]);
    })
    // 暂停事件
    AVSessionManager.session.on('pause', () => {
      AVPlayerManager.pause();
    })
    // 播放上一首事件
    AVSessionManager.session.on('playPrevious', () => {
      AVPlayerManager.prevPlay();
    })
    // 播放下一首事件
    AVSessionManager.session.on('playNext', () => {
      AVPlayerManager.nextPlay();
    })
  }
  // 重置会话
  static async reset()
  {
    await AVSessionManager.session.destroy();
    await AVSessionManager.init()
  }

}
