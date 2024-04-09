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
  @Prop trackColor: string = "#FFFFFF"
  /**
   * 滑块的圆角
   */
  @Prop radius: number = 40
  @Prop layoutWidth: number = 200
  @Prop layoutHeight: number = 80
  /**
   * 滑块的颜色
   */
  @Prop selectedColorList: string[] = ["#fffc23f0", "#ff4df170"]
  // ***************************************以下属性私有 START************************************************
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State private _slideOffsetX: number = 20
  private _touchX: number = 0
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
      .width(this.layoutWidth)
      .height(this.layoutHeight)
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
        this.draw()
        this._touchX = event.touches[0].x;
        this.onChange?.(this.getCallbackValue(), SeekBarSliderChangeMode.Begin, true, this._percent)
        this.onChange?.(this.getCallbackValue(), SeekBarSliderChangeMode.Click, true, this._percent)
      }
        break;
      case TouchType.Up:
        this.onSlideEnd();
        break;
      case TouchType.Move: {
        let tempTouchX = event.touches[0].x;
        // let stepSize = this.max / this.step;
        let slideDistance = this._slideOffsetX + (tempTouchX - this._touchX)
        if (slideDistance <= 0) {
          this._slideOffsetX = 0;
        } else if (slideDistance > this.context.width) {
          this._slideOffsetX = this.context.width
        } else {
          // const x = Math.round(slideDistance * 1.0 / this.step) * this.step
          // this._slideOffsetX = x;
          this._slideOffsetX = slideDistance;
        }
        this._percent = this._slideOffsetX / this.context.width;
        this.onScrolling(this._percent);
        this._touchX = event.touches[0].x;
        this.draw()
      }
        break;
      case TouchType.Cancel:

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
    this.fillRoundRect(this.context, 0, 0, this.context.width, this.context.height, this.radius, this.trackColor)
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
    this.context.fillRect(0, 0, this._slideOffsetX, this.context.height)
  }

  /**该方法用来绘制一个有填充色的圆角矩形
   * @param cxt:canvas的上下文环境
   * @param x:左上角x轴坐标
   * @param y:左上角y轴坐标
   * @param width:矩形的宽度
   * @param height:矩形的高度
   * @param radius:圆的半径
   * @param fillColor:填充颜色
   **/
  fillRoundRect(cxt: CanvasRenderingContext2D, x: number, y: number, width: number, height: number, radius: number, fillColor: string) {
    //圆的直径必然要小于矩形的宽高
    if (2 * radius > width || 2 * radius > height) {
      radius = Math.min(width / 2, height / 2)
    }

    cxt.save();
    cxt.translate(x, y);
    //绘制圆角矩形的各个边
    this.drawRoundRectPath(cxt, width, height, radius);

    cxt.fillStyle = fillColor || "#000"; //若是给定了值就用给定的值否则给予默认值
    cxt.fill()
    cxt.restore();
  }

  /**
   * 绘制圆角矩形
   * @param ctx
   * @param width
   * @param height
   * @param radius
   */
  drawRoundRectPath(ctx: CanvasRenderingContext2D, width: number, height: number, radius: number) {
    ctx.beginPath();
    //从右下角顺时针绘制，弧度从0到1/2PI
    ctx.arc(width - radius, height - radius, radius, 0, Math.PI / 2);

    //矩形下边线
    ctx.lineTo(radius, height);

    //左下角圆弧，弧度从1/2PI到PI
    ctx.arc(radius, height - radius, radius, Math.PI / 2, Math.PI);

    //矩形左边线
    ctx.lineTo(0, radius);

    //左上角圆弧，弧度从PI到3/2PI
    ctx.arc(radius, radius, radius, Math.PI, Math.PI * 3 / 2);

    //上边线
    ctx.lineTo(width - radius, 0);

    //右上角圆弧
    ctx.arc(width - radius, radius, radius, Math.PI * 3 / 2, Math.PI * 2);

    //右边线
    ctx.lineTo(width, height - radius);
    ctx.closePath();
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

