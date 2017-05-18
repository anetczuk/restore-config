#!/bin/bash

# MIT License
# 
# Copyright (c) 2017 Arkadiusz Netczuk <dev.arnet@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#


##set -e


scriptname=`basename "$0"`


function help_info {
    echo "usage: $scriptname TIME|--help|--k"
    echo "params:"
    echo "       --help - display help info"
    echo "       TIME   - time to wait before reboot [s]"
    echo "       --k    - kill all instances"
}


if [ $# -ne 1 ]; then
    echo -e "invalid number of parameters\n"
    help_info
    exit 1
fi

case "$1" in
    --help) ## help
	    help_info
	    exit 1;;
	    
    --k)    ## kill all
	    killall $scriptname
	    exit;;
	    
    *)      timeout=$1;;
esac
            

##if [[ $((timeout)) != $timeout ]]; then
##if [ "$timeout" -ne "$timeout" ] 2>/dev/null; then
if [[ $timeout == *[!0-9]* ]]; then
    echo -e "invalid time parameter given, positive integer required\n"
    help_info
    exit 2
fi


if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi


echo "Timers pid: $$, use stop by 'sudo kill $$' or 'sudo killall $scriptname'"

echo "Waiting $timeout secs before reboot"


function wait_time {
    step=$1
    while (( $wait_counter >= $step )); do
	##echo "$(( wait_counter-- )) secs to reboot"
	echo -n "$wait_counter "
	sleep $step
	((wait_counter-=$step))
    done
}


wait_counter=$timeout
if (( wait_counter > 0 )); then
    wait_time 5
    wait_time 1
fi


#### old way
##sleep $time
##if [ $? -ne 0 ]; then
##    echo "Unable to wait, exiting"
##    exit 1
##fi


echo "Reboot!"
reboot

