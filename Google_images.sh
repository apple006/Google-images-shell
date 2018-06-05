#!/bin/bash
#linux上安装Google images脚本
#Author coding QQ2420498526
##如果想修改源文件请保留以上几行信息，谢谢开源的动力就是看着我写的轮子别人拿去使用还把我名字留在上面！！！！！
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo -e "\033[36m ================Welcome===================\033[0m"
echo -e "\033[33m Version：1.1 dev 2018 \033[0m"
echo -e "\033[33m Bug collect QQ：2420498526. \033[0m"
echo -e "\033[33m Developers E_mail：coding1618@Gmail.com \033[0m"
echo -e "\033[33m Blog：https://ilaok.com \033[0m"
echo -e "\033[36m =================感谢Toyo=================\033[0m"
echo -e "\033[36m    System Required: CentOS/Debian/Ubuntu \033[0m"
echo -e "\033[36m    Description: Caddy Install \033[0m"
echo -e "\033[36m    Version: 1.0.7 \033[0m"
echo -e "\033[36m    Blog: https://doub.io/shell-jc1 \033[0m"
echo -e "\033[36m ========================================== \033[0m"

#全局变量
file="/usr/local/caddy/"
caddy_file="/usr/local/caddy/caddy"
caddy_conf_file="/usr/local/caddy/Caddyfile"
Info_font_prefix="\033[32m" && Error_font_prefix="\033[31m" && Info_background_prefix="\033[42;37m" && Error_background_prefix="\033[41;37m" && Font_suffix="\033[0m"


#获取本机ip
local_host="`hostname --fqdn`"

#安装Google镜像函数,本函数技术支持:感谢以下Toyo
#=================================================
#       System Required: CentOS/Debian/Ubuntu
#       Description: Caddy Install
#       Version: 1.0.7
#       Author: Toyo
#       Blog: https://doub.io/shell-jc1/
#=================================================
installGoogle(){
    check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}
