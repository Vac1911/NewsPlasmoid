import QtQuick 2.2
import QtQuick.XmlListModel 2.2
import QtQuick.Controls 2.2
import QtQuick.Window 2.1
import QtLocation 5.5
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0 as Plasmoid
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import "./content"

Rectangle {
    id: window
    width: 800
    height: 400

    color: PlasmaCore.ColorScope.backgroundColor

    /*property string currentFeed: "www.mlb.com/feeds/news/rss.xml"*/
    property string currentFeed: "blogs.fangraphs.com/feed/"
    property bool loading: feedModel.status === XmlListModel.Loading

    onLoadingChanged: {
        if (feedModel.status == XmlListModel.Ready) {
            list.positionViewAtBeginning()
            if (!xmlContentReloader.running) xmlContentReloader.start()
            // imgData.runCommand('touch /home/andrew/hello')
            imgData.setLink('www.google.com');
        }
    }

    ImageData {
        id: imgData
    }

    Timer {
        id: xmlContentReloader
        repeat: true
        interval: 1000 * 60 * 10 // Check every 10mins
        onTriggered: {
            feedModel.source = "https://" + window.currentFeed + "?requestid=" + Math.random() * 9999
            feedModel.reload()
        }
    }

    XmlListModel {
        id: feedModel

        source: "https://" + window.currentFeed
        query: "/rss/channel/item"
        
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "pubDate"; query: "pubDate/string()" }
        XmlRole { name: "link"; query: "link/string()" }
    }

    Item {
        id: topbar
        width: window.width
        height: title.contentHeight + 8
        anchors.topMargin: 16
        PlasmaExtras.Heading {
            id: title
            anchors.left: parent.left
            anchors.leftMargin: 24
            width: 400
            level: 2
            textFormat: Text.RichText
            text: 'Fangraphs News'
        }
        /*Item {
            id: loadIndicator
            width: title.contentHeight
            height: title.contentHeight
            anchors.right: parent.right
            anchors.rightMargin: 24
            PlasmaComponents.Button {
                icon.name: "cm_refresh"
            }
        }*/
    }

    ListView {
        id: list
        spacing: -1
        anchors.left: window.left
        anchors.right: window.right
        anchors.top: topbar.bottom
        anchors.bottom: window.bottom
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        model: feedModel
        delegate: NewsDelegate {}
    }
}