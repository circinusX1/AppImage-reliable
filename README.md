# Very reliable AppImage APP generator
## A script which produces *.AppImage 95% rate of success

### Makes binary.appImage from a binary to run in any Linux. 
#### Note: Only on Linux x64 

#### ./appimage.sh -ARCH=x86_64 -APP=myapp -ICON=/path/to/myicon.png -QTROOT=/home/marius/Qt
####  resulting binary:                  /tmp/myapp/myapp.AppImage

It tries to resolve all dependencies libs locales files and pack them in the App.

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


### mounted appimage
```
marius@zbook:/tmp/clip_hist2$ tree
.
├── AppDir
│   ├── AppRun
│   ├── bin
│   │   ├── bash
│   │   └── clip_hist2
│   ├── clip_hist2.desktop
│   ├── clip_tray.png
│   ├── home
│   │   └── marius
│   │       └── Qt
│   │           └── 6.7.3
│   │               └── gcc_64
│   │                   └── lib
│   │                       ├── libicuuc.so.73
│   │                       ├── libicuuc.so.73.2 -> libicuuc.so.73
│   │                       ├── libQt6Core.so.6
│   │                       ├── libQt6Core.so.6.7.3 -> libQt6Core.so.6
│   │                       ├── libQt6Widgets.so.6
│   │                       └── libQt6Widgets.so.6.7.3 -> libQt6Widgets.so.6
│   ├── lib
│   │   ├── ld-linux-x86-64.so.2 -> x86_64-linux-gnu/ld-linux-x86-64.so.2
│   │   ├── libbrotlicommon.so.1 -> x86_64-linux-gnu/libbrotlicommon.so.1
│   │   ├── libbrotlidec.so.1 -> x86_64-linux-gnu/libbrotlidec.so.1
│   │   ├── libcap.so.2 -> x86_64-linux-gnu/libcap.so.2
│   │   ├── libc.so.6 -> x86_64-linux-gnu/libc.so.6
│   │   ├── libdbus-1.so.3 -> x86_64-linux-gnu/libdbus-1.so.3
│   │   ├── libdl.so.2 -> x86_64-linux-gnu/libdl.so.2
│   │   ├── libEGL.so.1 -> x86_64-linux-gnu/libEGL.so.1
│   │   ├── libexpat.so.1 -> x86_64-linux-gnu/libexpat.so.1
│   │   ├── libgcc_s.so.1 -> x86_64-linux-gnu/libgcc_s.so.1
│   │   ├── libGLdispatch.so.0 -> x86_64-linux-gnu/libGLdispatch.so.0
│   │   ├── libglib-2.0.so.0 -> x86_64-linux-gnu/libglib-2.0.so.0
│   │   ├── libGL.so.1 -> x86_64-linux-gnu/libGL.so.1
│   │   ├── libgthread-2.0.so.0 -> x86_64-linux-gnu/libgthread-2.0.so.0
│   │   ├── libicuuc.so.73 -> x86_64-linux-gnu/libicuuc.so.73
│   │   ├── liblzma.so.5 -> x86_64-linux-gnu/liblzma.so.5
│   │   ├── libmd.so.0 -> x86_64-linux-gnu/libmd.so.0
│   │   ├── libpthread.so.0 -> x86_64-linux-gnu/libpthread.so.0
│   │   ├── libQt6Core.so.6 -> x86_64-linux-gnu/libQt6Core.so.6
│   │   ├── libQt6Widgets.so.6 -> x86_64-linux-gnu/libQt6Widgets.so.6
│   │   ├── libtinfo.so.6 -> x86_64-linux-gnu/libtinfo.so.6
│   │   ├── libX11.so.6 -> x86_64-linux-gnu/libX11.so.6
│   │   ├── libxcb.so.1 -> x86_64-linux-gnu/libxcb.so.1
│   │   ├── libXdmcp.so.6 -> x86_64-linux-gnu/libXdmcp.so.6
│   │   ├── libz.so.1 -> x86_64-linux-gnu/libz.so.1
│   │   ├── libzstd.so.1 -> x86_64-linux-gnu/libzstd.so.1
│   │   └── x86_64-linux-gnu
│   │       ├── ld-linux-x86-64.so.2
│   │       ├── libbrotlicommon.so.1
│   │       ├── libbrotlicommon.so.1.0.9 -> libbrotlicommon.so.1
│   │       ├── libbrotlidec.so.1
│   │       ├── libbrotlidec.so.1.0.9 -> libbrotlidec.so.1
│   │       ├── libcap.so.2
│   │       ├── libcap.so.2.44 -> libcap.so.2
│   │       ├── libc.so.6
│   │       ├── libdbus-1.so.3
│   │       ├── libdbus-1.so.3.19.13 -> libdbus-1.so.3
│   │       ├── libdl.so.2
│   │       ├── libEGL.so.1
│   │       ├── libEGL.so.1.1.0 -> libEGL.so.1
│   │       ├── libexpat.so.1
│   │       ├── libexpat.so.1.8.7 -> libexpat.so.1
│   │       ├── libgcc_s.so.1
│   │       ├── libGLdispatch.so.0
│   │       ├── libGLdispatch.so.0.0.0 -> libGLdispatch.so.0
│   │       ├── libglib-2.0.so.0
│   │       ├── libglib-2.0.so.0.7200.4 -> libglib-2.0.so.0
│   │       ├── libGL.so.1
│   │       ├── libGL.so.1.7.0 -> libGL.so.1
│   │       ├── libgthread-2.0.so.0
│   │       ├── libgthread-2.0.so.0.7200.4 -> libgthread-2.0.so.0
│   │       ├── libicuuc.so.73
│   │       ├── liblzma.so.5
│   │       ├── liblzma.so.5.2.5 -> liblzma.so.5
│   │       ├── libmd.so.0
│   │       ├── libmd.so.0.0.5 -> libmd.so.0
│   │       ├── libpthread.so.0
│   │       ├── libQt6Core.so.6
│   │       ├── libQt6Widgets.so.6
│   │       ├── libtinfo.so.6
│   │       ├── libX11.so.6
│   │       ├── libX11.so.6.4.0 -> libX11.so.6
│   │       ├── libxcb.so.1
│   │       ├── libxcb.so.1.1.0 -> libxcb.so.1
│   │       ├── libXdmcp.so.6
│   │       ├── libXdmcp.so.6.0.0 -> libXdmcp.so.6
│   │       ├── libz.so.1
│   │       ├── libz.so.1.2.11 -> libz.so.1
│   │       ├── libzstd.so.1
│   │       └── libzstd.so.1.4.8 -> libzstd.so.1
│   ├── runtime
│   │   ├── compat
│   │   │   ├── lib
│   │   │   ├── lib64
│   │   │   │   ├── ld-linux-x86-64.so.2 -> ../../../lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
│   │   │   │   ├── libbrotlicommon.so.1 -> ../../../lib/x86_64-linux-gnu/libbrotlicommon.so.1
│   │   │   │   ├── libbrotlidec.so.1 -> ../../../lib/x86_64-linux-gnu/libbrotlidec.so.1
│   │   │   │   ├── libcap.so.2 -> ../../../lib/x86_64-linux-gnu/libcap.so.2
│   │   │   │   ├── libc.so.6 -> ../../../lib/x86_64-linux-gnu/libc.so.6
│   │   │   │   ├── libdbus-1.so.3 -> ../../../lib/x86_64-linux-gnu/libdbus-1.so.3
│   │   │   │   ├── libdl.so.2 -> ../../../lib/x86_64-linux-gnu/libdl.so.2
│   │   │   │   ├── libEGL.so.1 -> ../../../lib/x86_64-linux-gnu/libEGL.so.1
│   │   │   │   ├── libexpat.so.1 -> ../../../lib/x86_64-linux-gnu/libexpat.so.1
│   │   │   │   ├── libgcc_s.so.1 -> ../../../lib/x86_64-linux-gnu/libgcc_s.so.1
│   │   │   │   ├── libGLdispatch.so.0 -> ../../../lib/x86_64-linux-gnu/libGLdispatch.so.0
│   │   │   │   ├── libglib-2.0.so.0 -> ../../../lib/x86_64-linux-gnu/libglib-2.0.so.0
│   │   │   │   ├── libGL.so.1 -> ../../../lib/x86_64-linux-gnu/libGL.so.1
│   │   │   │   ├── libgthread-2.0.so.0 -> ../../../lib/x86_64-linux-gnu/libgthread-2.0.so.0
│   │   │   │   ├── libicuuc.so.73 -> ../../../lib/x86_64-linux-gnu/libicuuc.so.73
│   │   │   │   ├── liblzma.so.5 -> ../../../lib/x86_64-linux-gnu/liblzma.so.5
│   │   │   │   ├── libmd.so.0 -> ../../../lib/x86_64-linux-gnu/libmd.so.0
│   │   │   │   ├── libpthread.so.0 -> ../../../lib/x86_64-linux-gnu/libpthread.so.0
│   │   │   │   ├── libQt6Core.so.6 -> ../../../lib/x86_64-linux-gnu/libQt6Core.so.6
│   │   │   │   ├── libQt6Widgets.so.6 -> ../../../lib/x86_64-linux-gnu/libQt6Widgets.so.6
│   │   │   │   ├── libtinfo.so.6 -> ../../../lib/x86_64-linux-gnu/libtinfo.so.6
│   │   │   │   ├── libX11.so.6 -> ../../../lib/x86_64-linux-gnu/libX11.so.6
│   │   │   │   ├── libxcb.so.1 -> ../../../lib/x86_64-linux-gnu/libxcb.so.1
│   │   │   │   ├── libXdmcp.so.6 -> ../../../lib/x86_64-linux-gnu/libXdmcp.so.6
│   │   │   │   ├── libz.so.1 -> ../../../lib/x86_64-linux-gnu/libz.so.1
│   │   │   │   └── libzstd.so.1 -> ../../../lib/x86_64-linux-gnu/libzstd.so.1
│   │   │   └── usr
│   │   │       └── bin
│   │   │           └── bash -> ../../../../bin/bash
│   │   └── default
│   │       └── lib64
│   └── usr
│       ├── bin
│       ├── lib
│       │   ├── libapprun_hooks.so
│       │   └── x86_64-linux-gnu
│       │       ├── ld-linux-x86-64.so.2
│       │       ├── libc.so.6
│       │       ├── libdl.so.2
│       │       ├── libtinfo.so.6
│       │       └── libtinfo.so.6.3 -> libtinfo.so.6
│       └── share
│           ├── clip_tray.png
│           └── locale
│               └── en
│                   └── LC_MESSAGES
└── clip_hist2.AppImage
```


