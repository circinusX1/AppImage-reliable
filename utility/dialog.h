#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QSystemTrayIcon>
#include <QListWidgetItem>
#include <QClipboard>
#include <QTimer>


QT_BEGIN_NAMESPACE
class QAction;
class QCheckBox;
class QComboBox;
class QGroupBox;
class QLabel;
class QLineEdit;
class QMenu;
class QPushButton;
class QSpinBox;
class QTextEdit;
QT_END_NAMESPACE


QT_BEGIN_NAMESPACE
namespace Ui {
class Dialog;
}
QT_END_NAMESPACE



class MyTryIcon : public QSystemTrayIcon
{
public:
    MyTryIcon(QObject *parent = nullptr):QSystemTrayIcon(parent){
        ;
    }

    bool event(QEvent *event) override
    {
        return QSystemTrayIcon::event(event);
    }

};

class Dialog : public QDialog
{
    Q_OBJECT

public:
    Dialog(QWidget *parent = nullptr);
    ~Dialog();

     void setVisible(bool visible) override;

protected:
    void closeEvent(QCloseEvent *event) override;

private slots:
    void setIcon(int index);
    void iconActivated(QSystemTrayIcon::ActivationReason reason);
    void showMessage();
    void messageClicked();
    void onCb();

private:
    void createActions();
    void createTrayIcon();

private slots:
    void on_listWidget_itemDoubleClicked(QListWidgetItem *item);
    void on_pushButton_clicked();
    void on_toggle();
    void _capture_clip();

    void on_pushButton_2_clicked();

    void on_Dialog_destroyed();

    void on_pushButton_3_clicked();

    void on_listWidget_2_itemDoubleClicked(QListWidgetItem *item);

    void on_listWidget_3_itemDoubleClicked(QListWidgetItem *item);

    void on_listWidget_4_itemDoubleClicked(QListWidgetItem *item);

private:
    Ui::Dialog *ui;

    QAction *toogleAction;
    QAction *quitAction;

    MyTryIcon *trayIcon;
    QMenu *trayIconMenu;
    QTimer *timer;


};
#endif // DIALOG_H
