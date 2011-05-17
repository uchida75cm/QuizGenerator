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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import jp.nium.core.debug.Logger;
	import jp.nium.external.JavaScript;
	import jp.nium.utils.StageUtil;
	import jp.progression.core.impls.IWebConfig;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.PackageInfo;
	import jp.progression.Progression;
	import org.libspark.ui.SWFSize;
	import org.libspark.ui.SWFWheel;
	
	/**
	 * @private
	 */
	public class WebInitializer implements IInitializer {
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():Progression { return _target; }
		private var _target:Progression;
		
		/**
		 * 
		 */
		private var _timerId:uint;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい WebInitializer インスタンスを作成します。</span>
		 * <span lang="en">Creates a new WebInitializer object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい Progression インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function WebInitializer( target:Progression ) {
			// 引数を設定する
			_target = target;
			
			// 現在の環境設定を取得する
			var config:IWebConfig = Progression.config as IWebConfig;
			
			// SWFAddress のストリクトを無効化する
			SWFAddress.setStrict( false );
			
			// 環境設定が IWebConfig であり、SWFWheel を使用するのであれば
			if ( config && config.useSWFWheel ) {
				// SWFWheel を初期化する
				SWFWheel.initialize( _target.stage );
				
				if ( PackageInfo.hasDebugger ) {
					// 情報を表示する
					Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_000 ).toString( "SWFWheel" ) );
				}
			}
			
			// 環境設定が IWebConfig ではない、または SWFSize を使用しないのであれば
			if ( !config || !config.useSWFSize ) { return; }
			
			// 既に読み込まれていれば
			if ( _target.stage.loaderInfo.bytesTotal > 0 && _target.stage.loaderInfo.bytesLoaded >= _target.stage.loaderInfo.bytesTotal ) {
				_timerId = setTimeout( _complete, 0, null );
			}
			else {
				_target.stage.loaderInfo.addEventListener( Event.COMPLETE, _complete );
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			// 破棄する
			_target = null;
		}
		
		
		
		
		
		/**
		 * データが正常にロードされたときに送出されます。
		 */
		private function _complete( e:Event ):void {
			// イベントリスナーを解除する
			_target.stage.loaderInfo.removeEventListener( Event.COMPLETE, _complete );
			
			// タイマーを初期化する
			clearTimeout( _timerId );
			
			// ルートを取得する
			var root:Sprite = StageUtil.getDocument( _target.stage );
			
			// 最小幅を取得する
			var minWidth:Number = JavaScript.call( 'function() {'
			 + '	try { var minWidth = document.getElementById( "' + ExternalInterface.objectID + '" ).style.minWidth; } catch ( e ) {}'
			 + '	if ( new RegExp( "[0-9]*px" ).test( minWidth ) ) { return parseInt( minWidth ); }'
			 + '	return undefined;'
			 + '}' ) || root.loaderInfo.width;
			
			// 最小高さを取得する
			var minHeight:Number = JavaScript.call( 'function() {'
			 + '	try { var minHeight = document.getElementById( "' + ExternalInterface.objectID + '" ).style.minHeight; } catch ( e ) {}'
			 + '	if ( new RegExp( "[0-9]*px" ).test( minHeight ) ) { return parseInt( minHeight ); }'
			 + '	return undefined;'
			 + '}' ) || root.loaderInfo.height;
			
			// SWFSize を初期化する
			SWFSize.initialize( minWidth, minHeight );
			
			if ( PackageInfo.hasDebugger ) {
				// 情報を表示する
				Logger.info( Logger.getLog( L10NProgressionMsg.getInstance().INFO_000 ).toString( "SWFSize" ) );
			}
		}
	}
}
