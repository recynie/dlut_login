#!/bin/bash

# id and password needed (before this line) to complete this shell. 
captive_server='http://www.google.cn/generate_204'
url_index='http://123.123.123.123/'
user_agent='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
login() {
    login_page_url=$(curl -s "${url_index}" | grep -o '<script>[^<]*</script>' | sed -e "s/<script>\(.*\)<\/script>/\1/" | grep -o "'.*'" | sed -e "s/'//g")
    login_url=$(echo ${login_page_url} | awk -F \? '{print $1}')
    login_url="${login_url/index.jsp/InterFace.do?method=login}"
    query_string=$(echo ${login_page_url} | awk -F \? '{print $2}')
    query_string="${query_string//&/%26}"
    query_string="${query_string//=/%3D}"
    login_post_data="userId=$1&password=$2&service=&queryString=${query_string}&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=true"
    if [ -n "${login_url}" ]; then
        auth_result=$(curl -d "${login_post_data}" -H "Accept: */*" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: zh-CN,zh\;q=0.9" -H "Proxy-Connection: keep-alive" -H "Referer: ${login_url}" -H "User-Agent: ${user_agent}" "${login_url}")
        # echo "${auth_result}"
    fi
}
for ((i=0; i<5; i++)) #5次获取code，获取失败说明网络不通
do
    code=$(curl -I ${captive_server} -s | grep "HTTP/1.1" | awk '{print $2}')
    if [ -z "${code}" ]; then
        sleep 2s
    else
        break
    fi
done
if [ -z "${code}" ]; then
    echo 连接失败，请检查：$'\n'1. 校园网是否正常/是否插好网线$'\n'2. 电脑代理是否正确设置（可以尝试关闭代理）
    exit 1;
fi
for ((i=0; i<5; i++)) #5次连接校园网，连接失败说明账号密码不对或此脚本已失效
do
    if [ "${code}" = "200" ]; then
        echo 第${i}次尝试连接
        login ${id} ${passwd}
    elif [ "${code}" = "204" ]; then
        echo 连接成功
        exit 0;
    fi
    sleep 2s
    code=$(curl -I ${captive_server} -s | grep "HTTP/1.1" | awk '{print $2}')
done
echo 连接失败，请检查用户信息是否正确
