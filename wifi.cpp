#include <QCoreApplication>
#include <QProcess>
#include <QDebug>
#include <wifi.h>
#include <iostream>
#include <string>
#include <QStringList>

using namespace std;

QString Wifi::wifiScan()
{
	
    QProcess process;
    
	process.setProgram("connmanctl");
    process.setArguments({"scan", "wifi"});
    process.start();
    process.waitForFinished();

    QString output = QString::fromUtf8(process.readAllStandardOutput());
	

	process.setProgram("connmanctl");
    process.setArguments({"services"});
    process.start();
    process.waitForFinished();
		
    output = QString::fromUtf8(process.readAllStandardOutput());
	QStringList networkList = output.split(QRegExp("\n"));
	networkList.removeAll("");
	QString list = "";
	for (QString net : networkList) {
    	net = net.trimmed();
    	QString name = net.mid(0,net.indexOf("   "));
    	QString address = net.mid(net.indexOf("wifi"));
    	list += name + ":" + address + ";";
    }
    
    
    return list;
}

void Wifi::wifiEnable(bool status){
	
	QProcess process;
 
    if (status) {
    	process.setProgram("connmanctl");
    	process.setArguments({"enable", "wifi"});
    	process.start();
    	process.waitForFinished();
    	
    } else {
    	process.setProgram("connmanctl");
    	process.setArguments({"disable", "wifi"});
    	process.start();
    	process.waitForFinished();
    }
	
	
}

bool Wifi::wifiStatus(){
	
	QProcess process;
    process.setProgram("connmanctl");
    process.setArguments({"enable", "wifi"});
    process.start();
    process.waitForFinished();

	QString output = QString::fromUtf8(process.readAllStandardError());
	
	if(output.contains("wifi") && output.contains("already")) {
		return true;
		
	}else{
		process.setProgram("connmanctl");
   		process.setArguments({"disable", "wifi"});
	    process.start();
	    process.waitForFinished();
		return false;	
	}	
}

QString Wifi::wifiConnect(QString ssid, QString password){
	
	QProcess process;
    process.setProgram("connmanctl");
    process.start();
    if (!process.waitForStarted()) {
        qDebug() << "Failed to start process";
        
    }

    process.waitForReadyRead();
    QString output = QString::fromUtf8(process.readAll());
    qDebug() << "Output:" << output;
    
    process.write("agent on\n");
    process.waitForReadyRead();
    process.waitForFinished(100);
    output = QString::fromUtf8(process.readAll());
	qDebug() << "Output:" << output;
	    
    process.write("connect " + ssid.toUtf8() + "\n");
    process.waitForReadyRead();
    process.waitForFinished(100);
    output = QString::fromUtf8(process.readAll());
	qDebug() << "Output:" << output;

	process.write(password.toUtf8() + "\n");
    process.waitForReadyRead();
    process.waitForFinished(100);
    output = QString::fromUtf8(process.readAll());
    qDebug() << "Output:" << output;
    
    process.close();
	return output;
        
}    


