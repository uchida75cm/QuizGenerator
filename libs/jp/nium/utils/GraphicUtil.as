/**
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 * 
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.utils {
	import flash.display.Sprite;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * <span lang="ja">GraphicUtil クラスは、グラフィック描画操作のためのユーティリティクラスです。</span>
	 * <span lang="en"></span>
	 */
	public final class GraphicUtil {
		
		/**
		 * @private
		 */
		public function GraphicUtil() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">円を描画します。</span>
		 * <span lang="en">Draws a circle.</span>
		 * 
		 * @param target
		 * <span lang="ja">描画対象となる Sprite です。</span>
		 * <span lang="en"></span>
		 * @param color
		 * <span lang="ja">描画する色です。</span>
		 * <span lang="en"></span>
		 * @param alpha
		 * <span lang="ja">描画するアルファです。</span>
		 * <span lang="en"></span>
		 * @param x
		 * <span lang="ja">親表示オブジェクトの基準点からの円の中心の相対 x 座標（ピクセル単位）です。</span>
		 * <span lang="en">The x location of the center of the circle relative to the registration point of the parent display object (in pixels).</span>
		 * @param y
		 * <span lang="ja">親表示オブジェクトの基準点からの円の中心の相対 y 座標（ピクセル単位）です。</span>
		 * <span lang="en">The y location of the center of the circle relative to the registration point of the parent display object (in pixels).</span>
		 * @param radius
		 * <span lang="ja">円の半径（ピクセル単位）です。</span>
		 * <span lang="en">The radius of the circle (in pixels).</span>
		 * @return
		 * <span lang="en">target パラメータで渡す Sprite インスタンスです。</span>
		 * <span lang="en">The Sprite instance that you pass in the target parameter.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function drawCircle( target:Sprite, color:int = -1, alpha:Number = 1.0, x:Number = 0.0, y:Number = 0.0, radius:Number = 100.0 ):Sprite {
			if ( color < 0 ) {
				color = int( 0xFFFFFF * Math.random() );
			}
			
			target.graphics.beginFill( color, alpha );
			target.graphics.drawCircle( x, y, radius );
			target.graphics.endFill();
			
			return target;
		}
		
		/**
		 * <span lang="ja">楕円を描画します。</span>
		 * <span lang="en">Draws an ellipse.</span>
		 * 
		 * @param target
		 * <span lang="ja">描画対象となる Sprite です。</span>
		 * <span lang="en"></span>
		 * @param color
		 * <span lang="ja">描画する色です。</span>
		 * <span lang="en"></span>
		 * @param alpha
		 * <span lang="ja">描画するアルファです。</span>
		 * <span lang="en"></span>
		 * @param x
		 * <span lang="ja">親表示オブジェクトの基準点からの楕円の境界ボックスの左上の相対 x 座標（ピクセル単位）です。</span>
		 * <span lang="en">The x location of the top-left of the bounding-box of the ellipse relative to the registration point of the parent display object (in pixels).</span>
		 * @param y
		 * <span lang="ja">親表示オブジェクトの基準点からの楕円の境界ボックスの左上の相対 y 座標（ピクセル単位）です。</span>
		 * <span lang="en">The y location of the top left of the bounding-box of the ellipse relative to the registration point of the parent display object (in pixels).</span>
		 * @param width
		 * <span lang="ja">楕円の幅（ピクセル単位）です。</span>
		 * <span lang="en">The width of the ellipse (in pixels).</span>
		 * @param height
		 * <span lang="ja">楕円の高さ（ピクセル単位）です。</span>
		 * <span lang="en">The height of the ellipse (in pixels).</span>
		 * @return
		 * <span lang="en">target パラメータで渡す Sprite インスタンスです。</span>
		 * <span lang="en">The Sprite instance that you pass in the target parameter.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function drawEllipse( target:Sprite, color:int = -1, alpha:Number = 1.0, x:Number = 0.0, y:Number = 0.0, width:Number = 100.0, height:Number = 100.0 ):Sprite {
			if ( color < 0 ) {
				color = int( 0xFFFFFF * Math.random() );
			}
			
			target.graphics.beginFill( color, alpha );
			target.graphics.drawEllipse( x, y, width, height );
			target.graphics.endFill();
			
			return target;
		}
		
		/**
		 * <span lang="ja">矩形を描画します。</span>
		 * <span lang="en">Draws a rectangle.</span>
		 * 
		 * @param target
		 * <span lang="ja">描画対象となる Sprite です。</span>
		 * <span lang="en"></span>
		 * @param color
		 * <span lang="ja">描画する色です。</span>
		 * <span lang="en"></span>
		 * @param alpha
		 * <span lang="ja">描画するアルファです。</span>
		 * <span lang="en"></span>
		 * @param x
		 * <span lang="ja">親表示オブジェクトの基準点からの相対的な水平座標を示す数値（ピクセル単位）です。</span>
		 * <span lang="en">A number indicating the horizontal position relative to the registration point of the parent display object (in pixels).</span>
		 * @param y
		 * <span lang="ja">親表示オブジェクトの基準点からの相対的な垂直座標を示す数値（ピクセル単位）です。</span>
		 * <span lang="en">A number indicating the vertical position relative to the registration point of the parent display object (in pixels).</span>
		 * @param width
		 * <span lang="ja">矩形の幅（ピクセル単位）です。</span>
		 * <span lang="en">The width of the rectangle (in pixels).</span>
		 * @param height
		 * <span lang="ja">矩形の高さ（ピクセル単位）です。</span>
		 * <span lang="en">The height of the rectangle (in pixels).</span>
		 * @return
		 * <span lang="en">target パラメータで渡す Sprite インスタンスです。</span>
		 * <span lang="en">The Sprite instance that you pass in the target parameter.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function drawRect( target:Sprite, color:int = -1, alpha:Number = 1.0, x:Number = 0.0, y:Number = 0.0, width:Number = 100.0, height:Number = 100.0 ):Sprite {
			if ( color < 0 ) {
				color = int( 0xFFFFFF * Math.random() );
			}
			
			target.graphics.beginFill( color, alpha );
			target.graphics.drawRect( x, y, width, height );
			target.graphics.endFill();
			
			return target;
		}
		
		/**
		 * <span lang="ja">角丸矩形を描画します。</span>
		 * <span lang="en">Draws a rounded rectangle.</span>
		 * 
		 * @param target
		 * <span lang="ja">描画対象となる Sprite です。</span>
		 * <span lang="en"></span>
		 * @param color
		 * <span lang="ja">描画する色です。</span>
		 * <span lang="en"></span>
		 * @param alpha
		 * <span lang="ja">描画するアルファです。</span>
		 * <span lang="en"></span>
		 * @param x
		 * <span lang="ja">親表示オブジェクトの基準点からの相対的な水平座標を示す数値（ピクセル単位）です。</span>
		 * <span lang="en">A number indicating the horizontal position relative to the registration point of the parent display object (in pixels).</span>
		 * @param y
		 * <span lang="ja">親表示オブジェクトの基準点からの相対的な垂直座標を示す数値（ピクセル単位）です。</span>
		 * <span lang="en">A number indicating the vertical position relative to the registration point of the parent display object (in pixels).</span>
		 * @param width
		 * <span lang="ja">角丸矩形の幅（ピクセル単位）です。</span>
		 * <span lang="en">The width of the round rectangle (in pixels).</span>
		 * @param height
		 * <span lang="ja">角丸矩形の高さ（ピクセル単位）です。</span>
		 * <span lang="en">The height of the round rectangle (in pixels).</span>
		 * @param ellipseWidth
		 * <span lang="ja">丸角の描画に使用される楕円の幅（ピクセル単位）です。</span>
		 * <span lang="en">The width of the ellipse used to draw the rounded corners (in pixels).</span>
		 * @param ellipseHeight
		 * <span lang="ja">丸角の描画に使用される楕円の高さ（ピクセル単位）。
		 * （オプション）値を指定しない場合は、ellipseWidth パラメータに指定された値がデフォルトで適用されます。</span>
		 * <span lang="en">The height of the ellipse used to draw the rounded corners (in pixels).
		 * Optional; if no value is specified, the default value matches that provided for the ellipseWidth parameter.</span>
		 * @return
		 * <span lang="en">target パラメータで渡す Sprite インスタンスです。</span>
		 * <span lang="en">The Sprite instance that you pass in the target parameter.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function drawRoundRect( target:Sprite, color:int = -1, alpha:Number = 1.0, x:Number = 0.0, y:Number = 0.0, width:Number = 100.0, height:Number = 100.0, ellipseWidth:Number = 20.0, ellipseHeight:Number = NaN ):Sprite {
			if ( color < 0 ) {
				color = int( 0xFFFFFF * Math.random() );
			}
			
			target.graphics.beginFill( color, alpha );
			target.graphics.drawRoundRect( x, y, width, height, ellipseWidth, ellipseHeight );
			target.graphics.endFill();
			
			return target;
		}
		
		/**
		 * <span lang="ja">角丸矩形を描画します。</span>
		 * <span lang="en">Draws a rounded rectangle.</span>
		 * 
		 * @param target
		 * <span lang="ja">描画対象となる Sprite です。</span>
		 * <span lang="en"></span>
		 * @param color
		 * <span lang="ja">描画する色です。</span>
		 * <span lang="en"></span>
		 * @param alpha
		 * <span lang="ja">描画するアルファです。</span>
		 * <span lang="en"></span>
		 * @param x
		 * <span lang="ja">親表示オブジェクトの基準点からの相対的な水平座標を示す数値（ピクセル単位）です。</span>
		 * <span lang="en">A number indicating the horizontal position relative to the registration point of the parent display object (in pixels).</span>
		 * @param y
		 * <span lang="ja">親表示オブジェクトの基準点からの相対的な垂直座標を示す数値（ピクセル単位）です。</span>
		 * <span lang="en">A number indicating the vertical position relative to the registration point of the parent display object (in pixels).</span>
		 * @param width
		 * <span lang="ja">角丸矩形の幅（ピクセル単位）です。</span>
		 * <span lang="en">The width of the round rectangle (in pixels).</span>
		 * @param height
		 * <span lang="ja">角丸矩形の高さ（ピクセル単位）です。</span>
		 * <span lang="en">The height of the round rectangle (in pixels).</span>
		 * @param topLeftRadius
		 * <span lang="ja">左上の楕円サイズです。</span>
		 * <span lang="en"></span>
		 * @param topRightRadius
		 * <span lang="ja">右上の楕円サイズです。</span>
		 * <span lang="en"></span>
		 * @param bottomLeftRadius
		 * <span lang="ja">左下の楕円サイズです。</span>
		 * <span lang="en"></span>
		 * @param bottomRightRadius
		 * <span lang="ja">右下の楕円サイズです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="en">target パラメータで渡す Sprite インスタンスです。</span>
		 * <span lang="en">The Sprite instance that you pass in the target parameter.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function drawRoundRectComplex( target:Sprite, color:int = -1, alpha:Number = 1.0, x:Number = 0.0, y:Number = 0.0, width:Number = 100.0, height:Number = 100.0, topLeftRadius:Number = 10.0, topRightRadius:Number = 10.0, bottomLeftRadius:Number = 10.0, bottomRightRadius:Number = 10.0 ):Sprite {
			if ( color < 0 ) {
				color = int( 0xFFFFFF * Math.random() );
			}
			
			target.graphics.beginFill( color, alpha );
			target.graphics.drawRoundRectComplex( x, y, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius );
			target.graphics.endFill();
			
			return target;
		}
	}
}
