## Want to turn your tplink smart plug on and off with your PC? Save on power? T

## this script will ping a network resource (a pc, phone, anything with an IP addresss) and turn on a Kasa Smart Plug
## on and off accordingly 

## Adapted script from https://blog.georgovassilis.com/2016/05/07/controlling-the-tp-link-hs100-wi-fi-smart-plug/

## Notes for scheduling this script from Windows Task Scheduler:
## 
## Works with Windows 10 with the bash shell installed.
## Taks Scheduler options:
##
## general | security options | run whether user is logged on or not
## triggers | at system startup
## actions | start a program | program script = bash | arguments = -c "/AddPathToScrip/tpmonitor.sh 1>/dev/null" 
## settings | if the task fails, restart every 10 minutes


## --------------------------------------------------
## the payloads below are used to control the smart plug

# encoded {"system":{"set_relay_state":{"state":1}}}
payload_on="AAAAKtDygfiL/5r31e+UtsWg1Iv5nPCR6LfEsNGlwOLYo4HyhueT9tTu36Lfog=="

# encoded {"system":{"set_relay_state":{"state":0}}}
payload_off="AAAAKtDygfiL/5r31e+UtsWg1Iv5nPCR6LfEsNGlwOLYo4HyhueT9tTu3qPeow=="

# encoded { "system":{ "get_sysinfo":null } }
payload_query="AAAAI9Dw0qHYq9+61/XPtJS20bTAn+yV5o/hh+jK8J7rh+vLtpbr"


## resource IP = static IP of device to be monitored
resource_ip=192.168.0.20

## plug IP = static IP of tp-link smart plug
plug_ip=192.168.0.80

## looptime = the polling time in seconts between checking the plug and device status
looptime=10

# flags
resource_status=off
plug_status=off


# decode utility for plug output
decode(){
  echo "DECODE"
   code=171
   offset=4
   input_num=`od -j $offset -An -t u1 -v | tr "\n" " "`
   IFS=' ' read -r -a array <<< "$input_num"
   args_for_printf=""
   for element in "${array[@]}"
   do
     output=$(( $element ^ $code ))
     args_for_printf="$args_for_printf\x$(printf %x $output)"
     code=$element
   done
     printf "$args_for_printf"
}

# check if plug is on or off
check_plug_status(){
  output=`echo -n $payload_query | base64 --decode | nc  $plug_ip 9999 | decode | egrep -o 'relay_state":[0,1]' | egrep -o '[0,1]'`
  if [[ $output -eq 1 ]]; then
      plug_status=on
  else
      plug_status=off
  fi
}

# check machine/device is on / pingable
check_resource_status(){
  ping -W 5 -c 1 $resource_ip > /dev/null
  if [[ $? -eq 0 ]]; then
    resource_status=on
  else 
    resource_status=off
  fi
}

plug_on(){
  echo "turn plug on"
  echo -n "$payload_on" | base64 --decode | nc $plug_ip 9999 1>/dev/null  || echo couldn''t connect to $ip:$port, nc failed with exit code $?
}

# turn plug off
plug_off(){
  echo "turn plug off"
  echo -n "$payload_off" | base64 --decode | nc $plug_ip 9999 1>/dev/null || echo couldn''t connect to $ip:$port, nc failed with exit code $?
}


# monitoring logic
monitor(){
    check_resource_status
    check_plug_status

    echo "resource $resource_status"
    echo "plug $plug_status"
    echo "-----"

    if [[ "$resource_status" = "on" && "$plug_status" = "off" ]]; then
      plug_on
    fi

    if [[ "$resource_status" = "off" && "$plug_status" = "on" ]]; then
      plug_off
    fi
}

# main loop
while true
do
  monitor
  sleep $looptime
done
