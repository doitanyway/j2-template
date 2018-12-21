#!/usr/bin/env bash
force=false
s_dir='/home/j2-template/config-file'
d_dir='/home/j2-template/temp'
file='/home/j2-template/config-file/jdbc.properties.j2,/home/j2-template/jdbc.properties'
vars_file='/home/j2-template/config-file/param.sh'
#分割赋值源文件，目标文件
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
  echo ""
  echo "help cmd:"
  echo "  ./j2.sh --[options]=[options values] ... [cmd]  "
  echo ""
  echo "[vars]"
  echo "      --force=[true/false],...     -Mandatory coverage"
  echo "      --s_dir=[path],...    	     -*.j2 file path"
  echo "      --d_dir=[path],...    		   -config file path	"
  echo "      --file=[file],[file]...    	 -file config"
  echo "      --v_file=[file]              -vars config "
  echo ""
  echo "[examples]"
  echo "         ./j2.sh --force=true    "
  echo "         ./j2.sh --s_dir="/ddd/ddd/sss" --d_dir="/ddd/ddd"    --v_file=123.sh   "
  echo "         ./j2.sh --file="/file/file.txt.j2,/file/file.txt"   --v_file=123.sh   "
  echo "         ./j2.sh --help                                                 "
  return ;
}

function dir_config(){
   echo "源文件夹：" $s_dir
   echo "目标文件夹" $d_dir
   echo "变量文件" $vars_file
   # 初始化参数变量
   source $vars_file
   dir_create_files
   dir_read_and_replace_params
}

function file_config(){
   rh=(${file//,/ })  
   source_file=${rh[0]}
   dist_file=${rh[1]}
   echo "源文件："$source_file
   echo "目标文件"$dist_file
   echo "变量文件" $vars_file
   # 初始化参数变量
   source $vars_file
   file_create_files
   file_read_and_replace_params
}

# dir/新建文件
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
      sed 's/888888888-88899999998888/0/g' $line > $d_dir/$new_name
    done
    echo "......End create config files......"
    echo ""
    echo ""
    return;
} 

# dir/{{param}}参数替换成为真实值
function dir_replace_param(){
    echo "--"$1-$2
    param_str=$1
    param=$2
    cd $s_dir
    ls *.j2 | awk '{print $1}'| while read file
    do
      new_file_name=$(echo $file | sed "s/.j2//g")
      echo "-"file"-"$new_file_name
      sed -i "s/{{${param_str}}}/${param}/g" $d_dir/${new_file_name}
    done
    return;
}

# dir/读取参数，修改替换配置文件
function dir_read_and_replace_params(){
    # 从参数文件中读取参数
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

#  file/新建文件
function file_create_files(){
    echo ""
    echo "......Create config files......"
    sed 's/888888888-88899999998888/0/g' $source_file > $dist_file
    echo "......End create config files......"
    echo ""
    echo ""
    return;
} 

# file/{{param}}参数替换成为真实值
function file_replace_param(){
    echo "--"$1-$2
    param_str=$1
    param=$2
      sed -i "s/{{${param_str}}}/${param}/g" $dist_file
    return;
}

# file/读取参数，修改替换配置文件
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
		#echo "s:"$s_dir
    ;;
    --v_file)
    vars_file=${array[1]}
		#echo "v:"$vars_file
    ;;
    --d_dir)
    d_dir=${array[1]}
		#echo "d:"$d_dir
    CMD=${array[0]}
    ;;
		--file)
    file=${array[1]}
	  #echo "f:"$file
    CMD=${array[0]}
    
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
