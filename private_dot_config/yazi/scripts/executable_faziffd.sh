#!/usr/bin/env sh

# Find files/directories in current directy (max-depth) with fd and fzf
# https://github.com/Shallow-Seek/fazif.yazi/blob/main/faziffd

fd . --max-depth 1 -H "$@" |fzf \
--info=inline \
--multi \
--layout=reverse \
--prompt='ctl-wetcrfp_CWD> ' \
--bind 'ctrl-w:transform:echo "change-prompt(ctl-wetcrfp_Home_File> )+reload(fd . ~ --hidden --type f)"' \
--bind 'ctrl-e:transform:echo "change-prompt(ctl-wetcrfp_Home_Dir> )+reload(fd . ~ --hidden --type d)"' \
--bind 'alt-c:transform:echo "change-prompt(ctl-wetcrfp_CWD_Dir> )+reload(fd  --hidden --type d)"' \
--bind 'ctrl-t:transform:echo "change-prompt(ctl-wetcrfp_CWD_File> )+reload(fd  --hidden --type f)"' \
--bind 'ctrl-f:transform:echo "change-prompt(ctl-wetcrfp_root_Dir> )+reload(fd . / --hidden --type d)"' \
--bind 'ctrl-r:transform:echo "change-prompt(ctl-wetcrfp_Root_File> )+reload(fd . / --hidden --type f)"' \
--bind 'focus:transform-preview-label:echo {}' \
--bind 'ctrl-p:change-preview-window(right|down|hidden)' \
--bind 'focus:transform-preview-label:echo {}' \
--bind 'ctrl-x:execute-silent(setsid kitty nnn {} &)' \
--bind 'ctrl-a:execute-silent(setsid kitty yazi {} &)' \
--bind 'ctrl-s:execute-silent(setsid thunar {} &)' \
--preview-window 'hidden' \
--preview '
    printf "\033_Ga=d,q=1\033\\"
    [ -d {} ] && eza -aTL 2 --group-directories-first --color=always --icons=always {} ||
    tmp="/tmp/fzf_preview"
    case $(basename {}) in
        *.pdf)
            pdftoppm -q -f 1 -l 1 -jpeg -jpegopt quality=60 -scale-to-x 1000 -scale-to-y -1 -singlefile {} $tmp && \
            kitty icat --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 $tmp.jpg
            ;;
        *.doc|*.docx|*.xls|*.xlsx|*.ppt|*.pptx|*.odt|*.ods|*.odp)
            libreoffice --convert-to jpg --outdir /tmp {} >/dev/null 2>&1
            mv /tmp/${$(basename {})%.*}.jpg $tmp
            kitty icat --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 $tmp
            ;;
        *.djvu)
            ddjvu -format=ppm -page=1 -size 1000x-1 -aspect=yes {} $tmp 2>/dev/null && \
            kitty icat --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 $tmp
            ;;
        *)
            if file --mime-type {} | grep -qP "image/(?!vnd\.djvu)"; then
                kitty icat --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}
            else
                bat -p {} --color=always 2>/dev/null
            fi
            ;;
    esac
'
