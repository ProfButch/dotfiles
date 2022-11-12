function getRunningBuilds(buildName){
	var se = Application('System Events')
	var p = se.processes()
	var toReturn = []
	
	p.forEach(element => {
		if(!element.backgroundOnly()){
			if(element.file().path().includes(buildName)){
				toReturn.push(element)
				console.log(`* ${element.name()} [${element.file().path()}] ${element.unixId()} ${element.id()}`)
			} else {
				console.log(`. ${element.name()}`)
			}
		}
	});

	return toReturn;
}

function moveWindowTo(window, x, y ){
	console.log(`position = ${window.position()}`)

	// console.log(typeof window);
	// console.log(window.position().x)
	// console.log(window.position().y)

	// var pos = window.position()
	// console.log(typeof pos)
	// console.log(pos)
	// pos.x = 0
	// console.log(pos)
	// console.log(window.bounds.x)
	// console.log(window.bounds.y)
	// console.log(window.position())

			// console.log(window.toString())
		
		
		// app.activate()
		// window.bounds = {
		// 	x: 0,
		// 	y: 0,
		// 	width: 500,
		// 	height: 500
		//   }
		  
		// console.log(app.windows[0].size())

		// app.windows[0].position().x = 0
		// app.windows[0].position().y = 0
		// app.windows[0].position = {
		// 	x: 0,
		// 	y: 0
		// };

		// app.windows.at(0).bounds = {
		// 	"x": 0,
		// 	"y": 0,
		// 	"width": 500,
		// 	"height": 500
		// }
}

function moveWindows(theProcesses){
	theProcesses.forEach(proc => {
		var app = Application(proc.name())		
		// var app = Application(proc.bundleIdentifier())
		// var app = Application(proc.name()).whose({"id": {"=": proc.id}})
		app.activate()
		
		
		var window = proc.windows[0];
		// window.position = [0, 0]
		// window.size = [200, 200]
	});
}


function main(){
	var app = Application.currentApplication()
	app.includeStandardAdditions = true;

	// var unityApp = Application("BaseNetworkingProject");
	// unityApp.activate()
	// console.log(unityApp.windows.length)

	var theApps = getRunningBuilds("TheBuild.app")
	moveWindows(theApps)
}


main()

