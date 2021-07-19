import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponent

Rectangle {
    id: imgDataRoot
    property string link
    property string imgSrc

	Image {
		id: imgOut
		anchors.fill: parent
		fillMode: Image.PreserveAspectCrop
		source: ""
		sourceSize.width: 1024
       	sourceSize.height: 1024
    }

	function setImg(src) {
        this.imgSrc = src.toString()
		imgOut.source = this.imgSrc;
    }

    function setLink(link) {
        this.link = link
        this.runCommand('curl ' + link)
    }

    PlasmaCore.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: {
			var exitCode = data["exit code"]
			var exitStatus = data["exit status"]
			var stdout = data["stdout"]
			var stderr = data["stderr"]
			exited(sourceName, exitCode, exitStatus, stdout, stderr)
			disconnectSource(sourceName) // cmd finished
		}
		function exec(cmd) {
			connectSource(cmd)
		}
		signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)

        onExited: {
			var metaTag = stdout.match(/<meta [^>]+>/g).find(metaTag => metaTag.includes('og:image'))
			imgDataRoot.setImg(metaTag.match(/content="(.*)"/g)[0].slice(9, -1))
        }
	}
    function runCommand(cmd) {
		executable.exec(cmd)
	}
}