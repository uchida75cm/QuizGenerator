/**
 * Progression 4
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://progression.jp/
 * 
 * Progression Libraries is dual licensed under the "Progression Library License" and "GPL".
 * http://progression.jp/license
 */
package jp.progression.ui {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	import jp.nium.utils.StageUtil;
	
	/**
	 * <span lang="ja">ToolTip クラスは、基本的なツールチップを提供するクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class ToolTip implements IToolTip {
		
		/**
		 * <span lang="ja">インスタンスのクラス名を取得します。</span>
		 * <span lang="en">Indicates the instance className of the Command.</span>
		 */
		public function get className():String { return _classNameObj ? _classNameObj.toString() : ClassUtil.nium_internal::$DEFAULT_CLASS_NAME; }
		private var _classNameObj:StringObject;
		
		/**
		 * <span lang="ja">初期値となるツールチップのテキスト色を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #textColor
		 */
		public static function get defaultTextColor():uint { return _defaultTextColor; }
		public static function set defaultTextColor( value:uint ):void { _defaultTextColor = value; }
		private static var _defaultTextColor:uint = 0x000000;
		
		/**
		 * <span lang="ja">初期値となるツールチップの TextFormat を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #textFormat
		 */
		public static function get defaultTextFormat():TextFormat { return _defaultTextFormat; }
		public static function set defaultTextFormat( value:TextFormat ):void { _defaultTextFormat = value; }
		private static var _defaultTextFormat:TextFormat = ( function():TextFormat {
			var font:String = "_sans";
			
			switch ( Capabilities.language ) {
				case "ja"	: { font = "_ゴシック"; }
			}
			
			return new TextFormat( font, 12 );
		} )();
		
		/**
		 * <span lang="ja">初期値となるツールチップの背景色を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #backgroundColor
		 */
		public static function get defaultBackgroundColor():uint { return _defaultBackgroundColor; }
		public static function set defaultBackgroundColor( value:uint ):void { _defaultBackgroundColor = value; }
		private static var _defaultBackgroundColor:uint = 0xFFFFEE;
		
		/**
		 * <span lang="ja">初期値となるツールチップのボーダー色を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #borderColor
		 */
		public static function get defaultBorderColor():uint { return _defaultBorderColor; }
		public static function set defaultBorderColor( value:uint ):void { _defaultBorderColor = value; }
		private static var _defaultBorderColor:uint = 0x000000;
		
		/**
		 * <span lang="ja">初期値となるツールチップの最大幅を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #maxWidth
		 */
		public static function get defaultMaxWidth():Number { return _defaultMaxWidth; }
		public static function set defaultMaxWidth( value:Number ):void { _defaultMaxWidth = value; }
		private static var _defaultMaxWidth:Number = 200.0;
		
		/**
		 * <span lang="ja">初期値となるツールチップのフィルター設定を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #filters
		 */
		public static function get defaultFilters():Array { return _defaultFilters; }
		public static function set defaultFilters( value:Array ):void { _defaultFilters = value; }
		private static var _defaultFilters:Array;
		
		/**
		 * <span lang="ja">初期値となるツールチップを表示するまでの遅延時間をミリ秒で取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #delay
		 */
		public static function get defaultDelay():Number { return _defaultDelay; }
		public static function set defaultDelay( value:Number ):void { _defaultDelay = value; }
		private static var _defaultDelay:Number = 1.0;
		
		/**
		 * ToolTip インスタンスを取得します。
		 */
		private static var _current:ToolTip;
		
		/**
		 * Stage インスタンスを取得します。
		 */
		private static var _stage:Stage;
		
		/**
		 * TextField インスタンスを取得します。
		 */
		private static var _textField:TextField;
		
		/**
		 * Timer インスタンスを取得します。
		 */
		private static var _timer:Timer = new Timer( 0, 1 );
		
		/**
		 * 画面端から離す距離を取得します。
		 */
		private static var _padding:Number = 5;
		
		/**
		 * マウスの X 座標からずらすツールチップの距離を取得します。
		 */
		private static var _marginX:Number = 0;
		
		/**
		 * マウスの Y 座標からずらすツールチップの距離を取得します。
		 */
		private static var _marginY:Number = 0;
		
		/**
		 * マウスに追従する際の摩擦係数を取得します。
		 */
		private static var _friction:Number = 0.25;
		
		/**
		 * ツールチップに適用する DropShadowFilter フィルターを取得します。
		 */
		private static var _dropShadow:DropShadowFilter = new DropShadowFilter( 1, 45, 0x000000, 0.5, 4, 4, 1 );
		
		
		
		
		
		/**
		 * <span lang="ja">関連付けられている Sprite インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():Sprite { return _target; }
		private var _target:Sprite;
		
		/**
		 * <span lang="ja">ツールチップに表示するテキストを取得または設定します。
		 * この値が設定されていない状態では、ツールチップは表示されません。</span>
		 * <span lang="en"></span>
		 */
		public function get text():String { return _text; }
		public function set text( value:String ):void {
			if ( _text ) {
				// イベントリスナーを解除する
				_target.removeEventListener( MouseEvent.ROLL_OVER, _rollOver );
				_target.removeEventListener( MouseEvent.ROLL_OUT, _rollOut );
			}
			
			_text = value;
			
			if ( _text ) {
				// イベントリスナーを登録する
				_target.addEventListener( MouseEvent.ROLL_OVER, _rollOver );
			}
		}
		private var _text:String;
		
		/**
		 * <span lang="ja">ツールチップのテキスト色を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #defaultTextColor
		 */
		public function get textColor():uint { return _textFormat ? _textFormat.color as uint : 0; }
		public function set textColor( value:uint ):void {
			_textFormat ||= new TextFormat();
			_textFormat.color = value;
		}
		
		/**
		 * <span lang="ja">ツールチップに適用したい TextFormat を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #defaultTextFormat
		 */
		public function get textFormat():TextFormat { return _textFormat; }
		public function set textFormat( value:TextFormat ):void { _textFormat = value; }
		private var _textFormat:TextFormat;
		
		/**
		 * <span lang="ja">ツールチップの背景色を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #defaultBackgroundColor
		 */
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor( value:uint ):void { _backgroundColor = value; }
		private var _backgroundColor:uint;
		
		/**
		 * <span lang="ja">ツールチップのボーダー色を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #defaultBorderColor
		 */
		public function get borderColor():uint { return _borderColor; }
		public function set borderColor( value:uint ):void { _borderColor = value; }
		private var _borderColor:uint;
		
		/**
		 * <span lang="ja">ツールチップの最大幅を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #defaultMaxWidth
		 */
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth( value:Number ):void { _maxWidth = value; }
		private var _maxWidth:Number;
		
		/**
		 * <span lang="ja">ツールチップのフィルター設定を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #defaultFilters
		 */
		public function get filters():Array { return _filters;  }
		public function set filters( value:Array ):void { _filters = value; }
		private var _filters:Array;
		
		/**
		 * <span lang="ja">ツールチップを表示するまでの遅延時間を秒で取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #defaultDelay
		 */
		public function get delay():Number { return _delay; }
		public function set delay( value:Number ):void { _delay = value; }
		private var _delay:Number;
		
		
		
		
		
		/**
		 * 初期化する
		 */
		( function():void {
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, _timerComplete );
			
			// OS 毎にマージンを調整する
			switch ( true ) {
				case new RegExp( "^Windows" ).test( Capabilities.os )		: {
					_marginX = 5;
					_marginY = 22;
					break;
				}
				case new RegExp( "^Mac OS" ).test( Capabilities.os )		: {
					_marginX = 5;
					_marginY = 12;
					break;
				}
			}
		} )();
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ToolTip インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ToolTip object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい Sprite インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function ToolTip( target:Sprite ) {
			// クラスをコンパイルに含める
			nium_internal;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
			
			// 引数を設定する
			_target = target;
			
			// 初期化する
			_textFormat = _defaultTextFormat;
			_backgroundColor = _defaultBackgroundColor;
			_borderColor = _defaultBorderColor;
			_maxWidth = _defaultMaxWidth;
			_filters = _defaultFilters ? _defaultFilters.slice() : null;
			_delay = _defaultDelay;
			
			// 親クラスを初期化する
			super();
		}
		
		
		
		
		
		/**
		 * <span lang="ja">表示されている ToolTip を強制的に消去します。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function remove():void {
			if ( _current ) {
				_current._rollOut( null );
			}
		}
		
		
		
		
		
		/**
		 * <span lang="ja">保持しているデータを解放します。
		 * dispose() メソッドが呼び出されると、それ以降はこのインスタンスのメソッドまたはプロパティを呼び出すと失敗し、例外がスローされます。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			// イベントリスナーを解除する
			_target.removeEventListener( MouseEvent.ROLL_OUT, _rollOut );
			
			if ( _stage ) {
				_stage.removeEventListener( Event.ENTER_FRAME, _enterFrame );
				_stage.removeEventListener( Event.RESIZE, _resize );
				_stage.removeEventListener( MouseEvent.MOUSE_DOWN, _mouseKeyDown );
				_stage.removeEventListener( KeyboardEvent.KEY_DOWN, _mouseKeyDown );
			}
			
			// データを破棄する
			_target = null;
			_filters = null;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		public function toString():String {
			return ObjectUtil.formatToString( this, _classNameObj.toString(), "text", "textColor", "backgroundColor", "borderColor", "maxWidth", "delay" );
		}
		
		
		
		
		
		/**
		 * Timer.repeatCount で設定された数の要求が完了するたびに送出されます。
		 */
		private static function _timerComplete( e:TimerEvent ):void {
			// すでに表示されていれば削除する
			if ( _textField ) {
				_textField.parent.removeChild( _textField );
				_textField = null;
			}
			
			// TextField を作成する
			_textField = new TextField();
			_textField.defaultTextFormat = _current._textFormat;
			_textField.text = _current._text;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.background = true;
			_textField.backgroundColor = _current._backgroundColor;
			_textField.border = true;
			_textField.borderColor = _current._borderColor;
			_textField.mouseEnabled = false;
			_textField.multiline = true;
			_textField.selectable = false;
			_textField.wordWrap = true;
			_textField.filters = [ _dropShadow ].concat( _current._filters || [] );
			
			// 位置を補正する
			_textField.x = _stage.mouseX + _marginX;
			_textField.y = _stage.mouseY + _marginY;
			_textField.x = Math.min( _stage.stageWidth - StageUtil.getMarginLeft( _stage ) - _textField.width - _padding, _textField.x );
			_textField.y = Math.min( _stage.stageHeight - StageUtil.getMarginTop( _stage ) - _textField.height - _padding * 3, _textField.y );
			
			// イベントリスナーを登録する
			_stage.addEventListener( Event.ENTER_FRAME, _enterFrame );
			_stage.addEventListener( Event.RESIZE, _resize );
			
			// イベントを実行する
			_resize( null );
			
			// 初期位置を設定する
			_textField.x = Math.min( _stage.stageWidth - StageUtil.getMarginLeft( _stage ) - _textField.width - _padding, _stage.mouseX + _marginX );
			_textField.y = Math.min( _stage.stageHeight - StageUtil.getMarginTop( _stage ) - _textField.height - _padding * 3, _stage.mouseY + _marginY );
			
			// 画面に表示する
			_stage.addChild( _textField );
		}
		
		/**
		 * 再生ヘッドが新しいフレームに入るときに送出されます。
		 */
		private static function _enterFrame( e:Event ):void {
			// 移動先の位置を取得します。
			var x:Number = _stage.mouseX + _marginX;
			var y:Number = _stage.mouseY + _marginY;
			
			// ステージからはみ出ている場合に補正する
			x = Math.min( _stage.stageWidth - StageUtil.getMarginLeft( _stage ) - _textField.width - _padding, x );
			y = Math.min( _stage.stageHeight - StageUtil.getMarginTop( _stage ) - _textField.height - _padding * 3, y );
			
			// マウスを追従する
			_textField.x += ( x - _textField.x ) * _friction;
			_textField.y += ( y - _textField.y ) * _friction;
		}
		
		/**
		 * 
		 */
		private static function _resize( e:Event ):void {
			_textField.wordWrap = false;
			
			// サイズを補正する
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.width = Math.min( _textField.width + 2, _current._maxWidth, _stage.stageWidth - _padding * 2 );
			
			_textField.wordWrap = true;
		}
		
		/**
		 * Flash Player ウィンドウの InteractiveObject インスタンスの上でユーザーがポインティングデバイスのボタンを押すと送出されます。
		 */
		private static function _mouseKeyDown( e:Event ):void {
			// イベントリスナーを解除する
			_stage.removeEventListener( Event.ENTER_FRAME, _enterFrame );
			_stage.removeEventListener( Event.RESIZE, _resize );
			_stage.removeEventListener( MouseEvent.MOUSE_DOWN, _mouseKeyDown );
			
			// タイマーを停止する
			_timer.stop();
			
			// すでに表示されていれば削除する
			if ( _textField ) {
				_textField.parent.removeChild( _textField );
				_textField = null;
			}
		}
		
		/**
		 * ユーザーが InteractiveObject インスタンスにポインティングデバイスを合わせたときに送出されます。
		 */
		private function _rollOver( e:MouseEvent ):void {
			// イベントリスナーを解除する
			_target.removeEventListener( MouseEvent.ROLL_OVER, _rollOver );
			
			// 現在のツールチップを設定する
			_current = this;
			_stage ||= _target.stage;
			
			// タイマーを開始する
			_timer.reset();
			_timer.delay = _delay * 1000;
			_timer.start();
			
			// イベントリスナーを登録する
			_target.addEventListener( MouseEvent.ROLL_OUT, _rollOut );
			_stage.addEventListener( MouseEvent.MOUSE_DOWN, _mouseKeyDown );
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, _mouseKeyDown );
		}
		
		/**
		 * ユーザーが InteractiveObject インスタンスからポインティングデバイスを離したときに送出されます。
		 */
		private function _rollOut( e:MouseEvent ):void {
			// イベントリスナーを解除する
			_target.removeEventListener( MouseEvent.ROLL_OUT, _rollOut );
			_stage.removeEventListener( Event.ENTER_FRAME, _enterFrame );
			_stage.removeEventListener( Event.RESIZE, _resize );
			_stage.removeEventListener( MouseEvent.MOUSE_DOWN, _mouseKeyDown );
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, _mouseKeyDown );
			
			// タイマーを停止する
			_timer.stop();
			
			// すでに表示されていれば削除する
			if ( _textField ) {
				_textField.parent.removeChild( _textField );
				_textField = null;
			}
			
			// 現在のツールチップを破棄する
			_current = null;
			
			// イベントリスナーを登録する
			_target.addEventListener( MouseEvent.ROLL_OVER, _rollOver );
		}
	}
}
