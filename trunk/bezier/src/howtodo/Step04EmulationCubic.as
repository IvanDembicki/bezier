package howtodo {
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Bezier;
	import flash.geom.Line;
	import flash.geom.Point;
	
	import howtodo.assets.PointView;
	
	public class Step04EmulationCubic extends BezierUsage {
		
		private static const DESCRIPTION:String = "Press Space button for enable/disable Cubic Bezier"
		
		private var controlS:PointView = new PointView();
		private var controlE:PointView = new PointView();
		
		private var q_start:PointView=new PointView();
		private var q_mid:PointView=new PointView();
		private var q_end:PointView=new PointView();
		
		private var cubicEnabled:Boolean=true;
		
		/**
		 * @example
		 * Псевдо трехмерная кривая Безье.<BR/>
		 * <table width="100%" border=1><td>
		 * 	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		 *			id="Step1Building" width="100%" height="500"
		 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
		 *			<param name="movie" value="../images/Step04EmulationCubic.swf" />
		 *			<param name="quality" value="high" />
		 *			<param name="bgcolor" value="#FFFFFF" />
		 *			<param name="allowScriptAccess" value="sameDomain" />
		 *			<embed src="../images/Step04EmulationCubic.swf" quality="high" bgcolor="#FFFFFF"
		 *				width="100%" height="400" name="Step1Building"
		 * 				align="middle"
		 *				play="true"
		 *				loop="false"
		 *				quality="high"
		 *				allowScriptAccess="sameDomain"
		 *				type="application/x-shockwave-flash"
		 *				pluginspage="http://www.adobe.com/go/getflashplayer">
		 *			</embed>
		 *	</object>
		 * </td></table>
		 * <BR/>
		 * <I>
		 * Нажмите клавишу "пробел", чтобы включить/выключить отображение кривой Безье третьего порядка.
		 * </I>
		 **/

	
		public function Step04EmulationCubic():void {
			super();
		}
		
		override protected function init():void {
			super.init();
			
			initDescription(DESCRIPTION);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			cubicEnabled = false;
			
			initControl(controlS, 0xCCCCCC);
			initControl(controlE, 0xCCCCCC);
			
			removeChild(control);
			
			onPointMoved();
		}
		
		
		
		protected function onKeyUp(event:KeyboardEvent):void {
			if (event.keyCode == 32) {
				cubicEnabled = !cubicEnabled;
				onPointMoved();
			}
		}
		
		override protected function onPointMoved(event:Event=undefined):void {
			graphics.clear();
			if (cubicEnabled) {
				graphics.lineStyle(0, 0xFF0000, 1);
				drawCubic();
			}
			graphics.lineStyle(0, 0xFF0000, .3);
			var ss:Line = new Line(start.point, controlS.point);
			var ee:Line = new Line(end.point, controlE.point);
			drawLine(ss);
			drawLine(ee);
			
			recalcQuadratic();
		}
		
		private function recalcQuadratic():void {
			graphics.lineStyle(0, 0x00FFFF, 0.5);
			var sc:Point = Point.interpolate(controlS.point, start.point, 3/4);
			var ec:Point = Point.interpolate(controlE.point, end.point, 3/4);
			
			
//			graphics.moveTo(sc.x, sc.y);
//			graphics.lineTo(ec.x, ec.y);
			
			q_start.position = sc;
			q_end.position = ec;
			
			q_mid.x = (sc.x + ec.x)/2;
			q_mid.y = (sc.y + ec.y)/2;
			
//			sc = Point.interpolate(q_mid.point, sc, 1/4);
//			ec = Point.interpolate(q_mid.point, ec, 1/4);
			
			var first_bezier:Bezier = new Bezier(start.point, sc, q_mid.point);
			var second_bezier:Bezier = new Bezier(q_mid.point, ec, end.point);
			
			graphics.lineStyle(0, 0x0000FF, 1);
			drawBezier(first_bezier);
			graphics.lineStyle(0, 0xFF0000, 1);
			drawBezier(second_bezier);
			
			
		}
		
		
		private function drawCubic():void {
			graphics.moveTo(start.x, start.y);
			graphics.lineStyle(0, 0xFF00FF, 1);
			var t:uint = 0;
			var s:Point = start.point;
			var cs:Point = controlS.point;
			var ce:Point = controlE.point;
			var e:Point = end.point;
			
			while (t++ <100) {
				var point:Point = getCubicPoint(t/100, s, cs, ce, e);
				graphics.lineTo(point.x, point.y);
			}
			// getCubicTangent(.5, s, cs, ce, e);
		}
		
		
		private function getCubicTangent(time:Number, start:Point, controlS:Point, controlE:Point, end:Point):Line {
			var s:Line = new Line(start, controlS); 
			var e:Line = new Line(controlE, end); 
			var m:Line = new Line(controlS, controlE);
			
			var sm:Line = new Line(s.getPoint(time), m.getPoint(time));
			var me:Line = new Line(m.getPoint(time), e.getPoint(time));
			
			var tangent:Line = new Line(sm.getPoint(time), me.getPoint(time), false);
			
			graphics.lineStyle(0,0,.2);
			drawLine(tangent.getSegment(-1, 2));
			
			return tangent;
		}
		
		private function getCubicPoint (time:Number, start:Point, controlS:Point, controlE:Point, end:Point):Point {
			var cx:Number = 3 * (controlS.x - start.x);
			var bx:Number = 3 * (controlE.x - controlS.x) - cx;
			var ax:Number = end.x - start.x - cx - bx;
	
			var cy:Number = 3 * (controlS.y - start.y);
			var by:Number = 3 * (controlE.y - controlS.y) - cy;
			var ay:Number = end.y - start.y - cy - by;
	
			var tSquared:Number = time * time;
			var tCubed:Number = tSquared * time;
	
			var point:Point = new Point();
	
			point.x = (ax * tCubed) + (bx * tSquared) + (cx * time) + start.x;
			point.y = (ay * tCubed) + (by * tSquared) + (cy * time) + start.y;
	 
			return point;
		}
		
	
	}
}
