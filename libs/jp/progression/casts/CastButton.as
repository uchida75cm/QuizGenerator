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
package jp.progression.casts {
	import flash.accessibility.Accessibility;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import jp.nium.collections.UniqueList;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.display.ExMovieClip;
	import jp.nium.events.CollectionEvent;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.impls.ICastButton;
	import jp.progression.core.impls.IDisposable;
	import jp.progression.core.impls.IManageable;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.events.CastEvent;
	import jp.progression.events.CastMouseEvent;
	import jp.progression.events.ExecuteEvent;
	import jp.progression.events.ManagerEvent;
	import jp.progression.events.ProcessEvent;
	import jp.progression.executors.ExecutorObject;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneId;
	import jp.progression.ui.IToolTip;
	
	/**
	 * <span lang="ja">IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_ADDED
	 */
	[Event( name="castAdded", type="jp.progression.events.CastEvent" )]
	
	/**
	 * <span lang="ja">CastEvent.CAST_ADDED イベント中に実行された非同期処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_ADDED_COMPLETE
	 */
	[Event( name="castAddedComplete", type="jp.progression.events.CastEvent" )]
	
	/**
	 * <span lang="ja">IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_REMOVED
	 */
	[Event( name="castRemoved", type="jp.progression.events.CastEvent" )]
	
	/**
	 * <span lang="ja">CastEvent.CAST_REMOVED イベント中に実行された非同期処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastEvent.CAST_REMOVED_COMPLETE
	 */
	[Event( name="castRemovedComplete", type="jp.progression.events.CastEvent" )]
	
	/**
	 * <span lang="ja">ボタンの状態が変更された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_STATE_CHANGE
	 */
	[Event( name="castStateChange", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">ボタンが移動処理を開始する直前に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_NAVIGATE_BEFORE
	 */
	[Event( name="castNavigateBefore", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">Flash Player ウィンドウの CastButton インスタンスの上でユーザーがポインティングデバイスのボタンを押すと送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_MOUSE_DOWN
	 */
	[Event( name="castMouseDown", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">CastMouseEvent.CAST_MOUSE_DOWN イベント中に実行された非同期処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_MOUSE_DOWN_COMPLETE
	 */
	[Event( name="castMouseDownComplete", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_MOUSE_UP
	 */
	[Event( name="castMouseUp", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">CastMouseEvent.CAST_MOUSE_UP イベント中に実行された非同期処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_MOUSE_UP_COMPLETE
	 */
	[Event( name="castMouseUpComplete", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">ユーザーが CastButton インスタンスにポインティングデバイスを合わせたときに送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_ROLL_OVER
	 */
	[Event( name="castRollOver", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">CastMouseEvent.CAST_ROLL_OVER イベント中に実行された非同期処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_ROLL_OVER_COMPLETE
	 */
	[Event( name="castRollOverComplete", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
	 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_ROLL_OUT
	 */
	[Event( name="castRollOut", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">CastMouseEvent.CAST_ROLL_OUT イベント中に実行された非同期処理が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.CastMouseEvent.CAST_ROLL_OUT_COMPLETE
	 */
	[Event( name="castRollOutComplete", type="jp.progression.events.CastMouseEvent" )]
	
	/**
	 * <span lang="ja">Progression インスタンスとの関連付けがアクティブになったときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ManagerEvent.MANAGER_ACTIVATE
	 */
	[Event( name="managerActivate", type="jp.progression.events.ManagerEvent" )]
	
	/**
	 * <span lang="ja">Progression インスタンスとの関連付けが非アクティブになったときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ManagerEvent.MANAGER_DEACTIVATE
	 */
	[Event( name="managerDeactivate", type="jp.progression.events.ManagerEvent" )]
	
	/**
	 * <span lang="ja">非同期処理中にエラーが発生した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteErrorEvent.EXECUTE_ERROR
	 */
	[Event( name="executeError", type="jp.progression.events.ExecuteErrorEvent" )]
	
	/**
	 * <span lang="ja">CastButton クラスは、ExMovieClip クラスの基本機能を拡張し、ボタン機能とイベントフローとの連携機能を実装した jp.progression パッケージで使用される基本的な表示オブジェクトクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts#getInstanceById()
	 * @see jp.progression.casts#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * // CastButton インスタンスを作成する
	 * var cast:CastButton = new CastButton();
	 * cast.graphics.beginFill( 0x000000 );
	 * cast.graphics.drawRect( 0, 0, 100, 100 );
	 * cast.graphics.endFill();
	 * 
	 * // クリック時の移動先を設定する
	 * cast.sceneId = new SceneId( "/index" );
	 * 
	 * // 画面設置時のイベントを設定する
	 * cast.onCastAdded = function():void {
	 * 	trace( "表示されました" );
	 * };
	 * cast.onCastRemoved = function():void {
	 * 	trace( "消去されました" );
	 * };
	 * 
	 * // SerialList コマンドを実行する
	 * new SerialList( null,
	 * 	// 画面に表示する
	 * 	new AddChild( this, cast ),
	 * 	
	 * 	// 画面から消去する
	 * 	new RemoveChild( this, cast )
	 * ).execute();
	 * </listing>
	 */
	public class CastButton extends ExMovieClip implements ICastButton, IManageable {
		
		/**
		 * <span lang="ja">現在、ステージ上に設置されているボタンを含む配列を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get activatedButtons():Array { return _activatedButtons.toArray(); }
		private static var _activatedButtons:UniqueList = new UniqueList();
		
		/**
		 * アクセスキーを判別する正規表現を取得します。
		 */
		private static const _ACCESS_KEY_REGEXP:String = "^[a-z]?$";
		
		/**
		 * Stage の参照を取得します。
		 */
		private static var _stage:Stage;
		
		
		
		
		
		/**
		 * <span lang="ja">ボタンがクリックされた時の移動先を示すシーン識別子を取得または設定します。
		 * sceneId プロパティと href プロパティが両方とも設定されている場合には、href プロパティの設定が優先されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #href
		 * @see #windowTarget
		 * @see #navigateTo()
		 */
		public function get sceneId():SceneId { return _sceneId; }
		public function set sceneId( value:SceneId ):void {
			// NaS を設定しようとしたら
			if ( SceneId.isNaS( value ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_019 ).toString() ); }
			
			// 移動先が変更されていなければ終了する
			if ( _sceneId && value && _sceneId.equals( value ) ) { return; }
			
			// 更新する
			_sceneId = value;
			
			// 移動先が設定されていれば、ボタンを有効化する
			if ( _href || _sceneId ) {
				super.buttonMode = true;
			}
			else {
				super.buttonMode = false;
			}
			
			// 更新する
			_collectionUpdate( null );
		}
		private var _sceneId:SceneId;
		
		/**
		 * <span lang="ja">ボタンがクリックされた時の移動先の URL を取得または設定します。
		 * sceneId プロパティと href プロパティが両方とも設定されている場合には、href プロパティの設定が優先されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see #windowTarget
		 * @see #navigateTo()
		 */
		public function get href():String { return _href; }
		public function set href( value:String ):void {
			_href = value;
			
			// 移動先が設定されていれば、ボタンを有効化する
			if ( _href || _sceneId ) {
				super.buttonMode = true;
			}
			else {
				super.buttonMode = false;
			}
		}
		private var _href:String;
		
		/**
		 * <span lang="ja">ボタンがクリックされた時の移動先を開くウィンドウ名を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see #href
		 * @see #navigateTo()
		 * @see jp.progression.casts.CastButtonWindowTarget
		 */
		public function get windowTarget():String { return _windowTarget; }
		public function set windowTarget( value:String ):void { _windowTarget = value; }
		private var _windowTarget:String;
		
		/**
		 * <span lang="ja">ボタンの機能をキーボードから使用するためのアクセスキーを取得または設定します。
		 * 設定できるキーはアルファベットの A ～ Z までの値です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see #href
		 * @see #windowTarget
		 * @see #navigateTo()
		 */
		public function get accessKey():String { return _accessKey; }
		public function set accessKey( value:String ):void {
			if ( !new RegExp( _ACCESS_KEY_REGEXP, "i" ).test( value ) ) { new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_003 ).toString( "accessKey" ) ); }
			
			_accessKey = value;
			
			// アクセシビリティ補助がサポートされていなければ終了する
			if ( !Capabilities.hasAccessibility ) { return; }
			
			// AccessibilityProperties を更新する
			if ( _accessKey ) {
				super.accessibilityProperties = super.accessibilityProperties || new AccessibilityProperties();
				super.accessibilityProperties.shortcut = value;
			}
			
			// アクティブであれば更新する
			if ( Accessibility.active ) {
				Accessibility.updateProperties();
			}
		}
		private var _accessKey:String;
		
		/**
		 * <span lang="ja">マウス状態に応じて Executor を使用した処理を行うかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get mouseEventEnabled():Boolean { return _mouseEventEnabled; }
		public function set mouseEventEnabled( value:Boolean ):void { _mouseEventEnabled = value; }
		private var _mouseEventEnabled:Boolean = true;
		
		/**
		 * <span lang="ja">CastButton インスタンスにポインティングデバイスが合わされているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get isRollOver():Boolean { return _isRollOver; }
		private var _isRollOver:Boolean = false;
		
		/**
		 * <span lang="ja">CastButton インスタンスでポインティングデバイスのボタンを押されているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get isMouseDown():Boolean { return _isMouseDown; }
		private var _isMouseDown:Boolean = false;
		
		/**
		 * <span lang="ja">ボタンの状態を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see jp.progression.casts.CastButtonState
		 */
		public function get state():int { return _state; }
		private var _state:int = -1;
		
		/**
		 * <span lang="ja">自身の参照を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get self():CastButton { return CastButton( this ); }
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get manager():Progression { return _managerFromSceneId || _manager; }
		private var _manager:Progression;
		private var _managerFromSceneId:Progression;
		
		/**
		 * <span lang="ja">関連付けられている ExecutorObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #onCastMouseDown
		 * @see #onCastMouseUp
		 * @see #onCastRollOver
		 * @see #onCastRollOut
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 */
		public function get executor():ExecutorObject { return _executor; }
		private var _executor:ExecutorObject;
		
		/**
		 * <span lang="ja">このスプライトのボタンモードを指定します。</span>
		 * <span lang="en">Specifies the button mode of this sprite.</span>
		 */
		override public function get buttonMode():Boolean { return super.buttonMode; }
		override public function set buttonMode( value:Boolean ):void {
			super.buttonMode = value;
			
			_processScene( null );
		}
		
		/**
		 * マウスダウン/アップイベントを処理する ExecutorObject を取得します。
		 */
		private var _mouseDownUpExecutor:ExecutorObject;
		
		/**
		 * ロールオーバー/アウトイベントを処理する ExecutorObject を取得します。
		 */
		private var _rollOverOutExecutor:ExecutorObject;
		
		/**
		 * CTRL キー、または Shift キーが押されていたかどうかを取得します。
		 */
		private var _isDownCTRLorShiftKey:Boolean = false;
		
		/**
		 * マウスダウン / アップイベント発生時の MouseEvent オブジェクトを取得します。
		 */
		private var _mouseDownUpEvent:MouseEvent;
		
		/**
		 * ロールオーバー / アウトイベント発生時の MouseEvent オブジェクトを取得します。
		 */
		private var _rollOverOutEvent:MouseEvent;
		
		/**
		 * 現在処理中のイベントオブジェクトを保持した配列を取得します。
		 */
		private var _events:Array;
		
		/**
		 * <span lang="ja">関連付けられている IToolTip インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get toolTip():IToolTip {
			if ( _toolTip ) { return _toolTip; }
			
			try {
				var cls:Class = Progression.config.toolTipRenderer;
				_toolTip = new cls( this );
			}
			catch ( err:Error ) {
				if ( PackageInfo.hasDebugger ) {
					Logger.warn( Logger.getLog( L10NProgressionMsg.getInstance().WARN_003 ).toString( this, "toolTip" ) );
				}
			}
			
			return _toolTip;
		}
		public function set toolTip( value:IToolTip ):void {
			if ( _toolTip ) {
				_toolTip.dispose();
			}
			
			_toolTip = value;
		}
		private var _toolTip:IToolTip;
		
		/**
		 * 親の表示オブジェクトの参照を取得します。
		 */
		private var _parent:DisplayObjectContainer;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastEvent.CAST_ADDED イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastEvent#CAST_ADDED
		 * @see jp.progression.events.CastEvent#CAST_ADDED_COMPLETE
		 */
		public function get onCastAdded():Function { return _onCastAdded; }
		public function set onCastAdded( value:Function ):void { _onCastAdded = value; }
		private var _onCastAdded:Function;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastEvent.CAST_ADDED イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastEvent#CAST_ADDED
		 * @see jp.progression.events.CastEvent#CAST_ADDED_COMPLETE
		 */
		protected function atCastAdded():void {}
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastEvent.CAST_REMOVED イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastEvent#CAST_REMOVED
		 * @see jp.progression.events.CastEvent#CAST_REMOVED_COMPLETE
		 */
		public function get onCastRemoved():Function { return _onCastRemoved; }
		public function set onCastRemoved( value:Function ):void { _onCastRemoved = value; }
		private var _onCastRemoved:Function;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastEvent.CAST_REMOVED イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastEvent#CAST_REMOVED
		 * @see jp.progression.events.CastEvent#CAST_REMOVED_COMPLETE
		 */
		protected function atCastRemoved():void {}
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastMouseEvent.CAST_MOUSE_DOWN イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastMouseEvent#CAST_MOUSE_DOWN
		 */
		public function get onCastMouseDown():Function { return _onCastMouseDown; }
		public function set onCastMouseDown( value:Function ):void { _onCastMouseDown = value; }
		private var _onCastMouseDown:Function;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastMouseEvent.CAST_MOUSE_DOWN イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドで。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastMouseEvent#CAST_MOUSE_DOWN
		 */
		protected function atCastMouseDown():void {}
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastMouseEvent.CAST_MOUSE_UP イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastMouseEvent#CAST_MOUSE_UP
		 */
		public function get onCastMouseUp():Function { return _onCastMouseUp; }
		public function set onCastMouseUp( value:Function ):void { _onCastMouseUp = value; }
		private var _onCastMouseUp:Function;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastMouseEvent.CAST_MOUSE_UP イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastMouseEvent#CAST_MOUSE_UP
		 */
		protected function atCastMouseUp():void {}
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastMouseEvent.CAST_ROLL_OVER イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastMouseEvent#CAST_ROLL_OVER
		 */
		public function get onCastRollOver():Function { return _onCastRollOver; }
		public function set onCastRollOver( value:Function ):void { _onCastRollOver = value; }
		private var _onCastRollOver:Function;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastMouseEvent.CAST_ROLL_OVER イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastMouseEvent#CAST_ROLL_OVER
		 */
		protected function atCastRollOver():void {}
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastMouseEvent.CAST_ROLL_OUT イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastMouseEvent#CAST_ROLL_OUT
		 */
		public function get onCastRollOut():Function { return _onCastRollOut; }
		public function set onCastRollOut( value:Function ):void { _onCastRollOut = value; }
		private var _onCastRollOut:Function;
		
		/**
		 * <span lang="ja">キャストオブジェクトが CastMouseEvent.CAST_ROLL_OUT イベントを受け取った場合に呼び出されるオーバーライド・イベントハンドラメソッドです。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #addCommand()
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * @see jp.progression.events.CastMouseEvent#CAST_ROLL_OUT
		 */
		protected function atCastRollOut():void {}
		
		
		
		
		
		/**
		 * <span lang="ja">新しい CastButton インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CastButton object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function CastButton( initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 初期化する
			_events = [];
			
			// 親クラスを初期化する
			super( initObject );
			
			// ボタンを有効化する
			super.mouseChildren = false;
			
			// イベントリスナーを登録する
			super.addEventListener( Event.ADDED_TO_STAGE, _addedToStage, false, int.MAX_VALUE, true );
			super.addEventListener( Event.REMOVED_FROM_STAGE, _removedFromStage, false, int.MAX_VALUE, true );
			super.addEventListener( CastEvent.CAST_ADDED, _castEvent, false, 0, true );
			super.addEventListener( CastEvent.CAST_REMOVED, _castEvent, false, 0, true );
			Progression.progression_internal::$collection.addEventListener( CollectionEvent.COLLECTION_UPDATE, _collectionUpdate, false, 0, true );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定されたシーン識別子、または URL の示す先に移動します。
		 * 引数が省略された場合には、あらかじめ CastButton インスタンスに指定されている sceneId プロパティ、 href プロパティが示す先に移動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param location
		 * <span lang="ja">移動先を示すシーン識別子、または URL です。</span>
		 * <span lang="en"></span>
		 * @param window
		 * <span lang="en">location パラメータで指定されたドキュメントを表示するブラウザウィンドウまたは HTML フレームです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see #href
		 * @see #windowTarget
		 */
		public function navigateTo( location:*, window:String = null ):void {
			_navigateTo( location, window );
		}
		
		/**
		 * 指定されたシーン識別子、または URL の示す先に移動します。
		 */
		private function _navigateTo( location:*, window:String = null ):void {
			var request:URLRequest;
			var sceneId:SceneId;
			
			// window を設定する
			window ||= "_self";
			
			// location を型によって振り分ける
			switch ( true ) {
				case location is String			: { request = new URLRequest( location ); break; }
				case location is URLRequest		: { request = URLRequest( location ); break; }
				case location is SceneId		: { sceneId = SceneId( location ); break; }
				default							: { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( "location" ) ); }
			}
			
			// URL を移動する
			if ( request ) {
				navigateToURL( request, window );
			}
			
			// シーンを移動する
			else if ( _managerFromSceneId ) {
				// 同期機能が有効化されていなければ常に _self とする
				window = _managerFromSceneId.sync ? window : "_self";
				
				// 自身が指定されていれば
				if ( window == "_self" ) {
					_managerFromSceneId.goto( sceneId );
				}
				
				// 他のウィンドウが指定されていれば
				else {
					navigateToURL( new URLRequest( "#" + sceneId.toShortPath() ), window );
				}
			}
		}
		
		/**
		 * <span lang="ja">マネージャーオブジェクトとの関連付けを更新します。</span>
		 * <span lang="en"></span>
		 * 
		 * @return
		 * <span lang="ja">関連付けが成功したら true を、それ以外は false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #manager
		 * @see jp.progression.Progression
		 */
		public function updateManager():Boolean {
			// 現在のマネージャーを取得する
			var oldManager:Progression = _manager;
			
			// 新しいマネージャーを取得する
			if ( _managerFromSceneId ) {
				_manager = _managerFromSceneId;
			}
			else {
				var manageable:IManageable = _parent as IManageable;
				_manager = manageable ? manageable.manager : null;
			}
			
			// 変更されていなければ終了する
			if ( _manager == oldManager ) { return Boolean( !!_manager ); }
			
			// イベントを送出する
			if ( _manager ) {
				super.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_ACTIVATE, false, false, _manager ) );
			}
			else {
				super.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_DEACTIVATE, false, false, oldManager ) );
			}
			
			return Boolean( !!_manager );
		}
		
		/**
		 * <span lang="ja">特定のイベントが送出された際に、自動実行させたい Command インスタンスをリストの最後尾に追加します。
		 * 追加された Command インスタンスは、イベントが送出される直前に自動的に初期化されます。
		 * このメソッドを使用するためには executor プロパティに CommandExecutor が実装されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #onCastAdded
		 * @see #onCastRemoved
		 * @see #insertCommand()
		 * @see #clearCommand()
		 */
		public function addCommand( ... commands:Array ):void {
			ExecutorObject.progression_internal::$addCommand( _getCurrentExecutor(), commands );
		}
		
		/**
		 * <span lang="ja">特定のイベントが送出された際に、自動実行させたい Command インスタンスをすでにリストに登録され、実行中の Command インスタンスの次の位置に追加します。
		 * 追加された Command インスタンスは、イベントが送出される直前に自動的に初期化されます。
		 * このメソッドを使用するためには executor プロパティに CommandExecutor が実装されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #onCastAdded
		 * @see #onCastRemoved
		 * @see #addCommand()
		 * @see #clearCommand()
		 */
		public function insertCommand( ... commands:Array ):void {
			ExecutorObject.progression_internal::$insertCommand( _getCurrentExecutor(), commands );
		}
		
		/**
		 * <span lang="ja">登録されている Command インスタンスを削除します。
		 * このメソッドを使用するためには executor プロパティに CommandExecutor が実装されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @param completely
		 * <span lang="en">true が設定されている場合は登録されている全てのコマンド登録を解除し、false の場合には現在処理中のコマンド以降の登録を解除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #executor
		 * @see #onCastAdded
		 * @see #onCastRemoved
		 * @see #addCommand()
		 * @see #insertCommand()
		 */
		public function clearCommand( completely:Boolean = false ):void {
			ExecutorObject.progression_internal::$clearCommand( _getCurrentExecutor(), completely );
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			while ( super.numChildren > 0 ) {
				var target:DisplayObject = super.children[0] as DisplayObject;
				var disposable:IDisposable = target as IDisposable;
				
				if ( disposable ) {
					disposable.dispose();
				}
				else {
					super.removeChild( target );
				}
			}
			
			if ( super.parent ) {
				super.parent.removeChild( this );
			}
			
			if ( _toolTip ) {
				_toolTip.dispose();
				_toolTip = null;
			}
			
			_sceneId = null;
			_href = null;
			_windowTarget = null;
			_mouseEventEnabled = true;
			
			_collectionUpdate( null );
			
			super.accessibilityProperties = null;
			super.buttonMode = false;
			
			super.id = null;
			super.group = null;
			
			_onCastAdded = null;
			_onCastRemoved = null;
			_onCastRollOver = null;
			_onCastRollOut = null;
			_onCastMouseDown = null;
			_onCastMouseUp = null;
		}
		
		/**
		 * 現在処理する必要のある ExecutorObject インスタンスを取得します。
		 */
		private function _getCurrentExecutor():ExecutorObject {
			switch ( _events[0].type ) {
				case CastMouseEvent.CAST_MOUSE_DOWN		:
				case CastMouseEvent.CAST_MOUSE_UP		: { return _mouseDownUpExecutor; }
				case CastMouseEvent.CAST_ROLL_OUT		:
				case CastMouseEvent.CAST_ROLL_OVER		: { return _rollOverOutExecutor; }
			}
			return _executor;
		}
		
		/**
		 * <span lang="ja">イベントをイベントフローに送出します。</span>
		 * <span lang="en">Dispatches an event into the event flow.</span>
		 * 
		 * @param event
		 * <span lang="ja">イベントフローに送出されるイベントオブジェクトです。イベントが再度送出されると、イベントのクローンが自動的に作成されます。イベントが送出された後にそのイベントの target プロパティは変更できないため、再送出処理のためにはイベントの新しいコピーを作成する必要があります。</span>
		 * <span lang="en">The Event object that is dispatched into the event flow. If the event is being redispatched, a clone of the event is created automatically. After an event is dispatched, its target property cannot be changed, so you must create a new copy of the event for redispatching to work.</span>
		 * @return
		 * <span lang="ja">値が true の場合、イベントは正常に送出されました。値が false の場合、イベントの送出に失敗したか、イベントで preventDefault() が呼び出されたことを示しています。</span>
		 * <span lang="en">A value of true if the event was successfully dispatched. A value of false indicates failure or that preventDefault() was called on the event.</span>
		 */
		override public function dispatchEvent( event:Event ):Boolean {
			switch ( true ) {
				case event is CastEvent			:
				case event is CastMouseEvent	: { _events.unshift( event ); break; }
			}
			
			// イベントを送出する
			var result:Boolean = super.dispatchEvent( event );
			
			switch ( true ) {
				case event is CastEvent			:
				case event is CastMouseEvent	: { _events.shift(); break; }
			}
			
			return result;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, href ? "href" : "sceneId" );
		}
		
		
		
		
		
		/**
		 * 表示オブジェクトが、直接、または表示オブジェクトを含むサブツリーの追加により、ステージ上の表示リストに追加されたときに送出されます。
		 */
		private static function _addedToStage( e:Event ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			var target:CastButton = e.target as CastButton;
			
			// イベントリスナーを登録する
			target.addEventListener( MouseEvent.CLICK, target._click );
			target.addEventListener( MouseEvent.MOUSE_DOWN, target._mouseDown );
			target.addEventListener( MouseEvent.ROLL_OVER, target._rollOver );
			target.addEventListener( MouseEvent.ROLL_OUT, target._rollOut );
			target.addEventListener( CastMouseEvent.CAST_MOUSE_DOWN, _castEvent );
			target.addEventListener( CastMouseEvent.CAST_MOUSE_UP, _castEvent );
			target.addEventListener( CastMouseEvent.CAST_ROLL_OVER, _castEvent );
			target.addEventListener( CastMouseEvent.CAST_ROLL_OUT, _castEvent );
			target.stage.addEventListener( KeyboardEvent.KEY_DOWN, target._keyDown );
			target.stage.addEventListener( KeyboardEvent.KEY_UP, target._keyUp );
			
			// アクティブリストに登録する
			_activatedButtons.addItem( target );
			
			// 実装する
			_stage = target.stage;
			target._parent = target.parent;
			target._executor = ExecutorObject.progression_internal::$equip( target, target.parent );
			
			// イベントリスナーを登録する
			if ( target.parent ) {
				target.parent.addEventListener( ManagerEvent.MANAGER_ACTIVATE, target._managerActivateDeactivate, false, int.MAX_VALUE );
				target.parent.addEventListener( ManagerEvent.MANAGER_DEACTIVATE, target._managerActivateDeactivate, false, int.MAX_VALUE );
			}
			
			if ( target._executor ) {
				var classRef:Class = Progression.config.executor;
				target._mouseDownUpExecutor = new classRef( target );
				target._rollOverOutExecutor = new classRef( target );
			}
			
			// コンテクストメニューを設定する
			target["_contextMenuBuilder"] = Progression.config.contextMenuBuilder;
		}
		
		/**
		 * 表示オブジェクトが、直接、または表示オブジェクトを含むサブツリーの削除により、表示リストから削除されようとしているときに送出されます。
		 */
		private static function _removedFromStage( e:Event ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			var target:CastButton = e.target as CastButton;
			
			// イベントリスナーを解除する
			target.removeEventListener( MouseEvent.CLICK, target._click );
			target.removeEventListener( MouseEvent.MOUSE_DOWN, target._mouseDown );
			target.removeEventListener( MouseEvent.MOUSE_UP, target._mouseUp );
			target.removeEventListener( MouseEvent.ROLL_OVER, target._rollOver );
			target.removeEventListener( MouseEvent.ROLL_OUT, target._rollOut );
			target.removeEventListener( CastMouseEvent.CAST_MOUSE_DOWN, _castEvent );
			target.removeEventListener( CastMouseEvent.CAST_MOUSE_UP, _castEvent );
			target.removeEventListener( CastMouseEvent.CAST_ROLL_OVER, _castEvent );
			target.removeEventListener( CastMouseEvent.CAST_ROLL_OUT, _castEvent );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, target._mouseUpStage );
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, target._keyDown );
			_stage.removeEventListener( KeyboardEvent.KEY_UP, target._keyUp );
			
			// アクティブリストから削除する
			_activatedButtons.removeItem( target );
			
			// 実装を解除する
			target._parent = null;
			target._executor = ExecutorObject.progression_internal::$unequip( target );
			
			// イベントリスナーを解除する
			if ( target.parent ) {
				target.parent.removeEventListener( ManagerEvent.MANAGER_ACTIVATE, target._managerActivateDeactivate );
				target.parent.removeEventListener( ManagerEvent.MANAGER_DEACTIVATE, target._managerActivateDeactivate );
			}
			
			// ExecutorObject が存在すれば
			if ( target._mouseDownUpExecutor ) {
				// イベントリスナーを解除する
				target._mouseDownUpExecutor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, target._executeCompleteMouseDownUpExecutor );
				target._mouseDownUpExecutor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, target._executeCompleteMouseUp );
				
				// 破棄する
				target._mouseDownUpExecutor.dispose();
				target._mouseDownUpExecutor = null;
			}
			
			// ExecutorObject が存在すれば
			if ( target._rollOverOutExecutor ) {
				// イベントリスナーを解除する
				target._rollOverOutExecutor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, target._executeCompleteRollOverOutExecutor );
				
				// 破棄する
				target._rollOverOutExecutor.dispose();
				target._rollOverOutExecutor = null;
			}
			
			// 破棄する
			target._mouseDownUpEvent = null;
			target._rollOverOutEvent = null;
			
			// コンテクストメニューを破棄する
			target["_contextMenuBuilder"] = null;
		}
		
		/**
		 * CastEvent イベントの発生時に送出されます。
		 */
		private static function _castEvent( e:Event ):void {
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			// 対象を取得する
			var target:CastButton = e.target as CastButton;
			
			// イベントハンドラメソッドを実行する
			var type:String = e.type.charAt( 0 ).toUpperCase() + e.type.slice( 1 );
			( target[ "_on" + type ] || target[ "at" + type ] ).apply( target );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _managerActivateDeactivate( e:ManagerEvent ):void {
			updateManager();
		}
		
		/**
		 * ユーザーがキーを押したときに送出されます。
		 */
		private function _keyDown( e:KeyboardEvent ):void {
			// CTRL キー、または SHIFT キーが押されているかどうかを設定します。
			_isDownCTRLorShiftKey = e.ctrlKey || e.shiftKey;
			
			// キャラコードが一致しなければ終了する
			if ( !_accessKey || e.charCode != _accessKey.toLowerCase().charCodeAt() ) { return; }
			
			// ボタンであり、かつ移動先が存在すれば
			if ( super.buttonMode && ( _href || _sceneId ) ) {
				// イベントを送出する
				if ( super.dispatchEvent( new CastMouseEvent( CastMouseEvent.CAST_NAVIGATE_BEFORE, false, true ) ) ) {
					_navigateTo( _href || _sceneId, _isDownCTRLorShiftKey ? "_blank" : _windowTarget );
					_isDownCTRLorShiftKey = false;
				}
			}
		}
		
		/**
		 * ユーザーがキーを離したときに送出されます。
		 */
		private function _keyUp( e:KeyboardEvent ):void {
			// CTRL キー、または SHIFT キーが押されているかどうかを無効化します。
			_isDownCTRLorShiftKey = false;
		}
		
		/**
		 * ユーザーが同じ InteractiveObject 上でポインティングデバイスのメインボタンを押して離すと送出されます。
		 */
		private function _click( e:MouseEvent ):void {
			// マウスダウン、またはロール―オーバーされていれば終了する
			if ( _isMouseDown || _isRollOver ) { return; }
			
			// ボタンであり、かつ移動先が存在すれば
			if ( super.buttonMode && ( _href || _sceneId ) ) {
				// イベントを送出する
				if ( super.dispatchEvent( new CastMouseEvent( CastMouseEvent.CAST_NAVIGATE_BEFORE, false, true ) ) ) {
					_navigateTo( _href || _sceneId, _isDownCTRLorShiftKey ? "_blank" : _windowTarget );
					_isDownCTRLorShiftKey = false;
				}
			}
		}
		
		/**
		 * Flash Player ウィンドウの InteractiveObject インスタンスの上でユーザーがポインティングデバイスのボタンを押すと送出されます。
		 */
		private function _mouseDown( e:MouseEvent ):void {
			// 状態を変更する
			_isMouseDown = true;
			
			// マウス状態に応じた処理をしないのであれば終了する
			if ( !_mouseEventEnabled ) { return; }
			
			// ExecutorObject が存在しなければ終了する
			if ( !_mouseDownUpExecutor ) { return; }
			
			// すでに実行していたら終了する
			if ( _mouseDownUpExecutor.state > 0 ) {
				_mouseDownUpExecutor.interrupt();
			}
			
			// イベントを保存する
			_mouseDownUpEvent = e;
			
			// 実行する
			_mouseDownUpExecutor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteMouseDownUpExecutor );
			_mouseDownUpExecutor.execute( new CastMouseEvent( CastMouseEvent.CAST_MOUSE_DOWN, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta ) );
			
			// イベントリスナーを登録する
			super.addEventListener( MouseEvent.MOUSE_UP, _mouseUp );
			_stage.addEventListener( MouseEvent.MOUSE_UP, _mouseUpStage );
		}
		
		/**
		 * ユーザーが InteractiveObject インスタンスからポインティングデバイスを離したときに送出されます。
		 */
		private function _mouseUp( e:MouseEvent ):void {
			// イベントリスナーを解除する
			super.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, _mouseUpStage );
			
			// 状態を変更する
			_isMouseDown = false;
			
			// マウス状態に応じた処理をしないのであれば終了する
			if ( !_mouseEventEnabled ) { return; }
			
			// ExecutorObject が存在しなければ終了する
			if ( !_mouseDownUpExecutor ) { return; }
			
			// すでに実行していたら中断する
			if ( _mouseDownUpExecutor.state > 0 ) {
				_mouseDownUpExecutor.interrupt();
				
				// イベントを送出する
				super.dispatchEvent( new CastMouseEvent( CastMouseEvent.CAST_MOUSE_DOWN_COMPLETE, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta ) );
			}
			
			// ボタンであり、かつ移動先が存在すれば
			if ( super.buttonMode && ( _href || _sceneId ) ) {
				// イベントを送出する
				if ( super.dispatchEvent( new CastMouseEvent( CastMouseEvent.CAST_NAVIGATE_BEFORE, false, true ) ) ) {
					_navigateTo( _href || _sceneId, _isDownCTRLorShiftKey ? "_blank" : _windowTarget );
					_isDownCTRLorShiftKey = false;
				}
			}
			
			if ( _mouseDownUpExecutor ) {
				// イベントを保存する
				_mouseDownUpEvent = e;
				
				// 実行する
				_mouseDownUpExecutor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteMouseDownUpExecutor );
				_mouseDownUpExecutor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteMouseUp, false, int.MAX_VALUE );
				_mouseDownUpExecutor.execute( new CastMouseEvent( CastMouseEvent.CAST_MOUSE_UP, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta ) );
			}
		}
		
		/**
		 * ユーザーが InteractiveObject インスタンスからポインティングデバイスを離したときに送出されます。
		 */
		private function _mouseUpStage( e:MouseEvent ):void {
			// イベントリスナーを解除する
			super.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, _mouseUpStage );
			
			// 状態を変更する
			_isMouseDown = false;
			
			// マウス状態に応じた処理をしないのであれば終了する
			if ( !_mouseEventEnabled ) { return; }
			
			// ExecutorObject が存在しなければ終了する
			if ( !_mouseDownUpExecutor ) { return; }
			
			// すでに実行していたら中断する
			if ( _mouseDownUpExecutor.state > 0 ) {
				_mouseDownUpExecutor.interrupt();
				
				// イベントを送出する
				super.dispatchEvent( new CastMouseEvent( CastMouseEvent.CAST_MOUSE_DOWN_COMPLETE, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta ) );
			}
			
			// イベントを保存する
			_mouseDownUpEvent = e;
			
			// 実行する
			_mouseDownUpExecutor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteMouseDownUpExecutor );
			_mouseDownUpExecutor.execute( new CastMouseEvent( CastMouseEvent.CAST_MOUSE_UP, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta ) );
			
			// ロールオーバーしておらず、未処理のロールオーバーイベントが存在すれば
			if ( !_isRollOver && _rollOverOutEvent ) {
				_rollOut( _rollOverOutEvent );
			}
		}
		
		/**
		 * 処理が完了した場合に送出されます。
		 */
		private function _executeCompleteMouseDownUpExecutor( e:ExecuteEvent ):void {
			// イベントリスナーを解除する
			_mouseDownUpExecutor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteMouseDownUpExecutor );
			
			// イベントを送出する
			super.dispatchEvent( new CastMouseEvent( _isMouseDown ? CastMouseEvent.CAST_MOUSE_DOWN_COMPLETE : CastMouseEvent.CAST_MOUSE_UP_COMPLETE, _mouseDownUpEvent.bubbles, _mouseDownUpEvent.cancelable, _mouseDownUpEvent.localX, _mouseDownUpEvent.localY, _mouseDownUpEvent.relatedObject, _mouseDownUpEvent.ctrlKey, _mouseDownUpEvent.altKey, _mouseDownUpEvent.shiftKey, _mouseDownUpEvent.buttonDown, _mouseDownUpEvent.delta ) );
			
			// マウスイベントを破棄する
			_mouseDownUpEvent = null;
		}
		
		/**
		 * 処理が完了した場合に送出されます。
		 */
		private function _executeCompleteMouseUp( e:ExecuteEvent ):void {
			// イベントリスナーを解除する
			_mouseDownUpExecutor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteMouseUp );
			
			// ロールオーバーしておらず、未処理のロールオーバーイベントが存在すれば
			if ( !_isRollOver && _rollOverOutEvent ) {
				_rollOut( _rollOverOutEvent );
			}
		}
		
		/**
		 * ユーザーが InteractiveObject インスタンスにポインティングデバイスを合わせたときに送出されます。
		 */
		private function _rollOver( e:MouseEvent ):void {
			// 状態を変更する
			_isRollOver = true;
			
			// マウス状態に応じた処理をしないのであれば終了する
			if ( !_mouseEventEnabled ) { return; }
			
			// ExecutorObject が存在しなければ終了する
			if ( !_rollOverOutExecutor ) { return; }
			
			// マウスをダウンしていれば終了する
			if ( _isMouseDown ) { return; }
			
			// すでに実行していたら中断する
			if ( _rollOverOutExecutor.state > 0 ) {
				_rollOverOutExecutor.interrupt();
				
				// イベントを送出する
				super.dispatchEvent( new CastMouseEvent( CastMouseEvent.CAST_ROLL_OUT_COMPLETE, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta ) );
			}
			
			// イベントを保存する
			_rollOverOutEvent = e;
			
			// 実行する
			_rollOverOutExecutor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteRollOverOutExecutor );
			_rollOverOutExecutor.execute( new CastMouseEvent( CastMouseEvent.CAST_ROLL_OVER, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta ) );
			
			// イベントリスナーを登録する
			super.addEventListener( MouseEvent.ROLL_OUT, _rollOut, false, 0, true );
		}
		
		/**
		 * ユーザーが InteractiveObject インスタンスからポインティングデバイスを離したときに送出されます。
		 */
		private function _rollOut( e:MouseEvent ):void {
			// イベントリスナーを解除する
			super.removeEventListener( MouseEvent.ROLL_OUT, _rollOut );
			
			// 状態を変更する
			_isRollOver = false;
			
			// マウス状態に応じた処理をしないのであれば終了する
			if ( !_mouseEventEnabled ) { return; }
			
			// ExecutorObject が存在しなければ終了する
			if ( !_rollOverOutExecutor ) { return; }
			
			// すでに実行していたら中断する
			if ( _rollOverOutExecutor.state > 0 ) {
				_rollOverOutExecutor.interrupt();
				
				// イベントを送出する
				super.dispatchEvent( new CastMouseEvent( CastMouseEvent.CAST_ROLL_OVER_COMPLETE, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta ) );
			}
			
			// イベントを保存する
			_rollOverOutEvent = e;
			
			// 実行する
			_rollOverOutExecutor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteRollOverOutExecutor );
			_rollOverOutExecutor.execute( new CastMouseEvent( CastMouseEvent.CAST_ROLL_OUT, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta ) );
		}
		
		/**
		 * 処理が完了した場合に送出されます。
		 */
		private function _executeCompleteRollOverOutExecutor( e:ExecuteEvent ):void {
			// イベントリスナーを解除する
			_rollOverOutExecutor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeCompleteRollOverOutExecutor );
			
			// イベントを送出する
			super.dispatchEvent( new CastMouseEvent( _isRollOver ? CastMouseEvent.CAST_ROLL_OVER_COMPLETE : CastMouseEvent.CAST_ROLL_OUT_COMPLETE, _rollOverOutEvent.bubbles, _rollOverOutEvent.cancelable, _rollOverOutEvent.localX, _rollOverOutEvent.localY, _rollOverOutEvent.relatedObject, _rollOverOutEvent.ctrlKey, _rollOverOutEvent.altKey, _rollOverOutEvent.shiftKey, _rollOverOutEvent.buttonDown, _rollOverOutEvent.delta ) );
			
			// マウスイベントを破棄する
			_rollOverOutEvent = null;
		}
		
		/**
		 * コレクションに対して、インスタンスが追加された場合に送出されます。
		 */
		private function _collectionUpdate( e:CollectionEvent ):void {
			// シーン識別子から取得した Progression インスタンスが存在すれば
			if ( _managerFromSceneId ) {
				_managerFromSceneId.removeEventListener( ProcessEvent.PROCESS_SCENE, _processScene );
			}
			
			// シーン識別子が設定されていれば
			if ( _sceneId ) {
				_managerFromSceneId = Progression.progression_internal::$collection.getInstanceById( _sceneId.getNameByIndex( 0 ) ) as Progression;
			}
			else {
				_managerFromSceneId = null;
			}
			
			// シーン識別子から取得した Progression インスタンスが存在すれば
			if ( _managerFromSceneId ) {
				_managerFromSceneId.addEventListener( ProcessEvent.PROCESS_SCENE, _processScene, false, 0, true );
			}
			
			// 更新する
			updateManager();
			
			// 状態を変更する
			_processScene( null );
		}
		
		/**
		 * 管理下にあるシーンの移動処理中に対象シーンが変更された場合に送出されます。
		 */
		private function _processScene( e:ProcessEvent ):void {
			var state:int = _state;
			
			var sceneId:SceneId = _sceneId;
			var currentSceneId:SceneId;
			
			switch ( true ) {
				case !!_managerFromSceneId	: { currentSceneId = _managerFromSceneId.currentSceneId; break; }
				case !!_manager				: { currentSceneId = _manager.currentSceneId; break; }
			}
			
			// 現在の状態を取得する
			switch ( true ) {
				case !super.buttonMode						:
				case !_managerFromSceneId					:
				case !sceneId								:
				case !currentSceneId						: { _state = 0; break; }
				case sceneId.equals( currentSceneId )		: { _state = 2; break; }
				case sceneId.contains( currentSceneId )		: { _state = 1; break; }
				case currentSceneId.contains( _sceneId )	: { _state = 3; break; }
				default										: { _state = 4; }
			}
			
			// 状態が変更されていれば
			if ( state != _state ) {
				super.dispatchEvent( new CastMouseEvent( CastMouseEvent.CAST_STATE_CHANGE ) );
			}
		}
		
		
		
		
		
		/**
		 * 外部 ActionScript ファイルを取り込む
		 */
		include "../core/includes/CastObject_contextMenu.inc"
	}
}
