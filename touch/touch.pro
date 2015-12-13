QT += qml quick
TARGET = touch
!no_desktop: QT += widgets

include(src/src.pri)
include(../shared/shared.pri)

OTHER_FILES += \
    main.qml \
    content/ButtonPage.qml \
    content/ListPage.qml \
    content/ProgressBarPage.qml \
    content/SliderPage.qml \
    content/TabBarPage.qml \
    content/TextInputPage.qml

RESOURCES += \
    resources.qrc
DISTFILES += \
    content/AndroidDelegate2.qml \
    content/AndroidDelegate.qml
