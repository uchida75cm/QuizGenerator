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
package jp.progression.commands.lists {
	import flash.events.ProgressEvent;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	import jp.progression.commands.net.ILoadable;
	import jp.progression.core.L10N.L10NExecuteMsg;
	import jp.progression.events.ExecuteEvent;
	
	/**
	 * <span lang="ja">ダウンロード処理を実行中にデータを受信したときに送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event( name="progress", type="flash.events.ProgressEvent" )]
	
	/**
	 * <span lang="ja">LoaderList クラスは、複数の ILoadable インターフェイスを実装したコマンドをまとめて管理するためのコマンドリストクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // LoaderList インスタンスを作成する
	 * var list:LoaderList = new LoaderList();
	 * 
	 * // イベントハンドラメソッドを設定する
	 * list.onStart = function():void {
	 * 	trace( "読み込みを開始" );
	 * };
	 * list.onProgress = function():void {
	 * 	trace( this.percent, "%", this.loaded, "/", this.total );
	 * };
	 * list.onComplete = function():void {
	 * 	trace( "読み込んだデータ =", this.data );
	 * };
	 * 
	 * // 読み込み処理を設定する
	 * list.addCommand(
	 * 	new LoadURL( new URLRequest( "example.xml" ) ),
	 * 	new LoadBitmapData( new URLRequest( "example.png" ) ),
	 * 	new LoadSWF( new URLRequest( "example.swf" ) )
	 * );
	 * 
	 * // コマンドを実行する
	 * list.execute();
	 * </listing>
	 */
	public class LoaderList extends SerialList implements ILoadable {
		
		/**
		 * <span lang="ja">自身から見て最後に関連付けられた読み込みデータを取得または設定します。
		 * このコマンドインスタンスが CommandList インスタンス上に存在する場合には、自身より前、または自身の親のデータを取得します。</span>
		 * <span lang="en"></span>
		 */
		override public function get latestData():* { return _data; }
		override public function set latestData( value:* ):void { super.latestData = value; }
		
		/**
		 * <span lang="ja">読み込み操作によって受信したデータです。</span>
		 * <span lang="en">The data received from the load operation.</span>
		 */
		public function get data():* { return _data; }
		public function set data( value:* ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_013 ).toString( "data" ) ); }
		private function get _data():* {
			var data:Array = [];
			var commands:Array = super.commands;
			
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var loadable:ILoadable = commands[i] as Command as ILoadable;
				
				if ( !loadable ) { continue; }
				
				var latestData:* = loadable.data;
				
				if ( latestData != null ) {
					data = data.concat( latestData );
				}
				else {
					data.push( latestData );
				}
			}
			
			return data;
		}
		
		/**
		 * <span lang="ja">現在の読み込み対象を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():ILoadable {
			if ( _current is LoaderList ) { return _current.target; }
			if ( _current ) { return _current; }
			return null;
		}
		
		/**
		 * 現在の読み込み対象を取得します。
		 */
		private var _current:ILoadable;
		
		/**
		 * <span lang="ja">percent プロパティの算出時の自身の重要性を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #percent
		 */
		public function get factor():Number { return _factor; }
		public function set factor( value:Number ):void { _factor = value; }
		private var _factor:Number = 1.0;
		
		/**
		 * <span lang="ja">loaded プロパティと total プロパティから算出される読み込み状態をパーセントで取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #factor
		 * @see #loaded
		 * @see #total
		 */
		public function get percent():Number {
			var commands:Array = super.commands;
			var percent:Number = 0;
			var factor:Number = 0;
			
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var command:ILoadable = commands[i] as ILoadable;
				
				if ( !command ) { continue; }
				
				percent += command.percent * command.factor;
				factor += command.factor;
			}
			
			return factor ? percent / factor : 100;
		}
		
		/**
		 * <span lang="ja">登録されている ILoadable を実装したインスタンスの内、すでに読み込み処理が完了した数を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get loaded():uint {
			var commands:Array = super.commands;
			var loaded:int = 0;
			
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var command:ILoadable = commands[i] as ILoadable;
				if ( !command ) { continue; }
				loaded += command.loaded;
			}
			
			return loaded;
		}
		
		/**
		 * <span lang="ja">登録されている ILoadable を実装したインスタンスの総数を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get total():uint {
			var commands:Array = super.commands;
			var total:int = 0;
			
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var command:ILoadable = commands[i] as ILoadable;
				if ( !command ) { continue; }
				total += command.total;
			}
			
			return total;
		}
		
		/**
		 * <span lang="ja">コマンドの読み込み済みのバイト数です。</span>
		 * <span lang="en">The number of bytes that are loaded for the command.</span>
		 */
		public function get bytesLoaded():uint { return _bytesLoaded; }
		private var _bytesLoaded:uint = 0;
		
		/**
		 * <span lang="ja">コマンド全体の圧縮後のバイト数です。</span>
		 * <span lang="en">The number of compressed bytes in the entire command.</span>
		 */
		public function get bytesTotal():uint { return _bytesTotal; }
		private var _bytesTotal:uint = 0;
		
		/**
		 * エラーが発生中であるかどうかを取得します。
		 */
		private var _error:Boolean = false;
		
		/**
		 * <span lang="ja">コマンドオブジェクトが ProgressEvent.PROGRESS イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #scope
		 * @see flash.events.ProgressEvent#PROGRESS
		 */
		public function get onProgress():Function { return _onProgress; }
		public function set onProgress( value:Function ):void { _onProgress = value; }
		private var _onProgress:Function;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい LoaderList インスタンスを作成します。</span>
		 * <span lang="en">Creates a new LoaderList object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param commands
		 * <span lang="ja">登録したいコマンドインスタンス、関数、数値、配列などを含む配列です。</span>
		 * <span lang="en"></span>
		 */
		public function LoaderList( initObject:Object = null, ... commands:Array ) {
			// 親クラスを初期化する
			super( initObject );
			
			// initObject が LoaderList であれば
			var com:LoaderList = initObject as LoaderList;
			if ( com ) {
				// 特定のプロパティを継承する
				_factor = com._factor;
				_onProgress = com._onProgress;
			}
			
			// コマンドリストに登録する
			super.addCommand.apply( null, commands );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">コマンドインスタンスを実行します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param extra
		 * <span lang="ja">実行時に設定されるリレーオブジェクトです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #state
		 * @see #delay
		 * @see #timeout
		 * @see #scope
		 * @see #extra
		 * @see #executeComplete()
		 * @see #interrupt()
		 */
		override public function execute( extra:Object = null ):void {
			// イベントリスナーを登録する
			super.addEventListener( ExecuteEvent.EXECUTE_POSITION, _executePosition );
			super.addEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
			
			// 初期化する
			_error = false;
			
			// 親のメソッドを実行する
			super.execute( extra );
		}
		
		/**
		 * <span lang="ja">実行中のコマンド処理が完了したことを通知します。
		 * このメソッドを実行するためには、事前に execute() メソッドが実行されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #state
		 * @see #interrupt()
		 */
		override public function executeComplete():void {
			// すでにエラーが発生していれば終了する
			if ( _error ) { return; }
			
			// イベントリスナーを解除する
			super.removeEventListener( ExecuteEvent.EXECUTE_POSITION, _executePosition );
			super.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
			
			// 正常に読み込みが完了していれば
			if ( percent == 100 ) {
				// 親のメソッドを実行する
				super.executeComplete();
			}
			else {
				// エラー状態にする
				_error = true;
				
				// 例外をスローする
				super.throwError( this, new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_007 ).toString( super.className ) ) );
			}
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			_bytesLoaded = 0;
			_bytesTotal = 0;
			
			if ( _current ) {
				// イベントリスナーを解除する
				_current.removeEventListener( ProgressEvent.PROGRESS, _progress );
				_current.removeEventListener( ProgressEvent.PROGRESS, __progress );
				
				// 現在の対象を設定する
				_current = null;
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_onProgress = null;
		}
		
		/**
		 * <span lang="ja">LoaderList インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an LoaderList subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい LoaderList インスタンスです。</span>
		 * <span lang="en">A new LoaderList object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new LoaderList( this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "factor" );
		}
		
		
		
		
		/**
		 * リストに登録されているコマンドの実行処理位置が変更された場合に送出されます。
		 */
		private function _executePosition( e:ExecuteEvent ):void {
			// 破棄する
			_destroy();
			
			// 現在の対象を設定する
			_current = commands[super.position - 1] as ILoadable;
			
			// イベントリスナーを登録する
			if ( _current ) {
				_current.addEventListener( ProgressEvent.PROGRESS, _progress, false, int.MAX_VALUE );
				_current.addEventListener( ProgressEvent.PROGRESS, __progress );
			}
		}
		
		/**
		 * コマンドの処理が中断された場合に送出されます。
		 */
		private function _executeInterrupt( e:ExecuteEvent ):void {
			// 破棄する
			_destroy();
		}
		
		/**
		 * ダウンロード処理を実行中にデータを受信したときに送出されます。
		 */
		private function _progress( e:ProgressEvent ):void {
			// 現在の進捗を取得する
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
		}
		
		/**
		 * ダウンロード処理を実行中にデータを受信したときに送出されます。
		 */
		private function __progress( e:ProgressEvent ):void {
			// イベントを送出する
			super.dispatchEvent( e );
			
			// イベントハンドラメソッドを実行する
			if ( _onProgress != null ) {
				_onProgress.apply( scope || this );
			}
		}
	}
}
