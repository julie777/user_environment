#!/bin/bash

echo "Loading color definitions"
. ${USER_ENV_DIR}/bash/colordefinitions

host="$(hostname)"

success_color="${BGreen}"
fail_color="${BRed}"

venv_color="${Yellow}"
path_color="${BCyan}"
branch_color="${BGreen}"
userhost_color="${BBlue}"
load_color="${BPurple}"
mem_color="${BPurple}"


widths()
{
    echo "screen lines $screen_lines cols $screen_cols"
    echo "ret $ret_width venv $venv_width path $path_width branch $branch_width"
    echo "user $userhost_width load $load_width mem $mem_width"
}


update_screen_size()
{
    local prev_screen_lines=$screen_lines
    screen_lines="$(tput lines)"
    if [ "${prev_screen_lines}" != "${screen_lines}" ]
    then
        prev_status_line=${status_line}
        status_line=${screen_lines}
        ((scroll_lines = status_line-1))
echo "hreer ${prev_status_line} -lt ${status_line}"
        #if [ "${prev_status_line}" -lt "${status_line}" ]
        if [[ -n "${prev_status_line}" && "${prev_status_line}" -lt "${status_line}" ]]
        then  # larger
            # make sure we aren't on the last line which get the cursor stuck on the status line
            ((n = "${status_line}" + 5 - "${prev_status_line}"))
            echo -en "$(tput ed)"  # clear to end of screen
            echo -en "${save_cursor}"
            echo -en "\e[${prev_status_line};1H"
            echo -en "${clear_to_eol}"
            echo -en "${restore_cursor}"
            echo -en "$(tput indn 1)"
            echo -en "${save_cursor}"
            #echo -en "$(tput cuu 1)"
            # set scrolling region of screen
            echo -en "\e[1;${scroll_lines}r"
            echo -en "${restore_cursor}"
            ((n = ${n} + 1))
            echo -en "$(tput cuu 2)"
            #echo -en "${clear_to_eol}"
            echo -en "$(tput ed)"  # clear to end of screen
        else
            # set scrolling region of screen
            echo -en "\e[1;${scroll_lines}r"
            echo -en "\e[${scroll_lines};1H"
            echo -en "${clear_to_eol}"
            echo -en "$(tput cuu 1)"
            echo -en "${clear_to_eol}"
        fi
    fi
    screen_cols="$(tput cols)"
}


