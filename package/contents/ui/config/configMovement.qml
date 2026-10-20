import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Page {
	id: movementPage
	title: i18n('Movement')

	property alias cfg_enableMovement: enableMovementCheckBox.checked
	property alias cfg_speed: speedSlider.value
	property alias cfg_enableRandomIdle: enableRandomIdleCheckBox.checked
	property alias cfg_idleProbability: idleProbabilitySpinBox.value
	property alias cfg_enableFlipping: enableFlippingCheckBox.checked

	property bool cfg_enableMovementDefault: true
	property double cfg_speedDefault: 1.3
	property bool cfg_enableRandomIdleDefault: false
	property int cfg_idleProbabilityDefault: 13
	property bool cfg_enableFlippingDefault: true

	function restoreDefaults() {
		cfg_enableMovement = cfg_enableMovementDefault;
		cfg_speed = cfg_speedDefault;
		cfg_enableRandomIdle = cfg_enableRandomIdleDefault;
		cfg_idleProbability = cfg_idleProbabilityDefault;
		cfg_enableFlipping = cfg_enableFlippingDefault;
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: Kirigami.Units.smallSpacing

		Kirigami.FormLayout {
			Layout.fillWidth: true

			CheckBox {
				id: enableMovementCheckBox
				Kirigami.FormData.label: i18n('Overall Movement:')
				text: i18n('Enabled')
				checked: movementPage.cfg_enableMovementDefault
			}

			RowLayout {
				Kirigami.FormData.label: i18n('Speed:')
				Layout.fillWidth: true

				Slider {
					id: speedSlider
					Layout.fillWidth: true
					from: 0.5
					to: 10.0
					stepSize: 0.1
					value: movementPage.cfg_speedDefault
					enabled: enableMovementCheckBox.checked
				}

				Label {
					text: `${speedSlider.value.toFixed(1)}×`
					Layout.minimumWidth: Kirigami.Theme.defaultFont.pointSize * 6
					horizontalAlignment: Text.AlignRight
				}
			}

			CheckBox {
				id: enableRandomIdleCheckBox
				Kirigami.FormData.label: i18n('Random Idle:')
				text: i18n('Enabled')
				checked: movementPage.cfg_enableRandomIdleDefault
				enabled: enableMovementCheckBox.checked
			}

			SpinBox {
				id: idleProbabilitySpinBox
				Kirigami.FormData.label: i18n('Idle time (%):')
				from: 0
				to: 100
				value: movementPage.cfg_idleProbabilityDefault
				enabled: enableMovementCheckBox.checked && enableRandomIdleCheckBox.checked

				Layout.fillWidth: true
				Layout.maximumWidth: Kirigami.Units.gridUnit * 10
			}

			Label {
				Layout.fillWidth: true
				Layout.maximumWidth: Kirigami.Units.gridUnit * 22
				text: i18n('Approximate time spent idling. 0% keeps moving; 100% stays idle.')
				wrapMode: Text.WordWrap
			}

			CheckBox {
				id: enableFlippingCheckBox
				Kirigami.FormData.label: i18n('Image Flipping Based on the Direction:')
				text: i18n('Enabled')
				checked: movementPage.cfg_enableFlippingDefault
				enabled: enableMovementCheckBox.checked
			}

			Button {
				id: restoreDefaultsButton
				objectName: 'restoreDefaultsButton'
				text: i18n('Restore Defaults')
				icon.name: 'edit-undo'
				onClicked: movementPage.restoreDefaults()
			}
		}

		Item {
			Layout.fillHeight: true
		}
	}
}
