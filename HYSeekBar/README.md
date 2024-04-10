# HYSeekBar-HarmonyOS
一个仿 iOS 亮度的滑块

## 功能
- 支持自定义滑块大小
- 支持自定义滑块背景色
- 支持自定义滑动条颜色、渐变色
- 支持设置最大值、最小值
- 支持垂直方向和水平方向滑动以及逆向滑动

## 预览

![](https://raw.githubusercontent.com/1595901624/HYSeekBar-HarmonyOS/main/demo/demo1.png)

## 属性

| 属性名 | 类型 | 默认值 | 说明                  | 是否必须 |
| --- | --- | --- |---------------------| --- |
| max | int | 100 | 最大值                 | 否 |
| min | int | 0 | 最小值                 | 否 |
| value | int | 0 | 当前值                 | 否 |
| step | int | 1 | 步长                  | 否 |
| trackColor | string | "#F2F2F2" | 滑轨的颜色               | 否 |
| radius | int | 40 | 滑块的圆角               | 否 |
| barWidth | int | 200 | 滑轨的宽度               | 否 |
| barHeight | int | 80 | 滑轨的高度               | 否 |
| selectedColorList | string[] | ["#FFFFFF", "#FFFFFF"] | 滑块的颜色, 支持两个颜色从左向右渐变 | 否 |
| barDirection | HYSeekBarDirection | HYSeekBarDirection.HORIZONTAL | 滑块的方向               | 否 |
| reverse | boolean | false | 滑块是否翻转              | 否 |
| clickEnable | boolean | false | 点击是否可触发滑条变更，默认为 false | 否 |

## 事件
| 事件名 | 类型 | 默认值 | 说明 | 是否必须 |
| --- | --- | --- | --- | --- |
| onChange | (mode: SeekBarSliderChangeMode, value: number, fromUser: boolean, percent: number) => void | - | 滑块改变时触发 | 否 |

## 安装

执行安装命令
```
ohpm install @cloris/seekbar
```

## 使用方法
1. 在项目中引入 HYSeekBar
```
import { HYSeekBar, HYSeekBarDirection } from '@cloris/seekbar';
```
2. 在布局中使用 HYSeekBar
```
// 垂直方向, 逆向-滑动从下到上，该示例模仿 iOS 亮度调节
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
```

## 支持版本
- 仅支持 HarmonyOS Next API 11，且在 `DevEco Studio 4.1.3.700` 测试通过。

## 建议与反馈
如果您在第三方控件的使用过程中发现任何问题都可以提 issue 给我，当然，我们也非常欢迎你给我们提 PR。

## License
本项目基于 AGPL-3.0 开源协议进行分发。