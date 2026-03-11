import router from '@ohos.router';
import hilog from '@ohos.hilog';

const DOMAIN: number = 0xFF00;
const TAG: string = 'StartPage';

@Entry
@Component
struct Start {
  router = this.getUIContext().getRouter();
  // 定时器 id
  timerId: number = 0;

  aboutToAppear(): void {
    hilog.info(DOMAIN, TAG, 'aboutToAppear: 启动页即将显示，创建定时器');
    // 5秒后自动跳转到首页
    this.timerId = setTimeout(() => {
      this.router.replaceUrl({ url: 'pages/Index' });
    }, 5000);
    hilog.info(DOMAIN, TAG, 'aboutToAppear: 定时器创建完成，timerId = %{public}d', this.timerId);
  }

  aboutToDisappear(): void {
    hilog.info(DOMAIN, TAG, 'aboutToDisappear: 启动页即将消失，清除定时器');
    // 清除定时器
    clearTimeout(this.timerId);
    hilog.info(DOMAIN, TAG, 'aboutToDisappear: 定时器已清除，timerId = %{public}d', this.timerId);
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image($r('app.media.ad'))
      Button('跳过')
        .margin(10)
        .backgroundColor('#4d000000')
        .onClick(() => {
          this.router.replaceUrl({ url: 'pages/Index' });
        })
    }
  }
}