import { HYSeekBarDirection } from './HYSeekBarDirection'
import { rectUtil } from './RectUtil'
import { SeekBarSliderChangeMode } from './SeekBarSliderChangeMode'

@Component
@Preview
export struct HYSeekBar {
  /**
   * 最大值
   */
  @Prop max: number = 100
  /**
   * 最小值
   */
  @Prop min: number = 0
  /**
   * 当前值
   */
  @Prop @Watch("valueUpdated") value: number = 0
  /**
   * 步长
   */
  @Prop step: number = 1
  /**
   * 滑轨的颜色
   */
  @Prop trackColor: string = "#F2F2F2"
  /**
   * 滑块的圆角
   */
  radius: number = 40
  barWidth: number = 200
  barHeight: number = 80
  /**
   * 滑块的颜色
   */
  @Prop selectedColorList: string[] = ["#FFFFFF", "#FFFFFF"]
  /**
   * 滑块的方向
   */
  barDirection: HYSeekBarDirection = HYSeekBarDirection.HORIZONTAL
  /**
   * 滑块是否翻转
   */
  @State reverse: boolean = false
  // ***************************************以下属性私有 START************************************************
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State private _slideOffsetX: number = 20
  @State private _slideOffsetY: number = 20
  private _touchX: number = 0
  private _touchY: number = 0
  @State private _percent: number = 0
  // ***************************************以上属性私有 E N D************************************************
  /**
   * 滑块改变时触发
   * @param mode 改变模式
   * @param value 值
   * @param fromUser 是否是用户操作
   * @param percent 百分比
   */
  onChange?: (mode: SeekBarSliderChangeMode, value: number, fromUser: boolean, percent: number) => void

  /**
   * 值刷新
   */
  valueUpdated() {
    this.init()
    this.draw()
    this.onChange?.(SeekBarSliderChangeMode.Moving, this.getCallbackValue(), false, this._percent)
  }

  build() {
    Canvas(this.context)
      .width(this.barWidth)
      .height(this.barHeight)
      .onReady(() => {
        this.init();
        this.draw();
      })
      .onAreaChange((area) => {
        console.log('area: ' + area)
      })
      .onTouch((event: TouchEvent) => {
        this.handleTouchEvent(event)
      })
  }

  handleTouchEvent(event: TouchEvent) {
    switch (event.type) {
      case TouchType.Down: {
        let slideDistance = event.touches[0].x
        if (slideDistance <= 0) {
          this._slideOffsetX = 0;
        } else if (slideDistance > this.context.width) {
          this._slideOffsetX = this.context.width
        } else {
          // const x = Math.floor(slideDistance * 1.0 / this.step) * this.step
          this._slideOffsetX = slideDistance;
        }
        this._percent = this._slideOffsetX / this.context.width;
        // this.onScrolling(percent)
        // this.draw()
        this._touchX = event.touches[0].x;
        this._touchY = event.touches[0].y;
        this.onChange?.(this.getCallbackValue(), SeekBarSliderChangeMode.Begin, true, this._percent)
        this.onChange?.(this.getCallbackValue(), SeekBarSliderChangeMode.Click, true, this._percent)
      }
        break;
      case TouchType.Up:
        this._touchX = event.touches[0].x;
        this._touchY = event.touches[0].y;
        this.onSlideEnd();
        break;
      case TouchType.Move: {
        // 判断滑动方向
        let tempTouchX = event.touches[0].x;
        let tempTouchY = event.touches[0].y;
        // 根据方向获取滑动距离
        if (this.barDirection === HYSeekBarDirection.HORIZONTAL) {
          // 当前 Bar 的方向是横向

          if (this.reverse) {
            let slideDistance = this._slideOffsetX + (this._touchX - tempTouchX)
            console.log("slideDistance: " + (this._touchX - tempTouchX))
            if (slideDistance <= 0) {
              this._slideOffsetX = 0;
            } else if (slideDistance > this.context.width) {
              this._slideOffsetX = this.context.width
            } else {
              this._slideOffsetX = slideDistance;
            }
            this._percent = this._slideOffsetX / this.context.width;
          } else {
            let slideDistance = this._slideOffsetX + (tempTouchX - this._touchX)
            if (slideDistance <= 0) {
              this._slideOffsetX = 0;
            } else if (slideDistance > this.context.width) {
              this._slideOffsetX = this.context.width
            } else {
              this._slideOffsetX = slideDistance;
            }
            this._percent = this._slideOffsetX / this.context.width;
          }
        } else {
          // 当前 Bar 的方向是纵向
          if (this.reverse) {
            let slideDistance = this._slideOffsetY + (this._touchY - tempTouchY);
            if (slideDistance <= 0) {
              this._slideOffsetY = 0;
            } else if (slideDistance > this.context.height) {
              this._slideOffsetY = this.context.height
            } else {
              this._slideOffsetY = slideDistance;
            }
          } else {
            let slideDistance = this._slideOffsetY + (tempTouchY - this._touchY);
            if (slideDistance <= 0) {
              this._slideOffsetY = 0;
            } else if (slideDistance > this.context.height) {
              this._slideOffsetY = this.context.height
            } else {
              this._slideOffsetY = slideDistance;
            }
          }
        }
        this.onScrolling(this._percent);
        this._touchX = tempTouchX;
        this._touchY = tempTouchY;
        this.draw()
      }
        break;
      case TouchType.Cancel:
        this._touchX = event.touches[0].x;
        this._touchY = event.touches[0].y;
        break;

      default:
        break;
    }
  }

