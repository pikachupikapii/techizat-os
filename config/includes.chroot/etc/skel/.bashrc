# ============================================
# NyxOS - .bashrc
# Strix Terminal Baykuş Sistemi
# ============================================

case $- in
    *i*) ;;
      *) return;;
esac

# Geçmiş ayarları
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# Renkler
AMBER='\[\033[38;2;255;191;0m\]'
PURPLE='\[\033[38;2;75;0;130m\]'
CYAN='\[\033[38;2;64;224;208m\]'
SAGE='\[\033[38;2;188;184;138m\]'
RESET='\[\033[0m\]'

# ============================================
# TEHLİKELİ KOMUTLAR LİSTESİ
# ============================================

__strix_dangerous_cmds=(
    "rm -rf /"
    "rm -rf /*"
    "dd if=/dev/zero"
    "mkfs"
    ":(){:|:&};:"
    "chmod -R 777 /"
    "mv /* /dev/null"
    "wget.*|.*sh"
    "curl.*|.*sh"
)

__strix_is_dangerous() {
    local cmd="$1"
    for dangerous in "${__strix_dangerous_cmds[@]}"; do
        if echo "$cmd" | grep -qE "$dangerous"; then
            return 0
        fi
    done
    return 1
}

# ============================================
# STRIX - YÜZ İFADESİ FONKSİYONU
# Her komuttan sonra çağrılır
# ============================================

__strix_face() {
    local exit_code=$?
    local face=""

    # Root kontrolü
    if [ "$EUID" -eq 0 ]; then
        face="🤓🦉"   # Zeki/Gözlüklü — root modu
    elif [ $exit_code -eq 0 ]; then
        face="😊🦉"   # Mutlu — başarılı komut
    else
        face="😲🦉"   # Şaşkın — hatalı komut
    fi

    echo "$face"
}

# ============================================
# STRIX - UZUN BEKLEME ALGILAMA
# Komut 5 saniyeden uzun sürerse uykulu yüz
# ============================================

__strix_timer_start() {
    __strix_timer_start_time=${__strix_timer_start_time:-$SECONDS}
}

__strix_timer_stop() {
    local elapsed=$(( SECONDS - ${__strix_timer_start_time:-$SECONDS} ))
    unset __strix_timer_start_time
    if [ $elapsed -ge 5 ]; then
        __strix_long_cmd=1
    else
        __strix_long_cmd=0
    fi
}

trap '__strix_timer_start' DEBUG

# ============================================
# STRIX - TEHLİKELİ KOMUT KONTROLÜ
# Komut çalışmadan önce kontrol eder
# ============================================

__strix_precheck() {
    local cmd=$(history 1 | sed 's/^[ ]*[0-9]*[ ]*//')

    if __strix_is_dangerous "$cmd"; then
        echo ""
        echo -e "\033[38;2;255;191;0m😲🦉 Strix: DUR! Bu komut tehlikeli!\033[0m"
        echo -e "\033[38;2;255;0;0m    ⚠ $cmd\033[0m"
        echo -e "\033[38;2;64;224;208m    Devam etmek istediğine emin misin? (e/H)\033[0m"
        read -r confirm
        if [[ ! "$confirm" =~ ^[Ee]$ ]]; then
            echo -e "\033[38;2;188;184;138m😊🦉 Strix: İyi karar! Komut iptal edildi.\033[0m"
            return 1
        fi
        echo -e "\033[38;2;255;0;0m🤓🦉 Strix: Tamam, senin sorumluluğun!\033[0m"
    fi
}

trap '__strix_precheck' DEBUG

# ============================================
# STRIX - PROMPT (GÜNCELLENDİ)
# ============================================

__strix_prompt() {
    local exit_code=$?
    __strix_timer_stop

    local face=""

    if [ $__strix_long_cmd -eq 1 ]; then
        face="😴🦉"   # Uykulu — uzun bekleme
    elif [ "$EUID" -eq 0 ]; then
        face="🤓🦉"   # Zeki — root
    elif [ $exit_code -eq 0 ]; then
        face="😊🦉"   # Mutlu — başarılı
    elif [ $exit_code -eq 126 ] || [ $exit_code -eq 127 ]; then
        face="😠🔍🦉"  # Kızgın+Şüpheci — yanlış/bulunamayan komut
    else
        face="😠🔍🦉"  # Kızgın+Şüpheci — genel hata
    fi

    if [ "$EUID" -eq 0 ]; then
        USER_COLOR='\[\033[38;2;255;0;0m\]'
        PROMPT_CHAR='#'
    else
        USER_COLOR=$AMBER
        PROMPT_CHAR='$'
    fi

    PS1="${face} ${PURPLE}┌──(${USER_COLOR}\u${PURPLE}@${CYAN}NyxOS${PURPLE})-[${SAGE}\w${PURPLE}]\n${PURPLE}└─${USER_COLOR}${PROMPT_CHAR} ${RESET}"
}
    
# ============================================
# STRIX - HOŞ GELDİN MESAJI
# Terminal açılışında gösterilir
# ============================================

__strix_welcome() {
    echo ""
    echo -e "\033[38;2;255;191;0m    (^ᴗ^)🦉  Merhaba! Ben Strix.\033[0m"
    echo -e "\033[38;2;75;0;130m    NyxOS'a hoş geldin.\033[0m"
    echo -e "\033[38;2;64;224;208m    ─────────────────────────────\033[0m"
    echo ""

    # Neofetch sistem bilgisi
    neofetch 2>/dev/null || true
}

__strix_welcome

# ============================================
# KISAYOLLAR
# ============================================

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias cls='clear && __strix_welcome'
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias myip='curl ifconfig.me'
alias localip='hostname -I'
alias ports='netstat -tulanp'
alias msf='msfconsole'
alias proxychains='proxychains4'

# ============================================
# STRIX - ROOT GEÇİŞ UYARISI
# sudo su yapılınca uyarı ver
# ============================================

sudo() {
    if [ "$1" = "su" ] || [ "$1" = "-i" ] || [ "$1" = "-s" ]; then
        echo -e "\033[38;2;255;191;0m🤓🦉 Strix: Root moduna geçiyorsun! Dikkatli ol.\033[0m"
    fi
    command sudo "$@"
}