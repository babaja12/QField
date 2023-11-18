import QtQuick 2.14
import QtQuick.Shapes 1.14

import Theme 1.0
import org.qfield 1.0
import org.qgis 1.0

RubberbandShape {
  id: rubberbandShape

  Shape {
    anchors.fill: parent
    ShapePath {
      strokeColor: rubberbandShape.outlineColor
      strokeWidth: rubberbandShape.lineWidth + 2
      strokeStyle: ShapePath.SolidLine
      fillColor: "transparent"
      joinStyle: ShapePath.RoundJoin
      capStyle: ShapePath.RoundCap

      PathPolyline { path: rubberbandShape.polyline }
    }
    ShapePath {
      strokeColor: rubberbandShape.color
      strokeWidth: rubberbandShape.lineWidth
      strokeStyle: ShapePath.SolidLine
      fillColor: rubberbandShape.polylineType === Qgis.GeometryType.Polygon
                 ? Qt.hsla(strokeColor.hslHue, strokeColor.hslSaturation, strokeColor.hslLightness, 0.25)
                 : "transparent"
      joinStyle: ShapePath.RoundJoin
      capStyle: ShapePath.RoundCap

      PathPolyline { path: rubberbandShape.polyline }
    }
  }
}
