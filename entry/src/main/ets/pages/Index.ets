import { HYSeekBar, HYSeekBarDirection } from 'HYSeekBar';

@Entry
@Component
@Preview
struct Index {
  @State message: string = 'Hello World';
  @State value: number = 10
  @State dynamicValue : number = 20

  aboutToAppear(): void {
    // setInterval(() => {
    //   this.dynamicValue = this.dynamicValue + 10;
    // }, 1000)
  }

  build() {
    Column() {

      Column() {
        HYSeekBar({
          value: this.dynamicValue,
          radius: 20,
          barWidth: 40,
          barHeight: 140,
          reverse: true,
          trackColor: '#fff3b7b7',
          barDirection: HYSeekBarDirection.VERTICAL,
          onChange: (mode, value, fromUser, percent) => {
            console.log('垂直方向, 逆向-滑动从下到上: onChange: ' + value + ', fromUser: ' + fromUser + ', percent: ' + percent)
          }
        })

        Text("垂直方向, 逆向-滑动从下到上")
          .margin({
            top: 20
          })
          .fontSize(20)
          .fontColor(Color.White)
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor("#CC333333")
      .height('30%')
      .width('100%')

      Column() {
        HYSeekBar({
          value: this.value,
          radius: 20,
          barWidth: 40,
          barHeight: 140,
          reverse: false,
          trackColor: '#fff3b7b7',
          barDirection: HYSeekBarDirection.VERTICAL,
          onChange: (mode, value, fromUser, percent) => {
            console.log('垂直方向, 正向-滑动从上到下: onChange: ' + value + ', fromUser: ' + fromUser + ', percent: ' + percent)
          }
        })
        Text("垂直方向, 正向-滑动从上到下")
          .margin({
            top: 20
          })
          .fontSize(20)
          .fontColor(Color.White)
      }
      .justifyContent(FlexAlign.Center)
      .height('30%')
      .width('100%')

      Column() {
        HYSeekBar({
          value: this.value,
          radius: 20,
          barWidth: 140,
          barHeight: 40,
          reverse: true,
          trackColor: '#fff3b7b7',
          barDirection: HYSeekBarDirection.HORIZONTAL,
          onChange: (mode, value, fromUser, percent) => {
            console.log('水平方向, 逆向-滑动从右往左: onChange: ' + value + ', fromUser: ' + fromUser + ', percent: ' + percent)
          }
        })

        Text("水平方向, 逆向-滑动从右往左")
          .margin({
            top: 20
          })
          .fontSize(20)
          .fontColor(Color.White)
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor("#CC333333")
      .height('20%')
      .width('100%')

      Column() {
        HYSeekBar({
          value: this.value,
          radius: 20,
          barWidth: 140,
          barHeight: 40,
          reverse: false,
          trackColor: '#fff3b7b7',
          barDirection: HYSeekBarDirection.HORIZONTAL,
          onChange: (mode, value, fromUser, percent) => {
            console.log('水平方向, 正向-滑动从左往右: onChange: ' + value + ', fromUser: ' + fromUser + ', percent: ' + percent)
          }
        })

        Text("水平方向, 逆向-滑动从左往右")
          .margin({
            top: 20
          })
          .fontSize(20)
          .fontColor(Color.White)
      }
      .justifyContent(FlexAlign.Center)
      .height('20%')
      .width('100%')
    }
    .backgroundColor('#ffa09f9f')
    .height('100%')
  }
}