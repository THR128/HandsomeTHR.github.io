# 地球实时天气与海洋信息系统

一个开箱即用的交互式 3D 地球 GIS 页面。所有前端依赖（CesiumJS）已打包到本地，启动本地服务器后即可直接使用。

## 功能特性

- 🌍 **3D 地球**：CesiumJS 原生球体，自动 LOD，缩放越高分辨率越清晰。
- ☁️ **卫星云图**：NASA GIBS 真彩色卫星影像，云层、陆地、海洋一目了然。
- 🌊 **GIS 图层**：可叠加海岸线、边界/道路、地名标签、海表温度、叶绿素、海面风速、OSCAR 洋流等。
- 🌧️ **OWM 天气图层**：输入 [OpenWeatherMap](https://openweathermap.org/api) 免费 API Key 后可叠加云层、降水、温度、风速。
- 🖱️ **自由交互**：鼠标左键拖动旋转、滚轮缩放；手机端支持单指旋转、双指缩放。
- 📱 **手机适配**：移动端控制面板自动变为底部抽屉，点左上角 ☰ 按钮展开/收起。
- 📅 **日期选择**：可回看过去日期的卫星影像，默认加载最近可用数据。
- 📍 **坐标显示**：鼠标在球面上移动时实时显示经纬度。

## 开箱即用

### Windows

双击运行 `start.bat`，会自动打开浏览器并访问 `http://localhost:8080`。

### macOS / Linux

在终端中执行：

```bash
chmod +x start.sh
./start.sh
```

脚本会自动打开浏览器。

### 手动运行

如果脚本无法使用，也可手动起任意静态服务器：

```bash
python3 -m http.server 8080
# 或
py -m http.server 8080
```

然后访问 http://localhost:8080 。

### 手机 / 平板访问

`python -m http.server` 默认监听所有网卡（`0.0.0.0`），所以同一局域网内的手机也能访问：

1. 在电脑上先启动服务器（用 `start.bat` / `start.sh` 或手动命令）。
2. 查看电脑的局域网 IP 地址：
   - Windows：`ipconfig` 里的「IPv4 地址」，例如 `192.168.1.5`。
   - macOS / Linux：`ipconfig getifaddr en0` 或 `ip addr`。
3. 在手机浏览器访问 `http://<电脑IP>:8080`，例如 `http://192.168.1.5:8080`。

> 手机和电脑需要在同一个 Wi-Fi 下。若打不开，通常是 Windows 防火墙拦截，可临时放行 8080 端口。

### 随时随地访问（公网）

上面的方式都依赖局域网。要让**任何地方**的设备都能打开，有两种办法：

#### 方案 A：临时公网隧道（最快，无需账号）

保持本地服务器运行，另开一个终端执行：

```bash
ssh -R 80:localhost:8080 nokey@localhost.run
```

终端会输出一个形如 `https://xxxx.lhr.life` 的公网地址，手机、平板、其他电脑都能直接访问，**不需要在同一局域网**。

> 缺点：电脑关机或关闭终端后地址就失效，每次重连地址都会变。适合临时演示/分享。

#### 方案 B：部署到免费静态托管（推荐，永久地址）

本项目是纯静态站点，可直接托管到任意静态网站服务，获得固定公网地址：

| 平台 | 操作方式 | 地址示例 |
|------|----------|----------|
| **Netlify Drop** | 打开 https://app.netlify.com/drop ，把整个 `earth-weather` 文件夹或 `earth-weather-site.zip` 拖进去 | `https://xxx.netlify.app` |
| **Cloudflare Pages** | 控制台 → Workers & Pages → Pages → Direct Upload，上传 zip | `https://xxx.pages.dev` |
| **Vercel** | 网页导入或 `vercel` CLI，框架选 Other，输出目录填 `.` | `https://xxx.vercel.app` |
| **GitHub Pages** | 把文件推到 GitHub 仓库，Settings → Pages 选择分支根目录 | `https://用户名.github.io/仓库名` |

上传时**必须包含 `lib/` 目录**（CesiumJS 运行库），否则地球无法显示；`start.bat` / `start.sh` 只用于本地，不需要上传。

> 部署后通过 HTTPS 访问，NASA GIBS 与 OpenWeatherMap 也都是 HTTPS，不会出现混合内容问题。

> ⚠️ **不要直接双击 `index.html` 打开**。浏览器 `file://` 协议会阻止 3D 引擎的 Web Worker 和跨域瓦片加载，导致画面一直卡在“正在加载卫星云图”。请务必使用上面的启动脚本或手动启动本地服务器。
>
> 注意：卫星影像数据仍需联网获取（NASA GIBS 瓦片），但页面本身的所有代码和库都已本地化。
>
> 关于南北极：底图使用 Web Mercator 投影，该投影在数学上只能表示约北纬 85° 到南纬 85° 之间的区域，因此两极附近会显示为深蓝色填充，这是投影的正常限制（Google Maps / OpenStreetMap 同样如此）。

## 数据来源

| 图层 | 来源 | 说明 |
|------|------|------|
| 静态底图 | NASA GIBS / Blue Marble Next Generation | 静态全球底图，填补每日影像空白与数据缺口 |
| 卫星底图 | NASA GIBS / VIIRS SNPP CorrectedReflectance_TrueColor | 真彩色卫星影像，含云层，每日更新 |
| 海岸线 / 边界 / 标签 | NASA GIBS / OSM Reference Features / Coastlines | 地理参考叠加 |
| 海表温度 | NASA GIBS / GHRSST L4 MUR | 多尺度超高分辨率 SST |
| 叶绿素 A | NASA GIBS / MODIS Aqua L2 | 海洋叶绿素浓度 |
| 海面洋流 | NASA GIBS / OSCAR Sea Surface Currents | 经向 / 纬向海表流 |
| 海面风速 | NASA GIBS / CYGNSS L3 Daily | 海面风速 |
| 天气叠加（可选） | OpenWeatherMap `clouds_new` / `precipitation_new` / `temp_new` / `wind_new` | 需要免费 API Key |

## 使用说明

1. 页面加载后自动显示最近可用的 NASA 卫星云图，底层为 Blue Marble 静态底图。
2. 拖动地球查看任意区域，滚轮放大到云层细节。
3. 在左侧“GIS 图层”面板打开需要的叠加图层。
4. 点击 **🔄 刷新为最新** 可切换到今天最新影像。
5. 如需 OpenWeatherMap 图层，在输入框填入 API Key 后打开对应开关。

## 获取 OpenWeatherMap API Key（可选）

1. 访问 https://openweathermap.org/api
2. 注册免费账号。
3. 进入 [API Keys](https://home.openweathermap.org/api_keys) 页面复制 Key。
4. 粘贴到页面中的输入框，打开对应 OWM 开关即可。

## 自定义

- 修改 `index.html` 中的 `OVERLAYS` 数组可增删图层，或调整 `alpha` 透明度。
- 切换 `VIIRS_SNPP_CorrectedReflectance_TrueColor` 为 `MODIS_Aqua_CorrectedReflectance_TrueColor` 可换用 MODIS 卫星底图。
- 调整 `maximumLevel` 可限制最高瓦片层级，控制流量与清晰度。

## 许可

页面代码可自由使用。卫星影像遵循 NASA GIBS 使用条款；OpenWeatherMap 数据遵循其服务条款。
