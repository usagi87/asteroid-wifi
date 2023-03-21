#ifndef TEST_H
#define TEST_H

#include <QObject>

class Wifi : public QObject
{
	Q_OBJECT

public:
	Q_INVOKABLE QString wifiScan();
	
	Q_INVOKABLE void wifiEnable(bool status);
	
	Q_INVOKABLE bool wifiStatus();
	
	Q_INVOKABLE QString wifiConnect(QString ssid, QString password);

private:




};

#endif

