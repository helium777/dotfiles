# easy extract
function qextract() {
    if [ ! -f $1 ]; then
        echo "'$1' is not a file"
        return 1
    fi

    case $1 in
        *.tar.bz2)   tar xjf $1    ;;
        *.tar.gz)    tar xzf $1    ;;
        *.tar.xz)    tar xJf $1    ;;
        *.bz2)       bunzip2 $1    ;;
        *.rar)       unrar x $1    ;;
        *.gz)        gunzip $1     ;;
        *.tar)       tar xf $1     ;;
        *.tbz2)      tar xjf $1    ;;
        *.tgz)       tar xzf $1    ;;
        *.zip)       unzip $1      ;;
        *.7z)        7z x $1       ;;
        *)           echo "don't know how to extract '$1'..." ;;
    esac
}

# easy compress
function qcompress() {
    local FILE=$1
    if [ -z $FILE ]; then
        echo "Usage: qcompress <file> [files...]"
        return 1
    fi

    case $FILE in
        *.tar.bz2)   tar cjf $FILE ${@:2} ;;
        *.tar.gz)    tar czf $FILE ${@:2} ;;
        *.tar.xz)    tar cJf $FILE ${@:2} ;;
        *.bz2)       bzip2 $FILE ${@:2}   ;;
        *.rar)       rar a $FILE ${@:2}   ;;
        *.gz)        gzip $FILE ${@:2}    ;;
        *.tar)       tar cf $FILE ${@:2}  ;;
        *.tbz2)      tar cjf $FILE ${@:2} ;;
        *.tgz)       tar czf $FILE ${@:2} ;;
        *.zip)       zip $FILE ${@:2}     ;;
        *.7z)        7z a $FILE ${@:2}    ;;
        *)           echo "don't know how to compress '$FILE'..." ;;
    esac
}

# get current host related info
function qinfo() {
    local RED="\033[1;31m"
    local YELLOW="\033[1;33m"
    local NC="\033[0m"

    printf "You are logged on ${YELLOW}$HOST${NC}\n"
    printf "${RED}Additionnal information:$NC\n"
    uname -a
    printf "${RED}Users logged on:$NC\n"
    w -h
    printf "${RED}Current date:$NC\n"
    date
    printf "${RED}Machine stats:$NC\n"
    uptime
    printf "${RED}Public IP Address:$NC\n"
    qip
}

# get public IP address
function qip() {
    local ipv4=$(curl -4 ifconfig.co 2>/dev/null)
    local ipv6=$(curl -6 ifconfig.co 2>/dev/null)
    if [ -z $ipv4 ]; then
        ipv4="No IPv4 address"
    fi
    if [ -z $ipv6 ]; then
        ipv6="No IPv6 address"
    fi

    echo "$ipv4"
    echo "$ipv6"
}

# get all local IP addresses
function qlocalip() {
    case $(uname) in
        Darwin|*BSD)
            local ip=$(ifconfig | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{print $2}')
            ;;
        Linux)
            local ip=$(hostname -I | tr " " "\n" | grep -v '0.0.0.0' | grep -v '127.0.0.1')
            ;;
        *)
            local ip="?Unknown OS"
            ;;
    esac

    echo "$ip"
}

# change cuda visible devices
function c() {
    export CUDA_VISIBLE_DEVICES=$1
}
