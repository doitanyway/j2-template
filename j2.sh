#!/usr/bin/env bash

# 初始化参数变量
source param.sh

# 新建文件
function create_files(){
    echo ""
    echo "......Create config files......"
    rm -rf temp
    mkdir temp
    ls *.j2 | awk '{print $1}'| while read line
    do

      new_name=$(echo $line | sed "s/.j2//g")
      echo "file:-"$line"-"$new_name
      sed 's/888888888-88899999998888/0/g' $line > temp/$new_name
    done
    echo "......End create config files......"
    echo ""
    echo ""
    return;
}


# {{param}}参数替换成为真实值
function replace_param(){
    echo "--"$1-$2
    param_str=$1
    param=$2
    ls *.j2 | awk '{print $1}'| while read file
    do
      new_file_name=$(echo $file | sed "s/.j2//g")
      echo "-"file"-"$new_file_name
      sed -i "s/{{${param_str}}}/${param}/g" temp/${new_file_name}
    done
    return;
}

# 读取参数，修改替换配置文件
function read_and_replace_params(){
    # 从参数文件中读取参数
    cat param.sh | grep export | sed 's/export //g' | sed 's/=.*$//g' | while read param_str
    do
      param=`eval echo '$'"$param_str"`
      if [[ -z "$param" ]]; then
        echo $param_str"-不存在"
      else
    #    echo $param_str":"${param}
        replace_param $param_str $param
      fi
    done
    return;
}

create_files;
read_and_replace_params;


