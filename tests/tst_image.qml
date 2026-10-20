import QtQuick
import QtTest

TestCase {
	name: 'ImageConfiguration'
	when: windowShown
	visible: true
	width: 600
	height: 340

	function i18n(text) {
		return text;
	}

	function test_idleControlsRemainReachableInShortDialog() {
		const component = Qt.createComponent('../package/contents/ui/config/configImage.qml');
		const page = createTemporaryObject(component, this, { width: 600, height: 340, cfg_showIdleImage: true });
		verify(page !== null, component.errorString());
		const restore = findChild(page, 'restoreDefaultsButton');
		verify(waitForRendering(page));
		mouseWheel(page, page.width / 2, page.height / 2, 0, -1440);
		tryVerify(() => {
			const position = restore.mapToItem(page, 0, 0);
			return position.y >= 0 && position.y + restore.height <= page.height;
		}, 1500);

		tryCompare(page.flickable, 'moving', false);
		verify(waitForRendering(restore));
		mouseClick(restore, restore.width / 2, restore.height / 2);
		compare(page.cfg_showIdleImage, false);
	}
}
