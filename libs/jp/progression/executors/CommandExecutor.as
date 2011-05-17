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
package jp.progression.executors {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import jp.nium.core.debug.Logger;
	import jp.progression.commands.CommandList;
	import jp.progression.commands.lists.ParallelList;
	import jp.progression.commands.lists.SerialList;
	import jp.progression.core.L10N.L10NExecuteMsg;
	import jp.progression.events.ExecuteErrorEvent;
	import jp.progression.events.ExecuteEvent;
	
	/**
	 * <span lang="ja">CommandExecutor クラスは、コマンドを使用した非同期処理の実装を提供するための実行クラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // CommandExecutor インスタンスを作成する
	 * var executor:CommandExecutor = new CommandExecutor();
	 * 
	 * // CommandExecutor を実行する
	 * executor.execute( new Event( Event.COMPLETE ) );
	 * </listing>
	 */
	public class CommandExecutor extends ExecutorObject {
		
		/**
		 * <span lang="ja">現在処理している CommandList インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get current():CommandList { return _current; }
		private var _current:CommandList;
		
		/**
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 */
		public function get useParallelList():Boolean { return _useParallelList; }
		public function set useParallelList( value:Boolean ):void {
			_useParallelList = value;
			
			// 存在しなければ終了する
			if ( !_current ) { return; }
			
			if ( _useParallelList ) {
				_current = new ParallelList();
			}
			else {
				_current = new SerialList();
			}
		}
		private var _useParallelList:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい CommandExecutor インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CommandExecutor object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい IEventDispatcher インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function CommandExecutor( target:IEventDispatcher ) {
			// 親クラスを初期化する
			super( target, _executeFunction, _interruptFunction );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">処理を実行します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param event
		 * <span lang="en">ExecutorObject に登録された対象に対して送出するトリガーイベントです。</span>
		 * <span lang="en"></span>
		 * @param extra
		 * <span lang="ja">実行時に設定されるリレーオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param preRegistration
		 * <span lang="ja">実行対象の ExecutorObject を処理を行う前に登録するようにするかどうかです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #state
		 * @see #extra
		 * @see #executeComplete()
		 * @see #interrupt()
		 */
		override public function execute( event:Event, extra:Object = null, preRegistration:Boolean = true ):void {
			// CommandList を作成する
			if ( _useParallelList ) {
				_current = new ParallelList();
			}
			else {
				_current = new SerialList();
			}
			
			// 親のメソッドを実行する
			super.execute( event, extra, preRegistration );
		}
		
		/**
		 * 実行される ExecutorObject の実装です。
		 */
		private function _executeFunction():void {
			if ( _current ) {
				// イベントリスナーを登録する
				_current.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				_current.addEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				_current.addEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
				
				// コマンドを実行する
				_current.execute( super.extra );
			}
			else {
				// 処理を完了する
				super.executeComplete();
			}
		}
		
		/**
		 * 中断実行される ExecutorObject の実装です。
		 */
		private function _interruptFunction():void {
			// コマンドが存在し、実行中であれば中断する
			if ( _current && _current.state > 0 ) {
				_current.interrupt();
			}
		}
		
		/**
		 * <span lang="ja">特定のイベントが送出された際に、自動実行させたい Command インスタンスをリストの最後尾に追加します。
		 * 追加された Command インスタンスは、イベントが送出される直前に自動的に削除されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #insertCommand()
		 * @see #clearCommand()
		 */
		public function addCommand( ... commands:Array ):void {
			if ( super.state < 1 ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_000 ).toString( super.className ) ); }
			if ( commands.length == 0 ) { return; }
			
			// 登録する
			_current.addCommand.apply( null, commands );
		}
		
		/**
		 * <span lang="ja">特定のイベントが送出された際に、自動実行させたい Command インスタンスをすでにリストに登録され、実行中の Command インスタンスの次の位置に追加します。
		 * 追加された Command インスタンスは、イベントが送出される直前に自動的に削除されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #addCommand()
		 * @see #clearCommand()
		 */
		public function insertCommand( ... commands:Array ):void {
			if ( super.state < 1 ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_000 ).toString( super.className ) ); }
			if ( commands.length == 0 ) { return; }
			
			// 登録する
			_current.insertCommand.apply( null, commands );
		}
		
		/**
		 * <span lang="ja">登録されている Command インスタンスを削除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param completely
		 * <span lang="en">true が設定されている場合は登録されている全てのコマンド登録を解除し、false の場合には現在処理中のコマンド以降の登録を解除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #addCommand()
		 * @see #insertCommand()
		 */
		public function clearCommand( completely:Boolean = false ):void {
			if ( super.state < 1 ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_000 ).toString( super.className ) ); }
			
			// 登録を削除する
			_current.clearCommand( completely );
		}
		
		/**
		 * <span lang="ja">ExecutorObject の登録情報を解放します。
		 * dispose() メソッドが呼び出されると、それ以降はこのインスタンスのメソッドまたはプロパティを呼び出すと失敗し、例外がスローされます。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 破棄する
			if ( _current ) {
				_current.clearCommand( true );
				_current = null;
			}
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			if ( _current ) {
				// イベントリスナーを解除する
				_current.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				_current.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				_current.removeEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
				
				// 破棄する
				_current.clearCommand();
			}
		}
		
		
		
		
		
		/**
		 * 処理が完了した場合に送出されます。
		 */
		private function _executeComplete( e:ExecuteEvent ):void {
			// 破棄する
			_destroy();
			
			// 処理を完了する
			super.executeComplete();
		}
		
		/**
		 * 処理が中断された場合に送出されます。
		 */
		private function _executeInterrupt( e:ExecuteEvent ):void {
			// 破棄する
			_destroy();
			
			// 処理を中断する
			super.interrupt();
		}
		
		/**
		 * 処理の途中でエラーが発生した場合に送出されます。
		 */
		private function _error( e:ExecuteErrorEvent ):void {
			// 破棄する
			_destroy();
			
			// メッセージを追記する
			var messages:Array = e.errorObject.message.split( "\n" );
			messages.splice( 1, 0, "\tat " + super.className + " in the \"" + super.eventType + "\" event on " + super.target );
			e.errorObject.message = messages.join( "\n" );
			
			// イベントリスナーが設定されていれば
			if ( super.hasEventListener( e.type ) ) {
				// イベントを送出する
				super.dispatchEvent( e );
			}
			else {
				// 例外をスローする
				throw e.errorObject;
			}
		}
	}
}

