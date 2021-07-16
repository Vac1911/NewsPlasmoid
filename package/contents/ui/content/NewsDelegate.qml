import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import "../luxon.js" as DateUtil

Rectangle {
    id: delegate
    width: delegate.ListView.view.width
    height: heading.contentHeight + 8
    color: PlasmaCore.ColorScope.backgroundColor

    border.color: "#30363d"
    border.width: 1

    PlasmaComponents.Label {
        id: heading
        width: parent.width - 150
        wrapMode: Text.WordWrap
         anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 10
        font.underline: false
        textFormat: Text.RichText
        text: title
    }

    PlasmaComponents.Label {
        property date publishedDate: new Date()
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 8
        font.underline: false
        textFormat: Text.RichText
        text: publishedDate.toLocaleString(Qt.locale(), "yyyy.MM.dd HH:mm")
        Component.onCompleted: {
            publishedDate = Date.fromLocaleString(Qt.locale('en_GB'), pubDate, "ddd, dd MMM yyyy HH:mm:ss '+0000'")
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {heading.font.underline = true}
        onExited: {heading.font.underline = false}
        onClicked: {Qt.openUrlExternally(link) }
    }
}