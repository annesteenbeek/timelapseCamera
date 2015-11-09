#!/bin/bash
phototime="3" # time between photo's
mountdir="/dev/sda1"
usbdir="/mnt/usb"
path="$usbdir/pics/$(date +\%Y-\%m-\%d)/";
filename="$(date +\%H-\%M).jpeg";

while true
do
if [ ! -b "/dev/sda1" ]; then
        echo "No usb connected"
        if mount|grep $mountdir > /dev/null; then
                echo "unmounting usb"
                sudo umount $mountdir
        fi
else

        if mount|grep $mountdir > /dev/null; then
                mkdir -p $path;
                filename="$(date +\%H-\%M-%S).jpeg";
                if [ -c "/dev/video0" ]; then
                        fswebcam --no-banner -q -d /dev/video0 -r 1280x720 --save "$path$filename" 
                        echo "New photo: $filename"
                else 
                        echo "no camera connected"
                fi
                usep=$(df -hl | grep 'sda1' | awk 'BEGIN{print ""} {percent+=$5;} END{print percent}' | column -t)
                if [ "$usep" -eq "90" ]; then
                 echo "disk is 90% full, cleaning"
                 rm -R $(ls -lt $usbdir/pics | grep '^d' | tail -1  | tr " " "\n" | tail -1)
               fi
        else
                echo "mounting usb"
                sudo mount -t vfat -o uid=pi,gid=pi $mountdir $usbdir
        fi                
fi
sleep $phototime;
done
