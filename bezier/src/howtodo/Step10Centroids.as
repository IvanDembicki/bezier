package howtodo {
	import flash.events.Event;
	import flash.geom.Point;
	
	import howtodo.view.PointView;	

	/**
	 * @author ivan.dembicki@gmail.com
	 */
	public class Step10Centroids extends BezierUsage {
		
		private static const DESCRIPTION:String = "<B>Centroids</B>";
		
		protected var internalCentroid:PointView = new PointView();
		protected var externalCentroid:PointView = new PointView();
		protected var triangleCentroid:PointView = new PointView();
		
		protected var midPoint:PointView = new PointView();
		
		
		public function Step10Centroids() {
			super();
			initInstance();
		}
		
		private function initInstance() : void {
			initDescription(DESCRIPTION);
			
			initCentroid(internalCentroid, "Oi");
			initCentroid(externalCentroid, "Oe");
			initCentroid(triangleCentroid, "Ot");
			initCentroid(midPoint, "M");
			
			onPointMoved();
		}
		
		private function initCentroid(centroid:PointView, pointName:String) : void {
			centroid.pointName = pointName;
			addChild(centroid);
		}

		private function redraw ():void {
			graphics.clear();
			graphics.lineStyle(0, 0x0000FF, 1);
			drawBezier(bezier);
		}
		
		override protected function onPointMoved(event:Event=undefined):void {
			midPoint.position = Point.interpolate(bezier.start, bezier.end, 1/2);
			
			internalCentroid.position = bezier.internalCentroid;
			externalCentroid.position = bezier.externalCentroid;
			
			triangleCentroid.position = Point.interpolate(internalCentroid.position, externalCentroid.position, 2/3);
			
			redraw();
		}

		
		
	}
}
