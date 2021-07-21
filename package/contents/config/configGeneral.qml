import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: page
  
    property alias cfg_itemSize: itemSize.text

    TextField {
        id: itemSize
        Kirigami.FormData.label: i18n("Label:")
        placeholderText: i18n("Placeholder")
    }
}