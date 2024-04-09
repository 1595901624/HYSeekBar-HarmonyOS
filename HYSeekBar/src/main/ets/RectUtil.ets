class RectUtil {
  /**
   * 该方法用来绘制一个有填充色的圆角矩形
   * @param ctx:canvas的上下文环境
   * @param x:左上角x轴坐标
   * @param y:左上角y轴坐标
   * @param width:矩形的宽度
   * @param height:矩形的高度
   * @param radius:圆的半径
   * @param fillColor:填充颜色
   **/
  fillRoundRect(ctx: CanvasRenderingContext2D, x: number, y: number, width: number, height: number, radius: number, fillColor: string) {
    //圆的直径必然要小于矩形的宽高
    if (2 * radius > width || 2 * radius > height) {
      radius = Math.min(width / 2, height / 2)
    }

    ctx.save();
    ctx.translate(x, y);
    //绘制圆角矩形的各个边
    this.drawRoundRectPath(ctx, width, height, radius);

    ctx.fillStyle = fillColor || "#000";
    ctx.fill()
    ctx.restore();
  }

  /**
   * 绘制圆角矩形
   * @param ctx
   * @param width
   * @param height
   * @param radius
   */
  private drawRoundRectPath(ctx: CanvasRenderingContext2D, width: number, height: number, radius: number) {
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
}

export const rectUtil = new RectUtil();