# parameters: result message, col_width, _color, brackets, truncate
# the formatted_ message will be returned in result
# all but string can be empty
# truncate 'l' will truncate from the left. Otherwise truncation is from the end
format()
{
    local -n result=$1
    local s=$2
    local col_width=$3
    local color=$4
    local brackets=$5
    local truncate=$6
    local width=${col_width}

    if [ -z "${s}" ]
    then
        # pad to fill the column
        result="" #"$(tput cuf ${colwidth})"
        local pad
        ((pad = ${col_width} - ${#result}))
        result="${result}$(tput cuf ${pad})"
        return
    fi

    # make room for space between columns
    if [ "${truncate}" != "no_trailing_space" ]
    then
        ((width = ${col_width} - 1))
    else
        truncate=
    fi

    if [ "${#brackets}" = "2" ]
    then
        local lb=${brackets::1}
        local rb=${brackets:1:2}
        # make room for the brackets
        ((width = ${width} - 2))
    else
        brackets=''
    fi
    if [ "$width" -lt 4 ]
    then
        # not enough room to manipulate it
        result=""
        local pad
        ((pad = ${col_width} - ${#result}))
        result="${result}$(tput cuf ${pad})"
        return
    fi

    local slen=${#s}
    if [ "${slen}" -gt "${width}" ]
    then
        local newlen
        ((newlen = ${width} - 3))  # make room for ...
        if [ "${truncate}" = "l" ]
        then
            local cutlen
            ((cutlen = ${slen} - ${newlen}))
            s="...${s:${cutlen}:${slen}}"
        else
            #s="${s::${newlen}}..."
            s="${s::${width}}"
        fi
    fi

    # add brackets
    if [ -n "${s}" ]
    then
        s="${lb}${s}${rb}"
    fi

    # pad to fill the column
    slen=${#s}
    if [ "${slen}" -lt "${col_width}" ]
    then
        local pad
        ((pad = ${col_width} - ${slen}))
        s="${s}$(tput cuf ${pad})"
    fi

    # there has to be a string or adding color is bad
    if [ "${slen}" -gt "0" ]
    then
        s="${color}${s}"
    fi
    result="${s}"
}


update_userhost()
{
    local userhost="${USER}@${host}"
    userhost_width=${#userhost}
    format formatted_userhost "${userhost}" "${userhost_width}" "${userhost_color}" "" "no_trailing_space"
}

update_branch()
{
    local branch=$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
    format formatted_branch "${branch}" "${branch_width}" "${branch_color}" "{}"
}


update_venv()
{
    if [ -n "${VIRTUAL_ENV}" ]
    then
        local venv=$(basename "${VIRTUAL_ENV}")
        if [ "${venv}" = "pyenv" ]
        then
            local c=$(dirname "${VIRTUAL_ENV}")
            venv=$(basename "${c}")
        fi
    fi
    format formatted_venv "${venv}" "${venv_width}" "${venv_color}" "()"
}


update_path()
{
    local path="$(pwd)"
    path="${path//\//;}"
    local home="${HOME//\//;}"
    path="${path/#${home}/\~}"
    path="${path//;/\/}"
    format formatted_path "${path}" "${path_width}" "${path_color}" "" "l"
}


update_ret()
{
    local ret=$? # Must come first!
    ret_width=6
    local color
    if [ "$ret" = "0" ]
    then
        color="${success_color}"
        ret=";)"
    else
        color="${fail_color}"
        ret="${ret};("
    fi
    format formatted_ret "${ret}" "${ret_width}" "${color}"
}


update_mem()
{
    local mem="$(( `sed -n "s/MemFree:[\t ]\+\([0-9]\+\) kB/\1/p" /proc/meminfo`/1024))MB"
    ((mem_width = ${#mem} + 1))
    format formatted_mem "${mem}" "${mem_width}" "${mem_color}"
}


update_load()
{
    get_first() { echo $1; }
    local load=$(get_first $(</proc/loadavg))
    ((load_width = ${#load} + 1))
    format formatted_load "${load}" "${load_width}" "${load_color}"
}


set_prompt()
{
    # Must come first!
    update_ret
    update_screen_size
    update_load
    update_mem
    update_userhost
    if [ ${screen_cols} -lt 90 ]
    then
        formatted_mem=
        mem_width=0
        formatted_load=
        load_width=0
    fi
    if [ ${screen_cols} -lt 60 ]
    then
        formatted_userhost=
        userhost_width=0
        ret_width=0
        formatted_ret=
    fi

    ((cols = ${screen_cols} - ${ret_width} - ${load_width} - ${mem_width} - ${userhost_width}))

    if [ ${screen_cols} -lt 40 ]
    then
        branch_width=0
        formatted_branch=
        venv_percent=35
    else
        ((branch_width = ${cols} * 25 / 100))
        venv_percent=25
        update_branch
    fi

    ((venv_width = ${cols} * venv_percent / 100))
    ((path_width = ${cols} - ${venv_width} - ${branch_width}))

    update_venv
    update_path
    if [ ${EUID} == 0 ]
    then
        # sudo prompt
        PS1="${Red}\w # ${Reset}"
    else
#        PS1+="\n"
        PS1="${count_off}"
        PS1+="${save_cursor}"
        PS1+="${move_to_status_line}"
        PS1+="${BG}"
        PS1+="${clear_to_eol}"
        PS1+="${formatted_ret}"
        PS1+="${formatted_venv}"
        PS1+="${formatted_path}"
        PS1+="${formatted_branch}"
        PS1+="${formatted_load}"
        PS1+="${formatted_mem}"
        PS1+="${formatted_userhost}"
        PS1+="${Reset}"
        PS1+="${restore_cursor}"
        PS1+="${count_on}"
        PS1+="\$ "
    fi

}
PROMPT_COMMAND=set_prompt

