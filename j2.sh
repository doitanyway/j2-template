#!/usr/bin/env bash
force=false
s_dir='/home/j2-template/config-file'
d_dir='/home/j2-template/temp'
file='/home/j2-template/config-file/jdbc.properties.j2,/home/j2-template/jdbc.properties'
vars_file='/home/j2-template/config-file/param.sh'
#分割赋值源文件，目标文件
pwd_file=$(pwd | awk '{print $1}')

#echo "当前目录:" $pwd_file
array=()
function split(){
  split_ret=${1//=/ }
  count=0
  for e in $split_ret
  do
    array[$count]=$e
    let count++
  done
}

#help函数
function help(){
  echo "help cmd:"
  echo "  ./j2.sh --[options]=[options values] ... [cmd]  "
  echo ""
  echo "      [vars]"
  echo "      --force=[true/false],...     -Mandatory coverage"
  echo "      --s_dir=[path],...    	-*.j2 file path"
  echo "      --d_dir=[path],...    		-config file path	"
  echo "      --file=[file],[file]...    	-file config"
  echo "      --v_file=[file]              -vars config "
  echo ""
  echo "      [examples]"
  echo "         ./j2.sh --force=true    "
  echo "         ./j2.sh --s_dir="/ddd/ddd/sss" --d_dir="/ddd/ddd"   --v_file=123.sh   "
  echo "         ./j2.sh --file="/file/file.txt.j2,/file/file.txt"   --v_file=123.sh   "
  echo "         ./j2.sh --help                                                 "
  return ;
}

function file_force(){
    if $force ; then
      file_exit
    else
      echo "Mandatory coverage"
    fi
}

function file_exit(){
if [ -e "$dist_file" ];then
      echo "exit"
      exit
else
      echo "Mandatory coverage2"
fi
}

function dir_force(){
    if $force ; then
      dir_exit
    else
      echo "Mandatory coverage"
      dir_create_files
    fi
}


# 新建文件
function dir_exit(){
    echo ""
    echo "......Create config files......"
 #   rm -rf $d_dir
 #   mkdir -p $d_dir
    cd $s_dir
     ls *.j2 | awk '{print $1}'| while read line
    do
      new_name=$(echo $line | sed "s/.j2//g")
      if [ -e "$dd_dir/$new_name" ];then
      echo "exit"
       else
       echo "file:-"$line"-"$new_name
      sed 's/888888888-88899999998888/0/g' $line > $dd_dir/$new_name
       fi

    done
    echo "......End create config files......"
    echo ""
    echo ""
    return;
}

function dir_config(){
   echo "source_dir：" $s_dir
   echo "dis_dir" $d_dir
   echo "vars_file" $vars_file
   cd $d_dir
   dd_dir=`pwd | awk '{print $1}'`
   echo "111:"$pwd_file
   cd $pwd_file
   #echo "dd:"$dd_file
   # 初始化参数变量
   pwd
   source $vars_file
   dir_force
   dir_read_and_replace_params
}

function file_config(){
   rh=(${file//,/ })
   source_file=${rh[0]}
   dist_file=${rh[1]}
   echo "source_file："$source_file
   echo "dist_file"$dist_file
   echo "vars_file" $vars_file

   file_force
   # 初始化参数变量
   source $vars_file
   file_create_files
   file_read_and_replace_params
}

# 新建文件
function dir_create_files(){
    echo ""
    echo "......Create config files......"
 #   rm -rf $d_dir
 #   mkdir -p $d_dir
    cd $s_dir
     ls *.j2 | awk '{print $1}'| while read line

    do

      new_name=$(echo $line | sed "s/.j2//g")
      echo "file:-"$line"-"$new_name
      sed 's/888888888-88899999998888/0/g' $line > $dd_dir/$new_name
    done
    echo "......End create config files......"
    echo ""
    echo ""
    return;
}

# {{param}}参数替换成为真实值
function dir_replace_param(){
    echo "--"$1-$2
    param_str=$1
    param=$2
    cd ${pwd_file}
    cd $s_dir
    ls *.j2 | awk '{print $1}'| while read file

    do
      new_file_name=$(echo $file | sed "s/.j2//g")
      echo "-"file"-"$new_file_name
      sed -i "s/{{${param_str}}}/${param}/g" $dd_dir/${new_file_name}
    done
    return;
}

# 读取参数，修改替换配置文件
function dir_read_and_replace_params(){
    # 从参数文件中读取参数
    cd ${pwd_file}
    cat $vars_file | grep export | sed 's/export //g' | sed 's/=.*$//g' | while read param_str
    do
      param=`eval echo '$'"$param_str"`
      if [[ -z "$param" ]]; then
        echo $param_str"-不存在"
      else
    #    echo $param_str":"${param}
        dir_replace_param $param_str $param
      fi
    done
    return;
}


# 新建文件
function file_create_files(){
    echo ""
    echo "......Create config files......"
    sed 's/888888888-88899999998888/0/g' $source_file > $dist_file
    echo "......End create config files......"
    echo ""
    echo ""
    return;
}

# {{param}}参数替换成为真实值
function file_replace_param(){
    echo "--"$1-$2
    param_str=$1
    param=$2
      sed -i "s/{{${param_str}}}/${param}/g" $dist_file
    return;
}

# 读取参数，修改替换配置文件
function file_read_and_replace_params(){
    # 从参数文件中读取参数
    cat $vars_file | grep export | sed 's/export //g' | sed 's/=.*$//g' | while read param_str
    do
      param=`eval echo '$'"$param_str"`
      if [[ -z "$param" ]]; then
        echo $param_str"-不存在"
      else
    #    echo $param_str":"${param}
       file_replace_param $param_str $param
      fi
    done
    return;
}

for arg in $*
do
  split $arg
  case ${array[0]} in
    --s_dir)
    s_dir=${array[1]}
		echo "s:"$s_dir
    ;;
    --v_file)
    vars_file=${array[1]}
		echo "v:"$vars_file
    ;;
    --d_dir)
    d_dir=${array[1]}
		echo "d:"$d_dir
    CMD=${array[0]}
    ;;
		--file)
    file=${array[1]}
	  echo "f:"$file
    CMD=${array[0]}

    ;;
    --force)
     force=true
      ;;
     --help)
         CMD=${array[0]}

    ;;
  esac
done

# main function
 case $CMD in
  --d_dir)
    dir_config
    ;;
  --file)
    file_config
    ;;
    *)
    help
  ;;
  --help)
    help
  ;;
esac

