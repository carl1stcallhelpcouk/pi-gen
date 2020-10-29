alias sudo="sudo "
#alias ll="LANG=C ls -FAlh"
alias ll="LANG=C ls -FAlht | ~/bin/colourise.sh"
alias auu="sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y"
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias gh='history|grep'
alias cpv='rsync -ah --info=progress2'