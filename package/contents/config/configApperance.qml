import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: page
  
    property alias cfg_itemSize: itemSize.text

    ComboBox {
        id: combo
        editable: true
        model: ListModel {
            id: model
            ListElement { text: "Banana"; color: "Yellow" }
            ListElement { text: "Apple"; color: "Green" }
            ListElement { text: "Coconut"; color: "Brown" }
        }
        onAccepted: {
            if (combo.find(currentText) === -1) {
                model.append({text: editText})
                currentIndex = combo.find(editText)
            }
        }
    }
}