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
package jp.progression.commands {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import jp.nium.utils.ObjectUtil;
	
	/**
	 * <span lang="ja">Func クラスは、指定された関数を実行するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // 関数を作成する
	 * var myfunc:Function = function():void {
	 * 	trace( "関数を実行しました。" );
	 * 	trace( "実行中の関数内での this は、登録されている Func インスタンスになります。", this );
	 * };
	 * 
	 * // Func インスタンスを作成する
	 * var com:Func = new Func( myfunc );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class Func extends Command {
		
		/**
		 * @private
		 */
		internal static var _variables:Object = {};
		
		
		
		
		
		/**
		 * <span lang="ja">実行したい関数を取得します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #args
		 */
		public function get func():Function { return _func; }
		public function set func( value:Function ):void { _func = value; }
		private var _func:Function;
		
		/**
		 * <span lang="ja">関数を実行する際に引数として使用する配列を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #func
		 * 
		 * @example <listing version="3.0">
		 * // 関数を作成する
		 * var myfunc:Function = function( num1:Number, num2:Number ):void {
		 * 	trace( "result = ", num1 * num2 ); // result = 2000
		 * };
		 * 
		 * // Func インスタンスを作成する
		 * var com:Func = new Func( myfunc, [ 100, 20 ] );
		 * 
		 * // コマンドを実行する
		 * com.execute();
		 * </listing>
		 */
		public function get args():Array { return _args; }
		public function set args( value:Array ):void { _args = value; }
		private var _args:Array;
		
		/**
		 * <span lang="ja">処理の終了イベントを発行する IEventDispatcher インスタンスを取得します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #eventType
		 * @see #listening
		 * @see #listen()
		 */
		public function get dispatcher():IEventDispatcher { return _dispatcher; }
		private var _dispatcher:IEventDispatcher;
		
		/**
		 * <span lang="ja">発行される終了イベントの種類を取得します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #dispatcher
		 * @see #listening
		 * @see #listen()
		 */
		public function get eventType():String { return _eventType; }
		private var _eventType:String;
		
		/**
		 * <span lang="ja">イベント待ちをしているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #dispatcher
		 * @see #eventType
		 * @see #listen()
		 */
		public function get listening():Boolean { return _listening; }
		private var _listening:Boolean = false;
		
		/**
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 */
		public function get eventObject():Event { return _eventObject; }
		private var _eventObject:Event;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Func インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Func object.</span>
		 * 
		 * @param func
		 * <span lang="ja">実行したい関数です。</span>
		 * <span lang="en"></span>
		 * @param args
		 * <span lang="ja">関数を実行する際に引数として使用する配列です。</span>
		 * <span lang="en"></span>
		 * @param dispatcher
		 * <span lang="ja">処理の終了イベントを発行する EventDispatcher インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param eventType
		 * <span lang="ja">発行される終了イベントの種類です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function Func( func:Function, args:Array = null, dispatcher:IEventDispatcher = null, eventType:String = null, initObject:Object = null ) {
			// 引数を設定する
			_func = func;
			_args = args;
			_dispatcher = dispatcher;
			_eventType = eventType;
			
			// 親クラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// 初期化する
			_eventObject = null;
			
			// イベントが存在するかどうか確認する
			_listening = ( _dispatcher && _eventType );
			
			// イベントが存在すれば登録する
			if ( _listening ) {
				_dispatcher.addEventListener( _eventType, _listener );
			}
			
			// 関数を実行する
			_func.apply( this, _args );
			
			// イベントが存在すれば終了する
			if ( _listening ) { return; }
			
			// 実行中であれば
			if ( super.state > 1 ) {
				super.executeComplete();
			}
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void {
			// イベントを監視していれば
			if ( _listening ) {
				// イベントリスナーを解除する
				_dispatcher.removeEventListener( _eventType, _listener );
			}
		}
		
		/**
		 * <span lang="ja">イベント待ちを設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param dispatcher
		 * <span lang="ja">イベントの送出元です。</span>
		 * <span lang="en"></span>
		 * @param eventType
		 * <span lang="ja">送出されるのを待つイベントタイプです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #dispatcher
		 * @see #eventType
		 * @see #listening
		 * 
		 * @example <listing version="3.0">
		 * // 関数を作成する
		 * var myfunc:Function = function():void {
		 * 	// ステージがクリックされるまで待機する
		 * 	this.listen( stage, MouseEvent.CLICK );
		 * };
		 * 
		 * // SerialList インスタンスを作成する
		 * var com:SerialList = new SerialList( null,
		 * 	new Trace( "start" ),
		 * 	new Func( myfunc ),
		 * 	new Trace( "complete" )
		 * );
		 * 
		 * // コマンドを実行する
		 * com.execute();
		 * </listing>
		 */
		public function listen( dispatcher:IEventDispatcher, eventType:String ):void {
			if ( _listening ) {
				_listening = false;
				_dispatcher.removeEventListener( _eventType, _listener );
			}
			
			_dispatcher = dispatcher;
			_eventType = eventType;
			
			if ( _dispatcher && _eventType ) {
				_listening = true;
				_dispatcher.addEventListener( _eventType, _listener );
			}
		}
		
		/**
		 * <span lang="ja">イベント待ちを解除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #dispatcher
		 * @see #eventType
		 * @see #listening
		 */
		public function unlisten():void {
			if ( _listening ) {
				_listening = false;
				_dispatcher.removeEventListener( _eventType, _listener );
			}
			
			_dispatcher = null;
			_eventType = null;
		}
		
		/**
		 * <span lang="ja">設定された値を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param name
		 * <span lang="ja">取得したい変数名です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">取得した値です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #setVar()
		 * @see jp.progression.commands.Var
		 */
		public function getVar( name:String ):* {
			return _variables[name];
		}
		
		/**
		 * <span lang="ja">指定された変数名に値を設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param name
		 * <span lang="ja">設定したい変数名です。</span>
		 * <span lang="en"></span>
		 * @param value
		 * <span lang="ja">設定したい値です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #getVar()
		 * @see jp.progression.commands.Var
		 */
		public function setVar( name:String, value:* ):void {
			_variables[name] = value;
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			if ( _listening ) {
				_listening = false;
				_dispatcher.removeEventListener( _eventType, _listener );
			}
			
			_func = null;
			_args = null;
			_dispatcher = null;
			_eventType = null;
			_eventObject = null;
		}
		
		/**
		 * <span lang="ja">Func インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an Func subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい Func インスタンスです。</span>
		 * <span lang="en">A new Func object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new Func( _func, _args, _dispatcher, _eventType, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, _dispatcher ? "dispatcher" : null, _eventType ? "eventType" : null );
		}
		
		
		
		
		
		/**
		 * dispatcher の eventType イベントが発生した瞬間に送出されます。
		 */
		private function _listener( e:Event ):void {
			// イベントリスナーを解除する
			_dispatcher.removeEventListener( _eventType, _listener );
			
			// イベントオブジェクトを保持する
			_eventObject = e;
			
			// 実行中であれば
			if ( super.state > 1 ) {
				super.executeComplete();
			}
		}
	}
}
