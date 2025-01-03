# appImage-script

### Makes binary.appImage from a binary to run in any Linux. 
#### Note: Only on Linux x64 

#### ./appimage.sh -ARCH=x86_64 -APP=myapp -ICON=/path/to/myicon.png -QTROOT=/home/marius/Qt
####  resulting binary:                  /tmp/myapp/myapp.AppImage

```
./appimage.sh -FLAG=OPTION, where OPTION's are:
         -ARCH=x86_64 / arm
         -APP=application_binary
         -ICON=icon_file.png
         -QTROOT=path to Qt, aka: /home/marius/Qt, optional
         -LIBS=path to extra libs, optional / not implemented yet

```

### example
  * You can build the clipboard grabber application icon from the subfolder using QTCreator or qmaking the pro file
  * copy the build/Release/clip_hist2 binary to same folder where the script is located

```
  ./appimage.sh -ARCH=x86_64 -APP=./clip_hist2 -QTROOT=/home/marius/Qt -ICON=/usr/share/hplip/data/images/16x16/quit.png

```
  * The Application package will be deployed as:

```
marius@zbook:/tmp/clip_hist2$ ll
total 3308
drwxrwxr-x  3 marius marius    4096 Jan  3 15:28 ./
drwxrwxrwt 27 root   root     45056 Jan  3 15:53 ../
drwxrwxr-x  6 marius marius    4096 Jan  3 15:28 AppDir/
-rwxr-xr-x  1 marius marius 3326704 Jan  3 15:28 clip_hist2.AppImage*
```
   * Run it:

```
arius@zbook:/tmp/clip_hist2$ ./clip_hist2.AppImage 
qt.core.qmetaobject.connectslotsbyname: QMetaObject::connectSlotsByName: No matching signal for on_listWidget_2_itemDoubleClicked(QListWidgetItem*)
qt.core.qmetaobject.connectslotsbyname: QMetaObject::connectSlotsByName: No matching signal for on_listWidget_3_itemDoubleClicked(QListWidgetItem*)
qt.core.qmetaobject.connectslotsbyname: QMetaObject::connectSlotsByName: No matching signal for on_listWidget_4_itemDoubleClicked(QListWidgetItem*)

```
    * The clipboard grabber is shown on the taksbar
      * The utility allows you to capture clipboard text then retrive it later from the list box.


![image](https://github.com/user-attachments/assets/de12aaea-06a1-4d59-af5e-e452ddd59c0c)

    

