import QtQuick
import QtTest
import '../package/contents/ui' as Roameow

TestCase {
	id: testCase
	name: 'CatRegression'
	when: windowShown
	visible: true
	width: 400
	height: 300

	Component {
		id: catComponent

		Roameow.Cat {
			width: 300
			height: 200
			imageSize: 64
			speed: 1000
			enableMovement: true
			enableRandomIdle: true
			idleProbability: 100
			showIdleImage: true
			imageSource: Qt.resolvedUrl('../package/contents/images/nyancat.gif')
			idleImageSource: Qt.resolvedUrl('../package/contents/images/sleepingcat.svg')
		}
	}

	SignalSpy {
		id: idleSpy
		signalName: 'isIdleChanged'
	}

	SignalSpy {
		id: clickSpy
		signalName: 'clicked'
	}

	function test_sleepStartsAtRandomPositionAndDoesNotReseed() {
		const cat = createTemporaryObject(catComponent, this, { positionRandom: () => 0.5 });
		const sprite = findChild(cat, 'catSprite');
		verify(waitForRendering(sprite));
		compare(sprite.mapToItem(cat, 0, 0), Qt.point(118, 68));
		compare(cat.isIdle, true);
		cat.width = 500;
		cat.height = 400;
		cat.enableRandomIdle = false;
		cat.enableRandomIdle = true;
		verify(waitForRendering(sprite));
		compare(sprite.mapToItem(cat, 0, 0), Qt.point(118, 68));
	}

	function test_sleepPlacementWaitsForBothDimensions() {
		const cat = createTemporaryObject(catComponent, this, { width: 0, height: 0, positionRandom: () => 0.5 });
		const sprite = findChild(cat, 'catSprite');
		verify(waitForRendering(sprite));
		compare(sprite.mapToItem(cat, 0, 0), Qt.point(0, 0));
		cat.width = 300;
		verify(waitForRendering(sprite));
		compare(sprite.mapToItem(cat, 0, 0), Qt.point(0, 0));
		cat.height = 200;
		verify(waitForRendering(sprite));
		compare(sprite.mapToItem(cat, 0, 0), Qt.point(118, 68));
		compare(cat.isIdle, true);
	}

	function test_disabledMovementKeepsAnchoredPlacementUntilEnabled() {
		const cat = createTemporaryObject(catComponent, this, { enableMovement: false, positionRandom: () => 0.5 });
		const sprite = findChild(cat, 'catSprite');
		verify(waitForRendering(sprite));
		compare(sprite.mapToItem(cat, 0, 0), Qt.point(0, 0));
		cat.width = 400;
		cat.height = 300;
		verify(waitForRendering(sprite));
		compare(sprite.mapToItem(cat, 0, 0), Qt.point(0, 0));
		cat.enableMovement = true;
		verify(waitForRendering(sprite));
		compare(sprite.mapToItem(cat, 0, 0), Qt.point(168, 118));
		compare(cat.isIdle, true);
	}

	function test_fullIdleStartsImmediatelyAndNeverWakes() {
		const cat = createTemporaryObject(catComponent, this);
		compare(cat.isIdle, true);
		const sprite = findChild(cat, 'catSprite');
		compare(sprite.source, cat.idleImageSource);
		verify(waitForRendering(sprite));
		const position = sprite.mapToItem(cat, 0, 0);
		idleSpy.target = cat;
		idleSpy.clear();
		wait(4300);
		compare(cat.isIdle, true);
		compare(idleSpy.count, 0);
		compare(sprite.mapToItem(cat, 0, 0), position);
	}

	function test_percentageChangesApplyImmediately() {
		const cat = createTemporaryObject(catComponent, this);
		compare(cat.isIdle, true);
		cat.idleProbability = 0;
		compare(cat.isIdle, false);
		const sprite = findChild(cat, 'catSprite');
		compare(sprite.source, cat.imageSource);
		cat.idleProbability = 100;
		compare(cat.isIdle, true);
		compare(sprite.source, cat.idleImageSource);
	}

	function test_zeroIdleKeepsMovingEvenWithSleepRolls() {
		const cat = createTemporaryObject(catComponent, this, { idleProbability: 0, speed: 1, idleRandom: () => 0.25, positionRandom: () => 0.5 });
		compare(cat.isIdle, false);
		idleSpy.target = cat;
		idleSpy.clear();
		const sprite = findChild(cat, 'catSprite');
		verify(waitForRendering(sprite));
		const position = sprite.mapToItem(cat, 0, 0);
		cat.targetPosition = Qt.point(200, 100);
		tryVerify(() => sprite.mapToItem(cat, 0, 0).x > position.x);
		wait(2200);
		compare(cat.isIdle, false);
		compare(idleSpy.count, 0);
	}

	function test_idleClockIgnoresWaypointsAndAllowsConsecutiveSleep() {
		let roll = 0.75;
		const cat = createTemporaryObject(catComponent, this, { idleProbability: 50, speed: 0.001, idleRandom: () => roll, positionRandom: () => 0.5 });
		compare(cat.isIdle, false);
		verify(waitForRendering(findChild(cat, 'catSprite')));
		cat.targetPosition = Qt.point(200, 100);
		roll = 0.25;
		tryCompare(cat, 'isIdle', true, 2700);
		const sprite = findChild(cat, 'catSprite');
		const position = sprite.mapToItem(cat, 0, 0);
		idleSpy.target = cat;
		idleSpy.clear();
		wait(2200);
		compare(cat.isIdle, true);
		compare(idleSpy.count, 0);
		compare(sprite.mapToItem(cat, 0, 0), position);
		roll = 0.75;
		tryCompare(cat, 'isIdle', false, 2700);
		compare(sprite.source, cat.imageSource);
	}

	function test_disableMovementDuringIdle() {
		const cat = createTemporaryObject(catComponent, this);
		compare(cat.isIdle, true);
		cat.enableMovement = false;
		compare(cat.isIdle, false);
		cat.enableMovement = true;
		compare(cat.isIdle, true);
	}

	function test_disableRandomIdleDuringIdle() {
		const cat = createTemporaryObject(catComponent, this);
		compare(cat.isIdle, true);
		cat.enableRandomIdle = false;
		compare(cat.isIdle, false);
		cat.enableRandomIdle = true;
		compare(cat.isIdle, true);
	}

	function test_idleImageOptInDisabledKeepsActiveImage() {
		const cat = createTemporaryObject(catComponent, this, { showIdleImage: false });
		compare(cat.isIdle, true);
		const sprite = findChild(cat, 'catSprite');
		compare(sprite.source, cat.imageSource);
	}

	function test_clickSignalEmitted_data() {
		return [{ tag: 'awake', idle: 0 }, { tag: 'asleep', idle: 100 }];
	}

	function test_clickSignalEmitted(data) {
		const cat = createTemporaryObject(catComponent, this, { idleProbability: data.idle, speed: 0.001 });
		compare(cat.isIdle, data.idle === 100);
		clickSpy.target = cat;
		clickSpy.clear();
		const sprite = findChild(cat, 'catSprite');
		verify(waitForRendering(sprite));
		mouseClick(sprite, sprite.width / 2, sprite.height / 2);
		compare(clickSpy.count, 1);
	}
}
