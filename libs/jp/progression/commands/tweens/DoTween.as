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
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.events.Event;
	import jp.nium.events.EventAggregater;
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
	 * <span lang="ja">DoTweener クラスは、fl.transitions パッケージのイージング機能を実行するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // DoTween インスタンスを作成する
	 * var com:DoTween = new DoTween();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class DoTween extends Command {
		
		/**
		 * <span lang="ja">イージング処理を行いたい対象のオブジェクトを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get target():Object { return _target; }
		public function set target( value:Object ):void { _target = value; }
		private var _target:Object;
		
		/**
		 * <span lang="ja">イージング処理を行いたいプロパティを含んだオブジェクトを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get parameters():Object { return _parameters; }
		public function set parameters( value:Object ):void { _parameters = value; }
		private var _parameters:Object;
		
		/**
		 * <span lang="ja">イージング処理を行う関数を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get easing():Function { return _easing; }
		public function set easing( value:Function ):void { _easing = value; }
		private var _easing:Function;
		
		/**
		 * <span lang="ja">イージング処理の継続時間です。負の数、または省略されている場合、infinity に設定されます。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get duration():Number { return _duration; }
		public function set duration( value:Number ):void { _duration = value; }
		private var _duration:Number;
		
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
		 * Tween インスタンスを配列で取得します。
		 */
		private var _tweens:Array;
		
		/**
		 * EventAggregater インスタンスを取得します。 
		 */
		private var _aggregater:EventAggregater;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい DoTween インスタンスを作成します。</span>
		 * <span lang="en">Creates a new DoTween object.</span>
		 * 
		 * @param target
		 * <span lang="en">Tween のターゲットになるオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param props
		 * <span lang="ja">影響を受ける (target パラメータ値) のプロパティの名前と値を保持した Object インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param easing
		 * <span lang="ja">使用するイージング関数の名前です。</span>
		 * <span lang="en"></span>
		 * @param duration
		 * <span lang="ja">モーションの継続時間です。負の数、または省略されている場合、infinity に設定されます。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function DoTween( target:Object, parameters:Object, easing:Function, duration:Number, initObject:Object = null ) {
			// 引数を設定する
			_target = target;
			_parameters = parameters || {};
			_easing = easing;
			_duration = duration;
			
			// 親クラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
			
			// initObject が DoTween であれば
			var com:DoTween = initObject as DoTween;
			if ( com ) {
				// 特定のプロパティを継承する
				_onUpdate = com._onUpdate;
			}
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// 初期化する
			_tweens = [];
			
			// EventAggregater を作成する
			_aggregater = new EventAggregater();
			_aggregater.addEventListener( Event.COMPLETE, _complete );
			
			
			// Tween を作成する
			for ( var p:String in _parameters ) {
				if ( p in _target ) {
					// Tween を作成する
					var tween:Tween = new Tween( _target, p, _easing, _target[p], _parameters[p], _duration, true );
					_aggregater.addEventDispatcher( tween, TweenEvent.MOTION_FINISH );
					_tweens.push( tween );
				}
			}
			
			if ( _tweens.length > 0 ) {
				// イベントリスナーを登録する
				_tweens[0].addEventListener( TweenEvent.MOTION_CHANGE, _motionChange );
				
				// Tween を実行する
				for ( var i:int = 0, l:int = _tweens.length; i < l; i++ ) {
					Tween( _tweens[i] ).start();
				}
			}
			else {
				// 処理を終了する
				super.executeComplete();
			}
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void {
			// Tween を停止する
			for ( var i:int = 0, l:int = _tweens.length; i < l; i++ ) {
				var tween:Tween = Tween( _tweens[i] );
				
				// その場で停止する
				tween.stop();
				
				// 中断方法によって処理を振り分ける
				switch ( super.interruptType ) {
					case 0	: { _target[tween.prop] = tween.begin; break; }
					case 2	: { _target[tween.prop] = tween.finish; break; }
				}
			}
			
			// 破棄する
			_destroy();
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			if ( _aggregater ) {
				// イベントリスナーを解除する
				_aggregater.removeEventListener( Event.COMPLETE, _complete );
				_tweens[0].removeEventListener( TweenEvent.MOTION_CHANGE, _motionChange );
				
				// 全ての登録を解除する
				for ( var i:int = 0, l:int = _tweens.length; i < l; i++ ) {
					_aggregater.removeEventDispatcher( _tweens[i], TweenEvent.MOTION_FINISH );
				}
				
				// EventAggregater を破棄する
				_aggregater = null;
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
			_parameters = null;
			_easing = null;
			_duration = 0;
			_onUpdate = null;
		}
		
		/**
		 * <span lang="ja">DoTween インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an DoTween subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい DoTween インスタンスです。</span>
		 * <span lang="en">A new DoTween object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new DoTween( _target, _parameters, _easing, _duration, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "target", "duration" );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _motionChange( e:TweenEvent ):void {
			// イベントを送出する
			super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_UPDATE, false, false, this  ) );
			
			// イベントハンドラメソッドを実行する
			if ( _onUpdate != null ) {
				_onUpdate.apply( scope || this );
			}
		}
		
		/**
		 * 登録された全てのイベントが発生した際に送出されます。
		 */
		private function _complete( e:Event ):void {
			// 処理を終了する
			super.executeComplete();
			
			// 破棄する
			_destroy();
		}
	}
}
