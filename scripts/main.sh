#!/bin/bash
BASE_DIR=$(pwd)
folder_name="recon-$(date +%d-%m-%Y)"
# &>debug-main.txt
function search-nuclei {
    for i in $(ls -d */);
    do
        domain=$(echo $i | cut -d "/" -f1)
        cd $i
        if [[ -f nuclei-$domain.txt ]]
        then
            cat nuclei-$domain.txt | grep "$1" 
        fi
        cd ..
    done
}

function httpx-execute {
    domain=$1
    cd $i
    if [[ -f httpx-$domain.txt ]]
    then
            echo "Httpx was executed for $domain skipping"
    else
            echo $domain
            docker run -it --rm -v"$(pwd):/data" httpx $domain &>debug-main.txt
    fi
    cd ..
}

function nuclei-execute {
    domain=$1
    cd $i
    if [[ -f debug-nuclei-$domain.txt ]]
    then
            echo "Nuclei was executed for $domain skipping."
    else
            echo $domain
            docker run -it --rm -v "$(pwd):/data" nuclei $domain /data/domains.txt &>debug-main.txt
    fi
    cd ..
}

function convert-httpx {
    domain=$1
    cd $i
    if [[ -f httpx-$domain.txt ]]
    then
        cat httpx-*.txt | cut -d " " -f1 > domains.txt 
       
    fi
    cd ..
}

function clean-data {
    cd $BASE_DIR/$folder_name/$1
    rm -rf aiodns-*.txt
    rm -rf amass-*.txt
    rm -rf count.txt
    rm -rf subfinder-*.txt
    rm -rf tmp.txt
    rm -rf debug.txt
    rm -rf debug-main.txt
    cd ..
}

function main {
    mkdir $BASE_DIR/$folder_name
    cd $BASE_DIR/$folder_name
    if [[ -f ../domains.txt ]]
    then
        for i in $(cat ../domains.txt)
        do 
            docker run -it -v "$(pwd):/data" --rm subs $i &>debug-main.txt
            httpx-execute $i
            convert-httpx $i
            clean-data $i
            nuclei-execute $i
        done 
    else
            echo "Domains file does not exist."
    fi
    cd ..
}



{ time main ; } 2> time.txt
t=$(cat time.txt | grep real | cut -d " " -f2)

# number_domains=$(cat $inputfile | wc -l)
# notify "Nuclei for $DOMAIN with $number_domains subdomains in $t"