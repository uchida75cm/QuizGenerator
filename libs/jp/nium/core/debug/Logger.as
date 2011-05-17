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
package jp.nium.core.debug {
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.Dictionary;
	import jp.nium.core.debug.Log;
	import jp.nium.core.I18N.Locale;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * @private
	 */
	public final class Logger {
		
		/**
		 * <span lang="ja">ログの出力に使用する LocalConnection の接続名を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static const APPLICATION_OUTPUT_ID:String = "application/nium-logger-output";
		
		/**
		 * <span lang="ja">通常の情報を出力するように設定します。</span>
		 * <span lang="en"></span>
		 */
		public static const INFO:int = 0;
		
		/**
		 * <span lang="ja">警告情報を出力するように設定します。</span>
		 * <span lang="en"></span>
		 */
		public static const WARN:int = 1;
		
		/**
		 * <span lang="ja">問題情報を出力するように設定します。</span>
		 * <span lang="en"></span>
		 */
		public static const ERROR:int = 2;
		
		/**
		 * 未知のエラーです。
		 */
		private static var _unknownLog:Log = new Log( "UNKNOWN", "The error is unknown." );
		
		
		
		
		
		/**
		 * <span lang="ja">ログ出力を有効化するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public static function get enabled():Boolean { return _enabled; }
		public static function set enabled( value:Boolean ):void { _enabled = value; }
		private static var _enabled:Boolean = true;
		
		/**
		 * <span lang="ja">監視レベルを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public static function get level():int { return _level; }
		public static function set level( value:int ):void {
			switch ( value ) {
				case INFO		:
				case WARN		:
				case ERROR		: { _level = value; break; }
				default			: { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_003 ).toString( "level" ) ); }
			}
		}
		private static var _level:int = INFO;
		
		/**
		 * <span lang="ja">出力されるメッセージに対して連番を付加するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public static function get insertSerialNums():Boolean { return _insertSerialNums; }
		public static function set insertSerialNums( value:Boolean ):void { _insertSerialNums = value; }
		private static var _insertSerialNums:Boolean = false;
		
		/**
		 * 現在の連番値を取得します。
		 */
		private static var _serialNums:uint = 1;
		
		/**
		 * <span lang="ja">ログ出力に使用するロギング関数を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public static function get loggingFunction():Function { return _loggingFunction; }
		public static function set loggingFunction( value:Function ):void { _loggingFunction = value; }
		private static var _loggingFunction:Function;
		
		/**
		 * 登録された Log インスタンスを保持している Dictionary インスタンスを取得します。
		 */
		private static var _logs:Dictionary = new Dictionary();
		
		/**
		 * ログの出力に使用する LocalConnection インスタンスを取得します。
		 */
		private static var _connect:LocalConnection = new LocalConnection();
		
		
		
		
		
		/**
		 * 初期化する
		 */
		( function():void {
			// イベントリスナーを登録する
			_connect.addEventListener( StatusEvent.STATUS, _status, false, 0, true );
		} )();
		
		
		
		
		
		/**
		 * @private
		 */
		public function Logger() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">ログを登録します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param log
		 * <span lang="ja">登録したいログです。</span>
		 * <span lang="en"></span>
		 * @param language
		 * <span lang="ja">ログが対応する言語です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #getLog()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function setLog( log:Log, language:String ):void {
			_logs[language] ||= new Dictionary();
			_logs[language][log.id] = log;
		}
		
		/**
		 * <span lang="ja">指定された識別子で登録されているログを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param id
		 * <span lang="ja">取得したいログの識別子です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">条件に合致したログです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #setLog()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function getLog( id:String ):Log {
			return getLogByLang( id, Locale.language );
		}
		
		/**
		 * <span lang="ja">指定された識別子で登録されているログを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param id
		 * <span lang="ja">取得したいログの識別子です。</span>
		 * <span lang="en"></span>
		 * @param language
		 * <span lang="ja">取得したいログが対応する言語です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">条件に合致したログです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #setLog()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function getLogByLang( id:String, language:String ):Log {
			for ( var p:String in _logs ) {
				if ( p != language ) { continue; }
				
				for each ( var log:Log in _logs[p] ) {
					if ( id == log.id ) { return log; }
				}
			}
			
			return _unknownLog;
		}
		
		/**
		 * <span lang="ja">メッセージを出力します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param messages
		 * <span lang="ja">出力されるストリングを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #info()
		 * @see #warn()
		 * @see #error()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function output( ... messages:Array ):void {
			// 出力条件を満たしていなければ終了する
			if ( !_enabled ) { return; }
			
			_trace( messages.join( " " ) );
		}
		
		/**
		 * <span lang="ja">情報メッセージを出力します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param messages
		 * <span lang="ja">出力されるストリングを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #output()
		 * @see #warn()
		 * @see #error()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function info( ... messages:Array ):void {
			// 出力条件を満たしていなければ終了する
			if ( !_enabled || _level > INFO ) { return; }
			
			_trace( "  [info]", messages.join( " " ) );
		}
		
		/**
		 * <span lang="ja">メッセージを警告文として出力します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param messages
		 * <span lang="ja">出力されるストリングを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #output()
		 * @see #info()
		 * @see #error()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function warn( ... messages:Array ):void {
			// 出力条件を満たしていなければ終了する
			if ( !_enabled || _level > WARN ) { return; }
			
			_trace( "  [warn]", messages.join( " " ) );
		}
		
		/**
		 * <span lang="ja">メッセージをエラー文として出力します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param messages
		 * <span lang="ja">出力されるストリングを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #output()
		 * @see #info()
		 * @see #warn()
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function error( ... messages:Array ):void {
			// 出力条件を満たしていなければ終了する
			if ( !_enabled || _level > ERROR ) { return; }
			
			_trace( "  [error]", messages.join( " " ) );
		}
		
		/**
		 * <span lang="ja">区切り線を出力します。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function separate():void {
			// 出力条件を満たしていなければ終了する
			if ( !_enabled ) { return; }
			
			_trace( "\n----------------------------------------------------------------------" );
		}
		
		/**
		 * <span lang="ja">行を送ります。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function br():void {
			// 出力条件を満たしていなければ終了する
			if ( !_enabled ) { return; }
			
			_trace( " " );
		}
		
		/**
		 * 任意の出力関数でトレースします。
		 */
		private static function _trace( ... messages:Array ):void {
			// シリアルナンバーを付加するのであれば
			if ( _insertSerialNums ) {
				messages.unshift( "#" + _serialNums++ + ":" );
			}
			
			if ( _loggingFunction != null ) {
				_loggingFunction.apply( null, messages );
			}
			else {
				trace( messages.join( " " ) );
			}
			
			try {
				_connect.send( APPLICATION_OUTPUT_ID, "output", messages.join( " " ) );
			}
			catch ( err:Error ) {}
		}
		
		
		
		
		
		/**
		 * LocalConnection オブジェクトがステータスを報告するときに送出されます。
		 */
		private static function _status( e:StatusEvent ):void {
		}
	}
}
