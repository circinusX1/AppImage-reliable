
#include <QMessageBox>
#include <QCloseEvent>
#include <QMenu>
#include <QMimeData>
#include <QFile>

#include "dialog.h"
#include "./ui_dialog.h"
#include <limits.h>
#include <X11/Xlib.h>


Dialog::Dialog(QWidget *parent)
    : QDialog(parent) // ,  Qt::FramelessWindowHint | Qt::Dialog)
    , ui(new Ui::Dialog)
{

    ui->setupUi(this);
    //QDialog Dialog(0,);
    createActions();
    createTrayIcon();
    connect(trayIcon, &QSystemTrayIcon::messageClicked, this, &Dialog::messageClicked);
    connect(trayIcon, &QSystemTrayIcon::activated, this, &Dialog::iconActivated);

    // connect(qApp->clipboard(), &QClipboard::dataChanged, this, &Dialog::onCb);
    setIcon(0);

    trayIcon->show();

    char buffer[4096];
    QString lf = ::getenv("HOME");
    lf += "/.config/clip_hist2.txt";

    FILE* pf = ::fopen(lf.toUtf8(),"rb");
    if(pf)
    {
        while(!::feof(pf))
        {
            ::memset(buffer,0,sizeof(buffer));
            uint32_t l;
            ::fread(&l, sizeof(uint32_t), 1, pf);
            if(l>sizeof(buffer)-1)l=sizeof(buffer)-1;
            ::fread(buffer, 1, l, pf );
            if(::strlen(buffer) < 3) continue;
            ui->listWidget->addItem(buffer);
            if(::feof(pf))
            {
                break;
            }
        }
        ::fclose(pf);
    }

 //   timer = new QTimer(this);
 //   timer->setInterval(2000);
 //   connect(timer, SIGNAL(timeout()), this, SLOT(_capture_clip()));
 //   timer->start();
    setVisible(false);
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::on_listWidget_itemDoubleClicked(QListWidgetItem *item)
{
    QString s =item->text();
    qApp->clipboard()->setText(s);
    ui->lineEdit->selectAll();
    ui->lineEdit->setPlainText(s);
    ui->lineEdit->selectAll();
}

void Dialog::onCb()
{
    if (qApp->clipboard()->mimeData())
    {
        const QMimeData* pD = qApp->clipboard()->mimeData();

    }
}


void Dialog::on_pushButton_clicked()
{
    if(ui->lineEdit->toPlainText().length() > 2 )
    {
        ui->listWidget->addItem(ui->lineEdit->toPlainText());
    }
}


void Dialog::setVisible(bool visible)
{
    toogleAction->setEnabled(true);
    QDialog::setVisible(visible);

    if(visible)
    {
        _capture_clip();
      //  timer->setInterval(2000);
      //  connect(timer, SIGNAL(timeout()), this, SLOT(_capture_clip()));
      //  timer->start();
        QRect screenrect = qApp->primaryScreen()->geometry();
        this->move(screenrect.right()-this->size().width(), screenrect.top()+40);
        this->raise();
        this->setWindowState(Qt::WindowState::WindowActive);
    }
    else
    {
      //  timer->stop();
    }
}

void Dialog::closeEvent(QCloseEvent *event)
{
    QString lf = ::getenv("HOME");
    lf += "/.config/clip_hist2.txt";

    FILE* pf = ::fopen(lf.toUtf8(),"wb");
    if(pf)
    {
        for(int i=0; i < ui->listWidget->count();i++)
        {
            QString qs = ui->listWidget->item(i)->text();
            uint32_t l = qs.length();
            if(l>3)
            {
                ::fwrite(&l,sizeof(uint32_t), 1, pf);
                ::fwrite((const void*)qs.toUtf8(),1,l,pf);
            }
        }
        ::fclose(pf);
    }


    if (!event->spontaneous() || !isVisible())
        return;
    if (trayIcon->isVisible()) {
        hide();
        event->ignore();
    }
}

void Dialog::setIcon(int index)
{
    QIcon icon(":/clip_tray.png");
    if(icon.isNull())
    {
        QMessageBox::warning(this, tr("Systray"), "Image icon is null");
        return;
    }
    trayIcon->setIcon(icon);
    setWindowIcon(icon);
    trayIcon->setToolTip("Open...");

}

void Dialog::iconActivated(QSystemTrayIcon::ActivationReason reason)
{
    showMessage();
}

void Dialog::showMessage()
{
    trayIcon->showMessage("Clipboard","Open clipboards");
}

void Dialog::messageClicked()
{
    QMessageBox::information(nullptr, tr("Systray"),
                             tr("Sorry"));
}

void Dialog::on_toggle()
{
    if(this->isVisible())
        this->hide();
    else
    {
        this->show();
    }
}


void Dialog::createActions()
{
    toogleAction = new QAction(tr("&Toggle"), this);
    connect(toogleAction, &QAction::triggered, this, &Dialog::on_toggle);

    quitAction = new QAction(tr("&Quit"), this);
    connect(quitAction, &QAction::triggered, qApp, &QCoreApplication::quit);

}


void Dialog::createTrayIcon()
{
    trayIconMenu = new QMenu(this);
    trayIconMenu->addAction(toogleAction);
    trayIconMenu->addAction(quitAction);

    //Listener* pl = new Listener;
    // trayIcon->installEventFilter(pl);
    trayIcon = new MyTryIcon(this);
    trayIcon->setContextMenu(trayIconMenu);
}



void Dialog::_capture_clip()
{
    /*
    Display *display = XOpenDisplay(NULL);
    unsigned long color = BlackPixel(display, DefaultScreen(display));
    Window window = XCreateSimpleWindow(display, DefaultRootWindow(display), 0,0, 1,1, 0, color, color);

    char *result;
    unsigned long ressize, restail;
    int resbits;
    Atom bufid = XInternAtom(display, "CLIPBOARD", False),
        fmtid = XInternAtom(display, "STRING", False),
        propid = XInternAtom(display, "XSEL_DATA", False),
        incrid = XInternAtom(display, "INCR", False);
    XEvent event;

    XConvertSelection(display, bufid, fmtid, propid, window, CurrentTime);
    do {
        XNextEvent(display, &event);
    } while (event.type != SelectionNotify || event.xselection.selection != bufid);

    if (event.xselection.property)
    {
        XGetWindowProperty(display, window, propid, 0, LONG_MAX/4, False, AnyPropertyType,
                           &fmtid, &resbits, &ressize, &restail, (unsigned char**)&result);

        if (fmtid == incrid)
        {
            ui->lineEdit->insertPlainText("Buffer to large");
        }
        else
        {
            ui->lineEdit->selectAll();
            ui->lineEdit->insertPlainText(result);
        }
        XFree(result);
    }
*/
    if (qApp->clipboard()->mimeData())
    {
        const QMimeData* pD = qApp->clipboard()->mimeData();
        QString s = pD->text();
        if(s.length())
        {
            ui->lineEdit->selectAll();
            ui->lineEdit->insertPlainText(s);
        }
    }


}

void Dialog::on_pushButton_2_clicked()
{
    _capture_clip();
}


void Dialog::on_Dialog_destroyed()
{
    ;
}


void Dialog::on_pushButton_3_clicked()
{
    QModelIndexList selectedList = ui->listWidget->selectionModel()->selectedIndexes(); // take the list of selected indexes
    std::sort(selectedList.begin(),selectedList.end(),[](const QModelIndex& a, const QModelIndex& b)->bool{return a.row()>b.row();}); // sort from bottom to top
    for(const QModelIndex& singleIndex : selectedList)
        ui->listWidget->model()->removeRow(singleIndex.row()); // remove each row
}


void Dialog::on_listWidget_2_itemDoubleClicked(QListWidgetItem *item)
{

}


void Dialog::on_listWidget_3_itemDoubleClicked(QListWidgetItem *item)
{

}


void Dialog::on_listWidget_4_itemDoubleClicked(QListWidgetItem *item)
{

}

