import QtQuick
import QtTest

TestCase {
	name: 'ImageConfiguration'
	when: windowShown
	visible: true
	width: 600
	height: 900

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

	function test_idlePoseFollowsBuiltInCharacter() {
		const component = Qt.createComponent('../package/contents/ui/config/configImage.qml');
		const page = createTemporaryObject(component, this, { width: 600, height: 850, cfg_showIdleImage: true, cfg_defaultImage: 'tacnayn' });
		const preview = findChild(page, 'idleImagePreview');
		verify(preview.source.toString().endsWith('/sleepingtacnayn.svg'));
		tryCompare(preview, 'status', Image.Ready);
		page.cfg_defaultImage = 'nyancat';
		verify(preview.source.toString().endsWith('/sleepingcat.svg'));
		tryCompare(preview, 'status', Image.Ready);
	}

	function test_customIdleOverridesBuiltInCharacter() {
		const component = Qt.createComponent('../package/contents/ui/config/configImage.qml');
		const custom = Qt.resolvedUrl('../package/contents/images/tacnayn.gif').toString();
		const page = createTemporaryObject(component, this, { width: 600, height: 850, cfg_showIdleImage: true, cfg_customIdleImagePath: custom });
		const preview = findChild(page, 'idleImagePreview');
		page.cfg_defaultImage = 'tacnayn';
		compare(preview.source.toString(), custom);
		tryCompare(preview, 'status', Image.Ready);
		page.cfg_showIdleImage = false;
		compare(page.cfg_customIdleImagePath, custom);
		page.cfg_showIdleImage = true;
		compare(preview.source.toString(), custom);
	}

	function findPathField(item, text) {
		if ('readOnly' in item && 'text' in item && item.text === text) {
			return item;
		}

		for (const child of item.children || []) {
			const match = findPathField(child, text);
			if (match) {
				return match;
			}
		}

		return null;
	}

	function test_pathsCannotBeChangedByTyping_data() {
		return [
			{ tag: 'active', key: 'cfg_customImagePath', image: 'nyancat.gif' },
			{ tag: 'idle', key: 'cfg_customIdleImagePath', image: 'tacnayn.gif' }
		];
	}

	function test_pathsCannotBeChangedByTyping(data) {
		const component = Qt.createComponent('../package/contents/ui/config/configImage.qml');
		const selected = Qt.resolvedUrl(`../package/contents/images/${data.image}`).toString();
		const properties = { width: 600, height: 850, cfg_showIdleImage: true };
		properties[data.key] = selected;
		const page = createTemporaryObject(component, this, properties);
		const field = findPathField(page, selected);
		verify(field !== null);
		field.forceActiveFocus();
		keyClick(Qt.Key_A, Qt.ControlModifier);
		keyClick(Qt.Key_X);
		compare(page[data.key], selected);
	}
}
