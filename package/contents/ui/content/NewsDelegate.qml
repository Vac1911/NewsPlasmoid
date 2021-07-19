import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import "../luxon.js" as DateUtil

Rectangle {
    id: delegate
    width: delegate.ListView.view.width - 30
    height: 96
    color: PlasmaCore.ColorScope.backgroundColor

    border.color: "#30363d"
    border.width: 1

    Component.onCompleted: {
        imgData.setLink(link);
    }
    RowLayout {
        id: layout
        anchors.fill: parent
        height: parent.height
        spacing: 16

        ImageData {
            id: imgData
            width: parent.height * 2
            height: parent.height
        }

        PlasmaComponents.Label {
            id: heading
            Layout.fillWidth: true
            Layout.preferredWidth: 400
            wrapMode: Text.WordWrap
            font.pointSize: 10
            font.underline: false
            textFormat: Text.RichText
            text: title
        }

        PlasmaComponents.Label {
            id: timeLabel
            Layout.minimumWidth: 100
            font.pointSize: 8
            font.underline: false
            text: '---'
            Component.onCompleted: {
                var DateTime = DateUtil.luxon.DateTime
                var publishedDate = DateTime.fromHTTP(pubDate)
                if(!publishedDate.isValid) publishedDate = DateTime.fromRFC2822(pubDate)
                if(!publishedDate.isValid) publishedDate = DateTime.now()
                this.text = publishedDate.toRelative()
            }
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: {heading.font.underline = true}
        onExited: {heading.font.underline = false}
        onClicked: {Qt.openUrlExternally(link) }
    }
}