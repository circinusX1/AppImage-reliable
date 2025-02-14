#!/bin/bash

USR_BIN=${HOME}/bin
[[ ! -d ${USR_BIN} ]] && echo "Making ${USR_BIN}" && mkdir ${USR_BIN}

IS=$(which appimagetool-x86_64.AppImage)
if [[ -z $IS ]];then
    wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -P ${USR_BIN}
    chmod +x ${USR_BIN}/appimagetool-x86_64.AppImage
    IS=$(which appimagetool-x86_64.AppImage)
    [[ -z $IS ]] && echo "Please add: ${USR_BIN} to ${HOME}/.bashrc as PATH=${PATH}:${USR_BIN} and close this terminal, and rerun this script" && exit 1
else
    echo "appimagetool-x86_64.AppImage found in: ${USR_BIN}"
fi


if [[ 0 ]];then
    if [[ ! -d  AppRun ]] ;then
        echo "We are about to git out https://github.com/AppImageCrafters/AppRun and build it. Press enter to conitnue Ctrl+C to exit"
        read YN
        git clone https://github.com/AppImageCrafters/AppRun
        pushd AppRun
            mkdir build
            pushd build
                cmake ..
                make
            popd
        popd
    fi
    APP_UTIL=$(find -name AppRun | grep build)
    [[ -z ${APP_UTIL} ]] && echo "Cannot find AppRun" && exit 1
    [[ ! -f ./AppRun/build/src/hooks/libapprun_hooks.so ]] && echo "./AppRun/build/src/hooks/libapprun_hooks.so missing" && exit 1
fi

function usage()
{
    echo -e "${0} -FLAG=OPTION, where OPTION's are:\n\
         -ARCH=x86_64 / arm\n\
         -APP=application_binary\n\
         -ICON=icon_file.png\n\
         -QTROOT=path to Qt, aka: /home/${USER}/Qt, optional\n\
         -LIBS=path to extra libs, optional\n\n"
    exit 1
}


LIBS_DIR=""
while [[ $# -gt 0 ]]; do
  case $1 in
    -ARCH=*)
        ARCH="${1#*=}"
        shift
    ;;
   -ICON=*)
        ICON="${1#*=}"
        shift
    ;;
    -QTROOT=*)
        QT_DIR="${1#*=}"
        [[ ${QT_DIR:0:1} != '/' ]] && echo "pass the full path to Qt: QT_DIR=/full/path/to/Qt" && exit 1
        shift
    ;;
    -LIBS=*)
        LIBS_DIR="${LIBS_DIR}:${1#*=}"
        shift
    ;;
    -APP=*)
        APP_BIN="${1#*=}"
        shift
    ;;
    -*|--*)
      echo "Unknown option $1"
      usage
      exit 1
    ;;
  esac
done

[[ -z ${APP_BIN} ]] && echo "-APP=application is missing " && usage
APP_BIN=$(realpath ${APP_BIN})
[[ -z ${ARCH} ]] && echo "-ARCH=arch is missing " && usage
[[ -z ${ICON} ]] && echo "-ICON=icon.png is missing " && usage
[[ ! -f ${APP_BIN} ]] && echo "Application ${APP_BIN} not found" && usage

if [[ ${ARCH} == "x86_64" ]];then
    ARCH="gcc_64"
elif  [[ ${ARCH} == "arm" ]];then
    echo "arm is not supported yet"
    exit 1
else
    echo "-ARCH= should be x86_64 or arm" && usage
fi

# cp $APP_BIN ./
APP=$(basename $APP_BIN)

[[ ! -f $APP ]] && cp $APP_BIN $APP

