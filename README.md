# tpmonitor

A shell script which will turn a tplink hs100 smart plug on and off, based on the status of a machine on the network

My use case was to power on a number of dependent devices, based on whether my main PC was on or not. This script will monitor an IP address on the network, and turn a tplink HS100 smart plug on or off accordingly.

This was adapted from the work George Georgovassilis https://blog.georgovassilis.com/2016/05/07/controlling-the-tp-link-hs100-wi-fi-smart-plug/ and Thomas Baust on understanding the plug commands and decrypting the output.

There is also a related npm package here https://www.npmjs.com/package/tplink-smarthome-crypto?activeTab=readme


