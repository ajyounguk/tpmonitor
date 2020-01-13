# tpmonitor

Want to switch power on and off based on whether a network PC/device is on/off? 

This is a shell script which will instruct a tplink hs100 smart plug to turn on and off, based on whether a device is available on the network. It will monitor an IP address, and send out a command to tp-link HS100 smart plug accordingly.

This was adapted from the work George Georgovassilis https://blog.georgovassilis.com/2016/05/07/controlling-the-tp-link-hs100-wi-fi-smart-plug/ and Thomas Baust on understanding the plug commands and decrypting the output.
 
There is also a related npm package here https://www.npmjs.com/package/tplink-smarthome-crypto?activeTab=readme

There are some pointers in the script comments on how to schedule this script to run on a Windows 10 device with the bash developer extensions and the Windows Task Scheduler

Also see https://docs.microsoft.com/en-us/windows/wsl/install-win10 for details on how to install the Linux subsystem on Windows 10
