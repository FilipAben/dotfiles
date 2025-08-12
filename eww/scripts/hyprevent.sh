#!/bin/sh

ALLOWED="$*"

handle() {
  echo $1 | awk -F'>>' -v keys="$ALLOWED" '
  BEGIN {
      split(keys, allowed, " ")
      for (i in allowed) whitelist[allowed[i]] = 1
  }
  whitelist[$1] {
    split($2, arr, ",")
    printf("{\"key\":\"%s\", \"value\":[", $1)
    for (i = 1; i <= length(arr); i++) {
        printf("\"%s\"%s", arr[i], (i < length(arr) ? ", " : ""))
    }
    print "]}"
  }
  '
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
