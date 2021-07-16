import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponent

Item {
    id: imgDataRoot
    property string link
    property string imgSrc

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
            imgDataRoot.imgSrc = 'here'
            console.log(imgDataRoot.imgSrc)
        }
	}
    function runCommand(cmd) {
		console.log('[commandoutput]', Date.now(), 'runCommand', cmd)
		executable.exec(cmd)
	}
}