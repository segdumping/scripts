#!/bin/sh

#必应壁纸api
url="https://www.bing.com/HPImageArchive.aspx?format=js&n=8"
rootpath="/Users/$USER/Pictures/"
#结果存入文件
jsonpath=${rootpath}wallpaper.json
#数据信息不存在直接下载
if [[ ! -e $jsonpath ]];then
        curl $url > $jsonpath 2>>${rootpath}err.log
fi
#最近的壁纸日期
lastestdate=$(cat $jsonpath | /usr/local/bin/jq -r ".images[0].enddate")
#今天的日期
today=$(date +%Y%m%d)
#下载最新的信息
if [[ $lastestdate -lt $today ]];then
        curl $url > $jsonpath 2>>${rootpath}err.log
fi
#随机数
random=$(expr $RANDOM % 8)
echo $random >> ${rootpath}debug.log
#壁纸url
imgurl=$(cat $jsonpath | /usr/local/bin/jq -r ".images[$random].url")
#添加域名
imgurl="http://cn.bing.com"${imgurl}
#提取壁纸名称
imgname=$(expr "$imgurl" : '.*ZH-CN\(.*\)&rf')
#壁纸路径
imgpath=${rootpath}$imgname
#不存在则先下载
if [[ ! -e $imgpath ]]; then
        curl -o $imgpath $imgurl
fi
#调用Finder应用切换桌面壁纸
osascript -e "tell application \"Finder\" to set the desktop picture to POSIX file \"$imgpath\""
