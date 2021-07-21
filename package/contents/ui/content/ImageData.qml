import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponent

Rectangle {
    id: imgDataRoot
	color: 'transparent'
	property string size
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
        this.imgSrc = src
		imgOut.source = this.imgSrc
    }

	function normalizeSource(src, location) {
		var url = src
		var pos = url.search('//')

		// If absolute url
		if(pos !== -1) {
			 url = url.slice(pos + 2)
		}
		// If relative url
		else if (url.startsWith('/')) {
			url = imgDataRoot.getHost(location) + src
		}

		return 'https://' + url
	}

	function getHost(location) {
		var start = location.search('//')
		if(start !== -1) location = location.slice(start + 2)

		var end = location.search('/')
		if(end !== -1) location = location.slice(0, end)

		return location
	}

    function setLink(link, size) {
        this.link = link
		this.size = size
        this.runCommand('curl ' + link + " -L -s -w '\n[%{url_effective}]'")
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
			var source = ''
			var location = stdout.match(/\n\[(.)+\]$/)[0].trim().slice(1, -1)
			var host = imgDataRoot.getHost(location)

			if(imgDataRoot.size == 'large') {
				var metaTag = stdout.match(/<meta [^>]+>/g).find(metaTag => metaTag.includes('og:image'))
				if(metaTag) source = metaTag.match(/content="(.*)"/g)[0].slice(9, -1)

				source = imgDataRoot.normalizeSource(source, location)
			}

			if(!source && window.iconCache[host]) {
				source = window.iconCache[host]
			}

			if(!source) {
				var linkTags = stdout.match(/<link [^>]+>/g)
				var icon = linkTags.find(metaTag => metaTag.includes('shortcut icon'))
				if(!icon) icon = linkTags.find(metaTag => metaTag.includes('icon'))

				source = icon.match(/href="(.*)"/g)[0].slice(6, -1)
				source = imgDataRoot.normalizeSource(source, location)

				window.iconCache[host] = source
			}

			imgDataRoot.setImg(source)
        }
	}
    function runCommand(cmd) {
		executable.exec(cmd)
	}
}