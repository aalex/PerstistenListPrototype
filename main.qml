import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3

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

    function changeOneItem() {
        if (dataModel.count > 0) {
            var index = Math.floor(Math.random() * dataModel.count);
            var value = Math.round(Math.random() * 10);
            dataModel.setProperty(index, "exampleInt", value);
        }
    }

    width: 640
    height: 480
    visible: true

    Component.onCompleted: {
        loadModel();
    }

    onClosing: {
        saveModel();
    }

    Settings {
        property alias datastore: main.datastore
    }


    ColumnLayout {
        anchors.fill: parent

        ScrollView {
            width: parent.width
            height: children[0].height > 400 ? 400 : children[0].height
            clip: true

            contentItem: ListView {
                //width: container.width
                height: childrenRect.height
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
    }
}
