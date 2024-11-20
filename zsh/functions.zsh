function update_dotfiles() {
    bash ~/.local/dotfiles/bootstrap.sh
}

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
    case $(uname) in
        Darwin|*BSD)
            local OS_TYPE="macos"
            local OS_INFO="$(sw_vers -productName) $(sw_vers -productVersion) $(uname -m)"
            local MEM_USAGE=$(top -l 1 -n 0 | grep PhysMem | cut -d' ' -f2- | tr -d '.')
            local CPU_USAGE=$(top -l 1 -n 0 | grep 'CPU usage' | cut -d' ' -f3-)
            local CPU_CORES=$(sysctl -n hw.ncpu)
            local SWAP_USAGE=$(sysctl -n vm.swapusage | awk '{print $6 " / " $3}')
        ;;
        Linux)
            local OS_TYPE="linux"
            local OS_INFO="$(cat /etc/os-release | awk -F= '/PRETTY_NAME/ {print $2}' | tr -d '"') $(uname -m)"
            local MEM_USAGE=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
            local CPU_USAGE=$(top -bn1 | grep 'Cpu(s)' | cut -d' ' -f2-)
            local CPU_CORES=$(nproc)
            local SWAP_USAGE=$(free -h | awk '/Swap:/ {print $3 " / " $2}')
        ;;
        *)
            print "Unknown OS"
            return 1
        ;;
    esac

    print "$fg_bold[green]OS:$reset_color $OS_INFO"
    print "$fg_bold[green]Kernel:$reset_color $(uname -s) $(uname -r)"
    print "$fg_bold[green]Hostname:$reset_color $(hostname)"
    print "$fg_bold[green]Uptime:$reset_color $(uptime | sed 's/.*up \(.*\),.* user.*/\1/')"
    print "$fg_bold[green]CPU:$reset_color $CPU_USAGE"
    print "$fg_bold[green]Load ($CPU_CORES cores):$reset_color $(uptime | awk -F'averages: ' '{print $2}')"
    print "$fg_bold[green]Memory:$reset_color $MEM_USAGE"
    print "$fg_bold[green]Swap:$reset_color $SWAP_USAGE"
    print "$fg_bold[green]Date:$reset_color $(date '+%Y-%m-%d %H:%M:%S %Z (UTC%z)')"
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

    echo "$ip" | sort
}

# get network info
function qnet() {
    print "$fg_bold[green]Local IP addresses:$reset_color"
    qlocalip

    print

    print "$fg_bold[green]Public IP address:$reset_color"
    qip

    print

    print "$fg_bold[green]DNS servers:$reset_color"
    cat /etc/resolv.conf | grep nameserver | awk '{print $2}'
}