  draw() {
    this.clear()
    this.drawRoundBackground();
    this.context.clip()
    this.drawProgressBar();
  }

  clear() {
    this.context.clearRect(0, 0, this.context.width, this.context.height)
  }

  /**
   * 绘制背景
   */
  drawRoundBackground() {
    rectUtil.fillRoundRect(this.context, 0, 0, this.context.width, this.context.height, this.radius, this.trackColor)
  }

  /**
   * 绘制进度条
   * @param cxt
   * @param width
   * @param height
   * @param radius
   */
  drawProgressBar() {
    console.log('drawProgressBar', this.selectedColorList[0])
    let grad = this.context.createLinearGradient(0, 0, this.context.width, this.context.height)
    grad.addColorStop(0.0, this.selectedColorList[0])
    grad.addColorStop(1.0, this.selectedColorList[1])
    this.context.fillStyle = grad

    if (this.barDirection === HYSeekBarDirection.HORIZONTAL) {
      if (this.reverse) {
        this.context.fillRect(this.context.width - this._slideOffsetX, 0, this._slideOffsetX, this.context.height)
      } else {
        this.context.fillRect(0, 0, this._slideOffsetX, this.context.height)
      }
    } else {
      if (this.reverse) {
        this.context.fillRect(0, this.context.height - this._slideOffsetY, this.context.width, this._slideOffsetY)
      } else {
        this.context.fillRect(0, 0, this.context.width, this._slideOffsetY)
      }
    }
  }

  /**
   * 滑动事件处理
   * @param percent
   */
  onScrolling(percent: number) {
    this.onChange?.(this.getCallbackValue(), SeekBarSliderChangeMode.Moving, true, this._percent)
    console.log('onScrolling: ' + percent)
  }

  /**
   * 滑动结束
   */
  onSlideEnd() {
    this.onChange?.(this.getCallbackValue(), SeekBarSliderChangeMode.End, true, this._percent)
  }

  /**
   * 获取回调值
   */
  getCallbackValue(): number {
    const originalValue = (this.max - this.min) * this._percent + this.min;
    let x = Math.round(originalValue / this.step) * this.step
    if (x < this.min) {
      x = this.min
    } else if (x > this.max) {
      x = this.max
    }
    this.value = x;
    return x
  }

  private init() {
    if (this.step < 1) {
      this.step = 1
    }

    // 默认值
    if (this.value < this.min) {
      this.value = this.min
    } else if (this.value > this.max) {
      this.value = this.max
    }
    if (this.min > this.max) {
      this.min = 0;
      this.max = 100;
    }

    // 初始化滑块位置
    this._slideOffsetX = (this.value - this.min) / (this.max - this.min) * this.context.width

    // 修正颜色数组
    const selectedColorListLength = this.selectedColorList.length
    if (selectedColorListLength == 1) {
      this.selectedColorList.push(this.selectedColorList[0])
    } else if (selectedColorListLength === 0) {
      this.selectedColorList.push('#00D8AF', '#AAFFBC')
    } else if (selectedColorListLength > 2) {
      this.selectedColorList.splice(2, selectedColorListLength - 2)
    }
    console.log('selectedColorList: ' + this.selectedColorList)
  }
}

