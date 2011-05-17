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
	import jp.progression.events.ExecuteErrorEvent;
	import jp.progression.events.ExecuteEvent;
	import jp.progression.executors.ExecutorObject;
	
	/**
	 * <span lang="ja">DoExecutor クラスは、指定された対象の ExecutorObject を実行するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // DoExecutor インスタンスを作成する
	 * var com:DoExecutor = new DoExecutor();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class DoExecutor extends Command {
		
		/**
		 * <span lang="ja">実行したい ExecutorObject インスタンスを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get executor():ExecutorObject { return _executor; }
		public function set executor( value:ExecutorObject ):void { _executor = value; }
		private var _executor:ExecutorObject;
		
		/**
		 * <span lang="ja">ExecutorObject に登録された対象に対して送出するトリガーイベントを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get event():Event { return _event; }
		public function set event( value:Event ):void { _event = value; }
		private var _event:Event;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい DoExecutor インスタンスを作成します。</span>
		 * <span lang="en">Creates a new DoExecutor object.</span>
		 * 
		 * @param executor
		 * <span lang="ja">実行したい ExecutorObject です。</span>
		 * <span lang="en"></span>
		 * @param event
		 * <span lang="en">ExecutorObject に登録された対象に対して送出するトリガーイベントです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function DoExecutor( executor:ExecutorObject, event:Event, initObject:Object = null ) {
			// 引数を設定する
			_executor = executor;
			_event = event;
			
			// スーパークラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// イベントリスナーを登録する
			_executor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
			_executor.addEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
			_executor.addEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
			
			// 実行する
			_executor.execute( _event, super.extra );
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void {
			// 実行中であれば
			if ( _executor.state > 0 ) {
				// 実行する
				_executor.interrupt();
			}
			else {
				// イベントリスナーを解除する
				_removeExecutorListeners();
			}
		}
		
		/**
		 * CommandExecutor のイベントリスナーを解除します。
		 */
		private function _removeExecutorListeners():void {
			if ( _executor ) {
				// イベントリスナーを解除する
				_executor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				_executor.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				_executor.removeEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			if ( _executor ) {
				_executor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				_executor.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				_executor.removeEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
				
				_executor = null;
			}
			
			_event = null;
		}
		
		/**
		 * <span lang="ja">DoExecutor インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an DoExecutor subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい DoExecutor インスタンスです。</span>
		 * <span lang="en">A new DoExecutor object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new DoExecutor( _executor, _event, this );
		}
		
		
		
		
		
		/**
		 * 処理が完了した場合に送出されます。
		 */
		private function _executeComplete( e:ExecuteEvent ):void {
			// イベントリスナーを解除する
			_removeExecutorListeners();
			
			// 処理を終了する
			super.executeComplete();
		}
		
		/**
		 * 処理が中断された場合に送出されます。
		 */
		private function _executeInterrupt( e:ExecuteEvent ):void {
			// イベントリスナーを解除する
			_removeExecutorListeners();
		}
		
		/**
		 * 処理の途中でエラーが発生した場合に送出されます。
		 */
		private function _error( e:ExecuteErrorEvent ):void {
			super.throwError( this, e.errorObject );
		}
	}
}
