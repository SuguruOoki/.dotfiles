#!/usr/local/bin/bash

set -ue

declare -A method_count
declare -A total_complexity

:> /tmp/cc.tmp
find "$(pwd)" -type f -name '*.php' | while read file_name ; do
    phpmd "${file_name}" text ~/bin/check_cc.xml | tr '\t' ' ' | cut -d' ' -f1,4,10 | sed 's/[\\(\\)\.]//g' | while read result ; do
        if [[ "${result}" = '' ]] ; then
            continue
        fi

        linum="$(echo "${result}" | cut -d' ' -f1 | cut -d':' -f2)"
        method_name="$(echo "${result}" | cut -d' ' -f2)"
        complexity="$(echo "${result}" | cut -d' ' -f3)"
        author="$(git blame ${file_name} -L${linum},+1 | head -n1 | sed 's/.*(\(.* \)201.*/\1/g' | cut -d' ' -f1,2)"

        echo "${complexity} ${file_name} ${method_name} ${author}" >> /tmp/cc.tmp
    done
done

while read line ; do
    complexity="$(echo "${line}" | sed 's/  */ /g' | cut -d' ' -f1)"
    author="$(echo "${line}" | sed 's/  */ /g' | cut -d' ' -f4- | tr ' ' '.')"

    if [ ! ${method_count["${author}"]+'abc'} ] ; then
        method_count["${author}"]=0
        total_complexity["${author}"]=0
    fi

    method_count["${author}"]=$((${method_count["${author}"]} + 1))
    total_complexity["${author}"]=$((${total_complexity["${author}"]} + $complexity))
done < <(cat /tmp/cc.tmp)

for author in ${!total_complexity[@]}; do
    avg=$(echo "scale=2; ${total_complexity[${author}]} / ${method_count[${author}]}" | bc)
    echo -e "\e[33m${author}\e[m ${avg} (${method_count[${author}]} methods)"
    grep -r "${author}" /tmp/cc.tmp | sort -nr | head -n5 | while read worst5 ; do
        worst5="$(echo $worst5 | cut -d: -f2)"
        tmp=($worst5)
        echo -e "    \e[40m${tmp[0]} ${tmp[2]}@${tmp[1]}\e[m"
    done
done

rm -f /tmp/cc.tmp
