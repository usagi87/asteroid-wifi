TARGET = asteroid-wifi
CONFIG += asteroidapp

SOURCES +=	main.cpp 
    

RESOURCES +=   resources.qrc
OTHER_FILES += main.qml 
				
				


lupdate_only{ SOURCES += i18n/asteroid-authenticator.desktop.h }
TRANSLATIONS = $$files(i18n/$$TARGET.*.ts)

HEADERS += \
		
    
    

