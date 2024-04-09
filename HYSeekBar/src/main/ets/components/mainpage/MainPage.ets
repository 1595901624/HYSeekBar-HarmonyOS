import { HYSeekBar } from '../../HYSeekBar';
import { HYSeekBarDirection } from '../.././HYSeekBarDirection'

@Component
@Preview
@Entry
export struct MainPage {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        HYSeekBar({
          value: 10,
          barWidth:230,
          barHeight: 40,
          reverse: false,
          barDirection: HYSeekBarDirection.HORIZONTAL
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
