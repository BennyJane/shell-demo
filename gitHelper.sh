#!/bin/bash
#set -ex
set -e

#### todo
# 修改为死循环, 在该脚本中完成常用命令的缩写操作
# 添加 git add等快捷方式
# 封装为函数

# 获取当前脚本所在的目录
#cd "$(dirname "$0")"
cd `dirname "$0"`
echo "[当前目录]: $(pwd)"


current_branch="$(git symbolic-ref --short -q HEAD)"
echo "[本地分支]: ${current_branch}"


# 获取输入的第一个参数：期待
push_branch=$1

setBranch (){
    if [[ -z ${push_branch} ]]
    then
        echo "请输入推送分支的名称(可选参数:d|q)"; read push_branch
        if [[ -z ${push_branch} ]]
        then
            echo "输入内容为空，退出."
            exit 1
        elif [[ ${push_branch} = "d" ]]
        then
            push_branch=${current_branch}

        fi
    else
        echo "[推送分支]: ${push_branch}"
    fi
}


setPushBranch (){
if [[ $current_branch != $push_branch ]]
then
   echo "当前所处分支与推送远程分支不一致!"
   echo "是否将推送分支${push_branch}修改为当前分支${current_branch}(y|*)"; read is_change
   if test ${is_change} = "y"
   then
       push_branch=${current_branch}
   else
       exit 1
   fi
fi

}



function gitCommit () {
    if test "$(git commit -m $1)"
    then
       git status
       echo "[commit success!]"
    else
       echo "[commit fail!]"
    fi
}

function clearGittrace(){
	echo "清除本地git文件追踪内容"
	git rm -r -f --cached .

}


function ACP(){
echo '------------------------------------------------------------------------------------'

git add .
git status
#echo $?

echo '------------------------------------------------------------------------------------'
echo '请输入本次更新的注释(msg|d|q):　'
read message

if [[ ${message} = "q" ]]
then
    # 通过输入 q, 直接推出当前脚本
    exit 1
elif [[ ${message} = "d" ]]
then
    echo "使用默认注释，进行更新"
    message="更新"
    gitCommit ${message}
elif [[ -n ${message} ]]
then
    gitCommit ${message}
else
    echo "请输入本次更新信息"
fi

echo '------------------------------------------------------------------------------------'
echo "是否向远程分支推送本次修改(y|yes|q)"
read is_push

case ${is_push} in
"y" | "yes")
  git push origin ${current_branch};;
"q" | "exit" | "e")
 echo "退出,不推送到远程分支"
 exit 1;;
 *)
 echo "退出";;
esac
echo '---------------------------------[end]-----------------------------------------------'

}


main (){
#    clearGittrace
    setBranch
    setPushBranch
    ACP
}

main