echo "Preparing /tmp/${APP}"
DEST_APP="/tmp/${APP}"
rm -rf ${DEST_APP}/*


ldd "${APP}" | \
while read x; do
    if [[ $x =~ "=>" ]];then
        D=$(echo $x | awk '{print $3}')
        echo "-Found library ${D}"
    else
        D=$(echo $x | awk '{print $1}')
        echo "-Found library ${D}"
    fi
    if [[ $D =~ "Qt" ]];then
        touch ${DEST_APP}/.qtdir
        break;
    fi
done

echo "Running on QT arhitecture: $ARCH"

if [[ -f ${DEST_APP}/.qtdir ]];then
    rm -rf ${DEST_APP}/.qtdir
    if [[ ! -z $QT_DIR ]];then
        LD=$(find $QT_DIR -name lib |  grep ${ARCH})
        echo "-Found qt lib folder ${LD}";
        QT_LIBS="${LD}"
    else
        echo "Your app has QT libraries. Please add the -QTROOT=path/to/Qt installation folder " && usage
    fi
fi

echo "Creating ${DEST_APP}/AppDir/"

[[ -d ${DEST_APP} ]] && rm -rf ${DEST_APP}
ls -la ${DEST_APP}
mkdir -p ${DEST_APP}/AppDir/runtime/compat/lib64/
mkdir -p ${DEST_APP}/AppDir/runtime/compat/lib/
mkdir -p ${DEST_APP}/AppDir/runtime/compat/usr/bin
mkdir -p ${DEST_APP}/AppDir/runtime/default/lib64/

mkdir -p ${DEST_APP}/AppDir/bin
mkdir -p ${DEST_APP}/AppDir/usr/lib
mkdir -p ${DEST_APP}/AppDir/usr/bin
mkdir -p ${DEST_APP}/AppDir/usr/share/locale/en/LC_MESSAGES
cp -rf ${APP} ${DEST_APP}/AppDir/bin/
cp ${APP_UTIL} ${DEST_APP}/AppDir/
cp ./AppRun/build/src/hooks/libapprun_hooks.so  ${DEST_APP}/AppDir/usr/lib
cp ${ICON} ${DEST_APP}/AppDir/usr/share/
cp ${ICON} ${DEST_APP}/AppDir/
DEST_APPDIR=${DEST_APP}/AppDir/
ICN=$(basename ${ICON})

# copy file to dest
function cpf()
{
    FULL_NAME=$1
    DIRNAME=$(dirname $1)
    FILENAME=$(basename $1)
    LINKNAME=$(readlink $1)
    REALFILE=$(realpath $1)
    ODIRNAME=${DIRNAME}
    [[ ${DIRNAME:0:1} == "/" ]] && DIRNAME=${DIRNAME:1}
    DESTDIR=${DEST_APPDIR}${DIRNAME}
    DEST_FIL=${DEST_APPDIR}${DIRNAME}/${FILENAME}
    echo "File: $FULL_NAME"
    echo "	Dir:  ${DIRNAME}"
    echo "	File: ${FILENAME}"
    echo "	Link: ${LINKNAME}"
    echo "	Appd: ${DESTDIR}"
    echo "	Appf: ${DEST_FIL}"
    echo "  Real: ${REALFILE}"


    [[ ! -d ${DESTDIR} ]] && echo "	   Creating dir: ${DESTDIR}" && mkdir -p  ${DESTDIR}
    [[ ! -f ${DESFILE} ]] && echo "    Deploying $FULL_NAME->${DEST_FIL}" && cp ${FULL_NAME} ${DEST_FIL}
    if [[ ! -z ${LINKNAME} ]];then
        echo "         Deploying Link: ln -s ${DEST_FIL} ${LINKNAME}"
        echo ">>>>>>>>>>>pushd ${DESTDIR}<<<<<<<<<"
        pushd ${DESTDIR}
            echo "CWD=$(pwd)"
            echo "ln -s ${FILENAME} ${LINKNAME}"
            echo "cp -rf ${REALFILE} ${FILENAME}"
            DR=$(dirname ${FILENAME})
            [[ ! -d $DR ]] && mkdir -p $DR
            ln -s ${FILENAME} ${LINKNAME}
            cp -rf ${REALFILE} ${FILENAME}
            echo "--------------------"
        popd
    #	sleep 1
    fi
    if [[ $DEST_FIL =~ ".so" ]];then
        echo "Creating a symlink from /usr/lib/*.so's -> to /lib/x86_64-linux-gnu/libs"

        [[ ! -d ${DEST_APPDIR}lib ]] && mkdir -p ${DEST_APPDIR}lib
        echo ">>>>>>>>>>>pushd ${DEST_APPDIR}lib <<<<<<<<<<"
        pushd ${DEST_APPDIR}lib
            echo "CWD=$(pwd)"
            echo "ln -s x86_64-linux-gnu/${FILENAME} ${FILENAME}"
            echo "cp -rf ${REALFILE} x86_64-linux-gnu/${FILENAME}"
            DR=$(dirname x86_64-linux-gnu/${FILENAME})
            [[ ! -d $DR ]] && mkdir -p $DR

            ln -s x86_64-linux-gnu/${FILENAME} ${FILENAME}
            cp -rf ${REALFILE} x86_64-linux-gnu/${FILENAME}
            echo "--------------------"
        popd
    #	sleep 1
        echo "${DEST_APPDIR}runtime/compat/lib64"
        [[ ! -d ${DEST_APPDIR}runtime/compat/lib64 ]] && mkdir -p ${DEST_APPDIR}runtime/compat/lib64
        pushd ${DEST_APPDIR}runtime/compat/lib64
            ln -s ../../../lib/x86_64-linux-gnu/${FILENAME} ${FILENAME}
        popd
    #	sleep 1

    fi
    export DST_FILE=${DESFILE}
    export DST_DIR=${DESTDIR}
}




LBS=("ld-linux-x86-64.so.2 libtinfo.so.6 libc.so.6 libdl.so.2")
for L in  ${LBS[@]};do
    P="/usr/lib"

    LF=$(find $P -name $L | grep 64)
    [[ -z $LF ]] && P="/lib" && LF=$(find $P -name $L)
    [[ -z $LF ]] && "ERROR: Required library: ${L} not found on the system" && exit 1

    echo "Processing lib $LF=================================================="
    cpf $LF
done
echo "-------------------------------------------------------------------------"
echo "ls -la $DST_DIR "
ls -l $DST_DIR/
echo "-------------------------------------------------------------------------"


echo "----------------------------------------------------------------/bin/bash"
WBASH=$(which bash)
cp -rf ${WBASH} ${DEST_APP}/AppDir/bin/bash
mkdir -rf  ${DEST_APP}/AppDir/runtime/compat/usr/bin
ln -s ../../../../bin/bash ${DEST_APP}/AppDir/runtime/compat/usr/bin/bash



echo "-----------------------------------------------------------------/qt/base"
if [[ ! -z $QT_LIBS ]];then
    cp -r ${QT_DIR}/Tools/QtCreator/lib/Qt/plugins/platforms ${DEST_APP}/AppDir/
fi

echo "-----------------------------------------------------------------ldd ${APP}<"
ldd "${APP}" | \
while read x; do
    if [[ $x =~ "=>" ]];then
        D=$(echo $x | awk '{print $3}')
        echo "Found library ${D}"
    else
        D=$(echo $x | awk '{print $1}')
        [[ ${D:0:1} == '/' ]] && D=${lb:1}
        echo "Found library ${D}"
    fi
    [[ -z ${D} ]] && continue
    [[ ${D} =~ "linux-vdso" ]] && continue
    cpf ${D}
done
echo "-----------------------------------------------------------------ldd ${APP}>"


[[ -z $(which patchelf) ]] && echo "Please install: sudo apt install -y patchelf " && exit 1
ICN=$(echo "${ICN%.*}")
echo "[Desktop Entry]" > ${DEST_APP}/AppDir/${APP}.desktop
echo "Name=${APP} Application" >> ${DEST_APP}/AppDir/${APP}.desktop
echo "Exec=AppRun" >> ${DEST_APP}/AppDir/${APP}.desktop
echo "Terminal=false" >> ${DEST_APP}/AppDir/${APP}.desktop
echo "Type=Application" >> ${DEST_APP}/AppDir/${APP}.desktop
echo "Icon=${ICN}" >> ${DEST_APP}/AppDir/${APP}.desktop
echo "Categories=Utility;" >> ${DEST_APP}/AppDir/${APP}.desktop
echo ""  >> ${DEST_APP}/AppDir/${APP}.desktop
chmod +x ${DEST_APP}/AppDir/${APP}.desktop
chmod +x ${DEST_APP}/AppDir/bin/*

CMDLINE="/bin/${APP}"

echo -e '#!/bin/bash\n'\
'THIS="$0"\n'\
'BINAR="$1"\n'\
'\n'\
'if [ -z "$APPDIR" ] ; then\n'\
'  APPDIR=$(pwd)\n'\
'fi\n'\
'\n'\
'export PATH="${APPDIR}:${APPDIR}/usr/bin:${APPDIR}/usr/sbin:${APPDIR}/bin:${PATH}:${APPDIR}/platforms"\n'\
'export XDG_DATA_DIRS="./share/:/usr/share/gnome:/usr/local/share/:/usr/share/:${XDG_DATA_DIRS}"\n'\
'export LD_LIBRARY_PATH="${APPDIR}/lib:${APPDIR}/lib/x86_64-linux-gnu:${APPDIR}/usr/lib:${APPDIR}/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"\n'\
'export XDG_DATA_DIRS="${APPDIR}"/usr/share/:"${XDG_DATA_DIRS}":/usr/share/gnome/:/usr/local/share/:/usr/share/:${APPDIR}/usr/lib\n'\
'export GSETTINGS_SCHEMA_DIR="${APPDIR}/usr/share/glib-2.0/schemas:${GSETTINGS_SCHEMA_DIR}"\n'\
'\n' > ${DEST_APP}/AppDir/AppRun

echo -e "if [ -z \${BINAR} ];then\n\
    BINAR=bin/${APP}\n\
fi\n \
BIN="\$APPDIR/\$BINAR"\n\
exec \"\$BIN\"\n\
\n\n" >> ${DEST_APP}/AppDir/AppRun
chmod +x ${DEST_APP}/AppDir/AppRun


echo "--------------------------------------------------------------------------"
pushd  ${DEST_APP}
    echo "Running on $(pwd)------------------"

    export APPDIR=./AppDir
    export ARCH=x86_64
    export XDG_DATA_DIR=/usr/share
    appimagetool-x86_64.AppImage AppDir ${APP}.AppImage
popd
echo "--------------------------------------------------------------------------"
ls -ltr ${DEST_APP}

echo "testing app dir-----------------------------------------------------------"
# copy more

pushd ${DEST_APP}
    echo "Press enter to run app...."
    read yn
    ./${APP}.AppImage
popd

echo "Did it ran ?"
read yn
if [[ $yn == 'n' || $yn == 'N' ]]; then
    echo "Attempting to fix it"

    pushd ${DEST_APP}/AppDir
        echo "tracing: ./AppRun ./bin/${APP}"
        strace "./AppRun ./bin/${APP}" > /tmp/apprun_trace.log 2>&1
    popd


    grep "No such file or directory" /tmp/apprun_trace.log  | grep lib | grep openat | \
    while read x; do
        libfp=$(echo $x | awk -F"\"" '{print$2}')
        [[ ${libfp:0:1} == "." ]] && continue
        lib=$(basename $libfp)
    cpf $lib
    done

    echo "rebuilding again"

    echo "--------------------------------------------------------------------------"
    pushd  ${DEST_APP}
        echo "Running on $(pwd)------------------"

        export APPDIR=./AppDir
        export ARCH=x86_64
        export XDG_DATA_DIR=/usr/share
        appimagetool-x86_64.AppImage AppDir ${APP}.AppImage
    popd
    echo "--------------------------------------------------------------------------"
    ls -ltr ${DEST_APP}

    echo "testing app dir-----------------------------------------------------------"
    # copy more

    pushd ${DEST_APP}
        echo "Press enter to run app...."
        read yn
        ./${APP}.AppImage
    popd
fi
echo "your app is in /tmp/..."


# echo ${DEST_APP}
# echo 'TARGET=${DEST_APP}/AppDir/bin/bash'
# echo 'LINKER=$(patchelf --print-interpreter \"$TARGET\")'
# echo 'patchelf --set-interpreter \"${LINKER:1}\" \"$TARGET\"'











