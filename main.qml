import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3

/**
 * Prototype of an ListView with some items - and we can create/update/delete them - with state saving.
 */
ApplicationWindow {
    id: main

    /**
     * The JSON string that is saved to the settings.
     */
    property string datastore: ""

    /**
     * Loads the model from the settings.
     */
    function loadModel() {
        if (datastore !== "") {
            dataModel.clear();
            console.log("Loading " + datastore);
            var datamodel = JSON.parse(datastore);
            for (var i = 0; i < datamodel.length; ++i) {
                dataModel.append(datamodel[i]);
            }
        }
    }

    /**
     * Saves the model to the settings.
     */
    function saveModel() {
        var datamodel = [];
        for (var i = 0; i < dataModel.count; ++i) {
            datamodel.push(dataModel.get(i));
        }
        datastore = JSON.stringify(datamodel);
    }

    /**
     * Adds a new item to the model.
     * Its value is random.
     */
    function addNewItem() {
        var num = Math.round(Math.random() * 10);
        dataModel.append({
            "exampleString": "test" + num,
            "exampleInt": num
        });
        console.log("Add new item " + num);
    }

    /**
     * Removes one item from the model.
     */
    function removeOneItem() {
        if (dataModel.count > 0) {
            dataModel.remove(0, 1);
        }
        console.log("Remove one item");
    }

    /**
     * Changes one item with some random data.
     */
    function changeOneItem() {
        if (dataModel.count > 0) {
            var index = Math.floor(Math.random() * dataModel.count);
            var num = Math.round(Math.random() * 10);
            dataModel.setProperty(index, "exampleInt", num);
            dataModel.setProperty(index, "exampleString", "test" + num);
        }
    }

    width: 640
    height: 480
    visible: true

    /**
     * At startup, load the model from the settings.
     */
    Component.onCompleted: {
        loadModel();
    }

    /**
     * Before closing the app properly, save the model to the settings.
     * TODO: We could periodically same it, just it case we close the app with an error.
     */
    onClosing: {
        saveModel();
    }

    /**
     * Settings for the state saving of the model as a JSON string.
     */
    Settings {
        property alias datastore: main.datastore
    }

    /**
     * Our layout contains the buttons to edit the list items and the list items themselves.
     */
    ColumnLayout {
        // We use the Layout.* properties to manage the positionning of our widgets, since we use the QtQuick.Layout types.
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: 10

        /**
         * Buttons to create/update/delete the items.
         */
        RowLayout {
            Button {
                text: qsTr("Add one")
                onClicked: {
                    addNewItem();
                }
            }
            Button {
                text: qsTr("Remove one")
                onClicked: {
                    removeOneItem();
                }
            }
            Button {
                text: qsTr("Change one")
                onClicked: {
                    changeOneItem();
                }
            }
        }

        /**
         * Shows the list items.
         */
        ScrollView {
            //width: parent.width
            // FIXME: We should be able to scroll within the flickable area of this ScrollView.
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ScrollBar.horizontal.interactive: false
            ScrollBar.vertical.interactive: true
            contentHeight: children[0].height
            contentWidth: children[0].width

            contentItem: ListView {
                height: childrenRect.height
                width: childrenRect.width

                model: ListModel {
                    id: dataModel

                    ListElement {
                        exampleString: "test1"
                        exampleInt: 1
                    }
                }
                delegate: ItemWidget {
                    someString: exampleString + " " + exampleInt
                }
            }
        }
    }
}
