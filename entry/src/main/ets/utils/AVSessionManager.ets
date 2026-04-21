import { avSession } from '@kit.AVSessionKit';
export default class AVSessionManager {
  static session: avSession.AVSession;
  static context: Context;
  static async init(context?: Context) {
    if (context) {
      AVSessionManager.context = context;
    }
    AVSessionManager.session = await avSession.createAVSession(AVSessionManager.context, 'bgPlay', 'audio');

  }
}
