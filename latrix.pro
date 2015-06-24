#-------------------------------------------------
#
# Project created by QtCreator 2014-12-30T15:19:20
#
#-------------------------------------------------

QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = latrix
TEMPLATE = app
QMAKE_CXXFLAGS += -std=c++11

SOURCES += main.cpp\
    mainwindow.cpp \
    debugoutput.cpp


HEADERS  += mainwindow.h debugoutput.h

FORMS    += mainwindow.ui
