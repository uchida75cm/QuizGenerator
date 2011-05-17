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
package jp.nium.external {
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.Security;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.StringUtil;
	
	/**
	 * <span lang="ja">JavaScript クラスは、SWF ファイルを再生中のブラウザと、JavaScript を使用して通信を行うクラスです。</span>
	 * <span lang="en">The JavaScript class communicates with the browser which are playing the SWF file, using JavaScript.</span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class JavaScript {
		
		/**
		 * <span lang="ja">再生中のブラウザと JavaScript 通信が可能かどうかを取得します。</span>
		 * <span lang="en">Returns if it is able to communicate with Browser via JavaScript.</span>
		 */
		public static function get enabled():Boolean { return _enabled; }
		private static var _enabled:Boolean = false;
		
		/**
		 * <span lang="ja">SWF ファイルを再生中のブラウザのコード名を取得します。</span>
		 * <span lang="en">Returns the code name of the browser which playing the SWF file.</span>
		 */
		public static function get appCodeName():String { return _appCodeName; }
		private static var _appCodeName:String;
		
		/**
		 * <span lang="ja">SWF ファイルを再生中のブラウザからアプリケーション名を取得します。</span>
		 * <span lang="en">Get the application name from the browser which playing the SWF file.</span>
		 */
		public static function get appName():String { return _appName; }
		private static var _appName:String;
		
		/**
		 * <span lang="ja">SWF ファイルを再生中のブラウザからバージョンと機種名を取得します。</span>
		 * <span lang="en">Get the version and machine name from the browser which playing the SWF file.</span>
		 */
		public static function get appVersion():String { return _appVersion; }
		private static var _appVersion:String;
		
		/**
		 * <span lang="ja">SWF ファイルを再生中のブラウザからプラットフォーム名を取得します。</span>
		 * <span lang="en">Get the platform name from the browser which playing the SWF file.</span>
		 */
		public static function get platform():String { return _platform; }
		private static var _platform:String;
		
		/**
		 * <span lang="ja">SWF ファイルを再生中のブラウザからエージェント名を取得します。</span>
		 * <span lang="en">Get the agent name from the browser which playing the SWF file.</span>
		 */
		public static function get userAgent():String { return _userAgent; }
		private static var _userAgent:String;
		
		/**
		 * <span lang="ja">SWF ファイルを再生中のブラウザのタイトルを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public static function get documentTitle():String { return call( 'function() { return document.title; }' ) || ""; }
		public static function set documentTitle( value:String ):void {
			if ( _enabled ) {
				call( 'function( value ) { document.title = value; }', value );
			}
			else {
				Logger.info( "JavaScript.title" );
			}
		}
		
		/**
		 * <span lang="ja">SWF ファイルを再生中のブラウザから URL を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public static function get locationHref():String { return call( 'function() { return window.location.href; }' ) || ""; }
		public static function set locationHref( value:String ):void {
			if ( _enabled ) {
				call( 'function( value ) { window.location.href = value; }', value );
			}
			else {
				Logger.info( "JavaScript.locationHref" );
			}
		}
		
		
		
		
		
		/**
		 * 初期化する
		 */
		( function():void {
			// プレイヤー種別が対応していなければ終了する
			switch ( Capabilities.playerType ) {
				case "ActiveX"		:
				case "PlugIn"		: { break; }
				case "Desktop"		:
				case "External"		:
				case "StandAlone"	: { return; }
			}
			
			// セキュリティサンドボックスが対応していなければ終了する
			switch ( Security.sandboxType ) {
				case Security.REMOTE				:
				case Security.LOCAL_TRUSTED			: { break; }
				case Security.LOCAL_WITH_FILE		:
				case Security.LOCAL_WITH_NETWORK	: { return; }
			}
			
			// ExternalInterface が有効でなければ終了する
			if ( !ExternalInterface.available ) { return; }
			
			// PLAYSTATION 3 以外で実行されていれば
			if ( !new RegExp( "^PS3 " ).test( Capabilities.version ) ) {
				// objectID を確認する
				if ( !ExternalInterface.objectID ) { return; }
			}
			
			// 実際にスクリプトが実行できなければ終了する
			try {
				if ( ExternalInterface.call( 'function() { return "enabled"; }' ) != "enabled" ) { return; }
			}
			catch ( err:Error ) { return; }
			
			// 有効化する
			_enabled = true;
			
			// ブラウザ情報を取得する
			_appCodeName = call( 'function() { return navigator.appCodeName; }' );
			_appName = call( 'function() { return navigator.appName; }' );
			_appVersion = call( 'function() { return navigator.appVersion; }' );
			_platform = call( 'function() { return navigator.platform; }' );
			_userAgent = call( 'function() { return navigator.userAgent; }' );
		} )();
		
		
		
		
		
		/**
		 * @private
		 */
		public function JavaScript() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">Flash Player コンテナで公開されている関数を呼び出し、必要に応じてパラメータを渡します。</span>
		 * <span lang="en">Call the function which the Flash Player container opens and pass the parameter if needed.</span>
		 * 
		 * @param funcName
		 * <span lang="ja">実行したい関数名です。</span>
		 * <span lang="en">The name of the function to execute.</span>
		 * @param args
		 * <span lang="ja">引数に指定したい配列です。</span>
		 * <span lang="en">The array to specify as argument.</span>
		 * @return
		 * <span lang="ja">関数の戻り値を返します。</span>
		 * <span lang="en">The return value of the function.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function call( funcName:String, ... args:Array ):* {
			args.unshift( funcName );
			return _enabled ? StringUtil.toProperType( ExternalInterface.call.apply( null, args ) ) : null;
		}
		
		/**
		 * <span lang="ja">ActionScript メソッドをコンテナから呼び出し可能なものとして登録します。</span>
		 * <span lang="en">Register the ActionScript method as callable from the container.</span>
		 * 
		 * @param funcName
		 * <span lang="ja">コンテナが関数を呼び出すことができる名前です。</span>
		 * <span lang="en">The name that the container can function call.</span>
		 * @param closure
		 * <span lang="ja">呼び出す関数閉包です。これは独立した関数にすることも、オブジェクトインスタンスのメソッドを参照するメソッド閉包とすることもできます。メソッド閉包を渡すことで、特定のオブジェクトインスタンスのメソッドでコールバックを実際にダイレクトできます。</span>
		 * <span lang="en">The function closure to call. This can be an independent function or method closure which refer the method of the object instance. By passing the method closure, it is actually able to direct the callback by method of the perticular object instance.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function addCallback( funcName:String, closure:Function ):void {
			if ( !enabled ) { return; }
			ExternalInterface.addCallback( funcName, closure );
		}
		
		/**
		 * <span lang="ja">JavaScript を使用したアラートを表示します。</span>
		 * <span lang="en">Displays the alert using JavaScript.</span>
		 * 
		 * @param messages
		 * <span lang="ja">出力したいストリングです。</span>
		 * <span lang="en">The strings to display.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function alert( ... messages:Array ):void {
			var message:String = messages.join( " " );
			
			if ( _enabled ) {
				call( 'function() { alert( "' + message + '" ); }' );
			}
			else {
				Logger.info( "JavaScript.alert(", message, ")" );
			}
		}
		
		/**
		 * <span lang="ja">JavaScript を使用した問い合わせダイアログを表示します。</span>
		 * <span lang="en">Displays the inquiry dialog using JavaScript.</span>
		 * 
		 * @param messages
		 * <span lang="ja">出力したいストリングです。</span>
		 * <span lang="en">The strings to display.</span>
		 * @return
		 * <span lang="ja">ユーザーが [OK] をクリックしたときは true、[キャンセル] をクリックしたときは false を返します。</span>
		 * <span lang="en">Returns true when the user clicked "OK" and false when clicked "Cancel".</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function confirm( ... messages:Array ):Boolean {
			var message:String = messages.join( " " );
			
			if ( _enabled ) { return Boolean( !!StringUtil.toProperType( call( 'function() { confirm( "' + message + '" ); }' ) ) ); }
			
			Logger.info( "JavaScript.confirm(", message, ")" );
			
			return false;
		}
		
		/**
		 * <span lang="ja">JavaScript を使用したプロンプトを表示します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param messages
		 * <span lang="ja">出力したいストリングです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">ユーザーが入力したストリングです。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function prompt( ... messages:Array ):String {
			var message:String = messages.join( " " );
			
			if ( _enabled ) { return call( 'function() { prompt( "' + message + '" ); }' ); }
			
			Logger.info( "JavaScript.prompt(", message, ")" );
			
			return null;
		}
		
		/**
		 * <span lang="ja">ブラウザを再読み込みします。</span>
		 * <span lang="en">Reload the browser.</span>
		 * 
		 * @param enforce
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function reload( enforce:Boolean = true ):void {
			if ( _enabled ) {
				call( 'function() { window.location.reload( ' + String( enforce ) + ' ); }' );
			}
			else {
				Logger.info( "JavaScript.reload( " + String( enforce ) + " )" );
			}
		}
		
		/**
		 * <span lang="ja">ブラウザの印刷ダイアログを表示します。</span>
		 * <span lang="en">Displays the print dialog of the browser.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function print():void {
			if ( _enabled ) {
				call( 'function() { window.print(); }' );
			}
			else {
				Logger.info( "JavaScript.print()" );
			}
		}
	}
}
