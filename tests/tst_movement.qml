import QtQuick
import QtTest

TestCase {
	name: 'MovementConfiguration'
	when: windowShown

	function i18n(text) {
		return text;
	}

	function test_zeroIdleTimeCanBeLoadedWithoutClamping() {
		const component = Qt.createComponent('../package/contents/ui/config/configMovement.qml');
		const page = createTemporaryObject(component, this, { cfg_enableMovement: true, cfg_enableRandomIdle: true, cfg_idleProbability: 0 });
		verify(page !== null, component.errorString());
		compare(page.cfg_idleProbability, 0);
	}
}
