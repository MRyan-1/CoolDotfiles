# hammerspoon-config

## 安装配置与升级:

安装 hammerspoon 
```
brew cask install hammerspoon
```

将配置文件克隆到本地根目录。
```
git clone https://gitee.com/Ryan_ma/hammerspoon-config.git ~/.hammerspoon
```
**重新加载配置文件即可生效**。

如果提示：already exists and is not an empty directory.
先删除目录

```
rm -rf ~/.hammerspoon
```

升级：

```
cd ~/.hammerspoon && git pull
```

## 功能实现：

**注：所有模式按 `esc` 和 `q` 退出。**

### 帮助面板
按下快捷键 `shift` + `option` + `/` 显示帮助面板查看各个模式快捷键。再按下对应快捷键切换模式。


### 窗口管理模式
按下前缀键 `Option` + `R` 进入窗口管理模式：

* 使用 `h、j、k、l` 移动为上下左右的半屏
* 使用 ` y、u、i、o`（即 hjkl 上方按键）移动为左上/左下/右上/右下的四分之一窗口
* 使用 `c` 居中，按下 `=、-` 进行窗口大小缩放
* 使用 `w、s、a、d` 向上下左右移动窗口
* 使用 `H、J、K、L` 向左/下增减窗口大小
* 使用方向键 `上、下、左、右` 移动到相应方向上的显示器（多块显示器的话）
* 使用 `[,]` 左三分之二屏和右三分之二屏
* 使用 `space` 将窗口投送到另外一块屏幕（假如有两块以上显示器的话）
* 使用 `t` 光标移动到所在窗口的中间位置
* 使用 `tab` 显示帮助面板，查看键位图
* 使用 `G` 左三分之二居中分屏 
* 使用 `Z` 展示显示 
* 使用 `V` 编程显示 
* 使用 `t` 将光标移至所在窗口的中心位置 
* 使用 `X` 三分之一居中分屏 

注：如设置程序坞自动隐藏请修改  `/Users/zuorn/.hammerspoon/Spoons/WinWin.spoon/init.lua.bak` 为`init.lua`




## 参考：

* [Hammerspoon Spoons](https://www.hammerspoon.org/Spoons/)
* [awesome-hammerspoon](https://github.com/ashfinal/awesome-hammerspoon)
