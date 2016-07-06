TEMPLATE = app

QT += core qml quick
CONFIG += c++11 resources_big

SOURCES += main.cpp \
    b2file.cpp

RESOURCES += qml.qrc \
    font.qrc \
    bg.qrc \
    script.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES +=

HEADERS += \
    b2file.h
