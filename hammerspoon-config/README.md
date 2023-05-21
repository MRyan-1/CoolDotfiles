* # hammerspoon-config

  ## 安装配置:

  安装 hammerspoon 
  ```
  brew cask install hammerspoon
  ```

  将 .hammerspoon 目录下的配置文件克隆到本地 .hammerspoon 目录下。

  **重新加载配置文件即可生效**。

  如果提示：already exists and is not an empty directory.
  先删除目录

  ```
  rm -rf ~/.hammerspoon
  ```

  

  ## 功能实现：
  
  ### 窗口管理模式

  **注：按 `esc` 和 `q` 退出。**

  按下前缀键 `Option` + `R` 进入窗口管理模式：

  0. 使用 `tab` 显示帮助面板，查看键位图

  1. 使用 `h、j、k、l` 移动为上下左右的半屏

  2. 使用 ` y、u、i、o`（即 hjkl 上方按键）移动为左上/左下/右上/右下的四分之一窗口
  
  3. 使用 `c` 居中，按下 `=、-` 进行窗口大小缩放
  
  4. 使用 `w、s、a、d` 向上下左右移动窗口
  
  5. 使用 `H、J、K、L` 向左/下增减窗口大小
  
  6. 使用方向键 `上、下、左、右` 移动到相应方向上的显示器（多块显示器的话）
  
  7. 使用 `[,]` 左三分之二屏和右三分之二屏
  8. 使用 `space` 将窗口投送到另外一块屏幕（假如有两块以上显示器的话）
  9. 使用 `t` 光标移动到所在窗口的中间位置
  10. 使用 `G` 左三分之二居中分屏 
  11. 使用 `Z` 展示显示 
  12. 使用 `V` 编程显示 
  13. 使用 `t` 将光标移至所在窗口的中心位置 
  14. 使用 `X` 三分之一居中分屏 
  
  等等
  
  ![](./assets/截图.png)
  
  ### 显示当前时间
  
  按下 `Option` + `t` 显示当前时间。
  
  ![](./assets/截图2.png)
  
  
  
  ### 锁屏
  
  按下 `Option` + `l` 锁定屏幕。
  
  
  
  ### 快捷显示 Hammerspoon 控制台
  
  按下 `Option` + `z` 快捷显示 Hammerspoon 控制台。
  
  
  
  ### 重新加载配置
  
  按下 `shift` + `control` + `command` + `r` 重新加载配置。
  
  
  
  
  
  ## 参考：
  
  1. [Hammerspoon Spoons](https://www.hammerspoon.org/Spoons/)
  
  2. [awesome-hammerspoon](https://github.com/ashfinal/awesome-hammerspoon)
