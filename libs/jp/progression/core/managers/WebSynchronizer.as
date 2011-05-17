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
package jp.progression.core.managers {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import jp.nium.core.debug.Logger;
	import jp.nium.external.JavaScript;
	import jp.nium.utils.ArrayUtil;
	import jp.nium.utils.ClassUtil;
	import jp.progression.core.impls.IWebConfig;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.data.WebDataHolder;
	import jp.progression.events.ProcessEvent;
	import jp.progression.events.SceneEvent;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneId;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * <span lang="ja">シンクロナイザの準備が完了した場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event( name="complete", type="flash.events.Event" )]
	
	/**
	 * @private
	 */
	public class WebSynchronizer extends EventDispatcher implements ISynchronizer {
		
		/**
		 * 同期対象となっている Progression インスタンスを取得します。
		 */
		private static var _syncedManager:Progression;
		
		/**
		 * 全てのインスタンスを保存した Dictionary インスタンスを取得します。
		 */
		private static var _instances:Dictionary = new Dictionary( true );
		
		/**
		 * 登録されたインスタンス数を取得します。
		 */
		private static var _numInstances:uint = 0;
		
		/**
		 * 
		 */
		private static var _initialize:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():Progression { return _target; }
		private var _target:Progression;
		
		/**
		 * <span lang="ja">現在同期中の Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get syncedManager():Progression { return _syncedManager; }
		
		/**
		 * <span lang="ja">起点となるシーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get sceneId():SceneId { return _sceneId; }
		private var _sceneId:SceneId;
		
		/**
		 * <span lang="ja">同期機能が有効化されているかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled( value:Boolean ):void {
			if ( _enabled = value ) {
				// 他のシンクロナイザを停止する
				for ( var otherSynchronizer:* in _instances ) {
					if ( otherSynchronizer == this ) { continue; }
					otherSynchronizer.enabled = false;
				}
				
				// プレイヤーを判別する
				switch ( Capabilities.playerType ) {
					case "ActiveX"		: { break; }
					case "External"		: { _enabled = false; break; }
					case "PlugIn"		: { break; }
					case "StandAlone"	:
					case "Desktop"		: { _enabled = false; break; }
				}
				
				// 同期対象として設定する
				_syncedManager = _target;
				
				if ( PackageInfo.hasDebugger ) {
					// 情報を表示する
					Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_000 ).toString( "SWFAddress" ) );
				}
				
				// 解析モジュールを検出する
				var result:Boolean = JavaScript.call( 'function() {'
				 + '	try { if ( urchinTracker ) { return true; } } catch ( e ) {}'
				 + '	try { if ( pageTracker ) { return true; } } catch ( e ) {}'
				 + '	return false'
				 + '}' );
				
				// 検出に成功したら
				if ( result && PackageInfo.hasDebugger ) {
					Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_003 ).toString( "Google Analytics" ) );
				}
				
				// イベントリスナーを登録する
				SWFAddress.addEventListener( SWFAddressEvent.EXTERNAL_CHANGE, __externalChange, false, int.MAX_VALUE );
				_target.addEventListener( ProcessEvent.PROCESS_COMPLETE, _processCompleteAndSceneQueryChange );
				_target.root.sceneInfo.addEventListener( SceneEvent.SCENE_QUERY_CHANGE, _processCompleteAndSceneQueryChange );
			}
			else {
				// 有効化されているシンクロナイザが存在するかどうかを確認する
				var exists:Boolean = false;
				for ( var targetSynchronizer:* in _instances ) {
					if ( !targetSynchronizer.enabled ) { continue; }
					exists = true;
				}
				
				// 存在しなければ同期対象を null にする
				if ( !exists ) {
					_syncedManager = null;
				}
				
				// イベントリスナーを解除する
				SWFAddress.removeEventListener( SWFAddressEvent.EXTERNAL_CHANGE, __externalChange );
				_target.removeEventListener( ProcessEvent.PROCESS_COMPLETE, _processCompleteAndSceneQueryChange );
				_target.root.sceneInfo.removeEventListener( SceneEvent.SCENE_QUERY_CHANGE, _processCompleteAndSceneQueryChange );
				
				// 対象シーンが存在すれば
				if ( _scene ) {
					// イベントリスナーを解除する
					_scene.removeEventListener( SceneEvent.SCENE_TITLE_CHANGE, _sceneTitleChange );
					
					// 破棄する
					_scene = null;
				}
			}
		}
		private var _enabled:Boolean = false;
		
		/**
		 * すでに開始されているかどうかを取得します。
		 */
		private var _started:Boolean = false;
		
		/**
		 * SceneObject インスタンスを取得します。
		 */
		private var _scene:SceneObject;
		
		/**
		 * URLLoader インスタンスを取得します。
		 */
		private var _loader:URLLoader;
		
		
		
		
		
		/**
		 * 初期化する
		 */
		( function():void {
			// イベントリスナーを登録する
			SWFAddress.addEventListener( SWFAddressEvent.EXTERNAL_CHANGE, _externalChange );
		} )();
		
		
		
		
		
		/**
		 * <span lang="ja">新しい WebSynchronizer インスタンスを作成します。</span>
		 * <span lang="en">Creates a new WebSynchronizer object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい Progression インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function WebSynchronizer( target:Progression ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_target = target;
			
			// ルートシーン識別子を取得する
			var scenePath:String = "/" + target.id;
			var fragmentPath:String = JavaScript.locationHref.split( "#" )[1] || "";
			
			// シーンパスの書式が正しければ
			if ( SceneId.validatePath( scenePath + fragmentPath ) ) {
				scenePath += fragmentPath;
			}
			
			// 初期シーン識別子を設定する
			_sceneId = new SceneId( scenePath );
			
			// 登録する
			_instances[this] = _numInstances++;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">同期を開始します。</span>
		 * <span lang="en"></span>
		 */
		public function start():void {
			// すでに開始されていれば例外をスローする
			if ( _started ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_020 ).toString( ClassUtil.getClassName( this ) ) ); }
			
			// 同期を開始する
			_started = true;
			
			// 現在の環境設定を取得します。
			var config:IWebConfig = Progression.config as IWebConfig;
			
			// 環境設定が WebConfig ではない、または HTMLInjection を使用しないのであれば終了する
			if ( !config || !config.useHTMLInjection ) {
				// イベントを送出する
				super.dispatchEvent( new Event( Event.COMPLETE ) );
				return;
			}
			
			// 同期候補の HTML ファイルの URL を取得する
			if ( JavaScript.enabled ) {
				var url:String = JavaScript.locationHref;
			}
			else {
				url = _target.root.container.loaderInfo.url.replace( new RegExp( ".swf$" ), ".html" );
				
				if ( PackageInfo.hasDebugger ) {
					// 警告を表示する
					Logger.warn( Logger.getLog( L10NProgressionMsg.getInstance().WARN_000 ).toString() );
				}
			}
			
			// URLLoader を作成する
			_loader = new URLLoader();
			
			// イベントリスナーを設定する
			_loader.addEventListener( Event.COMPLETE, _complete );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, _ioAndSecurityError );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _ioAndSecurityError );
			
			// データを読み込む
			_loader.load( new URLRequest( url ) );
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			// 無効化する
			enabled = false;
			
			// 破棄する
			_target = null;
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _complete( e:Event ):void {
			// イベントリスナーを解除する
			_loader.removeEventListener( Event.COMPLETE, _complete );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR, _ioAndSecurityError );
			_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _ioAndSecurityError );
			
			try {
				// データを取得する
				var data:String = String( _loader.data );
				
				// ネームスペースを破棄する
				data = data.replace( new RegExp( 'xmlns=".*"', "g" ), "" );
				
				// HTML データを取得する
				var html:XML = new XML( data );
				
				// コンテンツを取得する
				var htmlcontent:XML = html..div.( @id == "htmlcontent" )[0];
				
				// データを登録する
				WebDataHolder.progression_internal::$htmlcontent = htmlcontent;
				
				// 作成したシーンを保持する
				var scenes:Array = [];
				
				( function( content:XML, scene:SceneObject = null ):void {
					for each ( var div:XML in content.div ) {
						var id:String = String( div.@id );
						
						// id がシーン識別子でなければ次へ
						if ( !SceneId.validatePath( id ) ) { continue; }
						
						var name:String = id.split( "/" ).reverse()[0];
						var classes:Array = ArrayUtil.compress( String( div.@["class"] ).split( " " ) ).reverse();
						var child:SceneObject;
						
						// クラスが指定されていれば
						if ( classes.length > 0 ) {
							var classPath:String = null;
							var classRef:Class = null;
							
							// クラスを取得する
							for ( var ii:int = 0, ll:int = classes.length; ii < ll; ii++ ) {
								try {
									classPath = classes[ii];
									classRef = getDefinitionByName( classPath ) as Class;
									break;
								}
								catch ( err:Error ) {}
							}
							
							// シーンを作成する
							try {
								child = new classRef();
							}
							catch ( err:Error ) {
								Logger.error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_011 ).toString( classPath ) );
								continue;
							}
						}
						else {
							child = new SceneObject();
						}
						
						// シーン名を設定する
						child.name = name;
						
						if ( scene ) {
							scene.addScene( child );
						}
						else {
							scenes.push( child );
						}
						
						// 再帰処理する
						arguments.callee( div, child );
					}
				} )( htmlcontent );
				
				// シーンを追加する
				while ( scenes.length > 0 ) {
					_target.root.addScene( SceneObject( scenes.shift() ) );
				}
				
				if ( PackageInfo.hasDebugger ) {
					// 情報を表示する
					Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_002 ).toString() );
				}
			}
			catch ( err:Error ) {
				// データを登録する
				WebDataHolder.progression_internal::$htmlcontent = null;
				
				if ( PackageInfo.hasDebugger ) {
					// 警告を表示する
					Logger.warn( Logger.getLog( L10NProgressionMsg.getInstance().WARN_002 ).toString( err.message ) );
				}
			}
			
			// 破棄する
			_loader = null;
			
			// イベントを送出する
			super.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * 
		 */
		private function _ioAndSecurityError( e:Event ):void {
			// イベントリスナーを解除する
			_loader.removeEventListener( Event.COMPLETE, _complete );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR, _ioAndSecurityError );
			_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _ioAndSecurityError );
			
			// 破棄する
			_loader = null;
			
			if ( PackageInfo.hasDebugger ) {
				// 情報を表示する
				Logger.warn( Logger.getLog( L10NProgressionMsg.getInstance().WARN_001 ).toString() );
			}
			
			// イベントを送出する
			super.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * 
		 */
		private static function _externalChange( e:SWFAddressEvent ):void {
			// イベントリスナーを解除する
			SWFAddress.removeEventListener( SWFAddressEvent.EXTERNAL_CHANGE, _externalChange );
			
			// 初期化する
			_initialize = true;
		}
		
		/**
		 * 
		 */
		private function __externalChange( e:SWFAddressEvent ):void {
			// 初期化されていなければ終了する
			if ( !_initialize ) { return; }
			
			// 現在地が NaS であれば終了する
			if ( SceneId.isNaS( _target.currentSceneId ) ) { return; }
			
			// 発行されるパスを取得する
			var path:String = SWFAddress.getValue();
			
			// path が / であればルートシーンに移動する
			if ( path == "/" ) {
				_target.goto( _target.root.sceneId );
				return;
			}
			
			// 書式が正しくなければ終了する
			if ( !SceneId.validatePath( path ) ) { return; }
			
			// 移動する
			_target.goto( new SceneId( "/" + _target.id + path ) );
		}
		
		/**
		 * 
		 */
		private function _processCompleteAndSceneQueryChange( e:Event ):void {
			if ( _scene ) {
				// イベントリスナーを解除する
				_scene.removeEventListener( SceneEvent.SCENE_TITLE_CHANGE, _sceneTitleChange );
			}
			
			// 現在のシーンを設定する
			_scene = SceneObject.progression_internal::$getSceneBySceneId( _target.currentSceneId );
			
			if ( _scene ) {
				// 発行するパスを取得する
				var sceneId:SceneId = _target.destinedSceneId || _target.root.sceneId;
				var path:String = sceneId.toShortPath();
				
				// URL を発行する
				if ( SWFAddress.getValue() != path ) {
					SWFAddress.setValue( sceneId.toShortPath() );
				}
				
				// タイトルを設定する
				if ( _scene.title ) {
					SWFAddress.setTitle( _scene.title );
				}
				
				// イベントリスナーを登録する
				_scene.addEventListener( SceneEvent.SCENE_TITLE_CHANGE, _sceneTitleChange, false, 0, true );
			}
			
			// ログを送信する
			var result:Boolean = JavaScript.call( 'function( path ) {'
			 + '	try { pageTracker._trackPageview( path ); return true; } catch ( e ) {'
			 + '		try { urchinTracker( path ); return true; } catch ( e ) {}'
			 + '	}'
			 + '	return false'
			 + '}', _target.currentSceneId.toString() );
			
			// 送信に成功していれば
			if ( result && PackageInfo.hasDebugger ) {
				Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_004 ).toString( "Google Analytics", _target.currentSceneId.toString() ) );
			}
		}
		
		/**
		 * シーンオブジェクトの title プロパティが変更された場合に送出されます。
		 */
		private function _sceneTitleChange( e:SceneEvent ):void {
			// タイトルを設定する
			if ( e.target.title ) {
				SWFAddress.setTitle( e.target.title );
			}
		}
	}
}
