# Source-able shell utilities for bootstrap script
# E.g.,: source ../util.sh


#### Useful functions ####
function cmd_exists {
  command -v "$1" >/dev/null 2>&1
}



#### Environment variables ####
export os="$(lsb_release -i | cut -f2)"

if [ -f "/sys/class/bluetooth" ]; then
  export feat_bt=1
fi
