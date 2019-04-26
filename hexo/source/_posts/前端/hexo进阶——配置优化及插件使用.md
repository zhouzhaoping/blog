---
title: hexo进阶——配置优化及插件使用
urlname: hexo-config
date: 2018-12-14 11:25:43
tags: 前端
categories: 前端
---
 在上一篇文章[十分钟hexo装进docker](http://blog.zhouzhaoping.com/Frontend/docker-hexo/)里，我们搞定了docker部署hexo的方式，但是默认样式总是不能让人满意，于是接下来继续折腾。

<!-- more -->

## 食用前提
本文的基础是已经搞定了hexo部署，同时对hexo有基本的了解。如果还不会部署可以参考[十分钟hexo装进docker](http://zhouzhaoping.com/frontend/docker-hexo)

## 基本配置

### 主题选择与安装
在hexo的[官网](https://hexo.io/themes/)上有很多主题可以选择，在搜索各种资料的时候，发现有相当部分的技术博客都是用[next主题](https://github.com/theme-next/hexo-theme-next)做的，而且界面还挺美观的，所以选择了使用这个主题。  
```bash
$ cd hexo
$ git clone https://github.com/theme-next/hexo-theme-next themes/next
```
接下来进行基本的站点配置和主题配置，站点配置文件在`_config.yml`，主题配置文件在`themes/next/_config.yml`。我这边的基本配置参考了[打造个性超赞博客Hexo+NexT+GitHubPages的超深度优化](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html)

### 站点配置
```yaml
# Site
title: 码兴邦
subtitle: 空谈误国，代码兴邦
description: Zhou Zhaoping's blog
keywords: technology,computer science,zhouzhaoping,blog,博客,周钊平,计算机,技术,科学
author: fisher allan
language: zh-CN
timezone:

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: http://blog.zhouzhaoping.com
root: /
permalink: :category/:urlname/
permalink_defaults:

# Directory
source_dir: source
public_dir: public
tag_dir: tags
archive_dir: archives
category_dir: categories
code_dir: downloads/code
i18n_dir: :lang
skip_render:

# Writing
new_post_name: :title.md # File name of new posts
default_layout: post
titlecase: false # Transform title into titlecase
external_link: true # Open external links in new tab
filename_case: 0
render_drafts: false
post_asset_folder: false
relative_link: false
future: true
highlight:
  enable: true
  line_number: true
  auto_detect: false
  tab_replace:
  
# Home page setting
# path: Root path for your blogs index page. (default = '')
# per_page: Posts displayed per page. (0 = disable pagination)
# order_by: Posts order. (Order by date descending by default)
index_generator:
  path: ''
  per_page: 10
  order_by: -date
  
# Category & Tag
default_category: uncategorized
category_map:
  日记: Diary
  前端: Frontend
  后端: Backend
tag_map:
  日记: Diary
  前端: Frontend
  后端: Backend

# Date / Time format
## Hexo uses Moment.js to parse and display date
## You can customize the date format as defined in
## http://momentjs.com/docs/#/displaying/format/
date_format: YYYY-MM-DD
time_format: HH:mm:ss

# Pagination
## Set per_page to 0 to disable pagination
per_page: 10
pagination_dir: page

# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: next

# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type:
```

### 主题配置
```yaml
# Allow to cache content generation. Introduced in NexT v6.0.0.
cache:
  enable: true

# ---------------------------------------------------------------
# Site Information Settings
# ---------------------------------------------------------------

# To get or check favicons visit: https://realfavicongenerator.net
# Put your favicons into `hexo-site/source/` (recommend) or `hexo-site/themes/next/source/images/` directory.

# Default NexT favicons placed in `hexo-site/themes/next/source/images/` directory.
# And if you want to place your icons in `hexo-site/source/` root directory, you must remove `/images` prefix from pathes.

# For example, you put your favicons into `hexo-site/source/images` directory.
# Then need to rename & redefine they on any other names, otherwise icons from Next will rewrite your custom icons in Hexo.
favicon:
  small: /images/favicon.ico
  medium: /images/favicon.ico
  apple_touch_icon: /images/favicon.ico
  safari_pinned_tab: /images/favicon.ico
  #android_manifest: /images/manifest.json
  #ms_browserconfig: /images/browserconfig.xml

# Set rss to false to disable feed link.
# Leave rss as empty to use site's feed link, and install hexo-generator-feed: `npm install hexo-generator-feed --save`.
# Set rss to specific value if you have burned your feed already.
rss:

footer:
  # Specify the date when the site was setup.
  # If not defined, current year will be used.
  since: 2018

  # Icon between year and copyright info.
  icon:
    # Icon name in fontawesome, see: https://fontawesome.com/v4.7.0/icons
    # `heart` is recommended with animation in red (#ff0000).
    name: heart
    # If you want to animate the icon, set it to true.
    animated: false
    # Change the color of icon, using Hex Code.
    color: "#808080"

  # If not defined, will be used `author` from Hexo main config.
  copyright:
  # -------------------------------------------------------------
  powered:
    # Hexo link (Powered by Hexo).
    enable: false
    # Version info of Hexo after Hexo link (vX.X.X).
    version: false

  theme:
    # Theme & scheme info link (Theme - NexT.scheme).
    enable: false
    # Version info of NexT after scheme info (vX.X.X).
    version: false
  # -------------------------------------------------------------
  # Beian icp information for Chinese users. In China, every legal website should have a beian icp in website footer.
  # http://www.miitbeian.gov.cn
  beian:
    enable: false
    icp:

  # -------------------------------------------------------------
  # Any custom text can be defined here.
  #custom_text: Hosted by <a target="_blank" rel="external nofollow" href="https://pages.coding.me"><b>Coding Pages</b></a>

# Creative Commons 4.0 International License.
# https://creativecommons.org/share-your-work/licensing-types-examples
# Available: by | by-nc | by-nc-nd | by-nc-sa | by-nd | by-sa | zero
creative_commons:
  license: by-nc-sa
  sidebar: false
  post: false


# ---------------------------------------------------------------
# SEO Settings
# ---------------------------------------------------------------

# Canonical, set a canonical link tag in your hexo, you could use it for your SEO of blog.
# See: https://support.google.com/webmasters/answer/139066
# Tips: Before you open this tag, remember set up your URL in hexo _config.yml ( ex. url: http://yourdomain.com )
canonical: true

# Change headers hierarchy on site-subtitle (will be main site description) and on all post/pages titles for better SEO-optimization.
seo: false

# If true, will add site-subtitle to index page, added in main hexo config.
# subtitle: Subtitle
index_with_subtitle: false

# Automatically add external URL with BASE64 encrypt & decrypt.
exturl: false


# ---------------------------------------------------------------
# Menu Settings
# ---------------------------------------------------------------

# When running the site in a subdirectory (e.g. domain.tld/blog), remove the leading slash from link value (/archives -> archives).
# Usage: `Key: /link/ || icon`
# Key is the name of menu item. If translate for this menu will find in languages - this translate will be loaded; if not - Key name will be used. Key is case-senstive.
# Value before `||` delimeter is the target link.
# Value after `||` delimeter is the name of FontAwesome icon. If icon (with or without delimeter) is not specified, question icon will be loaded.
menu:
  home: / || home
  about: /about/ || user
  tags: /tags/ || tags
  categories: /categories/ || th
  archives: /archives/ || archive
  #schedule: /schedule/ || calendar
  #sitemap: /sitemap.xml || sitemap
  #commonweal: /404/ || heartbeat

# Enable/Disable menu icons / item badges.
menu_settings:
  icons: true
  badges: true

# ---------------------------------------------------------------
# Scheme Settings
# ---------------------------------------------------------------

# Schemes
#scheme: Muse
#scheme: Mist
scheme: Pisces
#scheme: Gemini


# ---------------------------------------------------------------
# Sidebar Settings
# ---------------------------------------------------------------

# Posts / Categories / Tags in sidebar.
site_state: true

# Social Links.
# Usage: `Key: permalink || icon`
# Key is the link label showing to end users.
# Value before `||` delimeter is the target permalink.
# Value after `||` delimeter is the name of FontAwesome icon. If icon (with or without delimeter) is not specified, globe icon will be loaded.
social:
  GitHub: https://github.com/zhouzhaoping || github
  E-Mail: mailto:zhouzhaoping11@gmail.com || envelope
  Weibo: https://weibo.com/2290298424 || weibo
  #Google: https://plus.google.com/yourname || google
  Twitter: https://twitter.com/FisherAllen11 || twitter
  FB Page: https://www.facebook.com/fisherallan11 || facebook
  #VK Group: https://vk.com/yourname || vk
  #StackOverflow: https://stackoverflow.com/yourname || stack-overflow
  #YouTube: https://youtube.com/yourname || youtube
  Instagram: https://instagram.com/fisher11allen || instagram
  #Skype: skype:yourname?call|chat || skype
  Telegram: http://t.me/fisherallan || telegram

social_icons:
  enable: true
  icons_only: false
  transition: false

# Follow me on GitHub banner in right-top corner.
# Usage: `permalink || title`
# Value before `||` delimeter is the target permalink.
# Value after `||` delimeter is the title and aria-label name.
github_banner: https://github.com/zhouzhaoping || Follow me on GitHub

# Blog rolls
links_icon: globe
links_title: Links
#links_layout: block
links_layout: inline
links:
  This blog: http://blog.zhouzhaoping.com

# Sidebar Avatar
avatar:
  # in theme directory(source/images): /images/avatar.gif
  # in site  directory(source/uploads): /uploads/avatar.gif
  # You can also use other linking images.
  url: /images/avatar.jpg
  # If true, the avatar would be dispalyed in circle.
  rounded: true
  # The value of opacity should be choose from 0 to 1 to set the opacity of the avatar.
  opacity: 1
  # If true, the avatar would be rotated with the cursor.
  rotated: true

# Table Of Contents in the Sidebar
toc:
  enable: true

  # Automatically add list number to toc.
  number: true

  # If true, all words will placed on next lines if header width longer then sidebar width.
  wrap: true

sidebar:
  # Sidebar Position, available value: left | right (only for Pisces | Gemini).
  position: left
  #position: right

  # Manual define the sidebar width.
  # If commented, will be default for:
  # Muse | Mist: 320
  # Pisces | Gemini: 240
  #width: 300

  # Sidebar Display, available value (only for Muse | Mist):
  #  - post    expand on posts automatically. Default.
  #  - always  expand for all pages automatically
  #  - hide    expand only when click on the sidebar toggle icon.
  #  - remove  Totally remove sidebar including sidebar toggle.
  display: post
  #display: always
  #display: hide
  #display: remove

  # Sidebar offset from top menubar in pixels (only for Pisces | Gemini).
  offset: 12

  # Back to top in sidebar (only for Pisces | Gemini).
  b2t: true

  # Scroll percent label in b2t button.
  scrollpercent: true

  # Enable sidebar on narrow view (only for Muse | Mist).
  onmobile: false


# ---------------------------------------------------------------
# Post Settings
# ---------------------------------------------------------------

# Automatically scroll page to section which is under <!-- more --> mark.
scroll_to_more: false

# Automatically saving scroll position on each post/page in cookies.
save_scroll: false

# Automatically excerpt description in homepage as preamble text.
excerpt_description: true

# Automatically Excerpt. Not recommend.
# Please use <!-- more --> in the post to control excerpt accurately.
auto_excerpt:
  enable: true
  length: 150

# Read more button
# If true, the read more button would be displayed in excerpt section
read_more_btn: true

# Post meta display settings
post_meta:
  item_text: true
  created_at: true
  updated_at:
    enabled: false
    # If true, show updated date label only if `updated date` different from 'created date' (post edited in another day than was created).
    # And if post will edited in same day as created, edited time will show in popup title under created time label.
    # If false show anyway, but if post edited in same day, show only edited time.
    another_day: true
  categories: true

# Post wordcount display settings
# Dependencies: https://github.com/theme-next/hexo-symbols-count-time
symbols_count_time:
  separated_meta: true
  item_text_post: true
  item_text_total: false
  awl: 4
  wpm: 275

codeblock:
  # Manual define the border radius in codeblock
  # Leave it empty for the default 1
  border_radius:
  # Add copy button on codeblock
  copy_button:
    enable: false
    # Show text copy result
    show_result: false

# Wechat Subscriber
#wechat_subscriber:
  #enabled: true
  #qcode: /path/to/your/wechatqcode ex. /uploads/wechat-qcode.jpg
  #description: ex. subscribe to my blog by scanning my public wechat account

# Reward
# If true, reward would be displayed in every article by default.
# And you can show or hide one article specially through add page variable `reward: true/false`.
reward:
  enable: true
  comment: Buy Me a Coffee
  wechatpay: /images/wechatpay.png
  alipay: /images/alipay.jpg
  #bitcoin: /images/bitcoin.png

# Related popular posts
# Dependencies: https://github.com/tea3/hexo-related-popular-posts
related_posts:
  enable: false
  title: # custom header, leave empty to use the default one
  display_in_home: false
  params:
    maxCount: 5
    #PPMixingRate: 0.0
    #isDate: false
    #isImage: false
    #isExcerpt: false

# Post edit
# Dependencies: https://github.com/hexojs/hexo-deployer-git
post_edit:
  enable: false
  url: https://github.com/theme-next/theme-next.org/_posts/tree/master/ # Link for view source.
# url: https://github.com/theme-next/theme-next.org/_posts/edit/master/ # Link for fork & edit.


# ---------------------------------------------------------------
# Font Settings
# - Find fonts on Google Fonts (https://www.google.com/fonts)
# - All fonts set here will have the following styles:
#     light, light italic, normal, normal italic, bold, bold italic
# - Be aware that setting too much fonts will cause site running slowly
# - Introduce in 5.0.1
# ---------------------------------------------------------------
# CAUTION! Safari Version 10.1.2 bug: https://github.com/iissnan/hexo-theme-next/issues/1844
# To avoid space between header and sidebar in Pisces / Gemini themes recommended to use Web Safe fonts for `global` (and `logo`):
# Arial | Tahoma | Helvetica | Times New Roman | Courier New | Verdana | Georgia | Palatino | Garamond | Comic Sans MS | Trebuchet MS
# ---------------------------------------------------------------
font:
  enable: true

  # Uri of fonts host. E.g. //fonts.googleapis.com (Default).
  host: https://fonts.cat.net

  # Font options:
  # `external: true` will load this font family from `host` above.
  # `family: Times New Roman`. Without any quotes.
  # `size: xx`. Use `px` as unit.

  # Global font settings used for all elements in <body>.
  global:
    external: true
    family: Lato
    size:

  # Font settings for Headlines (H1, H2, H3, H4, H5, H6).
  # Fallback to `global` font settings.
  headings:
    external: true
    family: Roboto Slab
    size:

  # Font settings for posts.
  # Fallback to `global` font settings.
  posts:
    external: true
    family:

  # Font settings for Logo.
  # Fallback to `global` font settings.
  logo:
    external: true
    family:
    size:

  # Font settings for <code> and code blocks.
  codes:
    external: true
    family: Roboto Slab
    size:
```

## 第三方配置
### 评论
经过调研，尝试了LiveRe之后发现被墙，转向使用leancloud
```yaml
# Valine.
# You can get your appid and appkey from https://leancloud.cn
# more info please open https://valine.js.org
valine:
  enable: true # When enable is set to be true, leancloud_visitors is recommended to be closed for the re-initialization problem within different leancloud adk version.
  appid:  # your leancloud application appid
  appkey:  # your leancloud application appkey
  notify: false # mail notifier , https://github.com/xCss/Valine/wiki
  verify: false # Verification code
  placeholder: 留下你的评论 # comment box placeholder
  avatar: mm # gravatar style
  guest_info: nick,mail,link # custom comment header
  pageSize: 10 # pagination size
  visitor: false # leancloud-counter-security is not supported for now. When visitor is set to be true, appid and appkey are recommended to be the same as leancloud_visitors' for counter compatibility. Article reading statistic https://valine.js.org/visitor.html
```
### 评分
```yaml
# Star rating support to each article.
# To get your ID visit https://widgetpack.com
rating:
  enable: true
  id:    #<app_id>
  color:  fc6423
```

### 统计访问
```yaml
# Show number of visitors to each article.
# You can visit https://leancloud.cn get AppID and AppKey.
leancloud_visitors:
  enable: true
  app_id: XXX #<app_id>
  app_key: XXX #<app_key>
  # Dependencies: https://github.com/theme-next/hexo-leancloud-counter-security
  # If you don't care about security in lc counter and just want to use it directly
  # (without hexo-leancloud-counter-security plugin), set the `security` to `false`.
  security: false
  betterPerformance: false
```

## SEO配置
### 百度谷歌收录
搜索验证
```
site:blog.zhouzhaoping.com
```
在google的Search Console里选择推荐的Domain name provider方式，baidu则使用html标签验证
```yaml
# Baidu Webmaster tools verification setting
# See: https://ziyuan.baidu.com/site
baidu_site_verification: XXXXX
```
### 添加站点地图
```bash
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
```
在博客的站点配置文件_config.yml中添加以下代码
```yaml
sitemap:
path: sitemap.xml
baidusitemap:
path: baidusitemap.xml
```
`hexo g`之后就能看到`sitemap.xml`和`baidusitemap.xml`  
到[https://ziyuan.baidu.com/linksubmit](https://ziyuan.baidu.com/linksubmit)提交百度sitemap  
到[https://www.google.com/webmasters/tools/sitemap-list](https://www.google.com/webmasters/tools/sitemap-list)提交谷歌sitemap
### 添加蜘蛛协议
在站点source文件夹下新建`robots.txt`文件
```text
User-agent: *
Allow: /
Allow: /archives/
Allow: /tags/
Allow: /about/
Allow: /categories/

Disallow: /vendors/
Disallow: /js/
Disallow: /css/
Disallow: /fonts/
Disallow: /vendors/
Disallow: /fancybox/

Sitemap: http://blog.zhouzhaoping.com/sitemap.xml
Sitemap: http://blog.zhouzhaoping.com/baidusitemap.xml
```
到[https://ziyuan.baidu.com/robots](https://ziyuan.baidu.com/robots)检测robots  
到[https://www.google.com/webmasters/tools/robots-testing-tool](https://www.google.com/webmasters/tools/robots-testing-tool)检测谷歌robots
### 其它配置
修改主题配置中的
```yaml
# ---------------------------------------------------------------
# SEO Settings
# ---------------------------------------------------------------

# Canonical, set a canonical link tag in your hexo, you could use it for your SEO of blog.
# See: https://support.google.com/webmasters/answer/139066
# Tips: Before you open this tag, remember set up your URL in hexo _config.yml ( ex. url: http://yourdomain.com )
canonical: true

# Change headers hierarchy on site-subtitle (will be main site description) and on all post/pages titles for better SEO-optimization.
seo: true

# If true, will add site-subtitle to index page, added in main hexo config.
# subtitle: Subtitle
index_with_subtitle: true

# Automatically add external URL with BASE64 encrypt & decrypt.
exturl: true
```

## 百度统计
修改站点配置中的百度分析id
```yaml
# Baidu Analytics ID
baidu_analytics:
```
id即[https://tongji.baidu.com](https://tongji.baidu.com)里代码管理部分如下的XXXXX
```javascript
var _hmt = _hmt || [];
(function() {
  var hm = document.createElement("script");
  hm.src = "https://hm.baidu.com/hm.js?XXXXX";
  var s = document.getElementsByTagName("script")[0]; 
  s.parentNode.insertBefore(hm, s);
})();
```

## 图片使用
### 公式图片
在markdown里面直接加上如下的一段
```html
<br><img src="http://latex.codecogs.com/gif.latex?J(\theta)=\frac1{2m}(X\theta-Y)^T(X\theta-Y)=\frac1{2m}(\theta^TX^T-Y^T)(X\theta-Y)"/>
```
### 图床
#### github
也可以选择github的issue作为图床
1. 创建一个新issue
2. 拖拽上传图片，一次可以上传多张
2. 上传完 issue 之后，就可以直接在图片上右键复制图片URL

#### 七牛云
选择七牛云图床，实名认证后有10G免费空间。一般3个工作日内会审批  
1. 打开对象存储，新建存储空间
2. 点开刚才新建的空间，在内容管理里上传文件
3. 把外链域名粘贴到markdown里

### https://imgur.com/
