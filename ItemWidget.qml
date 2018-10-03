import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

/**
 * Widget to display each item in our list.
 */
RowLayout {
    id: root

    property bool someBool: false
    property int someInt: 0
    property string someString: ""
    property real someFloat: 0.0

    Label {
        text: someBool ? "true": "false"
    }

    Label {
        text: "" + someInt
    }

    Label {
        text: someString
    }

    Label {
        text: "" + someFloat
    }
}
