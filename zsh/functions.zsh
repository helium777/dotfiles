function update_dotfiles() {
    bash ~/.local/share/dotfiles/bootstrap.sh
}

# glance system status
qs() {
    # --- System Information ---
    local username=$(whoami)
    local os_type=$(uname)
    local os_hostname=$(uname -n)
    local os_kernel=$(uname -r)
    local os_uptime=$(uptime | sed 's/.*up \(.*\),.* user.*/\1/')
    local os_date=$(date '+%Y-%m-%d %H:%M:%S %Z (UTC%z)')

    print "${fg[cyan]}${os_date}${reset_color} ${fg_bold[white]}Up${reset_color} ${fg[cyan]}${os_uptime}${reset_color}"
    print "${fg_bold[white]}${username}${reset_color}@${fg_bold[white]}${os_hostname}${reset_color} (${fg_bold[white]}${os_type} ${os_kernel}${reset_color})"

    if [[ $os_type != "Linux" && $os_type != "Darwin" ]]; then
        print "${fg[yellow]}Unsupported OS${reset_color}"
        return 1
    fi

    # --- CPU ---
    local cores load cpu_usage
    case "$os_type" in
    Darwin)
        cores=$(sysctl -n hw.ncpu)
        load=$(uptime | awk -F'load averages:' '{print $2}' | sed 's/^ *//')
        cpu_usage=$(top -l 2 -n 0 | grep "CPU usage" | tail -1 | awk -F',' '{print $NF}' | awk '{printf "%.1f", 100 - $1}')
        ;;
    Linux)
        cores=$(nproc)
        load=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^ *//')
        if command -v mpstat &>/dev/null; then
            cpu_usage=$(mpstat 1 1 | tail -n 1 | awk '{printf "%.1f", 100 - $NF}')
        else
            # fallback to top
            cpu_usage=$(top -bn2 -d1 | grep "Cpu(s)" | tail -1 | awk -F',' '{print $4}' | awk '{printf "%.1f", 100 - $1}')
        fi
        ;;
    esac

    print "├─ ${fg_bold[magenta]}CPU${reset_color} (${fg[cyan]}${cores}${reset_color} cores)"
    print "│  ${fg_bold[white]}Usage:${reset_color} ${fg[cyan]}${cpu_usage}%${reset_color}    ${fg_bold[white]}Load (1/5/15m):${reset_color} ${fg[cyan]}${load}${reset_color}"
    print "│"

    # --- Memory ---
    local total_mem used_mem mem_perc total_swap used_swap
    case "$os_type" in
    Darwin)
        local total_mem=$(($(sysctl -n hw.memsize) / 1024 / 1024))M
        local used_mem=$(top -l 1 -n 0 | grep "PhysMem" | awk '{print $2}')

        local swap_info=$(sysctl -n vm.swapusage | awk '{print $3, $6}')
        read -r total_swap used_swap <<<"$swap_info"

        print "├─ ${fg_bold[magenta]}Memory${reset_color}"
        print "│  ${fg_bold[white]}RAM:${reset_color}  ${fg[cyan]}${used_mem}${reset_color} / ${total_mem}"

        print "│  ${fg_bold[white]}Swap:${reset_color} ${fg[cyan]}${used_swap}${reset_color} / ${total_swap}"
        print "│"
        ;;
    Linux)
        local mem_info=$(free -b | awk '/Mem:/ {print $2, $3}')
        read -r total_mem used_mem <<<"$mem_info"
        local mem_perc=$((100 * used_mem / total_mem))

        local swap_info=$(free -b | awk '/Swap:/ {print $2, $3}')
        read -r total_swap used_swap <<<"$swap_info"
        local swap_perc=$((100 * used_swap / total_swap))

        local total_mem=$(numfmt --to=iec $total_mem)
        local used_mem=$(numfmt --to=iec $used_mem)
        local total_swap=$(numfmt --to=iec $total_swap)
        local used_swap=$(numfmt --to=iec $used_swap)

        print "├─ ${fg_bold[magenta]}Memory${reset_color}"
        print "│  ${fg_bold[white]}RAM:${reset_color}  ${fg[cyan]}${used_mem}${reset_color} / ${total_mem} (${fg[cyan]}${mem_perc}%${reset_color} used)"

        print "│  ${fg_bold[white]}Swap:${reset_color} ${fg[cyan]}${used_swap}${reset_color} / ${total_swap} (${fg[cyan]}${swap_perc}%${reset_color} used)"
        print "│"
        ;;
    esac

    # --- Disk I/O ---
    print "╰─ ${fg_bold[magenta]}Disk I/O${reset_color}"

    if command -v iostat &>/dev/null; then
        case "$os_type" in
        Darwin)
            local -a iostat_output=("${(@f)$(iostat -d 1 2)}")

            local -a disk_names=(${(s: :)${iostat_output[1]}})
            local -a data_fields=(${(s: :)${iostat_output[-1]}})

            printf "   ${fg_bold[white]}%-8s %8s %8s %8s${reset_color}\n" "Device" "KB/t" "tps" "MB/s"

            local col=1
            for i in {1..$#disk_names}; do
                local disk_name=${disk_names[$i]}
                local kbt=${data_fields[(($i - 1) * 3 + 1)]}
                local tps=${data_fields[(($i - 1) * 3 + 2)]}
                local mbs=${data_fields[(($i - 1) * 3 + 3)]}

                printf "   %-8s ${fg[cyan]}%8.1f${reset_color} ${fg[cyan]}%8.1f${reset_color} ${fg[cyan]}%8.1f${reset_color}\n" "$disk_name" "$kbt" "$tps" "$mbs"
            done
            ;;
        Linux)
            local io_data=$(iostat -d 1 2 | awk '
                /^Device/ { P++ }
                P == 2 && !/^Device/ && NF > 1 {
                    print $1, $2, $3, $4
                }
            ')

            printf "   ${fg_bold[white]}%-8s %8s %10s %10s${reset_color}\n" "Device" "tps" "R (KB/s)" "W (KB/s)"

            local device tps rs ws
            while read -r device tps rs ws; do
                printf "   %-8s ${fg[cyan]}%8.1f${reset_color} ${fg[cyan]}%10.1f${reset_color} ${fg[cyan]}%10.1f${reset_color}\n" "$device" "$tps" "$rs" "$ws"
            done <<<"$io_data"
            ;;
        esac
    else
        print "   ${fg[yellow]}iostat not available${reset_color}"
    fi
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
    Darwin)
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

    print "$fg_bold[green]Public IP addresses:$reset_color"
    qip

    print

    print "$fg_bold[green]DNS servers:$reset_color"
    cat /etc/resolv.conf | grep nameserver | awk '{print $2}'
}
