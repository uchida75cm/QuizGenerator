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
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import jp.nium.core.debug.Logger;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.L10N.L10NExecuteMsg;
	import jp.progression.events.ExecuteErrorEvent;
	
	/**
	 * <span lang="ja">ResumeExecutor クラスは、停止・再開という状態変化による非同期処理の実装を提供するための実行クラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // ResumeExecutor インスタンスを作成する
	 * var executor:ResumeExecutor = new ResumeExecutor();
	 * 
	 * // ResumeExecutor を実行する
	 * executor.execute( new Event( Event.COMPLETE ) );
	 * </listing>
	 */
	public class ResumeExecutor extends ExecutorObject {
		
		/**
		 * <span lang="ja">timeout プロパティの初期値を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #timeout
		 */
		public static function get defaultTimeout():Number { return _defaultTimeout; }
		public static function set defaultTimeout( value:Number ):void { _defaultTimeout = value; }
		private static var _defaultTimeout:Number = 15.0;
		
		
		
		
		
		/**
		 * <span lang="ja">ExecutorObject インスタンス実行中のタイムアウト時間を取得または設定します。
		 * 指定された時間中に executeComplete() メソッド、または interrupt() メソッドが実行されなかった場合にはエラーが送出されます。
		 * この値が 0 に設定されている場合、タイムアウト処理は発生しません。</span>
		 * <span lang="en"></span>
		 */
		public function get timeout():Number { return _timeout; }
		public function set timeout( value:Number ):void { _timeout = value; }
		private var _timeout:Number = 0.0;
		
		/**
		 * <span lang="ja">待機処理が実行中であるかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get pausing():Boolean { return _pausing; }
		private var _pausing:Boolean = false;
		
		/**
		 * Timer インスタンスを取得します。 
		 */
		private var _timer:Timer;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ResumeExecutor インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ResumeExecutor object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい IEventDispatcher インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function ResumeExecutor( target:IEventDispatcher ) {
			// 初期化する
			_timeout = _defaultTimeout;
			
			// 親クラスを初期化する
			super( target, _executeFunction, _interruptFunction );
		}
		
		
		
		
		
		/**
		 * 実行される ExecutorObject の実装です。
		 */
		private function _executeFunction():void {
			// 実行されていなければ終了する
			if ( super.state < 1 ) { return; }
			
			// 待機状態でなければ終了する
			if ( !_pausing ) {
				super.executeComplete();
				return;
			}
			
			// ミリ秒に変換する
			var time:Number = Math.round( _timeout * 1000 );
			
			// 時間が 1 未満であれば
			if ( time < 1 ) { return; }
			
			// Timer を作成する
			_timer = new Timer( time, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, _timerComplete );
			_timer.start();
		}
		
		/**
		 * 中断実行される ExecutorObject の実装です。
		 */
		private function _interruptFunction():void {
			// Timer を破棄する
			_destroyTimer();
			
			// 待機状態を無効化する
			_pausing = false;
		}
		
		/**
		 * <span lang="ja">現在の処理を待機状態にします。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #wating
		 * @see #resume()
		 */
		public function pause():void {
			_pausing = true;
		}
		
		/**
		 * <span lang="ja">待機状態にある処理を再開させます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #wating
		 * @see #wait()
		 */
		public function resume():void {
			// 実行中でなければ
			if ( super.state < 1 ) { throw new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_008 ).toString() ); }
			
			// Timer を破棄する
			_destroyTimer();
			
			// 待機状態を無効化する
			_pausing = false;
			
			// 処理を完了する
			super.executeComplete();
		}
		
		/**
		 * Timer を破棄します。
		 */
		private function _destroyTimer():void {
			// 対象が存在すれば
			if ( _timer ) {
				// イベントリスナーを解除する
				_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, _timerComplete );
				
				// Timer を破棄する
				_timer.stop();
				_timer = null;
			}
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
			return ObjectUtil.formatToString( this, super.className, "timeout" );
		}
		
		
		
		
		
		/**
		 * Timer.repeatCount で設定された数の要求が完了するたびに送出されます。
		 */
		private function _timerComplete( e:TimerEvent ):void {
			// Timer を破棄する
			_destroyTimer();
			
			// Error オブジェクトを作成する
			var error:Error = new Error( Logger.getLog( L10NExecuteMsg.getInstance().ERROR_006 ).toString( toString() ) );
			
			// イベントリスナーが設定されていれば
			if ( super.hasEventListener( ExecuteErrorEvent.EXECUTE_ERROR ) ) {
				// イベントを送出する
				super.dispatchEvent( new ExecuteErrorEvent( ExecuteErrorEvent.EXECUTE_ERROR, false, false, this, error ) );
			}
			else {
				// 例外をスローする
				throw error;
			}
		}
	}
}
