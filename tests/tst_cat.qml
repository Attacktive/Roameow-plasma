import QtQuick
import QtTest

TestCase {
	id: testCase
	name: 'CatRegression'
	when: windowShown
	visible: true
	width: 400
	height: 300

	readonly property string catComponentPath: Qt.resolvedUrl('../package/contents/ui/Cat.qml')
	readonly property string nyancatPath: Qt.resolvedUrl('../package/contents/images/nyancat.gif')
	readonly property string sleepingcatPath: Qt.resolvedUrl('../package/contents/images/sleepingcat.svg')

	function test_naturalIdleEntryAndExit() {
		const component = Qt.createComponent(catComponentPath);
		compare(component.status, Component.Ready, component.errorString());
		const cat = component.createObject(
			testCase,
			{
				width: 300,
				height: 200,
				imageSize: 64,
				speed: 1000,
				enableMovement: true,
				enableRandomIdle: true,
				idleProbability: 100,
				showIdleImage: true,
				imageSource: nyancatPath,
				idleImageSource: sleepingcatPath
			}
		);
		verify(cat !== null, 'Cat object must be created');
		tryCompare(cat, 'isIdle', true, 1500);

		const sprite = findChild(cat, 'catSprite');
		verify(sprite !== null, 'Sprite child must exist');
		compare(sprite.source, cat.idleImageSource);
		cat.idleProbability = 0;

		tryCompare(cat, 'isIdle', false, 3000);
		compare(sprite.source, cat.imageSource);
		cat.destroy();
	}

	function test_disableMovementDuringIdle() {
		const component = Qt.createComponent(catComponentPath);
		compare(component.status, Component.Ready, component.errorString());
		const cat = component.createObject(
			testCase,
			{
				width: 300,
				height: 200,
				imageSize: 64,
				speed: 1000,
				enableMovement: true,
				enableRandomIdle: true,
				idleProbability: 100,
				showIdleImage: true,
				imageSource: nyancatPath,
				idleImageSource: sleepingcatPath
			}
		);
		verify(cat !== null, 'Cat object must be created');
		tryCompare(cat, 'isIdle', true, 1500);

		cat.enableMovement = false;
		compare(cat.isIdle, false);
		cat.enableMovement = true;
		compare(cat.isIdle, false);
		cat.destroy();
	}

	function test_disableRandomIdleDuringIdle() {
		const component = Qt.createComponent(catComponentPath);
		compare(component.status, Component.Ready, component.errorString());
		const cat = component.createObject(
			testCase,
			{
				width: 300,
				height: 200,
				imageSize: 64,
				speed: 1000,
				enableMovement: true,
				enableRandomIdle: true,
				idleProbability: 100,
				showIdleImage: true,
				imageSource: nyancatPath,
				idleImageSource: sleepingcatPath
			}
		);
		verify(cat !== null, 'Cat object must be created');
		tryCompare(cat, 'isIdle', true, 1500);

		cat.enableRandomIdle = false;
		compare(cat.isIdle, false);
		cat.destroy();
	}

	function test_noStartupIdle() {
		const component = Qt.createComponent(catComponentPath);
		compare(component.status, Component.Ready, component.errorString());
		const cat = component.createObject(
			testCase,
			{
				width: 300,
				height: 200,
				imageSize: 64,
				speed: 0.001,
				enableMovement: true,
				enableRandomIdle: true,
				idleProbability: 100,
				showIdleImage: true,
				imageSource: nyancatPath,
				idleImageSource: sleepingcatPath
			}
		);
		verify(cat !== null, 'Cat object must be created');
		compare(cat.isIdle, false);
		cat.destroy();
	}

	function test_idleImageOptInDisabledKeepsActiveImage() {
		const component = Qt.createComponent(catComponentPath);
		compare(component.status, Component.Ready, component.errorString());
		const cat = component.createObject(
			testCase,
			{
				width: 300,
				height: 200,
				imageSize: 64,
				speed: 1000,
				enableMovement: true,
				enableRandomIdle: true,
				idleProbability: 100,
				showIdleImage: false,
				imageSource: nyancatPath,
				idleImageSource: sleepingcatPath
			}
		);
		verify(cat !== null, 'Cat object must be created');
		tryCompare(cat, 'isIdle', true, 1500);

		const sprite = findChild(cat, 'catSprite');
		verify(sprite !== null, 'Sprite child must exist');
		compare(sprite.source, cat.imageSource);
		cat.destroy();
	}

	SignalSpy {
		id: clickSpy
		signalName: 'clicked'
	}

	function test_clickSignalEmitted() {
		const component = Qt.createComponent(catComponentPath);
		compare(component.status, Component.Ready, component.errorString());
		const cat = component.createObject(
			testCase,
			{
				width: 300,
				height: 200,
				imageSize: 64,
				enableMovement: false,
				imageSource: nyancatPath
			}
		);
		verify(cat !== null, 'Cat object must be created');
		clickSpy.target = cat;
		clickSpy.clear();
		const sprite = findChild(cat, 'catSprite');
		mouseClick(sprite, sprite.width / 2, sprite.height / 2);
		compare(clickSpy.count, 1);
		cat.destroy();
	}
}
