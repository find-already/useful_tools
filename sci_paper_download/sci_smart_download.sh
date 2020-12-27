#/bin/bash

file_src="file_src.list"
sci_prefix="https://sci-hub.se/"
id=0
total=`wc $file_src -l | cut -d' ' -f1`
map_file="./map_file.txt"

for url in `cat $file_src`;
do
    let id=id+1
    echo
    str_id=`printf "%03d" $id`
    str_total=`printf "%03d" $total`
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Start Download <${str_id}/${str_total},  $url>  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    echo >> $map_file
    printf "%s/%s - %s -" ${str_id} ${str_total} $url >> $map_file

    #下载 html
    https_url=`echo ${sci_prefix}${url}`
    html_url="${url}.html"
    echo "====> Save $https_url to $html_url"
    html_file_name=`printf "%03d.html" $id`
    wget ${https_url} -O ${html_file_name}
    # axel -n25 ${https_url} -o ${html_file_name}

    #找到 pdf
    https_tmp=`cat ${html_file_name}  | grep pdf | grep src  | cut -d'#' -f1 | awk '$0 ~ "https" {print $0} ' | awk -F'"' '{printf("%s\n", $2)}'`
    https_tmp_0=`cat ${html_file_name}| grep pdf | grep src  | cut -d'#' -f1 | awk '$0 !~ "https" {print $0} ' | awk -F'"' '{printf("https:%s\n", $2)}'`
    echo "====> str_has_https: $https_tmp"
    echo "====> str_no_https:  $https_tmp_0"
    last_url=""
    if [ "${https_tmp}"x == ""x ]; then
        last_url=$https_tmp_0
    else
        last_url=$https_tmp
    fi
    echo "====> last_url:     $last_url"

    #检查 pdf url 是否有效
    if [ "${last_url}"x == ""x ]; then
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  End Download <${str_id}/${str_total},  $url>, Can't find pdf url,  failed !!!"
        continue
    fi

    #下载 pdf
    tmp=`echo ${last_url} | awk -F'/' '{print $NF}'`
    pdf_name=`echo ${str_id}_${tmp}`
    retv=`wget ${last_url} -O ${pdf_name}`
    # retv=`axel -n25 ${last_url} -o ${pdf_name}`
    printf " %s" ${pdf_name} >> $map_file

    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  End Download <$str_id/${str_total},  $url> , ret = ${retv}, successed  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    echo
done
