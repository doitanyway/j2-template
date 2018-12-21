# j2-template

## 前言

j2-template是一个模版软件，其作用是把文件中的{{系统变量}}替换成系统变量的值。


## 使用方法

```
help cmd:
  ./j2.sh --[options]=[options values] ... [cmd]  

      [vars]
      --force=[true/false],...     -Mandatory coverage
      --s_dir=[path],...        -*.j2 file path
      --d_dir=[path],...                -config file path       
      --file=[file],[file]...           -file config
      --v_file=[file]              -vars config 

      [examples]
         ./j2.sh --force=true    
         ./j2.sh --s_dir=/ddd/ddd/sss --d_dir=/ddd/ddd   --v_file=123.sh   
         ./j2.sh --file=/file/file.txt.j2,/file/file.txt   --v_file=123.sh   
         ./j2.sh --help  
```