check_installed_status(){
	[[ ! -e ${caddy_file} ]] && echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy 没有安装，请检查 !" && exit 1
}
Download_caddy(){
	[[ ! -e ${file} ]] && mkdir "${file}"
	cd "${file}"
	PID=$(ps -ef |grep "caddy" |grep -v "grep" |grep -v "init.d" |grep -v "service" |grep -v "caddy_install" |awk '{print $2}')
	[[ ! -z ${PID} ]] && kill -9 ${PID}
	[[ -e "caddy_linux*.tar.gz" ]] && rm -rf "caddy_linux*.tar.gz"
	
	if [[ ! -z ${extension} ]]; then
		extension_all="?plugins=${extension}&license=personal"
	else
		extension_all="?license=personal"
	fi
	
	if [[ ${bit} == "i386" ]]; then
		wget --no-check-certificate -O "caddy_linux.tar.gz" "https://caddyserver.com/download/linux/386${extension_all}" && caddy_bit="caddy_linux_386"
	elif [[ ${bit} == "i686" ]]; then
		wget --no-check-certificate -O "caddy_linux.tar.gz" "https://caddyserver.com/download/linux/386${extension_all}" && caddy_bit="caddy_linux_386"
	elif [[ ${bit} == "x86_64" ]]; then
		wget --no-check-certificate -O "caddy_linux.tar.gz" "https://caddyserver.com/download/linux/amd64${extension_all}" && caddy_bit="caddy_linux_amd64"
	else
		echo -e "${Error_font_prefix}[错误]${Font_suffix} 不支持 ${bit} !" && exit 1
	fi
	[[ ! -e "caddy_linux.tar.gz" ]] && echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy 下载失败 !" && exit 1
	tar zxf "caddy_linux.tar.gz"
	rm -rf "caddy_linux.tar.gz"
	[[ ! -e ${caddy_file} ]] && echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy 解压失败或压缩文件错误 !" && exit 1
	rm -rf LICENSES.txt
	rm -rf README.txt 
	rm -rf CHANGES.txt
	rm -rf "init/"
	chmod +x caddy
}
Service_caddy(){
	if [[ ${release} = "centos" ]]; then
		if ! wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/other/caddy_centos -O /etc/init.d/caddy; then
			echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy服务 管理脚本下载失败 !" && exit 1
		fi
		chmod +x /etc/init.d/caddy
		chkconfig --add caddy
		chkconfig caddy on
	else
		if ! wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/other/caddy_debian -O /etc/init.d/caddy; then
			echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy服务 管理脚本下载失败 !" && exit 1
		fi
		chmod +x /etc/init.d/caddy
		update-rc.d -f caddy defaults
	fi
}
install_caddy(){
	if [[ -e ${caddy_file} ]]; then
		echo && echo -e "${Error_font_prefix}[信息]${Font_suffix} 检测到 Caddy 已安装，是否继续安装(覆盖更新)？[y/N]"
		stty erase '^H' && read -p "(默认: n):" yn
		[[ -z ${yn} ]] && yn="n"
		if [[ ${yn} == [Nn] ]]; then
			echo && echo "已取消..." && exit 1
		fi
	fi
	Download_caddy
	Service_caddy
	echo && echo -e " Caddy 配置文件：${caddy_conf_file}
 Caddy 日志文件：/tmp/caddy.log
 使用说明：service caddy start | stop | restart | status
 或者使用：/etc/init.d/caddy start | stop | restart | status
 ${Info_font_prefix}[信息]${Font_suffix} Caddy 安装完成！" && echo
}
uninstall_caddy(){
	check_installed_status
	echo && echo "确定要卸载 Caddy ? [y/N]"
	stty erase '^H' && read -p "(默认: n):" unyn
	[[ -z ${unyn} ]] && unyn="n"
	if [[ ${unyn} == [Yy] ]]; then
		PID=`ps -ef |grep "caddy" |grep -v "grep" |grep -v "init.d" |grep -v "service" |grep -v "caddy_install" |awk '{print $2}'`
		[[ ! -z ${PID} ]] && kill -9 ${PID}
		if [[ ${release} = "centos" ]]; then
			chkconfig --del caddy
		else
			update-rc.d -f caddy remove
		fi
		[[ -s /tmp/caddy.log ]] && rm -rf /tmp/caddy.log
		rm -rf ${caddy_file}
		rm -rf ${caddy_conf_file}
		rm -rf /etc/init.d/caddy
		[[ ! -e ${caddy_file} ]] && echo && echo -e "${Info_font_prefix}[信息]${Font_suffix} Caddy 卸载完成 !" && echo && exit 1
		echo && echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy 卸载失败 !" && echo
	else
		echo && echo "卸载已取消..." && echo
	fi
}
check_sys
action=$1
extension=$2
[[ -z $1 ]] && action=install
case "$action" in
    install|uninstall)
    ${action}_caddy
    ;;
    *)
    echo "输入错误 !"
    echo "用法: {install | uninstall}"
    ;;
esac
}

#END Google install结束



#Caddy初始化端口
InitializeCaddy(){
    echo -e "\033[33m (端口范围1024-65535！请不要输入其他字符否则程序将无法运行): \033[0m"
    echo -e "\033[33m 请输入的你自定义端口: \033[0m"
    read port
       echo ":"${port}" {
            gzip
            proxy / https://www.google.com.hk
        }" > /usr/local/caddy/Caddyfile
    #重启    
    /etc/init.d/caddy restart
}


#开始执行安装
installGoogle
InitializeCaddy

echo -e "\033[32m ======================================= \033[0m"
echo -e "\033[32m       installed successfully!.         \033[0m"
echo -e "\033[32m 访问地址:http://你主机外网IP地址:"${port}"  \033[0m"
echo -e "\033[32m 你可以通过Nginx反向代理来绑定域名！        \033[0m"
echo -e "\033[32m 请记得手动在防火墙里添加端口哦！！           \033[0m"
echo -e "\033[32m            Good luck .                  \033[0m"
echo -e "\033[32m ======================================= \033[0m"

		