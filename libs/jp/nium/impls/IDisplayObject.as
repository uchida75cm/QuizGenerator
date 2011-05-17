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
package jp.nium.impls {
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	/**
	 * <span lang="ja">IDisplayObject インターフェイスは、対象に対して DisplayObject として必要となる機能を実装します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public interface IDisplayObject extends IEventDispatcher {
		
		/**
		 * <span lang="ja">この表示オブジェクトの現在のアクセシビリティオプションです。</span>
		 * <span lang="en">The current accessibility options for this display object.</span>
		 */
		function get accessibilityProperties():AccessibilityProperties;
		function set accessibilityProperties( value:AccessibilityProperties ):void;
		
		/**
		 * <span lang="ja">指定されたオブジェクトのアルファ透明度値を示します。</span>
		 * <span lang="en">Indicates the alpha transparency value of the object specified.</span>
		 */
		function get alpha():Number;
		function set alpha( value:Number ):void;
		
		/**
		 * <span lang="ja">使用するブレンドモードを指定する BlendMode クラスの値です。</span>
		 * <span lang="en">A value from the BlendMode class that specifies which blend mode to use.</span>
		 */
		function get blendMode():String;
		function set blendMode( value:String ):void;
		
		/**
		 * <span lang="ja">true に設定されている場合、表示オブジェクトの内部ビットマップ表現が Flash Player にキャッシュされます。</span>
		 * <span lang="en">If set to true, Flash Player or Adobe AIR caches an internal bitmap representation of the display object.</span>
		 */
		function get cacheAsBitmap():Boolean;
		function set cacheAsBitmap( value:Boolean ):void;
		
		/**
		 * <span lang="ja">表示オブジェクトに現在関連付けられている各フィルタオブジェクトが保存されているインデックス付きの配列です。</span>
		 * <span lang="en">An indexed array that contains each filter object currently associated with the display object.</span>
		 */
		function get filters():Array;
		function set filters( value:Array ):void;
		
		/**
		 * <span lang="ja">表示オブジェクトの高さを示します (ピクセル単位)。</span>
		 * <span lang="en">Indicates the height of the display object, in pixels.</span>
		 */
		function get height():Number;
		function set height( value:Number ):void;
		
		/**
		 * <span lang="ja">この表示オブジェクトが属するファイルのロード情報を含む LoaderInfo オブジェクトを返します。</span>
		 * <span lang="en">Returns a LoaderInfo object containing information about loading the file to which this display object belongs.</span>
		 */
		function get loaderInfo():LoaderInfo;
		
		/**
		 * <span lang="ja">呼び出し元の表示オブジェクトは、指定された mask オブジェクトによってマスクされます。</span>
		 * <span lang="en">The calling display object is masked by the specified mask object.</span>
		 */
		function get mask():DisplayObject;
		function set mask( value:DisplayObject ):void;
		
		/**
		 * <span lang="ja">マウス位置の x 座標を示します (ピクセル単位)。</span>
		 * <span lang="en">Indicates the x coordinate of the mouse position, in pixels.</span>
		 */
		function get mouseX():Number;
		
		/**
		 * <span lang="ja">マウス位置の y 座標を示します (ピクセル単位)。</span>
		 * <span lang="en">Indicates the y coordinate of the mouse position, in pixels.</span>
		 */
		function get mouseY():Number;
		
		/**
		 * <span lang="ja">DisplayObject のインスタンス名を示します。</span>
		 * <span lang="en">Indicates the instance name of the DisplayObject.</span>
		 */
		function get name():String;
		function set name( value:String ):void;
		
		/**
		 * <span lang="ja">表示オブジェクトが特定の背景色で不透明であるかどうかを指定します。</span>
		 * <span lang="en">Specifies whether the display object is opaque with a certain background color.</span>
		 */
		function get opaqueBackground():Object;
		function set opaqueBackground( value:Object ):void;
		
		/**
		 * <span lang="ja">この表示オブジェクトを含む DisplayObjectContainer オブジェクトを示します。</span>
		 * <span lang="en">Indicates the DisplayObjectContainer object that contains this display object.</span>
		 */
		function get parent():DisplayObjectContainer;
		
		/**
		 * <span lang="ja">ロードされた SWF ファイル内の表示オブジェクトの場合、root プロパティはその SWF ファイルが表す表示リストのツリー構造部分の一番上にある表示オブジェクトとなります。</span>
		 * <span lang="en">For a display object in a loaded SWF file, the root property is the top-most display object in the portion of the display list's tree structure represented by that SWF file.</span>
		 */
		function get root():DisplayObject;
		
		/**
		 * <span lang="ja">DisplayObject インスタンスの元の位置からの回転角を度単位で示します。</span>
		 * <span lang="en">Indicates the rotation of the DisplayObject instance, in degrees, from its original orientation.</span>
		 */
		function get rotation():Number;
		function set rotation( value:Number ):void;
		
		/**
		 * <span lang="ja">現在有効な拡大 / 縮小グリッドです。</span>
		 * <span lang="en">The current scaling grid that is in effect.</span>
		 */
		function get scale9Grid():Rectangle;
		function set scale9Grid( value:Rectangle ):void;
		
		/**
		 * <span lang="ja">基準点から適用されるオブジェクトの水平スケール (percentage) を示します。</span>
		 * <span lang="en">Indicates the horizontal scale (percentage) of the object as applied from the registration point.</span>
		 */
		function get scaleX():Number;
		function set scaleX( value:Number ):void;
		
		/**
		 * <span lang="ja">オブジェクトの基準点から適用されるオブジェクトの垂直スケール (percentage) を示します。</span>
		 * <span lang="en">Indicates the vertical scale (percentage) of an object as applied from the registration point of the object.</span>
		 */
		function get scaleY():Number;
		function set scaleY( value:Number ):void;
		
		/**
		 * <span lang="ja">表示オブジェクトのスクロール矩形の境界です。</span>
		 * <span lang="en">The scroll rectangle bounds of the display object.</span>
		 */
		function get scrollRect():Rectangle;
		function set scrollRect( value:Rectangle ):void;
		
		/**
		 * <span lang="ja">表示オブジェクトのステージです。</span>
		 * <span lang="en">The Stage of the display object.</span>
		 */
		function get stage():Stage;
		
		/**
		 * <span lang="ja">表示オブジェクトのマトリックス、カラー変換、ピクセル境界に関係するプロパティを持つオブジェクトです。</span>
		 * <span lang="en">An object with properties pertaining to a display object's matrix, color transform, and pixel bounds.</span>
		 */
		function get transform():Transform;
		function set transform( value:Transform ):void;
		
		/**
		 * <span lang="ja">表示オブジェクトが可視かどうかを示します。</span>
		 * <span lang="en">Whether or not the display object is visible.</span>
		 */
		function get visible():Boolean;
		function set visible( value:Boolean ):void;
		
		/**
		 * <span lang="ja">表示オブジェクトの幅を示します (ピクセル単位)。</span>
		 * <span lang="en">Indicates the width of the display object, in pixels.</span>
		 */
		function get width():Number;
		function set width( value:Number ):void;
		
		/**
		 * <span lang="ja">親 DisplayObjectContainer のローカル座標を基準にした DisplayObject インスタンスの x 座標を示します。</span>
		 * <span lang="en">Indicates the x coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer.</span>
		 */
		function get x():Number;
		function set x( value:Number ):void;
		
		/**
		 * <span lang="ja">親 DisplayObjectContainer のローカル座標を基準にした DisplayObject インスタンスの y 座標を示します。</span>
		 * <span lang="en">Indicates the y coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer.</span>
		 */
		function get y():Number;
		function set y( value:Number ):void;
		
		
		
		
		
		/**
		 * <span lang="ja">targetCoordinateSpace オブジェクトの座標系を基準にして、表示オブジェクトの領域を定義する矩形を返します。</span>
		 * <span lang="en">Returns a rectangle that defines the area of the display object relative to the coordinate system of the targetCoordinateSpace object.</span>
		 * 
		 * @param targetCoordinateSpace
		 * <span lang="ja">使用する座標系を定義する表示オブジェクトです。</span>
		 * <span lang="en">The display object that defines the coordinate system to use.</span>
		 * @return
		 * <span lang="en">targetCoordinateSpace オブジェクトの座標系を基準とする、表示オブジェクトの領域を定義する矩形です。</span>
		 * <span lang="en">The rectangle that defines the area of the display object relative to the targetCoordinateSpace object's coordinate system.</span>
		 */
		function getBounds( targetCoordinateSpace:DisplayObject ):Rectangle;
		
		/**
		 * <span lang="ja">シェイプ上の線を除き、targetCoordinateSpace パラメータによって定義された座標系に基づいて、表示オブジェクトの境界を定義する矩形を返します。</span>
		 * <span lang="en">Returns a rectangle that defines the boundary of the display object, based on the coordinate system defined by the targetCoordinateSpace parameter, excluding any strokes on shapes.</span>
		 * 
		 * @param targetCoordinateSpace
		 * <span lang="ja">使用する座標系を定義する表示オブジェクトです。</span>
		 * <span lang="en">The display object that defines the coordinate system to use.</span>
		 * @return
		 * <span lang="en">targetCoordinateSpace オブジェクトの座標系を基準とする、表示オブジェクトの領域を定義する矩形です。</span>
		 * <span lang="en">The rectangle that defines the area of the display object relative to the targetCoordinateSpace object's coordinate system.</span>
		 */
		function getRect( targetCoordinateSpace:DisplayObject ):Rectangle;
		
		/**
		 * <span lang="ja">point オブジェクトをステージ (グローバル) 座標から表示オブジェクトの (ローカル) 座標に変換します。</span>
		 * <span lang="en">Converts the point object from the Stage (global) coordinates to the display object's (local) coordinates.</span>
		 * 
		 * @param point
		 * <span lang="en">Point クラスを使って作成されるオブジェクトです。Point オブジェクトは、x および y 座標をプロパティとして指定します。</span>
		 * <span lang="en">An object created with the Point class. The Point object specifies the x and y coordinates as properties.</span>
		 * @return
		 * <span lang="ja">表示オブジェクトからの相対座標を持つ Point オブジェクトです。</span>
		 * <span lang="en">A Point object with coordinates relative to the display object.</span>
		 */
		function globalToLocal( point:Point ):Point;
		
		/**
		 * <span lang="ja">表示オブジェクトを評価して、obj 表示オブジェクトと重複または交差するかどうかを調べます。</span>
		 * <span lang="en">Evaluates the display object to see if it overlaps or intersects with the obj display object.</span>
		 * 
		 * @param obj
		 * <span lang="ja">検査の対象となる表示オブジェクトです。</span>
		 * <span lang="en">The display object to test against.</span>
		 * @return
		 * <span lang="ja">表示オブジェクトが交差する場合は true、そうでない場合は false です。</span>
		 * <span lang="en">true if the display objects intersect; false if not.</span>
		 */
		function hitTestObject( obj:DisplayObject ):Boolean;
		
		/**
		 * <span lang="ja">表示オブジェクトを評価して、x および y パラメータで指定されたポイントと重複または交差するかどうかを調べます。</span>
		 * <span lang="en">Evaluates the display object to see if it overlaps or intersects with the point specified by the x and y parameters.</span>
		 * 
		 * @param x
		 * <span lang="ja">このオブジェクトの検査の基準となる x 座標です。</span>
		 * <span lang="en">The x coordinate to test against this object.</span>
		 * @param y
		 * <span lang="ja">このオブジェクトの検査の基準となる y 座標です。</span>
		 * <span lang="en">The y coordinate to test against this object.</span>
		 * @param shapeFlag
		 * <span lang="ja">オブジェクトの実際のピクセルと比較して検査する場合は true、境界ボックスと比較して検査する場合は false です。</span>
		 * <span lang="en">Whether to check against the actual pixels of the object (true) or the bounding box (false).</span>
		 * @return
		 * <span lang="ja">指定されたポイントと表示オブジェクトが重複または交差する場合は true、そうでなければ false です。</span>
		 * <span lang="en">true if the display object overlaps or intersects with the specified point; false otherwise.</span>
		 */
		function hitTestPoint( x:Number, y:Number, shapeFlag:Boolean = false ):Boolean;
		
		/**
		 * <span lang="ja">point オブジェクトを表示オブジェクトの (ローカル) 座標からステージ (グローバル) 座標に変換します。</span>
		 * <span lang="en">Converts the point object from the display object's (local) coordinates to the Stage (global) coordinates.</span>
		 * 
		 * @param point
		 * <span lang="en">Point クラスを使用し、x および y 座標をプロパティとして指定して作成されるポイントの名前または識別子です。</span>
		 * <span lang="en">The name or identifier of a point created with the Point class, specifying the x and y coordinates as properties.</span>
		 * @return
		 * <span lang="ja">ステージからの相対座標を持つ Point オブジェクトです。</span>
		 * <span lang="en">A Point object with coordinates relative to the Stage.</span>
		 */
		function localToGlobal( point:Point ):Point;
	}
}
