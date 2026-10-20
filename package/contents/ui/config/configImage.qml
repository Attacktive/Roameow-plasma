import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore
import org.kde.kirigami as Kirigami
import "../../code/MediaPaths.js" as MediaPaths

Kirigami.ScrollablePage {
	id: imagePage
	title: i18n('Image')

	property alias cfg_imageSize: imageSizeSpinBox.value
	property string cfg_defaultImage: cfg_defaultImageDefault
	property alias cfg_customImagePath: customImageField.text
	property alias cfg_mirrorImage: mirrorImageCheckBox.checked
	property alias cfg_showIdleImage: showIdleImageCheckBox.checked
	property alias cfg_customIdleImagePath: customIdleImageField.text

	property int cfg_imageSizeDefault: 128
	property string cfg_defaultImageDefault: 'nyancat'
	property string cfg_customImagePathDefault: ''
	property bool cfg_mirrorImageDefault: false
	property bool cfg_showIdleImageDefault: false
	property string cfg_customIdleImagePathDefault: ''

	readonly property var defaultImages: [
		{ value: 'nyancat', label: 'Nyan Cat', image: '../../images/nyancat.gif' },
		{ value: 'tacnayn', label: 'Tac Nayn', image: '../../images/tacnayn.gif' }
	]

	function restoreDefaults() {
		cfg_imageSize = cfg_imageSizeDefault;
		cfg_defaultImage = cfg_defaultImageDefault;
		cfg_customImagePath = cfg_customImagePathDefault;
		cfg_mirrorImage = cfg_mirrorImageDefault;
		cfg_showIdleImage = cfg_showIdleImageDefault;
		cfg_customIdleImagePath = cfg_customIdleImagePathDefault;
	}

	FileDialog {
		id: activeFileDialog
		title: i18n('Choose an image file')
		currentFolder: {
			if (imagePage.cfg_customImagePath.length > 0) {
				const resolved = MediaPaths.source(imagePage.cfg_customImagePath, '');
				const lastSlash = resolved.lastIndexOf('/');
				if (lastSlash > 'file://'.length) {
					return resolved.substring(0, lastSlash);
				}
			}

			return StandardPaths.writableLocation(StandardPaths.HomeLocation);
		}
		nameFilters: [`${i18n('Image files')} (*.png *.jpg *.jpeg *.gif *.svg)`]
		onAccepted: {
			imagePage.cfg_customImagePath = selectedFile.toString();
		}
	}

	FileDialog {
		id: idleFileDialog
		title: i18n('Choose an idle image file')
		currentFolder: {
			if (imagePage.cfg_customIdleImagePath.length > 0) {
				const resolved = MediaPaths.source(imagePage.cfg_customIdleImagePath, '');
				const lastSlash = resolved.lastIndexOf('/');
				if (lastSlash > 'file://'.length) {
					return resolved.substring(0, lastSlash);
				}
			}

			return StandardPaths.writableLocation(StandardPaths.HomeLocation);
		}
		nameFilters: [`${i18n('Image files')} (*.png *.jpg *.jpeg *.gif *.svg)`]
		onAccepted: {
			imagePage.cfg_customIdleImagePath = selectedFile.toString();
		}
	}

	ColumnLayout {
		width: parent.width
		spacing: Kirigami.Units.smallSpacing

		Kirigami.FormLayout {
			Layout.fillWidth: true

			SpinBox {
				id: imageSizeSpinBox
				Kirigami.FormData.label: i18n('Image size:')
				from: 32
				to: 512
				stepSize: 1
				value: imagePage.cfg_imageSizeDefault
			}

			ComboBox {
				id: defaultImageCombo
				Kirigami.FormData.label: i18n('Built-in image:')
				model: imagePage.defaultImages
				textRole: 'label'
				valueRole: 'value'
				currentIndex: Math.max(0, imagePage.defaultImages.findIndex(({ value }) => value === imagePage.cfg_defaultImage))

				onActivated: {
					imagePage.cfg_defaultImage = currentValue;
				}
			}

			Kirigami.ActionTextField {
				id: customImageField
				Kirigami.FormData.label: i18n('Custom image:')
				placeholderText: i18n('Leave empty for built-in image')
				text: imagePage.cfg_customImagePathDefault
				Layout.fillWidth: true

				readonly property var fileOpeningAction: Kirigami.Action {
					icon.name: 'document-open'
					tooltip: i18n('Choose image file')
					onTriggered: activeFileDialog.open()
				}

				readonly property var clearAction: Kirigami.Action {
					icon.name: 'edit-clear'
					tooltip: i18n('Clear')
					visible: customImageField.text.length > 0
					onTriggered: customImageField.text = ''
				}

				rightActions: [fileOpeningAction, clearAction]
			}

			RowLayout {
				id: activePreviewContainer

				readonly property url imagePath: {
					if (customImageField.text.length > 0) {
						return MediaPaths.source(customImageField.text, '');
					}

					const selected = imagePage.defaultImages.find(({ value }) => value === imagePage.cfg_defaultImage);
					if (selected && selected.image) {
						return selected.image;
					}

					return '../../images/nyancat.gif';
				}

				AnimatedImage {
					id: activePreview
					objectName: 'activeImagePreview'
					Layout.preferredWidth: 200
					Layout.preferredHeight: 200
					source: activePreviewContainer.imagePath
					playing: true
					mirror: imagePage.cfg_mirrorImage
					visible: status !== AnimatedImage.Error

					onStatusChanged: {
						playing = (status === AnimatedImage.Ready);
					}
				}
			}

			Kirigami.InlineMessage {
				id: activeImageErrorNotice
				objectName: 'activeImageErrorMessage'
				Layout.fillWidth: true
				type: Kirigami.MessageType.Error
				visible: customImageField.text.length > 0 && activePreview.status === AnimatedImage.Error
				text: i18n('Failed to load custom image. Please choose another file or reset to the built-in image.')
				actions: [
					Kirigami.Action {
						text: i18n('Choose File…')
						icon.name: 'document-open'
						onTriggered: activeFileDialog.open()
					},
					Kirigami.Action {
						text: i18n('Use Built-in Image')
						icon.name: 'edit-undo'
						onTriggered: customImageField.text = ''
					}
				]
			}

			CheckBox {
				id: showIdleImageCheckBox
				checked: imagePage.cfg_showIdleImageDefault
				Kirigami.FormData.label: i18n('Idle Image:')
				text: i18n('Show a different image while idling')
			}

			Kirigami.ActionTextField {
				id: customIdleImageField
				Kirigami.FormData.label: i18n('Custom idle image:')
				placeholderText: i18n('Leave empty for built-in sleeping cat')
				text: imagePage.cfg_customIdleImagePathDefault
				enabled: showIdleImageCheckBox.checked
				Layout.fillWidth: true

				readonly property var fileOpeningAction: Kirigami.Action {
					icon.name: 'document-open'
					tooltip: i18n('Choose idle image file')
					enabled: showIdleImageCheckBox.checked
					onTriggered: idleFileDialog.open()
				}

				readonly property var clearAction: Kirigami.Action {
					icon.name: 'edit-clear'
					tooltip: i18n('Clear')
					visible: customIdleImageField.text.length > 0
					enabled: showIdleImageCheckBox.checked
					onTriggered: customIdleImageField.text = ''
				}

				rightActions: [fileOpeningAction, clearAction]
			}

			RowLayout {
				id: idlePreviewContainer
				visible: showIdleImageCheckBox.checked

				readonly property url imagePath: {
					if (customIdleImageField.text.length > 0) {
						return MediaPaths.source(customIdleImageField.text, '');
					}

					return '../../images/sleepingcat.svg';
				}

				AnimatedImage {
					id: idlePreview
					objectName: 'idleImagePreview'
					Layout.preferredWidth: 200
					Layout.preferredHeight: 200
					source: idlePreviewContainer.imagePath
					playing: true
					mirror: imagePage.cfg_mirrorImage
					visible: status !== AnimatedImage.Error

					onStatusChanged: {
						playing = (status === AnimatedImage.Ready);
					}
				}
			}

			Kirigami.InlineMessage {
				id: idleImageErrorNotice
				objectName: 'idleImageErrorMessage'
				Layout.fillWidth: true
				type: Kirigami.MessageType.Error
				visible: showIdleImageCheckBox.checked && customIdleImageField.text.length > 0 && idlePreview.status === AnimatedImage.Error
				text: i18n('Failed to load custom idle image. Please choose another file or reset to the built-in image.')
				actions: [
					Kirigami.Action {
						text: i18n('Choose File…')
						icon.name: 'document-open'
						onTriggered: idleFileDialog.open()
					},
					Kirigami.Action {
						text: i18n('Use Built-in Image')
						icon.name: 'edit-undo'
						onTriggered: customIdleImageField.text = ''
					}
				]
			}

			CheckBox {
				id: mirrorImageCheckBox
				checked: imagePage.cfg_mirrorImageDefault
				Kirigami.FormData.label: i18n('Mirror Image:')
			}

			Button {
				id: restoreDefaultsButton
				objectName: 'restoreDefaultsButton'
				text: i18n('Restore Defaults')
				icon.name: 'edit-undo'
				onClicked: imagePage.restoreDefaults()
			}
		}
	}
}
