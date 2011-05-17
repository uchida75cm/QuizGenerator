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
package jp.progression.commands.tweens {
	import flash.display.MovieClip;
	import flash.events.Event;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.MovieClipUtil;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	import jp.progression.events.ExecuteEvent;
	
	/**
	 * <span lang="ja">コマンド処理中に状態が更新された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteEvent.EXECUTE_UPDATE
	 */
	[Event( name="executeUpdate", type="jp.progression.events.ExecuteEvent" )]
	
	/**
	 * <span lang="ja">DoTweenFrame クラスは、指定されたタイムライン上に存在する 2 点間をアニメーション処理させるコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // DoTweenFrame インスタンスを作成する
	 * var com:DoTweenFrame = new DoTweenFrame();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class DoTweenFrame extends Command {
		
		/**
		 * <span lang="ja">アニメーション処理を行いたい対象の MovieClip インスタンスを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get target():MovieClip { return _target; }
		public function set target( value:MovieClip ):void { _target = value; }
		private var _target:MovieClip;
		private var __target:MovieClip;
		
		/**
		 * <span lang="ja">アニメーションを開始するフレーム番号、またはフレームラベル名を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get startFrame():* { return _startFrame; }
		public function set startFrame( value:* ):void { _startFrame = value; }
		private var _startFrame:*;
		private var __startFrame:int;
		
		/**
		 * <span lang="ja">アニメーションを終了するフレーム番号もしくはフレームラベル名を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get endFrame():* { return _endFrame; }
		public function set endFrame( value:* ):void { _endFrame = value; }
		private var _endFrame:*;
		private var __endFrame:int;
		
		/**
		 * <span lang="ja">コマンドオブジェクトが ExecuteEvent.EXECUTE_UPDATE イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #scope
		 * @see jp.progression.events.ExecuteEvent#EXECUTE_UPDATE
		 */
		public function get onUpdate():Function { return _onUpdate; }
		public function set onUpdate( value:Function ):void { _onUpdate = value; }
		private var _onUpdate:Function;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい DoTweenFrame インスタンスを作成します。</span>
		 * <span lang="en">Creates a new DoTweenFrame object.</span>
		 * 
		 * @param target
		 * <span lang="ja">アニメーション処理を行いたい対象の MovieClip インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param startFrame
		 * <span lang="ja">アニメーションを開始するフレーム番号、またはフレームラベル名です。</span>
		 * <span lang="en"></span>
		 * @param endFrame
		 * <span lang="ja">アニメーションを終了するフレーム番号もしくはフレームラベル名です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function DoTweenFrame( target:MovieClip, startFrame:*, endFrame:*, initObject:Object = null ) {
			// 引数を設定する
			_target = target;
			_startFrame = startFrame;
			_endFrame = endFrame;
			
			// 親クラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
			
			// initObject が DoTweenFrame であれば
			var com:DoTweenFrame = initObject as DoTweenFrame;
			if ( com ) {
				// 特定のプロパティを継承する
				_onUpdate = com._onUpdate;
			}
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// 対象のフレームが 1 つしか存在しなければ終了する
			if ( _target.totalFrames == 1 ) {
				super.executeComplete();
				return;
			}
			
			// 現在の状態を保存する
			__target = _target;
			
			// フレームが存在しなければ
			if ( !MovieClipUtil.hasFrame( __target, _startFrame ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_018 ).toString( _target, _startFrame ) ); }
			if ( !MovieClipUtil.hasFrame( __target, _endFrame ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_018 ).toString( _target, _endFrame ) ); }
			
			// 移動先のフレーム番号を取得する
			__startFrame = _startFrame is Number ? _startFrame : MovieClipUtil.labelToFrames( __target, _startFrame )[0];
			__endFrame = _endFrame is Number ? _endFrame : MovieClipUtil.labelToFrames( __target, _endFrame )[0];
			
			// 現在位置が範囲内に存在しなければ
			if ( !MovieClipUtil.playheadWithinFrames( __target, __startFrame, __endFrame ) ) {
				// 開始フレームに移動する
				__target.gotoAndStop( __startFrame );
			}
			
			// 現在位置と移動先位置が同一であれば終了する
			if ( __target.currentFrame == __endFrame ) {
				super.executeComplete();
				return;
			}
			
			// イベントリスナーを登録する
			_target.addEventListener( Event.ENTER_FRAME, _enterFrame );
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void {
			// 中断方法によって処理を振り分ける
			switch ( super.interruptType ) {
				case 0	: { __target.gotoAndStop( __startFrame ); break; }
				case 2	: { __target.gotoAndStop( __endFrame ); break; }
			}
			
			// 破棄する
			_destroy();
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			if ( __target ) {
				// イベントリスナーを解除する
				__target.removeEventListener( Event.ENTER_FRAME, _enterFrame );
				
				// 破棄する
				__target = null;
				__startFrame = 0;
				__endFrame = 0;
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_target = null;
			_startFrame = null;
			_endFrame = null;
			_onUpdate = null;
		}
		
		/**
		 * <span lang="ja">DoTweenFrame インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an DoTweenFrame subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい DoTweenFrame インスタンスです。</span>
		 * <span lang="en">A new DoTweenFrame object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new DoTweenFrame( _target, _startFrame, _endFrame, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "target", "startFrame", "endFrame" );
		}
		
		
		
		
		
		/**
		 * 再生ヘッドが新しいフレームに入るときに送出されます。
		 */
		private function _enterFrame( e:Event ):void {
			// 対象が存在しなければ終了する
			if ( !__target ) { return; }
			
			// イベントを送出する
			super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_UPDATE, false, false, this  ) );
			
			// イベントハンドラメソッドを実行する
			if ( _onUpdate != null ) {
				_onUpdate.apply( scope || this );
			}
			
			// 現在地が終了位置だった場合
			if ( __target.currentFrame == __endFrame ) {
				// 破棄する
				_destroy();
				
				// 実行されていなければ終了する
				if ( super.state < 1 ) { return; }
				
				// 処理を終了する
				super.executeComplete();
			}
			else {
				// 現在地が終了地より手前の場合
				if ( __target.currentFrame < __endFrame ) {
					__target.nextFrame();
				}
				else {
					__target.prevFrame();
				}
			}
		}
	}
}
