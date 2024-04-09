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
          layoutWidth:30,
          layoutHeight: 200,
          barDirection: HYSeekBarDirection.VERTICAL
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
