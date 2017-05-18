# restore-config

Two scripts that help to configure headless devices over network. Especially useful when configuration might break the connection.


### restore-config script

This is the main script. Purpose is to call it from startup script (e.g. /etc/rc.local), to restore safe configuration
to allow to connect to the device (e.g. when messing around with /etc/network/interfaces). Script restores given configuration 
after certain amount of time and reboots. If Your configuration is fine after first reboot You can stop rescue procedure by killing the script.

The procedure:
1. Keep safe configuratin
2. Configre the script to restore the config
3. Make changes
4. Reboot
5a. When works stop the script before timeout
5b. When not working then wait for timeout and second reboot
6. Go to 3.

Features of the script:
- parsing command line arguments,
- logging to file with certain format,
- handling SIGINT and SIGTERM signals,
- forking to separate process (required when calling from /etc/rc.local),
- calling bash command as subprocess


### timed-reboot.sh script

Helper script that reboots device after given certain amount of time. It's useful during e.g. network configuration made by hand.

The procedure:
1. Start the script with desired timeout,
2. Execute risky commands,
3a. When still connected then stop the script before timeout,
3b. When disconnected then wait for reboot.
4. Go to 1.

Script is an example of following procedures (in Bash):
- function definition,
- validating non-negative integer as input parameter,
- detection if script was run by superuser,
- increasing (decreasing) of integer counter.
